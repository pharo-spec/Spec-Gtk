Class {
	#name : 'GtkPopoverAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkPopoverAdapter >> addModelTo: gtkPopover [

	gtkPopover child: self presenterWidget.	
	gtkPopover autohide: false. "true to dismiss on click"
	gtkPopover connectHide: [ self unregister: gtkPopover ].
	self setPopoverPositionTo: gtkPopover.
	
	self presenter whenPresenterChangedDo: [
		self replaceChildPresenterOn: gtkPopover ]
]

{ #category : 'building' }
GtkPopoverAdapter >> addVisibleSettingsTo: gtkWidget [
	"popovers fo not have visibility settings, they are shown or hide"
]

{ #category : 'building' }
GtkPopoverAdapter >> buildWidget [
	
	^ super buildWidget ensureObjectRefAndAutoRelease
]

{ #category : 'api' }
GtkPopoverAdapter >> dismiss [ 

	self widgetDo: [ :w | 
		w popdown. 
		"I need to disconnect explicitly because it may cause gtk to send callbacks to 
		 me and it may (most of the times it *will*) be already collected (then... 
		 well, crash)."
		w disconnectAll ]
]

{ #category : 'api' }
GtkPopoverAdapter >> popup [

	self widgetDo: [ :w | 
		self register: w.
		w parent: self presenter relativeTo adapter innerWidget.
		w popup.
		self processInitializationDeferredActions ]
]

{ #category : 'api' }
GtkPopoverAdapter >> popupPointingTo: aRectangle [

	self widgetDo: [ :w | 
		self register: w.
		w parent: self presenter relativeTo adapter innerWidget.
		w setPointingTo: aRectangle asGdkRectangle.
		w popup.
		self processInitializationDeferredActions ]
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

{ #category : 'private' }
GtkPopoverAdapter >> unregister: gtkPopover [

	GEngine current unregisterWindow: gtkPopover
]

{ #category : 'building' }
GtkPopoverAdapter >> widgetClass [

	^ GtkPopover
]
