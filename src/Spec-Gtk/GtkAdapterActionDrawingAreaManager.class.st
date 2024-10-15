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

{ #category : 'private - actions' }
GtkAdapterActionDrawingAreaManager >> installContextMenuOn: gtkWidget [
	
	"drawing areas (like the morphic presenter) do not install a controller,
	 they show the menu calling showContextMenu"
	hasContextMenu := true
]
