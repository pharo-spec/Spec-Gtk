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

{ #category : #private }
GtkToolbarBaseButtonAdapter >> labelAndIcon [
	| box |

	box := GtkBox newVertical
		vAlignCenter;
		spacing: 3;
		yourself.

	self presenter icon ifNotNil: [ :icon | | gtkIcon |
		gtkIcon := self presenter icon asGtkImage.
		gtkIcon vExpand: false.
		box append: gtkIcon ].

	self getLabelText ifNotNil: [ :label | | gtkLabel |
		label ifNotEmpty: [
			gtkLabel := (GtkLabel newLabel: label).
			box append: gtkLabel ] ].

	^ box
]

{ #category : #factory }
GtkToolbarBaseButtonAdapter >> newWidget [ 
	
	^ GtkButton newLabel: self getLabelText 
]
