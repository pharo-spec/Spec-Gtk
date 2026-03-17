Class {
	#name : 'GtkMenuButtonAdapter',
	#superclass : 'GtkBaseButtonAdapter',
	#instVars : [
		'menuWidget'
	],
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkMenuButtonAdapter >> addModelTo: gtkButton [

	super addModelTo: gtkButton.

	gtkButton addClickEvent: [ :event | 
		self updateActions.
		event wasHandled: false ].

	self connectToSpecEvents: gtkButton.
	
	self presenter actions ifNotNil: [ :anActionGroup | 
		self setPopoverWithActionGroup: anActionGroup to: gtkButton ].

	self presenter whenActionsChangedDo: [ :anActionGroup |
		self widgetDo: [ :w |
			self setPopoverWithActionGroup: anActionGroup to: w ] ]
]

{ #category : 'building' }
GtkMenuButtonAdapter >> setPopoverWithActionGroup: anActionGroup to: gtkButton [
	| menuModel |
	
	menuModel := GtkActionMenuBuilder new 
		visit: anActionGroup;
		root.

	gtkButton popover: (GtkPopoverMenu newFromModelFull: menuModel)
]

{ #category : 'building' }
GtkMenuButtonAdapter >> updateActions [

	self widgetDo: [ :w |
		self ensureActionManager updateActions ]
]

{ #category : 'private - updating' }
GtkMenuButtonAdapter >> updateLabelAndIconTo: gtkButton [

	gtkButton alwaysShowArrow: false.
	super updateLabelAndIconTo: gtkButton
]

{ #category : 'building' }
GtkMenuButtonAdapter >> widgetClass [

	^ GtkMenuButton
]
