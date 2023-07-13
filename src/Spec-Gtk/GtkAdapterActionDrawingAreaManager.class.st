Class {
	#name : #GtkAdapterActionDrawingAreaManager,
	#superclass : #GtkAdapterActionManager,
	#category : #'Spec-Gtk-Actions'
}

{ #category : #'private - actions' }
GtkAdapterActionDrawingAreaManager >> installShortcutsOn: gtkDrawingArea [

	self anyCommandHasShortcut ifFalse: [ ^ self ].
	
	gtkDrawingArea focusable: true.
	super installShortcutsOn: gtkDrawingArea

]
