Class {
	#name : #GtkAthensAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkAthensAdapter >> addModelTo: gtkWidget [

	super addModelTo: gtkWidget.
	gtkWidget drawBlock: self presenter drawBlock.
	gtkWidget extent: self presenter surfaceExtent.
	self presenter
		whenDrawBlockChangedDo: [ :newBlock | self widget drawBlock: newBlock ].
	self presenter
		whenExtentChangedDo: [ :newExtent | self widget extent: newExtent ].
	self model contextMenu 
		ifNotNil: [ :menu | self addMenu: menu to: gtkWidget ]
]

{ #category : #drawing }
GtkAthensAdapter >> redraw [

	self widgetDo: #queueDraw
]

{ #category : #building }
GtkAthensAdapter >> widgetClass [
	^ GtkBlockBasedDrawingArea 
]
