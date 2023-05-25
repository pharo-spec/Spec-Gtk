Class {
	#name : #GtkButtonAdapter,
	#superclass : #GtkBaseButtonAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkButtonAdapter >> addActionTo: gtkButton [

	gtkButton connectClicked: [
		self presenter performAction ]
]

{ #category : #building }
GtkButtonAdapter >> addModelTo: gtkButton [

	super addModelTo: gtkButton.

	self presenter contextMenu ifNotNil: [ :menu |
		self addMenu: menu to: gtkButton ].

	self addActionTo: gtkButton
]

{ #category : #events }
GtkButtonAdapter >> clicked [

	self deprecated: #Gtk4
]

{ #category : #factory }
GtkButtonAdapter >> newWidget [ 
	
	^ GtkButton newLabel: self getLabelText 
]
