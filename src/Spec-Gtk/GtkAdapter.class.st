Class {
	#name : #GtkAdapter,
	#superclass : #SpAbstractAdapter,
	#instVars : [
		'lastShownMenu',
		'backendUpdating',
		'dispatcher'
	],
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #specs }
GtkAdapter class >> adaptingName [
	"Answers the name this component adapts."

	"Remove the 'Gtk' part will almost always give us the adapter name"
	^ (self name allButFirst: 3) asSymbol
]

{ #category : #initialize }
GtkAdapter class >> allAdapters [

	^ self allSubclasses
]

{ #category : #testing }
GtkAdapter class >> isAbstract [ 

	^ self = GtkAdapter
]

{ #category : #initialization }
GtkAdapter >> adapt: aPresenter [

	^ GRunLoop defer: [ super adapt: aPresenter ]
]

{ #category : #building }
GtkAdapter >> addContextMenuKeyBindings: gtkWidget [
	
	self flag: #TODO. "Take this from a configuration"
	self 
		bindKeyCombination: $t command mac | $t control unix | $t control win
		toAction: [ self showContextMenu ]
		inWidget: gtkWidget
]

{ #category : #building }
GtkAdapter >> addKeyBindingCategory: aCategory to: gtkWidget [

	aCategory allEntries keymaps do: [ :each |
		self 
			bindKeyCombination: each shortcut
			toAction: each action
			inWidget: gtkWidget ]
]

{ #category : #building }
GtkAdapter >> addKeyBindingsTo: gtkWidget [

	self presenter contextKeyBindings ifNotNil: [ :aCategory | 
		self configureKeyBindings: gtkWidget. 
		self addKeyBindingCategory: aCategory to: gtkWidget ]
]

{ #category : #building }
GtkAdapter >> addMenu: aValuable to: gtkWidget [

	gtkWidget connectRightClicked: [ :event |
		self showMenu: aValuable event: event.
		true ]
]

{ #category : #building }
GtkAdapter >> addModelTo: gtkWidget [
]

{ #category : #building }
GtkAdapter >> addSettingsTo: gtkWidget [
	"A secondary initialization generic to all widgets"

	self presenter styles 
		do: [ :each | gtkWidget addClass: each ].
	
	gtkWidget sensitive: self presenter isEnabled value.
	self presenter help ifNotNil: [ gtkWidget tooltipText: self getHelpText ].
	self presenter whenHelpChangedDo: [ 
		self backendUpdatingDo: [ self updateHelp ] ].
	self presenter whenEnabledChangedDo: [ 
		self backendUpdatingDo: [ self updateEnabled ] ].
	self presenter whenContextKeyBindingsChangedDo: [ 
		self updateKeyBindings ].
	
	self addVisibleSettingsTo: gtkWidget
]

{ #category : #protocol }
GtkAdapter >> addStyle: aStyle [

	self innerWidgetDo: [ :w | w addClass: aStyle ]
]

{ #category : #building }
GtkAdapter >> addVisibleSettingsTo: gtkWidget [

	self presenter isVisible
		ifTrue: [ gtkWidget beVisible ]
		ifFalse: [ gtkWidget hide ].
	self presenter whenVisibleChangedDo: [ :aValuable |
		self updateVisibility: aValuable value ]
]

{ #category : #'private cycle detection' }
GtkAdapter >> backendDetectCyclesDo: aBlock [ 

	self isBackendUpdating ifTrue: [ ^ self ].
	^ aBlock value
]

{ #category : #'private cycle detection' }
GtkAdapter >> backendUpdatingDo: aBlock [ 
	"This is a general mechanism to avoid colisions. 
	 I'm adding it for the cases where a presenter can be updated in two directions: from the 
	 user and from the backend. 
	 A tipical example of this is SpTextPresenter>>text:, who can be updated from the UI, but 
	 also needs to be updated from the backend to keep the text property updated."
	| oldStatus |

	oldStatus := backendUpdating.
	backendUpdating := true.
	aBlock ensure: [ 
		backendUpdating := oldStatus ]
]

{ #category : #protocol }
GtkAdapter >> bindKeyCombination: aShortcut toAction: aBlock [ 
	
	self 
		bindKeyCombination: aShortcut 
		toAction: aBlock 
		inWidget: self innerWidget
]

{ #category : #private }
GtkAdapter >> bindKeyCombination: aShortcut toAction: aBlock inWidget: gtkWidget [
	
	dispatcher ifNil: [ 
		GRunLoop defer: [
			self configureKeyBindings: gtkWidget ] ].

	dispatcher 
		bindKeyCombination: aShortcut
		toAction: aBlock
]

{ #category : #building }
GtkAdapter >> buildMenu: aMenuPresenter [

	^ aMenuPresenter 
		owner: self presenter;
		build
]

{ #category : #building }
GtkAdapter >> buildWidget [ 
	| gtkWidget |
	
	gtkWidget := self newWidget.
	self addSettingsTo: gtkWidget.
	self addKeyBindingsTo: gtkWidget.
	self addEventsTo: gtkWidget.
	self addModelTo: gtkWidget.
	^ self wrapWidget: gtkWidget
]

{ #category : #releasing }
GtkAdapter >> cleanupAfterReplacing [ 

	widget := nil
]

{ #category : #private }
GtkAdapter >> configureKeyBindings: gtkWidget [

	dispatcher := GtkKMDispatcher on: self presenter.
	gtkWidget addKeyPressEvent: [ :event |
		self handleKeyEvent: event ]
]

{ #category : #private }
GtkAdapter >> deferredUpdateMenuIn: w [
	| existingCallbacks menu |

	existingCallbacks := Set new.
	w 
		withCallbacksOfType: GSecondaryButtonPressEventCallback 
		do: [ :each | existingCallbacks add: each ].
		
	menu := self presenter contextMenu. 
	menu ifNil: [ 
		existingCallbacks do: [ :each | each disconnectFrom: w ].
		^ self ].
	"if there is already a callback, I do not need to do anything (because it will be 
	 evaluated each time)"
	existingCallbacks ifNotEmpty: [ ^ self ].
	"Now, actually add the menu callback"
	self addMenu: menu to: w
]

{ #category : #initialization }
GtkAdapter >> doInitializationDeferredActions [
	"some components can require a deferred action (to be executed when 
	 window is presented). Override this if this is the case."
]

{ #category : #protocol }
GtkAdapter >> doTakeKeyboardFocus [

	self innerWidgetDo: [ :w | 
		self presenter withWindowDo: [ :window | 
			window adapter
				ifNotNil: [ self doTakeKeyboardFocus: w ]
				ifNil: [ w deferAction: [ self doTakeKeyboardFocus: w ] ] ] ]
]

{ #category : #protocol }
GtkAdapter >> doTakeKeyboardFocus: gtkWidget [

	gtkWidget grabFocus
]

{ #category : #accessing }
GtkAdapter >> enabled [

	^ self innerWidget sensitive
]

{ #category : #accessing }
GtkAdapter >> enabled: aBoolean [

	self widgetDo: [ :w |
		w sensitive: aBoolean ]
]

{ #category : #private }
GtkAdapter >> getHelpText [

	^ self presenter help ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : #private }
GtkAdapter >> handleKeyEvent: event [

	event isModifier ifTrue: [ ^ false ].
	dispatcher ifNotNil: [
		dispatcher dispatchKeyEvent: event.
		^ event wasHandled ].
	
	^ false
]

{ #category : #private }
GtkAdapter >> hasContextMenu [
	
	^ self presenter contextMenu notNil
]

{ #category : #protocol }
GtkAdapter >> hasKeyboardFocus [
	| focus |
	
	focus := false.
	self innerWidgetDo: [ :w | focus := w isFocus ].
	^ focus
]

{ #category : #testing }
GtkAdapter >> hasWidget [

	^ widget notNil
]

{ #category : #accessing }
GtkAdapter >> helpText [

	^ self innerWidget tooltipText
]

{ #category : #initialization }
GtkAdapter >> initialize [

	super initialize.
	backendUpdating := false
]

{ #category : #'private accessing' }
GtkAdapter >> innerWidget [
	"this is the widget to be used internally (to operate). 
	 this is because widgets can be wrapped and we need to use the actual widget to 
	 config the adapter. 
	 Most of the cases, this the same as #widget"
	
	^ widget
]

{ #category : #accessing }
GtkAdapter >> innerWidgetDo: aBlock [

	self hasWidget ifFalse: [ ^ nil ].
	^ GRunLoop defer: [ 
		aBlock value: self innerWidget ]
]

{ #category : #'event installing' }
GtkAdapter >> installEvent: anEvent [

	self widgetDo: [ :w |
		anEvent installOn: self target: w ]
]

{ #category : #'event installing' }
GtkAdapter >> installFocusLostEvent: anEvent to: aWidget [

	aWidget connectFocusOutEvent: [ 
		anEvent action value. 
		false ]
]

{ #category : #'event installing' }
GtkAdapter >> installFocusReceivedEvent: anEvent to: aWidget [

	aWidget connectFocusInEvent: [
		anEvent action value. 
		false ]
]

{ #category : #'event installing' }
GtkAdapter >> installKeyDownEvent: anEvent to: aWidget [

	aWidget addKeyPressEvent: [ :event |
		anEvent action value: event.
		event wasHandled ]
]

{ #category : #'event installing' }
GtkAdapter >> installKeyUpEvent: anEvent to: aWidget [

	aWidget connectKeyReleaseEvent: [ :event |
		anEvent action value: event.
		event wasHandled ]
]

{ #category : #'event installing' }
GtkAdapter >> installMouseDoubleClickEvent: anEvent to: aWidget [

	aWidget connectDoubleClicked: [ :event |
		anEvent action value: event.
		event wasHandled ]
]

{ #category : #'event installing' }
GtkAdapter >> installMouseDownEvent: anEvent to: aWidget [

	aWidget connectButtonPressEvent: [ :event |
		anEvent action value: event.
		event wasHandled ]
]

{ #category : #'event installing' }
GtkAdapter >> installMouseEnterEvent: anEvent to: aWidget [

	aWidget addEnterEvent: [ :event |
		anEvent action value: event ]
]

{ #category : #'event installing' }
GtkAdapter >> installMouseLeaveEvent: anEvent to: aWidget [

	aWidget addLeaveEvent: [ :event |
		anEvent action value: event ]
]

{ #category : #'event installing' }
GtkAdapter >> installMouseMoveEvent: anEvent to: aWidget [

	aWidget addMotionEvent: [ :event |
		anEvent action value: event ]
]

{ #category : #'event installing' }
GtkAdapter >> installMouseUpEvent: anEvent to: aWidget [

	aWidget connectButtonReleaseEvent: [ :event |
		anEvent action value: event.
		event wasHandled ]
]

{ #category : #'private cycle detection' }
GtkAdapter >> isBackendUpdating [

	^ backendUpdating
]

{ #category : #visibility }
GtkAdapter >> isVisible [
	
	^ self innerWidget isConfiguredVisible
]

{ #category : #emulating }
GtkAdapter >> keyPressed: keyCode shift: shiftBoolean meta: metaBoolean control: controlBoolean option: optionBoolean [

	self innerWidget 
		withCallbacksOfType: GKeyPressEventCallback 
		do: [ :aCallback | 
			aCallback valueWithArguments: { 
				self innerWidget getHandle. 
				(GdkKeyEvent 
					newKeyPressValue: keyCode
					shift: shiftBoolean
					meta: metaBoolean
					control: controlBoolean
					option: optionBoolean) 
				getHandle.
				ExternalAddress null } ]
]

{ #category : #accessing }
GtkAdapter >> kmDispatcher [

	^ dispatcher
]

{ #category : #protocol }
GtkAdapter >> layout: aSpecLayoutFrame [ 
	
	self flag: #TODO.
]

{ #category : #building }
GtkAdapter >> newWidget [

	^ self widgetClass new
]

{ #category : #protocol }
GtkAdapter >> removeStyle: aStyle [

	self innerWidgetDo: [ :w | w removeClass: aStyle ]
]

{ #category : #emulating }
GtkAdapter >> sendRightClickEvent [
	
	self innerWidget 
		withCallbacksOfType: GSecondaryButtonPressEventCallback 
		do: [ :aCallback |
			aCallback valueWithArguments: {
				self innerWidget getHandle.
				GdkButtonEvent newRightClick getHandle.
				ExternalAddress null } ]
]

{ #category : #accessing }
GtkAdapter >> setBalloonText: aString [ 
	
	self innerWidgetDo: [ :w | 
		w tooltipText: self getHelpText ]
]

{ #category : #private }
GtkAdapter >> showContextMenu [

	self hasContextMenu ifFalse: [ ^ self ].
	self showMenu: self presenter contextMenu
]

{ #category : #private }
GtkAdapter >> showMenu: aValuable [
	
	lastShownMenu := self buildMenu: aValuable value.
	lastShownMenu 
		connectDestroy: [ lastShownMenu := nil ];
		showAll;
		popupAtWidget: self innerWidget
			widgetAnchor: GdkGravity GDK_GRAVITY_NORTH_WEST
			menuAnchor: GdkGravity GDK_GRAVITY_NORTH_WEST 
			triggerEvent: (GdkEvent fromHandle: ExternalAddress null).
]

{ #category : #private }
GtkAdapter >> showMenu: aValuable event: event [
	
	lastShownMenu := self buildMenu: aValuable value.
	lastShownMenu 
		connectDestroy: [ lastShownMenu := nil ];
		showAll;
		popupAtPointer: event.
]

{ #category : #protocol }
GtkAdapter >> takeKeyboardFocus [

	self doTakeKeyboardFocus
]

{ #category : #updating }
GtkAdapter >> update: aSymbol with: anArray [

	self flag: #TODO. "I'm not sure I want to do this :("
	self 
		perform: aSymbol 
		withArguments: anArray
]

{ #category : #updating }
GtkAdapter >> updateEnabled [
	
	self widgetDo: [ :w | w sensitive: self presenter isEnabled value ]
]

{ #category : #updating }
GtkAdapter >> updateHelp [
	
	self widgetDo: [ :w | w tooltipText: self presenter help  ]
]

{ #category : #updating }
GtkAdapter >> updateKeyBindings [

	dispatcher ifNotNil: [ dispatcher detachAllKeymapCategories ].
	self presenter contextKeyBindings 
		ifNotNil: [ :aCategory | self addKeyBindingCategory: aCategory to: self innerWidget ]
]

{ #category : #updating }
GtkAdapter >> updateMenu [

	self innerWidgetDo: [ :w |
		self deferredUpdateMenuIn: w ]
]

{ #category : #'private updating' }
GtkAdapter >> updateVisibility: aBoolean [ 

	self widgetDo: [ :w |
		aBoolean
			ifTrue: [ w show ]
			ifFalse: [ w hide ] ]
]

{ #category : #building }
GtkAdapter >> widgetClass [

	^ self subclassResponsibility
]

{ #category : #private }
GtkAdapter >> widgetDo: aBlock [ 

	self hasWidget ifFalse: [ ^ nil ].
	^ GRunLoop defer: [ aBlock value: widget ]
]

{ #category : #building }
GtkAdapter >> wrapWidget: gtkWidget [

	^ gtkWidget
]

{ #category : #'private utils' }
GtkAdapter >> wrapWithScrollableWindow: gtkWidget [

	^ (GtkScrolledWindow newWidget: gtkWidget)
		show;
		yourself
]
