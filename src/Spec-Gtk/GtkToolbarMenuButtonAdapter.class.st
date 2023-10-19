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
GtkToolbarMenuButtonAdapter >> addModelTo: gtkToolButton [

	super addModelTo: gtkToolButton.
	gtkToolButton connectClicked: self presenter action.
	self updateMenuTo: gtkToolButton.
	gtkToolButton connectShowMenu: [ self updateMenu ]
]

{ #category : 'building' }
GtkToolbarMenuButtonAdapter >> buildMenu: menuPresenter [

	menuPresenter owner: self presenter.
	menuWidget := SpBindings
		value: self presenter application adapterBindings
		during: [ menuPresenter build ].
	^ menuWidget
]

{ #category : 'accessing' }
GtkToolbarMenuButtonAdapter >> icon [

	^ self presenter icon 
		ifNotNil: [ :icon | icon asGtkImage ]
		ifNil: [ GtkImage null ]
]

{ #category : 'building' }
GtkToolbarMenuButtonAdapter >> newWidget [
	
	^ GtkMenuToolButton 
		newIcon: self icon 
		label: (self presenter label ifNil: [ '' ])
]

{ #category : 'updating' }
GtkToolbarMenuButtonAdapter >> updateMenu [

	self widgetDo: [ :w | self updateMenuTo: w ]
]

{ #category : 'updating' }
GtkToolbarMenuButtonAdapter >> updateMenuTo: aWidget [

	self presenter menu ifNotNil: [ :aValuable |
		aValuable value ifNotNil: [ :aMenu |
			aWidget menu: (self buildMenu: aMenu) showAll ] ]
]
