Class {
	#name : 'GtkTextAdapter',
	#superclass : 'GtkAbstractTextAdapter',
	#traits : 'GtkTHaveWrappingScrollBars',
	#classTraits : 'GtkTHaveWrappingScrollBars classTrait',
	#instVars : [
		'mutex'
	],
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'visiting' }
GtkTextAdapter >> accept [

	self innerWidgetDo: [ :w | 
		self model acceptText: w text ]
]

{ #category : 'building' }
GtkTextAdapter >> addEditionContextMenuTo: menuPresenter [
	

	self presenter hasEditionContextMenu ifFalse: [ ^ self ].
	
	menuPresenter addMenuGroup: self presenter editionContextMenu menuGroups last 
]

{ #category : 'building' }
GtkTextAdapter >> addModelTo: gtkTextView [

	super addModelTo: gtkTextView.

	gtkTextView editable: self presenter isEditable.
	self presenter whenEditableChangedDo: [ :value | 
		self setEditable: value ].
	
	self setWrapWord: self presenter isWrapWord to: gtkTextView. 
	self presenter whenWrapWordChangedDo: [ :value |
		self setWrapWord: value to: gtkTextView ].
	
	self addTextBufferTo: gtkTextView.	
	
	self flag: #Gtk4. "In fact, GtkTextView does not has undo/redo in Gtk3, but is 
	present in Gtk4. I will wait until we move there to implement this (since it does not 
	has sense to hack that before)"
	self presenter hasUndoRedoHistory 
		ifTrue: [ "do something" ]
		ifFalse: [ "do something else" ]
]

{ #category : 'building' }
GtkTextAdapter >> addTextBufferTo: gtkTextView [

	gtkTextView textBuffer connectChanged: [
		self updatePresenterText: gtkTextView text ]
]

{ #category : 'accessing' }
GtkTextAdapter >> appendText: aString [

	self innerWidgetDo: [ :w |
		w textBuffer appendText: aString ]
]

{ #category : 'api' }
GtkTextAdapter >> backendIncludesEditionMenu [

	^ true
]

{ #category : 'building' }
GtkTextAdapter >> bufferClass [

	^ GtkTextBuffer
]

{ #category : 'spec protocol' }
GtkTextAdapter >> cursorPosition [
	
	^ self innerWidgetDo: [ :w |
		w textBuffer cursorPositionAtLine ]
]

{ #category : 'spec protocol' }
GtkTextAdapter >> cursorPositionIndex: index [
	
	^ self innerWidgetDo: [ :w |
		w textBuffer cursorPosition: index - 1 ]
]

{ #category : 'commands' }
GtkTextAdapter >> cutText [

]

{ #category : 'accessing' }
GtkTextAdapter >> enabled: aBoolean [

	self innerWidgetDo: [ :w |
		w sensitive: aBoolean ]
]

{ #category : 'spec protocol' }
GtkTextAdapter >> lineAtCursorPosition [

	^ self innerWidgetDo: [ :w | w textBuffer lineAtCursorPosition ]
]

{ #category : 'private' }
GtkTextAdapter >> mutex [

	^ mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'commands' }
GtkTextAdapter >> pasteText [
]

{ #category : 'private' }
GtkTextAdapter >> setEditable: aBoolean [ 

	self innerWidgetDo: [ :w | w editable: aBoolean ]
]

{ #category : 'building' }
GtkTextAdapter >> setText: aString to: gtkWidget [
	self mutex critical: [
		self withCycleDetectionOnBackendDo: [
			"gtkWidget textBuffer 
				blockCallback: GChangedCallback signalName
				during: [" super setText: aString to: gtkWidget "]" ] ]
]

{ #category : 'private' }
GtkTextAdapter >> setWrapWord: value to: gtkTextView [

	self presenter isWrapWord 
		ifTrue: [ gtkTextView beWrapWord ]
		ifFalse: [ gtkTextView beWrapNone ]
]

{ #category : 'private' }
GtkTextAdapter >> updatePresenterText: aString [

	self runInSystem: [
		self mutex critical: [
			self backendUpdatingDo: [
				self presenter text: aString ] ] ]
]

{ #category : 'building' }
GtkTextAdapter >> widgetClass [

	^ GtkTextView
]
