Class {
	#name : #GtkSearchInputFieldAdapter,
	#superclass : #GtkTextInputFieldAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #private }
GtkSearchInputFieldAdapter >> widgetClass [

	^ GtkSearchEntry 
]
