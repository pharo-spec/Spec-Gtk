Class {
	#name : 'GtkToolbarMenuButtonAdapter',
	#superclass : 'GtkToolbarBaseButtonAdapter',
	#instVars : [
		'menuWidget'
	],
	#category : 'Spec-Gtk-Adapter-Toolbar',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Toolbar'
}

{ #category : 'private' }
GtkToolbarMenuButtonAdapter >> addModelTo: gtkButton [

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
GtkToolbarMenuButtonAdapter >> newWidget [
 
	^ GtkMenuButton new
		addClass: 'image-button';
		addClass: 'toolbar-button';
		yourself
]

{ #category : 'private' }
GtkToolbarMenuButtonAdapter >> setPopoverWithActionGroup: anActionGroup to: gtkButton [
	| menuModel |
	
	menuModel := GtkActionMenuBuilder new 
		visit: anActionGroup;
		root.

	gtkButton popover: (GtkPopoverMenu newFromModelFull: menuModel)
]

{ #category : 'updating' }
GtkToolbarMenuButtonAdapter >> updateActions [

	self widgetDo: [ :w |
		self ensureActionManager updateActions ]
]

{ #category : 'private - updating' }
GtkToolbarMenuButtonAdapter >> updateLabelAndIconTo: gtkButton [

	gtkButton alwaysShowArrow: false.
	super updateLabelAndIconTo: gtkButton
]
