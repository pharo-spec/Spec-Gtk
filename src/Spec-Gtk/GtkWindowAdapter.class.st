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
		'minimized',
		'lastSizeAllocation'
	],
	#pools : [
		'GdkWindowState'
	],
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #private }
GtkWindowAdapter >> add: gtkBox toWindow: gtkWindow [

	gtkWindow add: gtkBox
]

{ #category : #'private building' }
GtkWindowAdapter >> addDefaultKeyBindings: gtkWindow [
	
	self flag: #TODO. "Take this from a configuration."
	self 
		bindKeyCombination: $w command mac | $w control win | $w control unix 
		toAction: [ self closeFromKeyboard ]
		inWidget: gtkWindow
]

{ #category : #'private deferring' }
GtkWindowAdapter >> addDeferredAction: aBlock [

	deferredActions ifNil: [ deferredActions := #() ].
	deferredActions := deferredActions copyWith: aBlock
]

{ #category : #building }
GtkWindowAdapter >> addModelTo: gtkWindow [
	"model is not added here but in #addPresenterIn:withSpecLayout:. 
	 Spec windows may have just ONE presenter"
	
	gtkWindow connectWindowStateEvent: [ :event | 
		minimized := (event new_window_state & GDK_WINDOW_STATE_ICONIFIED value) = GDK_WINDOW_STATE_ICONIFIED value.
		false  ]
]

{ #category : #accessing }
GtkWindowAdapter >> addPresenterIn: gtkWindow withSpecLayout: aSpec [
	
	initialized := false.
	GtkRunLoop defer: [ 
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

	self model windowIsOpening
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
	self widgetDo: [ :w | windowSize := w size ].
	self presenter announcer announce: (SpWindowResizing new
		window: self presenter;
		newSize: windowSize;	
		yourself)	
]

{ #category : #private }
GtkWindowAdapter >> announceWillClose [

	self presenter announcer announce: (SpWindowWillClose new
		window: self presenter;
		yourself)
]

{ #category : #accessing }
GtkWindowAdapter >> beep [

	self widgetDo: [ :w | w beep ].
]

{ #category : #accessing }
GtkWindowAdapter >> centered [
	
	self deferAction: [ 
		self widgetDo: [ :w | 
			w isVisible 
				ifTrue: [ w hide; center; show ]
				ifFalse: [ w center ] ] ]
]

{ #category : #accessing }
GtkWindowAdapter >> centeredRelativeTo: aWindowPresenter [

	self deferAction: [
		self widgetDo: [ :w | 
			self 
				deferredCenter: w 
				relativeTo: aWindowPresenter ] ]
]

{ #category : #accessing }
GtkWindowAdapter >> close [

	self widgetDo: [ :w | 
		w hide. 
		w isAlive ifTrue: [ w destroy ] ]
]

{ #category : #private }
GtkWindowAdapter >> closeFromKeyboard [

	self presenter close
]

{ #category : #private }
GtkWindowAdapter >> closeFromSignal [

	self announceWillClose.
	self announceClosed
]

{ #category : #private }
GtkWindowAdapter >> configureKeyBindings: gtkWindow [
		
	dispatcher := GtkKMDispatcher on: self presenter.
	gtkWindow connectKeyPressEvent: [ :event |
		(self handleKeyEvent: event)
			ifTrue: [ true ]
			ifFalse: [ gtkWindow propagateKeyEvent: event ] ].
]

{ #category : #'private building' }
GtkWindowAdapter >> connectToGtkSignals: gtkWindow [

	"add close events (delete is sent before)"
	gtkWindow 
		connectDeleteEvent: [ self announceWillClose. false ];
		connectHide: [ self closeFromSignal ];
		connectSizeAllocate: [ :aRect | self announceResized: aRect extent ]
]

{ #category : #'private building' }
GtkWindowAdapter >> contentWithSpecLayout: aSpec [

	^ content ifNil: [ 
		content := self model presenter buildWithSpecLayout: aSpec ]
]

{ #category : #'private deferring' }
GtkWindowAdapter >> deferAction: aBlock [ 

	initialized
		ifTrue: [ aBlock value ]
		ifFalse: [ self addDeferredAction: aBlock ]
]

{ #category : #private }
GtkWindowAdapter >> deferredAddPresenterIn: gtkWindow withSpecLayout: aSpec [

	self connectToGtkSignals: gtkWindow.
	self addDefaultKeyBindings: gtkWindow.

	"add window properties"
	self presenter initialExtent
		ifNotNil: [ :extent |
			gtkWindow 
				defaultSize: extent;
				resize: extent ].
	self presenter initialPosition
		ifNotNil: [ :position | gtkWindow moveTo: position ].
	gtkWindow decorated: self presenter hasDecorations.
	self presenter whenDecorationsChangedDo: [ :aBoolean |
		self widgetDo: [ :w | w decorated: aBoolean ] ].

	"inner contents of window"
	contentBox := GtkBox newVertical.
	self populateContent: contentBox spec: aSpec window: gtkWindow.
	contentBox show.

	self add: contentBox toWindow: gtkWindow
]

{ #category : #accessing }
GtkWindowAdapter >> deferredCenter: gtkWindow relativeTo: aWindowPresenter [
	| isVisible bounds position |
	
	isVisible := gtkWindow isVisible.
	isVisible ifTrue:[ gtkWindow hide ].
	bounds := aWindowPresenter adapter widget bounds.
	position := bounds topLeft + ((bounds extent - gtkWindow size) // 2).
	gtkWindow moveTo: position.
	isVisible ifTrue: [ gtkWindow show ]
]

{ #category : #accessing }
GtkWindowAdapter >> delete [

	self widgetDo: [ :w | 
		w delete. 
		self presenter application windowClosed: self ]
]

{ #category : #'private building' }
GtkWindowAdapter >> infoArea [

	^ infoArea ifNil: [ infoArea := GtkInfoArea new ]
]

{ #category : #initialization }
GtkWindowAdapter >> initialize [

	initialized := false.
	minimized := false.
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

	^ minimized
]

{ #category : #'spec protocol' }
GtkWindowAdapter >> isTopWindow [

	^ self widgetDo: [ :w | w hasTopLevelFocus ]
]

{ #category : #'spec protocol' }
GtkWindowAdapter >> maximize [

	self widgetDo: [ :w | w maximize ]
]

{ #category : #'private building' }
GtkWindowAdapter >> menuBarAccelInstalledOn: gtkWindow [
	
	^ menuBar ifNil: [ 
		menuBar := self model menu buildWithSpec.
		self presenter menu shortcutGroup 
			ifNotNil: [ :accelGroup | gtkWindow addAcceleratorGroup: accelGroup  ].
		menuBar ]
]

{ #category : #'spec protocol' }
GtkWindowAdapter >> minimize [

	self widgetDo: [ :w | w iconify ]
]

{ #category : #building }
GtkWindowAdapter >> newWidget [

	^ GtkWindow new 
		autoRelease;
		yourself
]

{ #category : #notifying }
GtkWindowAdapter >> notifyError: aSpecNotification [

	infoArea addError: aSpecNotification message
]

{ #category : #notifying }
GtkWindowAdapter >> notifyInfo: aSpecNotification [

	infoArea addInfo: aSpecNotification message
]

{ #category : #accessing }
GtkWindowAdapter >> open [

	self widgetDo: [ :w | 
		GtkRunLoop defer: [ 
			w show.
			w present ].
		self announceOpened ].
]

{ #category : #'private building' }
GtkWindowAdapter >> populateContent: gtkBox spec: aSpec window: gtkWindow [

	"menu bar"
	self model hasMenu ifTrue: [ 
		gtkBox 
			packStart: (self menuBarAccelInstalledOn: gtkWindow) 
			expand: false 
			fill: false 
			padding: 0 ].
	"tool bar"
	self model hasToolbar ifTrue: [ 
		gtkBox 
			packStart: self toolbar 
			expand: false 
			fill: false 
			padding: 0 ].
	"infoArea"
	contentBox
		packStart: self infoArea
		expand: false
		fill: false
		padding: 0.
	"contents"
	gtkBox packStart: (self contentWithSpecLayout: aSpec).
	"status bar"
	self model hasStatusBar ifTrue: [ 
		gtkBox 
			packStart: self statusBar 
			expand: false 
			fill: false 
			padding: 0 ]
]

{ #category : #'private deferring' }
GtkWindowAdapter >> processDeferredActions [

	deferredActions ifNil: [ ^ self ].
	deferredActions do: [ :each | each value ].
	deferredActions := nil
]

{ #category : #building }
GtkWindowAdapter >> rebuild [

	contentBox hide.
	contentBox children do: [ :each | each markForAutoRelease ].
	contentBox removeAll.
	content := self model presenter adapter widget.
	
	self 
		populateContent: contentBox 
		spec: nil
		window: self widget.
		
	contentBox show
]

{ #category : #'private building' }
GtkWindowAdapter >> statusBar [

	^ statusBar ifNil: [ statusBar := self model statusBar buildWithSpec ]

]

{ #category : #accessing }
GtkWindowAdapter >> title: aString [ 

	self widgetDo: [ :w | w title: (aString ifNotNil: [ :theString | theString localizedForPresenter: self presenter]) ]
]

{ #category : #'private building' }
GtkWindowAdapter >> toolbar [ 

	^ toolbar ifNil: [ toolbar  := self presenter toolbar buildWithSpec ]

]
