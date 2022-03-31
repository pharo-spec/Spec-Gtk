Class {
	#name : #GtkPopoverAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkPopoverAdapter >> addModelTo: gtkPopover [

	gtkPopover setConstraintTo: GtkPopoverConstraint GTK_POPOVER_CONSTRAINT_NONE.
	gtkPopover add: self presenterWidget showAll.	
	gtkPopover beRelativeTo: self presenter relativeTo adapter innerWidget. 
	gtkPopover beNotModal.
	gtkPopover connectHide: [ self unregister: gtkPopover ].
	self setPopoverPositionTo: gtkPopover.
	
	self presenter whenPresenterChangedDo: [
		self replaceChildPresenterOn: gtkPopover ]
]

{ #category : #building }
GtkPopoverAdapter >> buildWidget [
	
	^ super buildWidget markForAutoRelease
]

{ #category : #api }
GtkPopoverAdapter >> dismiss [ 

	self widgetDo: [ :w | 
		w popdown. 
		"I need to destroy explicitly because it may cause gtk to send callbacks to 
		 me and it may (most of the times it *will*) be already collected (then... 
		 well, crash)."
		w destroy ]
]

{ #category : #api }
GtkPopoverAdapter >> popup [

	self widgetDo: [ :w | 
		self register: w.
		w popup; beModal ]
]

{ #category : #api }
GtkPopoverAdapter >> popupPointingTo: aRectangle [

	self widgetDo: [ :w | 
		w 
			setPointingTo: aRectangle asGdkRectangle;
			popup ]
]

{ #category : #building }
GtkPopoverAdapter >> presenterWidget [

	^ self presenter presenter build
]

{ #category : #building }
GtkPopoverAdapter >> rebuild [
	
	self widgetDo: [ :w |
		self replaceChildPresenterOn: w ]
]

{ #category : #private }
GtkPopoverAdapter >> register: gtkPopover [

	(GEngine current isWindowRegistered: gtkPopover) ifTrue: [ ^ self ].
	GEngine current registerWindow: gtkPopover
]

{ #category : #private }
GtkPopoverAdapter >> replaceChildPresenterOn: gtkPopover [

	gtkPopover 
		removeAll;
		add: self presenterWidget showAll
]

{ #category : #building }
GtkPopoverAdapter >> setPopoverPositionTo: gtkPopover [
		
	^ self presenter position applyTo: gtkPopover
]

{ #category : #private }
GtkPopoverAdapter >> unregister: gtkPopover [

	GEngine current unregisterWindow: gtkPopover
]

{ #category : #building }
GtkPopoverAdapter >> widgetClass [

	^ GtkPopover
]
