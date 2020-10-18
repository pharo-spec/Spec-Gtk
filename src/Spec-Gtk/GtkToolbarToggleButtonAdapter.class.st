Class {
	#name : #GtkToolbarToggleButtonAdapter,
	#superclass : #GtkToolbarBaseButtonAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkToolbarToggleButtonAdapter >> addModelTo: gtkToolButton [
	
	super addModelTo: gtkToolButton.

	gtkToolButton connectToggled: [ self presenter execute: gtkToolButton active ]
]

{ #category : #building }
GtkToolbarToggleButtonAdapter >> newWidget [
	| button  |
	
	button := GtkToggleToolButton new 
		label: self presenter label;
		yourself.
		
	self presenter icon ifNotNil: [ :icon | 
		button iconWidget: icon asGtkImage ].

	^ button 
]
