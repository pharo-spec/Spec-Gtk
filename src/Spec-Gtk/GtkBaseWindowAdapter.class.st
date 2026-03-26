"
A base for window adapters.
"
Class {
	#name : 'GtkBaseWindowAdapter',
	#superclass : 'GtkAdapter',
	#instVars : [
		'infoArea',
		'initialized',
		'deferredActions',
		'contentBox',
		'menuBar',
		'toolbar',
		'statusbar',
		'content',
		'lastSizeAllocation',
		'adapterHelper'
	],
	#pools : [
		'GdkWindowState'
	],
	#category : 'Spec-Gtk-Adapter-Window',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Window'
}

{ #category : 'spec protocol' }
GtkBaseWindowAdapter >> activate [

	self widgetDo: [ :w |
		w present ]
]

{ #category : 'private' }
GtkBaseWindowAdapter >> add: gtkBox toWindow: gtkWindow [

	adapterHelper 
		add: gtkBox 
		toWindow: gtkWindow
]

{ #category : 'private - building' }
GtkBaseWindowAdapter >> addActionsTo: gtkWindow [

	super addActionsTo: gtkWindow.
	self addDefaultKeyBindings: gtkWindow
]

{ #category : 'private - building' }
GtkBaseWindowAdapter >> addDefaultKeyBindings: gtkWindow [
	| actionGroup |
	
	actionGroup := self defaultActionGroup.
	actionGroup ifNil: [ ^ self ].

	self ensureActionManager
		installGroup: actionGroup 
on: gtkWindow
]

{ #category : 'private - deferring' }
GtkBaseWindowAdapter >> addDeferredAction: aBlock [

	deferredActions ifNil: [ deferredActions := #() ].
	deferredActions := deferredActions copyWith: aBlock
]

{ #category : 'building' }
GtkBaseWindowAdapter >> addModelTo: gtkWindow [

	"model is not added here but in #addPresenterIn:withSpecLayout:. 
	 Spec windows may have just ONE presenter"
	
]

{ #category : 'accessing' }
GtkBaseWindowAdapter >> addPresenterIn: gtkWindow withSpecLayout: aSpec [
	
	initialized := false.
	GRunLoop defer: [
		self deferredAddPresenterIn: gtkWindow withSpecLayout: aSpec.
		initialized := true.
		self processDeferredActions ]
]

{ #category : 'building' }
GtkBaseWindowAdapter >> addVisibleSettingsTo: gtkWidget [
	"windows fo not have visibility settings, they are shown or hide"
]

{ #category : 'private' }
GtkBaseWindowAdapter >> announceClosed [

	logger trace.
	self presenter windowIsClosing.
	self presenter windowClosed
]

{ #category : 'private' }
GtkBaseWindowAdapter >> announceOpened [
	"ensure not in callback"
	self runInSystem: [ self model windowIsOpened ]
]

{ #category : 'private' }
GtkBaseWindowAdapter >> announceResized: newSize [
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

{ #category : 'private' }
GtkBaseWindowAdapter >> announceWillClose [
	| ann |

	ann := SpWindowWillClose new
		window: self presenter;
		yourself.
	self presenter announce: ann.
	^ ann canClose
]

{ #category : 'accessing' }
GtkBaseWindowAdapter >> beep [

	self widgetDo: [ :w | w beep ].
]

{ #category : 'accessing' }
GtkBaseWindowAdapter >> centered [

	"Gtk can't do that in fact (because this is a WM task, and gtk has no idea what WM the
	 user has)"
	"self deferAction: [
		self widgetDo: [ :w |
			w isVisible
				ifTrue: [ w hide; center; show ]
				ifFalse: [ w center ] ] ]"
]

{ #category : 'accessing' }
GtkBaseWindowAdapter >> centeredRelativeTo: aWindowPresenter [

	'#centeredRelativeTo: This can''t be done in Gtk4' crTrace.
	"self deferAction: [
		self widgetDo: [ :w |
			self
				deferredCenter: w
				relativeTo: aWindowPresenter ] ]"
]

{ #category : 'accessing' }
GtkBaseWindowAdapter >> close [

	self widgetDo: [ :w | w beNotVisible ]
]

{ #category : 'private' }
GtkBaseWindowAdapter >> closeFromKeyboard [

	self close

]

{ #category : 'private' }
GtkBaseWindowAdapter >> closeFromSignal [
	"this is called from connectHide (just one time)"
	
	self runInSystem: [
		self announceClosed. 
		self widget unregister ].
		
	self innerWidgetDo: [ :w | 
		w child: GtkWidget null.
		w destroy ]
]

{ #category : 'private' }
GtkBaseWindowAdapter >> configureKeyBindings: gtkWindow [

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

{ #category : 'private - building' }
GtkBaseWindowAdapter >> connectToGtkSignals: gtkWindow [

	"add close events (delete is sent before)"

	gtkWindow
		connectCloseRequest: [ 
			"true to stop handlers to continue (so, if I want to *not* close it, I need 
			 to answer true, the oposite of canClose)"
			self announceWillClose not ];
		connectHide: [ self closeFromSignal ];
		connectDefaultWidth: [ self announceResized: self widget defaultSize ];
		connectDefaultHeight: [ self announceResized: self widget defaultSize ]
]

{ #category : 'private - building' }
GtkBaseWindowAdapter >> contentWithSpecLayout: aSpec [

	^ content ifNil: [ 
		  content := self model presenter buildWithLayout: aSpec ]
]

{ #category : 'private - building' }
GtkBaseWindowAdapter >> defaultActionGroup [
		
	^ SpActionGroup new 
		name: 'adapterWindowActions';
		addActionWith: [ :action | action 
			name: 'closeWindow';
			shortcutKey: $w actionModifier;
			action: [ self closeFromKeyboard ] ];
		yourself
]

{ #category : 'private - deferring' }
GtkBaseWindowAdapter >> deferAction: aBlock [ 

	initialized
		ifTrue: [ aBlock value ]
		ifFalse: [ self addDeferredAction: aBlock ]
]

{ #category : 'private - building' }
GtkBaseWindowAdapter >> deferredAddPresenterIn: gtkWindow withSpecLayout: aSpec [

	self connectToGtkSignals: gtkWindow.

	"add window properties"
	self presenter initialExtent ifNotNil: [ :extent |
		gtkWindow defaultSize: extent ].
	"self presenter initialPosition
		ifNotNil: [ :position | gtkWindow moveTo: position ]."
	self setDecorated: self presenter hasDecorations to: gtkWindow.
	self subscribeDecorations.

	"inner contents of window"
	contentBox := GtkBox newVertical.
	self populateContent: contentBox spec: aSpec window: gtkWindow.
	contentBox beVisible.

	self add: contentBox toWindow: gtkWindow
]

{ #category : 'accessing' }
GtkBaseWindowAdapter >> delete [

	self widgetDo: [ :w | 
		w delete. 
		self presenter application windowClosed: self ]
]

{ #category : 'private' }
GtkBaseWindowAdapter >> findPresenterFocused: widgetFocused inTopLevel: aPresenter [

	aPresenter traversePresentersDo: [ :each | 
		(each adapter isFocusedWidgetSameAsMe: widgetFocused) 
			ifTrue: [ ^ each ] ].

	^ nil
]

{ #category : 'private - building' }
GtkBaseWindowAdapter >> infoArea [

	^ infoArea ifNil: [
		infoArea := self presenter instantiate: SpGtkBannerPresenter.
		infoArea build.
		infoArea ]
]

{ #category : 'notifying' }
GtkBaseWindowAdapter >> inform: aString [

	self notifyInfo: aString
]

{ #category : 'initialization' }
GtkBaseWindowAdapter >> initialize [

	initialized := false.
	adapterHelper := GtkWindowAdapterHelper on: self.
	super initialize
]

{ #category : 'spec protocol' }
GtkBaseWindowAdapter >> isDisplayed [ 

	^ self widgetDo: [ :w | w isVisible ]
]

{ #category : 'spec protocol' }
GtkBaseWindowAdapter >> isMaximized [
	| maximized |

	maximized := self widgetDo: [ :w | w isMaximized ].
	^ maximized ifNil: [ false ]
]

{ #category : 'spec protocol' }
GtkBaseWindowAdapter >> isMinimized [

	^ self widgetDo: [ :w |
		w surface state isMinimized ]
]

{ #category : 'spec protocol' }
GtkBaseWindowAdapter >> isTopWindow [

	^ self widgetDo: [ :w |
		GEngine current ensureApplication activeWindow
			ifNotNil: [ :active | active getHandle = w getHandle ]
			ifNil: [ false ] ]
]

{ #category : 'accessing' }
GtkBaseWindowAdapter >> lastPresenterFocused [
	| widgetFocused |

	widgetFocused := self innerWidget widgetFocused. 
	widgetFocused isNullOrNil ifTrue: [ ^ nil ].
	
	(self findPresenterFocused: widgetFocused inTopLevel: self presenter presenter)
		ifNotNil: [ :aPresenter | ^ aPresenter ].
	"it may be a popover"
	self presenter application windows 
		select: [ :each | each isPopover ]
		thenDo: [ :each | 
			(self findPresenterFocused: widgetFocused inTopLevel: each presenter)
				ifNotNil: [ :aPresenter | ^ aPresenter ] ].
	
	^ nil
]

{ #category : 'spec protocol' }
GtkBaseWindowAdapter >> maximize [

	self widgetDo: [ :w | w maximize ]
]

{ #category : 'private' }
GtkBaseWindowAdapter >> maybeAddTransientTo: gtkWindow [
	| presenterOwner |

	presenterOwner := self presenter owner.
	(presenterOwner isNotNil and: [ presenterOwner isWindow ])
		ifTrue: [ gtkWindow transientTo: presenterOwner adapter widget ]
]

{ #category : 'private - building' }
GtkBaseWindowAdapter >> menuBarAccelInstalledOn: gtkWindow [

	self halt. "replace addAcceleratorGroup"
	^ menuBar ifNil: [
		menuBar := self model menu build.
		self presenter menu shortcutGroup
			ifNotNil: [ :accelGroup | gtkWindow addAcceleratorGroup: accelGroup  ].
		menuBar ]
]

{ #category : 'spec protocol' }
GtkBaseWindowAdapter >> minimize [

	self widgetDo: [ :w | w minimize ]
]

{ #category : 'spec protocol' }
GtkBaseWindowAdapter >> moveTo: aPoint [
	"can't directly position a window on gtk4 :("
]

{ #category : 'building' }
GtkBaseWindowAdapter >> newWidget [

	^ self widgetClass new 
		autoRelease;
		hideOnClose: true;
		yourself
]

{ #category : 'notifying' }
GtkBaseWindowAdapter >> notifyError: aString [

	self infoArea addError: aString
]

{ #category : 'notifying' }
GtkBaseWindowAdapter >> notifyInfo: aString [

	self infoArea addInfo: aString
]

{ #category : 'accessing' }
GtkBaseWindowAdapter >> open [

	self openWithDeferredAction: [ ]
]

{ #category : 'accessing' }
GtkBaseWindowAdapter >> openWithDeferredAction: aBlock [
 
	self hasWidget ifFalse: [ ^ nil ].
	self widgetDo: [ :w | 
		self maybeAddTransientTo: w.
		w present.
		self processInitializationDeferredActions ].
	self presenter presenter takeKeyboardFocus.
	self announceOpened.
	aBlock value
]

{ #category : 'private - building' }
GtkBaseWindowAdapter >> populateContent: gtkBox spec: aSpec window: gtkWindow [
	| windowContent |

	"menu bar"
	self presenter hasMenu 
		ifTrue: [ gtkBox append: (self menuBarAccelInstalledOn: gtkWindow) ].
	"tool bar"
	self presenter hasToolbar 
		ifTrue: [ gtkBox append: self toolbar ].
	"infoArea"
	contentBox append: self infoArea adapter widget.
	"contents"
	windowContent := self contentWithSpecLayout: aSpec.
	gtkBox append: windowContent.
	windowContent expand: true.
	"status bar"
	self presenter hasStatusbar 
		ifTrue: [ gtkBox append: self statusbar ]
]

{ #category : 'private - deferring' }
GtkBaseWindowAdapter >> processDeferredActions [

	deferredActions ifNil: [ ^ self ].
	deferredActions do: [ :each | each value ].
	deferredActions := nil
]

{ #category : 'private' }
GtkBaseWindowAdapter >> processInitializationDeferredActions [
	
	logger trace.
	self presenter traversePresentersDo: [ :each | 
		each adapter ifNotNil: [ :anAdapter |
			anAdapter doInitializationDeferredActions ] ] 
]

{ #category : 'building' }
GtkBaseWindowAdapter >> rebuild [

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

{ #category : 'spec protocol' }
GtkBaseWindowAdapter >> resize: aPoint [

	self widgetDo: [ :w | w defaultSize: aPoint ]
]

{ #category : 'private' }
GtkBaseWindowAdapter >> setDecorated: aBoolean [

	self widgetDo: [ :w | 
		self setDecorated: aBoolean to: w ]
]

{ #category : 'private - building' }
GtkBaseWindowAdapter >> setDecorated: aBoolean to: gtkWindow [

	adapterHelper 
		setDecorated: aBoolean 
		to: gtkWindow
]

{ #category : 'spec protocol' }
GtkBaseWindowAdapter >> size [

	^ self widgetDo: [ :w | w defaultSize ]
]

{ #category : 'private - building' }
GtkBaseWindowAdapter >> statusBar [

	^ statusBar ifNil: [ statusBar := self model statusbar build ]
]

{ #category : 'private - building' }
GtkBaseWindowAdapter >> statusbar [

	^ statusbar ifNil: [ statusbar := self presenter statusbar build ]
]

{ #category : 'private' }
GtkBaseWindowAdapter >> subscribeDecorations [
	self presenter whenDecorationsChangedDo: [ :aBoolean |
		self setDecorated: aBoolean ].

]

{ #category : 'accessing' }
GtkBaseWindowAdapter >> title: aString [ 
	| localizedTitle |

	localizedTitle := aString ifNotNil: [ :theString | theString localizedForPresenter: self presenter].

	logger trace: localizedTitle.

	self widgetDo: [ :w | 
		adapterHelper setTitle: localizedTitle to: w ]
]

{ #category : 'private - building' }
GtkBaseWindowAdapter >> toolbar [ 

	^ toolbar ifNil: [ toolbar  := self presenter toolbar build ]

]

{ #category : 'building' }
GtkBaseWindowAdapter >> widgetClass [

	^ adapterHelper widgetClass
]
