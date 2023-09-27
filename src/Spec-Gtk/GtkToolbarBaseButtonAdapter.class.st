Class {
	#name : #GtkToolbarBaseButtonAdapter,
	#superclass : #GtkBaseButtonAdapter,
	#category : #'Spec-Gtk-Adapter-Toolbar'
}

{ #category : #building }
GtkToolbarBaseButtonAdapter >> addActionTo: gtkButton [

	gtkButton connectClicked: [
		self presenter performAction ]
]

{ #category : #building }
GtkToolbarBaseButtonAdapter >> addModelTo: gtkButton [

	super addModelTo: gtkButton.
	self addActionTo: gtkButton
]

{ #category : #testing }
GtkToolbarBaseButtonAdapter >> hasIcon [

	^ self presenter icon notNil and: [ self presenter owner displayMode hasIcon ]
]

{ #category : #testing }
GtkToolbarBaseButtonAdapter >> hasLabel [

	^ self presenter owner displayMode hasLabel
]

{ #category : #private }
GtkToolbarBaseButtonAdapter >> labelAndIcon [
	| box |

	box := GtkBox newVertical
		vAlignCenter;
		spacing: 3;
		yourself.

	self hasIcon ifTrue: [ 
		| gtkIcon |
		gtkIcon := self presenter icon asGtkImage.
		gtkIcon vExpand: false.
		box append: gtkIcon ].

	self hasLabel ifTrue: [ 
		self getLabelText ifNotEmpty: [ :label | | gtkLabel |
			gtkLabel := (GtkLabel newLabel: label).
			box append: gtkLabel ] ].

	^ box
]

{ #category : #factory }
GtkToolbarBaseButtonAdapter >> newWidget [ 
	
	^ GtkButton new
]
