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

	gtkButton connectClicked: [ 
		self presenter performAction ]
]

{ #category : #events }
GtkButtonAdapter >> clicked [

	self widgetDo: #clicked
]

{ #category : #factory }
GtkButtonAdapter >> newWidget [ 
	
	^ GtkButton newLabel: self getLabelText 
]
