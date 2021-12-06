Class {
	#name : #GtkAthensAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkAthensAdapter >> addModelTo: gtkDrawingArea [

	super addModelTo: gtkDrawingArea.
	self ensureCanAnswerEvents: gtkDrawingArea.
	gtkDrawingArea drawBlock: self presenter drawBlock.
	gtkDrawingArea extent: self presenter surfaceExtent.
	self presenter
		whenDrawBlockChangedDo: [ :newBlock | self updateDrawBlock: newBlock ].
	self presenter
		whenExtentChangedDo: [ :newExtent | self widget extent: newExtent ].
	self model contextMenu 
		ifNotNil: [ :menu | self addMenu: menu to: gtkDrawingArea ]
]

{ #category : #private }
GtkAthensAdapter >> ensureCanAnswerEvents: gtkDrawingArea [

	gtkDrawingArea canFocus: true.
	gtkDrawingArea registerToAllEvents
]

{ #category : #drawing }
GtkAthensAdapter >> redraw [

	self widgetDo: [ :w | w queueDraw ]
]

{ #category : #private }
GtkAthensAdapter >> updateDrawBlock: aBlock [

	self widgetDo: [ :w |
		w 
			drawBlock: aBlock; 
			queueDraw ]
]

{ #category : #building }
GtkAthensAdapter >> widgetClass [

	^ GtkBlockBasedDrawingArea 
]
