Class {
	#name : #GtkToolbarAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkToolbarAdapter >> addModelTo: gtkToolbar [

	super addModelTo: gtkToolbar.
	
	gtkToolbar beIconSizeSmallToolbar.
	
	self model isDisplayModeIcons ifTrue: [ gtkToolbar beIcons ].
	self model isDisplayModeText ifTrue: [ gtkToolbar beText ].
	self model isDisplayModeBoth ifTrue: [ gtkToolbar beBoth ].

	self model whenItemsChangeDo: [ self updateItems: gtkToolbar ].

	self updateItems: gtkToolbar 
]

{ #category : #testing }
GtkToolbarAdapter >> hasButtonWithLabel: aString [ 
	
	^ self widget children anySatisfy: [ :e | 
		(e isKindOf: GtkToolButton) and: [ e label = aString ] ]
]

{ #category : #building }
GtkToolbarAdapter >> needsSeparator [

	^ self model leftItems isNotEmpty and: [self model rightItems isNotEmpty]
]

{ #category : #building }
GtkToolbarAdapter >> numberOfItems [

	^ self needsSeparator
		ifTrue: [ self widget size - 1 ]
		ifFalse: [ self widget size ]
]

{ #category : #building }
GtkToolbarAdapter >> updateItems: gtkToolbar [

	gtkToolbar removeAll.

	self model leftItems do: [ :each | gtkToolbar add: each build ].

	self needsSeparator ifTrue: [ 
		gtkToolbar add: (GtkSeparatorToolItem new
				 show;
				 yourself) ].

	self model rightItems reverseDo: [ :each | 
		gtkToolbar add: each build ]
]

{ #category : #building }
GtkToolbarAdapter >> widgetClass [

	^ GtkToolbar
]
