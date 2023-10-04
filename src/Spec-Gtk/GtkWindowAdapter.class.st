Class {
	#name : #GtkWindowAdapter,
	#superclass : #GtkAdapter,
	#instVars : [
		'infoArea',
		'initialized',
		'deferredActions',
		'contentBox',
		'menuBar',
		'toolbar',
		'statusBar',
		'content',
		'lastSizeAllocation'
	],
	#pools : [
		'GdkWindowState'
	],
	#category : #'Spec-Gtk-Adapter-Window'
}

{ #category : #'spec protocol' }
GtkWindowAdapter >> activate [

	self widgetDo: [ :w |
		w present ]
]

{ #category : #private }
GtkWindowAdapter >> add: gtkBox toWindow: gtkWindow [

	gtkWindow child: gtkBox
]

{ #category : #'private - building' }
GtkWindowAdapter >> addDefaultKeyBindings: gtkWindow [
	
	self flag: #TODO. "Take this from a configuration."
	self 
		addKeyCombination: $w actionModifier 
		action: [ self closeFromKeyboard ]
		toWidget: gtkWindow
]

{ #category : #'private - deferring' }
GtkWindowAdapter >> addDeferredAction: aBlock [

	deferredActions ifNil: [ deferredActions := #() ].
	deferredActions := deferredActions copyWith: aBlock
]

{ #category : #building }
GtkWindowAdapter >> addModelTo: gtkWindow [
	"model is not added here but in #addPresenterIn:withSpecLayout:. 
	 Spec windows may have just ONE presenter"
	
	"gtkWindow connectWindowStateEvent: [ :event | 
		minimized := (event new_window_state & GDK_WINDOW_STATE_ICONIFIED value) = GDK_WINDOW_STATE_ICONIFIED value.
		false  ]"
]

{ #category : #accessing }
GtkWindowAdapter >> addPresenterIn: gtkWindow withSpecLayout: aSpec [
	
	initialized := false.
	GRunLoop defer: [
		self deferredAddPresenterIn: gtkWindow withSpecLayout: aSpec.
		initialized := true.
		self processDeferredActions ]
]

{ #category : #building }
GtkWindowAdapter >> addVisibleSettingsTo: gtkWidget [
	"windows fo not have visibility settings, they are shown or hide"
]

{ #category : #private }
GtkWindowAdapter >> announceClosed [

	self presenter windowIsClosing.
	self presenter windowClosed
]

{ #category : #private }
GtkWindowAdapter >> announceOpened [

	self model windowIsOpened
]

{ #category : #private }
GtkWindowAdapter >> announceResized: newSize [
	| windowSize |

	"We keep last size allocation to compare, because size-allocate can be signaled 
	 several times, many of them with same extent. 
	 We want to avoid the internal signaling of window resized in those cases (because 
	 there is no real resizing). "
	lastSizeAllocation = newSize ifTrue: [ ^ self ].
	lastSizeAllocation := newSize.
	"It seems the allocated extent is not necessarly the resulting size of the window, 
	 Instead using that extent as newSize informed, we ask the real size of the 
	 window to send."
	self widgetDo: [ :w | windowSize := w defaultSize ].
	self presenter announcer announce: (SpWindowResizing new
		window: self presenter;
		newSize: windowSize;	
		yourself)	
]

{ #category : #private }
GtkWindowAdapter >> announceWillClose [
	| ann |

	ann := SpWindowWillClose new
		window: self presenter;
		yourself.
	self presenter announce: ann.
	^ ann canClose
]

{ #category : #accessing }
GtkWindowAdapter >> beep [

	self widgetDo: [ :w | w beep ].
]

{ #category : #accessing }
GtkWindowAdapter >> centered [

	"Gtk can't do that in fact (because this is a WM task, and gtk has no idea what WM the
	 user has)"
	"self deferAction: [
		self widgetDo: [ :w |
			w isVisible
				ifTrue: [ w hide; center; show ]
				ifFalse: [ w center ] ] ]"
]

{ #category : #accessing }
GtkWindowAdapter >> centeredRelativeTo: aWindowPresenter [

	'#centeredRelativeTo: This can''t be done in Gtk4' crTrace.
	"self deferAction: [
		self widgetDo: [ :w |
			self
				deferredCenter: w
				relativeTo: aWindowPresenter ] ]"
]

{ #category : #accessing }
GtkWindowAdapter >> close [

	self widgetDo: [ :w |
		w close ]
]

{ #category : #private }
GtkWindowAdapter >> closeFromKeyboard [

	self presenter close
]

{ #category : #private }
GtkWindowAdapter >> closeFromSignal [

	self flag: #TODO. "I think this should be here"
	self announceWillClose.
	self announceClosed
]

{ #category : #private }
GtkWindowAdapter >> configureKeyBindings: gtkWindow [

	dispatcher := GtkKMDispatcher on: self presenter.
	gtkWindow addKeyEventControllerWith: [ :keyController |
		keyController 
			name: 'key-controller';
			connectKeyPressed: [ :event |
				(self handleKeyEvent: event)
					ifTrue: [ true ]
					ifFalse: [ 
						gtkWindow child 
							ifNotNil: [ :child | keyController forwardTo: child ]
							ifNil: [ false ] ] ] ]
]

{ #category : #'private - building' }
GtkWindowAdapter >> connectToGtkSignals: gtkWindow [

	"add close events (delete is sent before)"

	gtkWindow
		connectCloseRequest: [ 
			"true to stop handlers to continue (so, if I want to *not* close it, I need 
			 to answer true, the oposite of canClose)"
			self announceWillClose not ];
		connectDestroy: [ self closeFromSignal ];
		connectDefaultWidth: [ self announceResized: self widget defaultSize ];
		connectDefaultHeight: [ self announceResized: self widget defaultSize ]
]

{ #category : #'private - building' }
GtkWindowAdapter >> contentWithSpecLayout: aSpec [

	^ content ifNil: [ 
		  content := self model presenter buildWithLayout: aSpec ]
]

{ #category : #'private - deferring' }
GtkWindowAdapter >> deferAction: aBlock [ 

	initialized
		ifTrue: [ aBlock value ]
		ifFalse: [ self addDeferredAction: aBlock ]
]

{ #category : #'private - building' }
GtkWindowAdapter >> deferredAddPresenterIn: gtkWindow withSpecLayout: aSpec [

	self connectToGtkSignals: gtkWindow.
	self addDefaultKeyBindings: gtkWindow.

	"add window properties"
	self presenter initialExtent ifNotNil: [ :extent |
		gtkWindow defaultSize: extent ].
	"self presenter initialPosition
		ifNotNil: [ :position | gtkWindow moveTo: position ]."
	gtkWindow decorated: self presenter hasDecorations.
	self subscribeDecorations.

	"inner contents of window"
	contentBox := GtkBox newVertical.
	self populateContent: contentBox spec: aSpec window: gtkWindow.
	contentBox beVisible.

	self add: contentBox toWindow: gtkWindow
]

{ #category : #accessing }
GtkWindowAdapter >> delete [

	self widgetDo: [ :w | 
		w delete. 
		self presenter application windowClosed: self ]
]

{ #category : #'private - building' }
GtkWindowAdapter >> infoArea [

	^ infoArea ifNil: [
		infoArea := self presenter instantiate: SpGtkBannerPresenter.
		infoArea build.
		infoArea ]
]

{ #category : #notifying }
GtkWindowAdapter >> inform: aString [

	self notifyInfo: aString
]

{ #category : #initialization }
GtkWindowAdapter >> initialize [

	initialized := false.
	super initialize
]

{ #category : #'spec protocol' }
GtkWindowAdapter >> isDisplayed [ 

	^ self widgetDo: [ :w | w isVisible ]
]

{ #category : #'spec protocol' }
GtkWindowAdapter >> isMaximized [
	| maximized |

	maximized := self widgetDo: [ :w | w isMaximized ].
	^ maximized ifNil: [ false ]
]

{ #category : #'spec protocol' }
GtkWindowAdapter >> isMinimized [

	^ self widgetDo: [ :w |
		w surface state isMinimized ]
]

{ #category : #'spec protocol' }
GtkWindowAdapter >> isTopWindow [

	^ self widgetDo: [ :w |
		GEngine current ensureApplication activeWindow
			ifNotNil: [ :active | active getHandle = w getHandle ]
			ifNil: [ false ] ]
]

{ #category : #'spec protocol' }
GtkWindowAdapter >> maximize [

	self widgetDo: [ :w | w maximize ]
]

{ #category : #'private - building' }
GtkWindowAdapter >> menuBarAccelInstalledOn: gtkWindow [

	self halt. "replace addAcceleratorGroup"
	^ menuBar ifNil: [
		menuBar := self model menu build.
		self presenter menu shortcutGroup
			ifNotNil: [ :accelGroup | gtkWindow addAcceleratorGroup: accelGroup  ].
		menuBar ]
]

{ #category : #'spec protocol' }
GtkWindowAdapter >> minimize [

	self widgetDo: [ :w | w minimize ]
]

{ #category : #building }
GtkWindowAdapter >> newWidget [

	^ GtkWindow new 
		autoRelease;
		yourself
]

{ #category : #notifying }
GtkWindowAdapter >> notifyError: aString [

	self infoArea addError: aString
]

{ #category : #notifying }
GtkWindowAdapter >> notifyInfo: aString [

	self infoArea addInfo: aString
]

{ #category : #accessing }
GtkWindowAdapter >> open [

	self openWithDeferredAction: [ ]
]

{ #category : #accessing }
GtkWindowAdapter >> openWithDeferredAction: aBlock [
 
	self hasWidget ifFalse: [ ^ nil ].
	self widgetDo: [ :w | w present ].
	self processInitializationDeferredActions.
	self presenter presenter takeKeyboardFocus.
	self announceOpened.
	aBlock value
]

{ #category : #'private - building' }
GtkWindowAdapter >> populateContent: gtkBox spec: aSpec window: gtkWindow [
	| windowContent |

	"menu bar"
	self model hasMenu
		ifTrue: [ gtkBox append: (self menuBarAccelInstalledOn: gtkWindow) ].
	"tool bar"
	self model hasToolbar
		ifTrue: [ gtkBox packStart: self toolbar ].
	"infoArea"
	contentBox append: self infoArea adapter widget.
	"contents"
	windowContent := self contentWithSpecLayout: aSpec.
	gtkBox append: windowContent.
	windowContent expand: true.
	"status bar"
	self model hasStatusBar
		ifTrue: [ gtkBox append: self statusBar ]
]

{ #category : #'private - deferring' }
GtkWindowAdapter >> processDeferredActions [

	deferredActions ifNil: [ ^ self ].
	deferredActions do: [ :each | each value ].
	deferredActions := nil
]

{ #category : #private }
GtkWindowAdapter >> processInitializationDeferredActions [
	
	self presenter traversePresentersDo: [ :each | 
		each adapter ifNotNil: [ :anAdapter |
			anAdapter doInitializationDeferredActions ] ] 
]

{ #category : #building }
GtkWindowAdapter >> rebuild [

	contentBox beNotVisible.
	contentBox children do: [ :each | each ensureObjectRefAndAutoRelease ].
	contentBox removeAll.
	content := self model presenter adapter widget.
	
	self 
		populateContent: contentBox 
		spec: nil
		window: self widget.
		
	contentBox beVisible
]

{ #category : #'spec protocol' }
GtkWindowAdapter >> resize: aPoint [

	self widgetDo: [ :w | w defaultSize: aPoint ]
]

{ #category : #private }
GtkWindowAdapter >> setDecorated: aBoolean [

	self widgetDo: [ :w | w decorated: aBoolean ]
]

{ #category : #'private - building' }
GtkWindowAdapter >> statusBar [

	^ statusBar ifNil: [ statusBar := self model statusBar build ]

]

{ #category : #private }
GtkWindowAdapter >> subscribeDecorations [
	self presenter whenDecorationsChangedDo: [ :aBoolean |
		self setDecorated: aBoolean ].

]

{ #category : #accessing }
GtkWindowAdapter >> title: aString [ 

	self widgetDo: [ :w | w title: (aString ifNotNil: [ :theString | theString localizedForPresenter: self presenter]) ]
]

{ #category : #'private - building' }
GtkWindowAdapter >> toolbar [ 

	^ toolbar ifNil: [ toolbar  := self presenter toolbar build ]

]
