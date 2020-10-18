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

	menuPresenter owner: self presenter.
	menuWidget := SpBindings
		value: self presenter application adapterBindings
		during: [ menuPresenter buildWithSpec ].
	^ menuWidget
]

{ #category : #updating }
GtkMenuButtonAdapter >> updateMenu [

	self presenter menu ifNotNil: [ :aValuable |
		aValuable value ifNotNil: [ :aMenu |
			self widgetDo: [ :w | w popUp: (self buildMenu: aMenu) showAll ] ] ]
]

{ #category : #building }
GtkMenuButtonAdapter >> widgetClass [

	^ GtkMenuButton
]
