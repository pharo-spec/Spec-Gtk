Class {
	#name : #GtkAthensAdapter,
	#superclass : #GtkAdapter,
	#instVars : [
		'eventsInstalled'
	],
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkAthensAdapter >> addModelTo: gtkDrawingArea [

	super addModelTo: gtkDrawingArea.
	gtkDrawingArea drawBlock: self presenter drawBlock.
	gtkDrawingArea extent: self presenter surfaceExtent.
	self presenter
		whenDrawBlockChangedDo: [ :newBlock | self widget drawBlock: newBlock ].
	self presenter
		whenExtentChangedDo: [ :newExtent | self widget extent: newExtent ].
	self model contextMenu 
		ifNotNil: [ :menu | self addMenu: menu to: gtkDrawingArea ].
]

{ #category : #private }
GtkAthensAdapter >> bindKeyCombination: aShortcut toAction: aBlock inWidget: gtkDrawingArea [

	self ensureCanAnswerEvents: gtkDrawingArea.
	super 
		bindKeyCombination: aShortcut 
		toAction: aBlock 
		inWidget: gtkDrawingArea
]

{ #category : #private }
GtkAthensAdapter >> ensureCanAnswerEvents: gtkDrawingArea [

	eventsInstalled ifTrue: [ ^ self ].
	gtkDrawingArea canFocus: true.
	gtkDrawingArea registerToAllEvents.
	eventsInstalled := true

]

{ #category : #private }
GtkAthensAdapter >> initialize [

	super initialize.
	eventsInstalled := false
]

{ #category : #'event installing' }
GtkAthensAdapter >> installEvent: anEvent [

	"Ensure the widget can be focused and will process events (just needed in case events are installed"
	self widgetDo: [ :w | self ensureCanAnswerEvents: w ].
	super installEvent: anEvent
]

{ #category : #drawing }
GtkAthensAdapter >> redraw [

	self widgetDo: [ :w | w queueDraw ]
]

{ #category : #building }
GtkAthensAdapter >> widgetClass [

	^ GtkBlockBasedDrawingArea 
]
