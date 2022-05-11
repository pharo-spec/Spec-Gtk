Class {
	#name : #GtkToolbarBaseButtonAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkToolbarBaseButtonAdapter >> addModelTo: gtkToolButton [
	
	"Show all to ensure icons are shown if they are not"
	gtkToolButton showAll.
	
	gtkToolButton tooltipText: self presenter help.
	
	self presenter contextMenu 
		ifNotNil: [ :menu | self addMenu: menu to: gtkToolButton ].
	
	self presenter 
		whenLabelChangedDo: [ self updateLabel ];
		whenIconChangedDo: [ self updateIcon ]
]

{ #category : #accessing }
GtkToolbarBaseButtonAdapter >> icon [ 

	^ self presenter icon
		ifNotNil: [ :icon | icon asGtkImage show ]
		ifNil: [ GtkImage null ]
]

{ #category : #private }
GtkToolbarBaseButtonAdapter >> ownerWidget [
	
	"A horrible way to get the widget of the owner. 
	 It may fail at any pont :("
	^ self presenter owner adapter widget
]

{ #category : #updating }
GtkToolbarBaseButtonAdapter >> updateEnabled [

	"It it is not included in owner, it will be collected by GTK, causing a crash"
	(self ownerWidget includes: self widget) ifFalse: [ ^ self ].
	super updateEnabled
]

{ #category : #updating }
GtkToolbarBaseButtonAdapter >> updateIcon [ 

	self widgetDo: [ :w |
		w iconWidget: self icon ]
]

{ #category : #updating }
GtkToolbarBaseButtonAdapter >> updateLabel [ 

	self widgetDo: [ :w | 
		w label: self presenter label ]
]
