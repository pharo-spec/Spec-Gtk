Class {
	#name : 'GtkAlexandrieAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Alexandrie',
	#package : 'Spec-Gtk-Alexandrie'
}

{ #category : 'building' }
GtkAlexandrieAdapter >> addModelTo: gtkDrawingArea [

	super addModelTo: gtkDrawingArea.
	self ensureCanAnswerEvents: gtkDrawingArea.
	gtkDrawingArea drawBlock: [ :cr :boundingBox | 
		self presenter drawBlock
			value: (AeCairoContext basicNew 
				setHandle: cr;
				yourself)
			value: boundingBox ].
	gtkDrawingArea extent: self presenter surfaceExtent.
	"gtkDrawingArea addVerticalScrollEvent: [ :event | event crTrace. false ]."
	self presenter
		whenDrawBlockChangedDo: [ :newBlock | self updateDrawBlock: newBlock ].
	self presenter
		whenExtentChangedDo: [ :newExtent | self widget extent: newExtent ]
]

{ #category : 'private' }
GtkAlexandrieAdapter >> ensureCanAnswerEvents: gtkDrawingArea [

	gtkDrawingArea canFocus: true.
	gtkDrawingArea registerToAllEvents
]

{ #category : 'private - actions' }
GtkAlexandrieAdapter >> newActionManager [

	^ GtkAdapterActionDrawingAreaManager on: self
]

{ #category : 'drawing' }
GtkAlexandrieAdapter >> redraw [

	self widgetDo: [ :w | w queueDraw ]
]

{ #category : 'private' }
GtkAlexandrieAdapter >> updateDrawBlock: aBlock [

	self widgetDo: [ :w |
		w 
			drawBlock: aBlock; 
			queueDraw ]
]

{ #category : 'building' }
GtkAlexandrieAdapter >> widgetClass [

	^ GtkBlockBasedDrawingArea 
]
