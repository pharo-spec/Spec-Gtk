Class {
	#name : 'GtkMenuBaseAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Adapter-Menu',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Menu'
}

{ #category : 'building' }
GtkMenuBaseAdapter >> addModelTo: gtkWidget [

	self subclassResponsibility
]
