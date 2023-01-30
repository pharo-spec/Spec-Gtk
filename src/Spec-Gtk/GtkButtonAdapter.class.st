Class {
	#name : #GtkButtonAdapter,
	#superclass : #GtkBaseButtonAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkButtonAdapter >> addModelTo: gtkButton [

	super addModelTo: gtkButton.

	self presenter contextMenu ifNotNil: [ :menu |
		self addMenu: menu to: gtkButton ].

	gtkButton addClickEvent: [
		self presenter performAction ]
]

{ #category : #events }
GtkButtonAdapter >> clicked [

	self deprecated: #Gtk4
]

{ #category : #factory }
GtkButtonAdapter >> newWidget [ 
	
	^ GtkButton newLabel: self getLabelText 
]
