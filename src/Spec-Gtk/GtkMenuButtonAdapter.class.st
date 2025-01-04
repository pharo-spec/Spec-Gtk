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

	self connectToSpecEvents: gtkButton.
	
	self presenter actions ifNotNil: [ :anActionGroup | 
		self setPopoverWithActionGroup: anActionGroup to: gtkButton ].

	self presenter whenActionsChangedDo: [ :anActionGroup |
		self widgetDo: [ :w |
			self setPopoverWithActionGroup: anActionGroup to: w ] ]
]

{ #category : 'building' }
GtkMenuButtonAdapter >> buildMenu: menuPresenter [

	self halt. 
	"Use a visitor here, to 
	a. build a menu model.
	b. build an action map."
	menuPresenter owner: self presenter.
	menuWidget := SpBindings
		value: self presenter application adapterBindings
		during: [ menuPresenter build ].
	^ menuWidget
]

{ #category : 'building' }
GtkMenuButtonAdapter >> setPopoverWithActionGroup: anActionGroup to: gtkButton [
	| menuModel |
	
	menuModel := GtkActionMenuBuilder new 
		visit: anActionGroup;
		root.

	gtkButton popover: (GtkPopoverMenu newFromModelFull: menuModel)
]

{ #category : 'private - updating' }
GtkMenuButtonAdapter >> updateLabelAndIconTo: gtkButton [

	gtkButton alwaysShowArrow: false.
	super updateLabelAndIconTo: gtkButton
]

{ #category : 'updating' }
GtkMenuButtonAdapter >> updateMenu [

	self halt. 
	"do: 
	a. build menu should answer both a menuModel and an action map (do a builder for it).
	b. remove previous action map for the component 
	c. install new action map (this is a deferred action, that needs to be finished on the window)
	"
	self presenter menu ifNotNil: [ :aValuable |
		aValuable value ifNotNil: [ :aMenu |
			self widgetDo: [ :w | w menuModel: (self buildMenu: aMenu) ] ] ]
]

{ #category : 'building' }
GtkMenuButtonAdapter >> widgetClass [

	^ GtkMenuButton
]
