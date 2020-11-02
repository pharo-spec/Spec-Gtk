Class {
	#name : #GtkToolbarPopoverButtonAdapter,
	#superclass : #GtkToolbarBaseButtonAdapter,
	#instVars : [
		'menuWidget'
	],
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkToolbarPopoverButtonAdapter >> addModelTo: gtkToolButton [
	
	super addModelTo: gtkToolButton.
	gtkToolButton connectClicked: [ self showPopover ]
]

{ #category : #building }
GtkToolbarPopoverButtonAdapter >> newWidget [
	
	^ GtkToolButton 
		newForm: self presenter icon 
		label: self presenter label
]

{ #category : #building }
GtkToolbarPopoverButtonAdapter >> showPopover [

	self presenter newPopover
		addStyle: 'popover-toolbar';
		presenter: self presenter content value;
		popup
]
