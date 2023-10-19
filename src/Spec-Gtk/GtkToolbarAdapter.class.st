Class {
	#name : 'GtkToolbarAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Adapter-Toolbar',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Toolbar'
}

{ #category : 'building' }
GtkToolbarAdapter >> addModelTo: gtkToolbar [

	super addModelTo: gtkToolbar.

	self model whenItemsChangeDo: [ self updateItems: gtkToolbar ].
	self updateItems: gtkToolbar 
]

{ #category : 'building' }
GtkToolbarAdapter >> buildButton: aButtonPresenter [ 

	^ aButtonPresenter build
]

{ #category : 'testing' }
GtkToolbarAdapter >> hasButtonWithLabel: aString [ 
	
	^ self widget children anySatisfy: [ :e | 
		(e isKindOf: GtkToolButton) and: [ e label = aString ] ]
]

{ #category : 'building' }
GtkToolbarAdapter >> newWidget [

	^ GtkBox newHorizontal
		addClass: 'toolbar';
		yourself
]

{ #category : 'building' }
GtkToolbarAdapter >> numberOfItems [

	^ self widget size
]

{ #category : 'building' }
GtkToolbarAdapter >> updateItems: gtkToolbar [

	gtkToolbar removeAll.

	self model leftItems 
		do: [ :each | gtkToolbar append: (self buildButton: each) ].
	self model rightItems 
		reverseDo: [ :each | 
			gtkToolbar append: (self buildButton: each) ]
]
