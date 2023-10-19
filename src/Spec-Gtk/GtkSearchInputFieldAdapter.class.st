Class {
	#name : 'GtkSearchInputFieldAdapter',
	#superclass : 'GtkTextInputFieldAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'private' }
GtkSearchInputFieldAdapter >> widgetClass [

	^ GtkSearchEntry 
]
