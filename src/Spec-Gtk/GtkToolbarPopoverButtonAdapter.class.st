Class {
	#name : 'GtkToolbarPopoverButtonAdapter',
	#superclass : 'GtkToolbarBaseButtonAdapter',
	#instVars : [
		'menuWidget'
	],
	#category : 'Spec-Gtk-Adapter-Toolbar',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Toolbar'
}

{ #category : 'building' }
GtkToolbarPopoverButtonAdapter >> addModelTo: gtkToolButton [
	
	super addModelTo: gtkToolButton.
	gtkToolButton connectClicked: [ self showPopover ]
]

{ #category : 'building' }
GtkToolbarPopoverButtonAdapter >> newWidget [
	
	^ GtkToolButton 
		newForm: self presenter icon 
		label: self presenter label
]

{ #category : 'building' }
GtkToolbarPopoverButtonAdapter >> showPopover [

	self presenter newPopover
		addStyle: 'popoverButton';
		presenter: self presenter content value;
		popup
]
