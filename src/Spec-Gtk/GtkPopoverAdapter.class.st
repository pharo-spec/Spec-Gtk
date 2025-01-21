Class {
	#name : 'GtkPopoverAdapter',
	#superclass : 'GtkAdapter',
	#traits : 'GtkTSpecialCharacterForText + GtkTSpecialCharacterForList',
	#classTraits : 'GtkTSpecialCharacterForText classTrait + GtkTSpecialCharacterForList classTrait',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkPopoverAdapter >> addModelTo: gtkPopover [

	gtkPopover child: self presenterWidget.	
	gtkPopover autohide: false. "true to dismiss on click"
	gtkPopover connectHide: [
		self announceClosed.
		self unregister: gtkPopover ].
	self setPopoverPositionTo: gtkPopover.
	
	self presenter whenPresenterChangedDo: [
		self replaceChildPresenterOn: gtkPopover ]
]

{ #category : 'building' }
GtkPopoverAdapter >> addVisibleSettingsTo: gtkWidget [
	"popovers fo not have visibility settings, they are shown or hide"
]

{ #category : 'private - announcing' }
GtkPopoverAdapter >> announceClosed [

	self presenter popoverClosed
]

{ #category : 'private - announcing' }
GtkPopoverAdapter >> announceOpened [

	self presenter popoverOpened
]

{ #category : 'building' }
GtkPopoverAdapter >> buildWidget [
	
	^ super buildWidget 
		"objectRef;"
		yourself
		"ensureObjectRefAndAutoRelease"
]

{ #category : 'api' }
GtkPopoverAdapter >> dismiss [ 

	self widgetDo: [ :w | 
		w popdown.
		"I need to disconnect explicitly because it may cause gtk to send callbacks to 
		 me and it may (most of the times it *will*) be already collected (then... 
		 well, crash)."
		"3/01/2025 -> testing without"
		"w disconnectAll."
		"unset parent (no idea if this is ok, but there is an error around saying: 
		 Funalizing X but it has children left
			- GtkPopover... etc.
		 which indicates I am not disposing correcly this guys..."
		 "w unparent"
		 "3/01/2025 -> I moved most of this to #unregister: (which is what happens on 
		  hide... no idea how all this will work out." ]
]

{ #category : 'api' }
GtkPopoverAdapter >> popup [

	self popupPointingTo: nil
]

{ #category : 'api' }
GtkPopoverAdapter >> popupModal [
	"is not really 'modal' but it will be hidden when lost focus/clicking 
	 outside..."

	self widgetDo: [ :w |
		w autohide: true.
		self popupPointingTo: nil ]
]

{ #category : 'api' }
GtkPopoverAdapter >> popupModalPointingTo: aRectangle [

	self widgetDo: [ :w |
		w autohide: true.
		self popupPointingTo: aRectangle ]
]

{ #category : 'api' }
GtkPopoverAdapter >> popupPointingTo: aRectangle [

	self widgetDo: [ :w | 
		self register: w.
		w parent: self presenter relativeTo adapter innerWidget.
		aRectangle ifNotNil: [ 
			w setPointingTo: aRectangle asGdkRectangle ].
		w popup.
		self processInitializationDeferredActions.
		self announceOpened.
		self presenter takeKeyboardFocus ]
]

{ #category : 'building' }
GtkPopoverAdapter >> presenterWidget [

	^ self presenter presenter build
]

{ #category : 'private' }
GtkPopoverAdapter >> processInitializationDeferredActions [
	
	self presenter traversePresentersDo: [ :each | 
		each adapter ifNotNil: [ :anAdapter |
			anAdapter doInitializationDeferredActions ] ] 
]

{ #category : 'building' }
GtkPopoverAdapter >> rebuild [
	
	self widgetDo: [ :w |
		self replaceChildPresenterOn: w ]
]

{ #category : 'private' }
GtkPopoverAdapter >> register: gtkPopover [

	(GEngine current isWindowRegistered: gtkPopover) ifTrue: [ ^ self ].
	GEngine current registerWindow: gtkPopover
]

{ #category : 'private' }
GtkPopoverAdapter >> replaceChildPresenterOn: gtkPopover [

	gtkPopover 
		removeAll;
		add: self presenterWidget
]

{ #category : 'building' }
GtkPopoverAdapter >> setPopoverPositionTo: gtkPopover [
		
	^ self presenter position applyTo: gtkPopover
]

{ #category : 'private - building' }
GtkPopoverAdapter >> specialActionsForListWidgetGroupName [
		
	^ #'popover-special-characters-list'
]

{ #category : 'private - building' }
GtkPopoverAdapter >> specialActionsForTextWidgetGroupName [
		
	^ #'popover-special-characters-text'
]

{ #category : 'private' }
GtkPopoverAdapter >> unregister: gtkPopover [

	"'remove' printToStdout.
	gtkPopover getHandle printToStdout."
	gtkPopover child: GObject null.
	"gtkPopover objectUnref."
	GEngine current unregisterWindow: gtkPopover
]

{ #category : 'building' }
GtkPopoverAdapter >> widgetClass [

	^ GtkPopover
]
