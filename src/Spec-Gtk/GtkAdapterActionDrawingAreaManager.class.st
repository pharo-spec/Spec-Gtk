Class {
	#name : 'GtkAdapterActionDrawingAreaManager',
	#superclass : 'GtkAdapterActionManager',
	#category : 'Spec-Gtk-Actions',
	#package : 'Spec-Gtk',
	#tag : 'Actions'
}

{ #category : 'private - actions' }
GtkAdapterActionDrawingAreaManager >> installActionGroupShortcuts: anActionGroup on: gtkWidget [

	self anyCommandHasShortcut ifFalse: [ ^ self ].
	
	gtkWidget focusable: true.
	super installActionGroupShortcuts: anActionGroup on: gtkWidget
]
