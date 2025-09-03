Class {
	#name : 'GtkButtonAdapter',
	#superclass : 'GtkBaseButtonAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkButtonAdapter >> addActionTo: gtkButton [

	gtkButton connectClicked: [
		self runInSystem: [ self presenter performAction ] ]
]

{ #category : 'building' }
GtkButtonAdapter >> addModelTo: gtkButton [

	super addModelTo: gtkButton.
	self addActionTo: gtkButton
]

{ #category : 'events' }
GtkButtonAdapter >> clicked [

	self deprecated: #Gtk4
]

{ #category : 'building' }
GtkButtonAdapter >> newWidget [ 
	
	^ self widgetClass newLabel: self getLabelText 
]
