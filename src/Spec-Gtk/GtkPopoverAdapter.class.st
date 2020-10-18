Class {
	#name : #GtkPopoverAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkPopoverAdapter >> addModelTo: gtkPopover [

	gtkPopover setConstraintTo: (GtkPopoverConstraint GTK_POPOVER_CONSTRAINT_NONE).
	gtkPopover add: self presenterWidget showAll.	
	gtkPopover beRelativeTo: self presenter relativeTo adapter innerWidget. 
	gtkPopover beModal.
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

	self widgetDo: [ :w | w popdown ]
]

{ #category : #api }
GtkPopoverAdapter >> popup [

	self widgetDo: [ :w | w popup ]
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

	^ self presenter presenter buildWithSpec
]

{ #category : #building }
GtkPopoverAdapter >> rebuild [
	
	self widgetDo: [ :w |
		self replaceChildPresenterOn: w ]
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

{ #category : #building }
GtkPopoverAdapter >> widgetClass [

	^ GtkPopover
]
