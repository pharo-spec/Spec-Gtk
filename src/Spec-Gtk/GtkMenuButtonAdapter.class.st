Class {
	#name : #GtkMenuButtonAdapter,
	#superclass : #GtkBaseButtonAdapter,
	#instVars : [
		'menuWidget'
	],
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkMenuButtonAdapter >> addModelTo: gtkButton [

	super addModelTo: gtkButton.
	gtkButton 
		connect: 'button-press-event'
		signature: #(gboolean (void *widget, void *event, void *data))
		do: [ :w :event :data | 
			self updateMenu.
			(GtkMenuButton fromHandle: w) 
				menuPopup: menuWidget 
				widgetGravity: GdkGravity GDK_GRAVITY_SOUTH_WEST 
				menuGravity: GdkGravity GDK_GRAVITY_NORTH_WEST. 
			false ]
]

{ #category : #building }
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

{ #category : #updating }
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

{ #category : #building }
GtkMenuButtonAdapter >> widgetClass [

	^ GtkMenuButton
]
