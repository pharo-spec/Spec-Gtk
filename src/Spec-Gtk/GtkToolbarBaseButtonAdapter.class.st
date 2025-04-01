Class {
	#name : 'GtkToolbarBaseButtonAdapter',
	#superclass : 'GtkBaseButtonAdapter',
	#category : 'Spec-Gtk-Adapter-Toolbar',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Toolbar'
}

{ #category : 'building' }
GtkToolbarBaseButtonAdapter >> addActionTo: gtkButton [

	gtkButton connectClicked: [
		self runInSystem: [ [ self performAction ] fork ] ]
]

{ #category : 'building' }
GtkToolbarBaseButtonAdapter >> addModelTo: gtkButton [

	super addModelTo: gtkButton.
	self addActionTo: gtkButton
]

{ #category : 'testing' }
GtkToolbarBaseButtonAdapter >> hasIcon [

	^ self presenter owner displayMode hasIcon 
		and: [ self presenter icon notNil ]
]

{ #category : 'testing' }
GtkToolbarBaseButtonAdapter >> hasLabel [

	^ self presenter owner displayMode hasLabel
]

{ #category : 'private' }
GtkToolbarBaseButtonAdapter >> labelAndIcon [
	| box gtkIcon gtkLabel |

	box := GtkBox newVertical
		vAlignCenter;
		spacing: 3;
		yourself.

	gtkIcon := GtkImage new.
	gtkIcon vExpand: false.
	box append: gtkIcon.
	gtkIcon visible: false.

	gtkLabel := GtkLabel new.
	box append: gtkLabel.
	gtkLabel visible: false.

	^ box
]

{ #category : 'factory' }
GtkToolbarBaseButtonAdapter >> newWidget [ 
	
	^ GtkButton new
]

{ #category : 'private' }
GtkToolbarBaseButtonAdapter >> performAction [

	self presenter performAction
]
