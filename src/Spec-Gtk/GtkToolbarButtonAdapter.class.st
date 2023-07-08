Class {
	#name : #GtkToolbarButtonAdapter,
	#superclass : #GtkToolbarBaseButtonAdapter,
	#category : #'Spec-Gtk-Adapter-Toolbar'
}

{ #category : #factory }
GtkToolbarButtonAdapter >> newWidget [
 
	^ super newWidget
		addClass: 'toolbar-button';
		yourself
]
