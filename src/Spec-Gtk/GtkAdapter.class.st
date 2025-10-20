Class {
	#name : 'GtkAdapter',
	#superclass : 'SpAbstractAdapter',
	#traits : 'GtkTSpecialCharacterForText + GtkTSpecialCharacterForList',
	#classTraits : 'GtkTSpecialCharacterForText classTrait + GtkTSpecialCharacterForList classTrait',
	#instVars : [
		'lastShownMenu',
		'backendUpdating',
		'dispatcher',
		'actionManager'
	],
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'specs' }
GtkAdapter class >> adaptingName [
	"Answers the name this component adapts."

	"Remove the 'Gtk' part will almost always give us the adapter name"
	^ (self name allButFirst: 3) asSymbol
]

{ #category : 'initialize' }
GtkAdapter class >> allAdapters [

	^ self allSubclasses
]

{ #category : 'testing' }
GtkAdapter class >> isAbstract [ 

	^ self = GtkAdapter
]

{ #category : 'initialization' }
GtkAdapter >> adapt: aPresenter [

	^ GRunLoop defer: [ super adapt: aPresenter ]
]

{ #category : 'private - actions' }
GtkAdapter >> addAction: action toWidget: aWidget [

	self ensureActionManager 
		installAction: action 
		on: aWidget
]

{ #category : 'adding' }
GtkAdapter >> addActionGroup: anActionGroup [
	"this is used to install 'special' actions ported from a window"

	self ensureActionManager 
		installGroup: anActionGroup
		on: self innerWidget
]

{ #category : 'building' }
GtkAdapter >> addActionsTo: gtkWidget [
	
	self hasActions ifFalse: [ ^ self ].

	actionManager := self ensureActionManager.
	actionManager installOn: gtkWidget
]

{ #category : 'private - actions' }
GtkAdapter >> addKeyCombination: aShortcut action: aBlock toWidget: aWidget [

	self ensureActionManager 
		installAction: (SpAction newShortcutKey: aShortcut action: aBlock) 
		on: aWidget
]

{ #category : 'TOREMOVE' }
GtkAdapter >> addMenu: aValuable to: gtkWidget [

	gtkWidget connectRightClicked: [ :event |
		self showMenu: aValuable event: event.
		true ]
]

{ #category : 'building' }
GtkAdapter >> addModelTo: gtkWidget [
]

{ #category : 'building' }
GtkAdapter >> addSettingsTo: gtkWidget [
	"A secondary initialization generic to all widgets"

	self presenter styles 
		do: [ :each | gtkWidget addClass: each ].
	
	gtkWidget sensitive: self presenter isEnabled value.
	self presenter help ifNotNil: [ gtkWidget tooltipText: self getHelpText ].
	self presenter whenHelpChangedDo: [ 
		self backendUpdatingDo: [ self updateHelp ] ].
	self presenter whenActionsChangedDo: [ 
		self backendUpdatingDo: [ self updateActions ] ].
	
	self addVisibleSettingsTo: gtkWidget
]

{ #category : 'accessing - style' }
GtkAdapter >> addStyle: aStyle [

	self innerWidgetDo: [ :w | w addClass: aStyle ]
]

{ #category : 'building' }
GtkAdapter >> addVisibleSettingsTo: gtkWidget [

	self presenter isVisible
		ifTrue: [ gtkWidget beVisible ]
		ifFalse: [ gtkWidget beNotVisible ].
	self presenter whenVisibleChangedDo: [ :aValuable |
		self updateVisibility: aValuable value ]
]

{ #category : 'private - cycle detection' }
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

{ #category : 'TOREMOVE' }
GtkAdapter >> buildMenu: aMenuPresenter [

	^ aMenuPresenter 
		owner: self presenter;
		build
]

{ #category : 'building' }
GtkAdapter >> buildWidget [ 
	| gtkWidget |
	
	gtkWidget := self newWidget.
	self addSettingsTo: gtkWidget.
	self addEventsTo: gtkWidget.
	self addModelTo: gtkWidget.
	self addActionsTo: gtkWidget.
	
	^ self wrapWidget: gtkWidget
]

{ #category : 'releasing' }
GtkAdapter >> cleanupAfterReplacing [ 

	widget := nil
]

{ #category : 'TOREMOVE' }
GtkAdapter >> deferredUpdateMenuIn: gtkWidget [
	| existingCallbacks menu |

	existingCallbacks := Set new.
	gtkWidget 
		withCallbacksOfType: GSecondaryButtonPressEventCallback 
		do: [ :each | existingCallbacks add: each ].
		
	menu := self presenter contextMenu. 
	menu ifNil: [ 
		existingCallbacks do: [ :each | each disconnectFrom: gtkWidget ].
		^ self ].
	"if there is already a callback, I do not need to do anything (because it will be 
	 evaluated each time)"
	existingCallbacks ifNotEmpty: [ ^ self ].
	"Now, actually add the menu callback"
	self addMenu: menu to: gtkWidget
]

{ #category : 'private' }
GtkAdapter >> doInitializationDeferredActions [
	"some components can require a deferred action (to be executed when 
	 window is presented). Override this if this is the case."
]

{ #category : 'accessing - focus' }
GtkAdapter >> doTakeKeyboardFocus [

	self innerWidgetDo: [ :w | 
		self presenter withWindowDo: [ :window | 
			window adapter
				ifNotNil: [ self doTakeKeyboardFocus: w ]
				ifNil: [ w deferAction: [ self doTakeKeyboardFocus: w ] ] ] ]
]

{ #category : 'accessing - focus' }
GtkAdapter >> doTakeKeyboardFocus: gtkWidget [

	gtkWidget grabFocus
]

{ #category : 'accessing' }
GtkAdapter >> enabled [

	^ self innerWidgetDo: [ :w | w sensitive ]
]

{ #category : 'accessing' }
GtkAdapter >> enabled: aBoolean [

	self widgetDo: [ :w |
		w sensitive: aBoolean ]
]

{ #category : 'private - actions' }
GtkAdapter >> ensureActionManager [

	^ actionManager ifNil: [ actionManager := self newActionManager ]
]

{ #category : 'private' }
GtkAdapter >> getHelpText [

	^ self presenter help ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : 'TOREMOVE' }
GtkAdapter >> handleKeyEvent: event [

	self halt.
	event isModifier ifTrue: [ ^ false ].
	dispatcher ifNotNil: [
		dispatcher dispatchKeyEvent: event.
		^ event wasHandled ].
	
	^ false
]

{ #category : 'testing' }
GtkAdapter >> hasActions [

	^ self presenter actions isNotNil
		or: [ self presenter internalActions isNotNil ]
]

{ #category : 'testing' }
GtkAdapter >> hasContextMenu [

	^ actionManager notNil
		and: [ actionManager hasContextMenu ]
]

{ #category : 'accessing - focus' }
GtkAdapter >> hasKeyboardFocus [
	| focus |
	
	focus := false.
	self innerWidgetDo: [ :w | focus := w isFocus ].
	^ focus
]

{ #category : 'testing' }
GtkAdapter >> hasWidget [

	^ widget notNil
]

{ #category : 'accessing' }
GtkAdapter >> helpText [

	^ self innerWidget tooltipText
]

{ #category : 'initialization' }
GtkAdapter >> initialize [

	super initialize.
	backendUpdating := false
]

{ #category : 'private - accessing' }
GtkAdapter >> innerWidget [
	"this is the widget to be used internally (to operate). 
	 this is because widgets can be wrapped and we need to use the actual widget to 
	 config the adapter. 
	 Most of the cases, this the same as #widget"
	
	^ widget
]

{ #category : 'private' }
GtkAdapter >> innerWidgetDo: aBlock [

	self hasWidget ifFalse: [ ^ nil ].
	^ GRunLoop defer: [ 
		[ aBlock value: self innerWidget ]
		on: Error 
		fork: [ :e | e pass ]
		return: [ nil ] ]
]

{ #category : 'event installing' }
GtkAdapter >> installEvent: anEvent [

	self widgetDo: [ :w |
		anEvent installOn: self target: w ]
]

{ #category : 'event installing' }
GtkAdapter >> installFocusLostEvent: anEvent to: aWidget [

	aWidget addFocusLeaveEvent: [ :event |
		anEvent action cull: event ]
]

{ #category : 'event installing' }
GtkAdapter >> installFocusReceivedEvent: anEvent to: aWidget [

	aWidget addFocusEnterEvent: [ :event |
		anEvent action cull: event ]
]

{ #category : 'event installing' }
GtkAdapter >> installKeyDownEvent: anEvent to: aWidget [

	aWidget addKeyPressEvent: [ :event |
		anEvent action value: event.
		event wasHandled ]
]

{ #category : 'event installing' }
GtkAdapter >> installKeyUpEvent: anEvent to: aWidget [

	aWidget addKeyReleaseEvent: [ :event |
		anEvent action value: event.
		event wasHandled ]
]

{ #category : 'event installing' }
GtkAdapter >> installMouseDoubleClickEvent: anEvent to: aWidget [

	aWidget addDoubleClickEvent: [ :event |
		anEvent action value: event.
		event wasHandled ]
]

{ #category : 'event installing' }
GtkAdapter >> installMouseDownEvent: anEvent to: aWidget [

	aWidget addButtonPressEvent: [ :event |
		anEvent action value: event.
		event wasHandled ]
]

{ #category : 'event installing' }
GtkAdapter >> installMouseEnterEvent: anEvent to: aWidget [

	aWidget addEnterEvent: [ :event |
		anEvent action value: event ]
]

{ #category : 'event installing' }
GtkAdapter >> installMouseLeaveEvent: anEvent to: aWidget [

	aWidget addLeaveEvent: [ :event |
		anEvent action value: event ]
]

{ #category : 'event installing' }
GtkAdapter >> installMouseMoveEvent: anEvent to: aWidget [

	aWidget addMotionEvent: [ :event |
		anEvent action value: event ]
]

{ #category : 'event installing' }
GtkAdapter >> installMouseUpEvent: anEvent to: aWidget [

	aWidget addButtonReleaseEvent: [ :event |
		anEvent action value: event.
		event wasHandled ]
]

{ #category : 'private - cycle detection' }
GtkAdapter >> isBackendUpdating [

	^ backendUpdating
]

{ #category : 'visibility' }
GtkAdapter >> isVisible [

	^ self innerWidgetDo: [ :w | w isConfiguredVisible ]
]

{ #category : 'emulating' }
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

{ #category : 'TOREMOVE' }
GtkAdapter >> kmDispatcher [

	^ dispatcher
]

{ #category : 'accessing' }
GtkAdapter >> layout: aSpecLayoutFrame [ 
	
	self flag: #TODO.
]

{ #category : 'private - actions' }
GtkAdapter >> newActionManager [

	^ GtkAdapterActionManager on: self
]

{ #category : 'building' }
GtkAdapter >> newWidget [

	^ self widgetClass new
]

{ #category : 'accessing - style' }
GtkAdapter >> removeStyle: aStyle [

	self innerWidgetDo: [ :w | w removeClass: aStyle ]
]

{ #category : 'private' }
GtkAdapter >> runInSystem: aBlock [
	"This will just make sure we left the main thread (e.g. the execution in callback) to run in the environment"
	
	GRunLoop enterSystem: aBlock
]

{ #category : 'emulating' }
GtkAdapter >> sendRightClickEvent [
	
	self innerWidget 
		withCallbacksOfType: GSecondaryButtonPressEventCallback 
		do: [ :aCallback |
			aCallback valueWithArguments: {
				self innerWidget getHandle.
				GdkButtonEvent newRightClick getHandle.
				ExternalAddress null } ]
]

{ #category : 'private - actions' }
GtkAdapter >> showContextMenu [

	self hasContextMenu ifFalse: [ ^ self ].
	actionManager showContextMenu
]

{ #category : 'private - actions' }
GtkAdapter >> showMenu: aValuable event: event [
	
	lastShownMenu := self buildMenu: aValuable value.
	lastShownMenu 
		connectDestroy: [ lastShownMenu := nil ];
		popupAtPointer: event.
]

{ #category : 'accessing - focus' }
GtkAdapter >> takeKeyboardFocus [

	self doTakeKeyboardFocus
]

{ #category : 'updating' }
GtkAdapter >> update: aSymbol with: anArray [

	self flag: #TODO. "I'm not sure I want to do this :("
	self halt. "in fact no, I do not want, I will stop here to change the occurences, then remove"
	self 
		perform: aSymbol 
		withArguments: anArray
]

{ #category : 'updating' }
GtkAdapter >> updateActions [

	self innerWidgetDo: [ :w |
		self ensureActionManager updateOn: w ]
]

{ #category : 'updating' }
GtkAdapter >> updateHelp [
	
	self widgetDo: [ :w | w tooltipText: self presenter help  ]
]

{ #category : 'private - actions' }
GtkAdapter >> updateMenu [

	self innerWidgetDo: [ :w |
		self deferredUpdateMenuIn: w ]
]

{ #category : 'accessing' }
GtkAdapter >> updateVisibility: aBoolean [ 

	self widgetDo: [ :w |
		aBoolean
			ifTrue: [ w beVisible ]
			ifFalse: [ w beNotVisible ] ]
]

{ #category : 'building' }
GtkAdapter >> widgetClass [

	^ self subclassResponsibility
]

{ #category : 'private' }
GtkAdapter >> widgetDo: aBlock [ 

	self hasWidget ifFalse: [ ^ nil ].
	^ GRunLoop defer: [
		[ aBlock value: widget ]
		on: Error 
		fork: [ :e | e pass ]
		return: [ nil ] ]
]

{ #category : 'private - cycle detection' }
GtkAdapter >> withCycleDetectionOnBackendDo: aBlock [ 

	self isBackendUpdating ifTrue: [ ^ self ].
	^ aBlock value
]

{ #category : 'building' }
GtkAdapter >> wrapWidget: gtkWidget [

	^ gtkWidget
]

{ #category : 'private - utils' }
GtkAdapter >> wrapWithScrollableWindow: gtkWidget [

	^ (GtkScrolledWindow newWidget: gtkWidget)
		  beVisible;
		  yourself
]
