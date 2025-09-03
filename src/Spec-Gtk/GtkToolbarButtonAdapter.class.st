Class {
	#name : 'GtkToolbarButtonAdapter',
	#superclass : 'GtkToolbarBaseButtonAdapter',
	#category : 'Spec-Gtk-Adapter-Toolbar',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Toolbar'
}

{ #category : 'building' }
GtkToolbarButtonAdapter >> newWidget [
 
	^ super newWidget
		addClass: 'image-button';
		addClass: 'toolbar-button';
		yourself
]
