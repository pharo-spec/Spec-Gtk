Class {
	#name : #GtkTextAdapter,
	#superclass : #GtkAbstractTextAdapter,
	#traits : 'GtkTHaveWrappingScrollBars',
	#classTraits : 'GtkTHaveWrappingScrollBars classTrait',
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #visiting }
GtkTextAdapter >> accept [

	self innerWidgetDo: [ :w | 
		self model acceptText: w text ]
]

{ #category : #building }
GtkTextAdapter >> addModelTo: gtkTextView [

	super addModelTo: gtkTextView.

	gtkTextView editable: self presenter isEditable.
	self presenter whenEditableChangedDo: [ :value | 
		self setEditable: value ].
	
	self setWrapWord: self presenter isWrapWord to: gtkTextView. 
	self presenter whenWrapWordChangedDo: [ :value |
		self setWrapWord: value to: gtkTextView ].
	
	self flag: #Gtk4. "In fact, GtkTextView does not has undo/redo in Gtk3, but is 
	present in Gtk4. I will wait until we move there to implement this (since it does not 
	has sense to hack that before)"
	self presenter hasUndoRedoHistory 
		ifTrue: [ "do something" ]
		ifFalse: [ "do something else" ].
	
	gtkTextView textBuffer connectChanged: [
		self updatePresenterText: gtkTextView text ]
]

{ #category : #building }
GtkTextAdapter >> bufferClass [

	^ GtkTextBuffer
]

{ #category : #'spec protocol' }
GtkTextAdapter >> cursorPosition [
	
	^ self innerWidgetDo: [ :w |
		w textBuffer cursorPositionAtLine ]
]

{ #category : #'spec protocol' }
GtkTextAdapter >> cursorPositionIndex: index [
	
	^ self innerWidgetDo: [ :w |
		w textBuffer cursorPosition: index ]
]

{ #category : #commands }
GtkTextAdapter >> cutText [

]

{ #category : #'spec protocol' }
GtkTextAdapter >> lineAtCursorPosition [

	^ self innerWidgetDo: [ :w | w textBuffer lineAtCursorPosition ]
]

{ #category : #commands }
GtkTextAdapter >> pasteText [
]

{ #category : #private }
GtkTextAdapter >> setEditable: aBoolean [ 

	self innerWidgetDo: [ :w | w editable: aBoolean ]
]

{ #category : #building }
GtkTextAdapter >> setText: aString to: gtkWidget [

	gtkWidget textBuffer 
		blockCallback: GChangedCallback signalName
		during: [ 
			self backendDetectCyclesDo: [
				super setText: aString to: gtkWidget	] ]
]

{ #category : #private }
GtkTextAdapter >> setWrapWord: value to: gtkTextView [

	self presenter isWrapWord 
		ifTrue: [ gtkTextView beWrapWord ]
		ifFalse: [ gtkTextView beWrapNone ]
]

{ #category : #updating }
GtkTextAdapter >> updateEnabled [	
	
	self innerWidgetDo: [ :w | w sensitive: self presenter isEnabled value ]
]

{ #category : #private }
GtkTextAdapter >> updatePresenterText: aString [

	self backendUpdatingDo: [ 
		self presenter text: aString ]
]

{ #category : #building }
GtkTextAdapter >> widgetClass [

	^ GtkTextView
]
