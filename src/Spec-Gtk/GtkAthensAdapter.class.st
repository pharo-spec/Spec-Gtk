Class {
	#name : 'GtkAthensAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkAthensAdapter >> addModelTo: gtkDrawingArea [

	super addModelTo: gtkDrawingArea.
	self ensureCanAnswerEvents: gtkDrawingArea.
	gtkDrawingArea drawBlock: [ :cr :boundingBox | 
		(AthensCairoCanvas fromHandle: cr) surface drawDuring: [ :canvas |
			self presenter drawBlock
				value: canvas
				value: boundingBox ] ].
	gtkDrawingArea extent: self presenter surfaceExtent.
	"gtkDrawingArea addVerticalScrollEvent: [ :event | event crTrace. false ]."
	self presenter
		whenDrawBlockChangedDo: [ :newBlock | self updateDrawBlock: newBlock ].
	self presenter
		whenExtentChangedDo: [ :newExtent | self widget extent: newExtent ]
]

{ #category : 'private' }
GtkAthensAdapter >> ensureCanAnswerEvents: gtkDrawingArea [

	gtkDrawingArea canFocus: true.
	gtkDrawingArea registerToAllEvents
]

{ #category : 'private - actions' }
GtkAthensAdapter >> newActionManager [

	^ GtkAdapterActionDrawingAreaManager on: self
]

{ #category : 'drawing' }
GtkAthensAdapter >> redraw [

	self widgetDo: [ :w | w queueDraw ]
]

{ #category : 'private' }
GtkAthensAdapter >> updateDrawBlock: aBlock [

	self widgetDo: [ :w |
		w 
			drawBlock: aBlock; 
			queueDraw ]
]

{ #category : 'building' }
GtkAthensAdapter >> widgetClass [

	^ GtkBlockBasedDrawingArea 
]
