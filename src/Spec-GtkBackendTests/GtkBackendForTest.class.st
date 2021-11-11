Class {
	#name : #GtkBackendForTest,
	#superclass : #SpAbstractBackendForTest,
	#instVars : [
		'app'
	],
	#category : #'Spec-GtkBackendTests'
}

{ #category : #accessing }
GtkBackendForTest >> assertHasHeader: anAdapter [ 
	
	self assert: anAdapter innerWidget isHeadersVisible
]

{ #category : #asserting }
GtkBackendForTest >> assertIcon: aGtkImage equals: aForm [ 
	
	(aForm isNil and: [ aGtkImage isNil ]) ifTrue: [ ^ self ].
	
	"I can only test if the image is nil and the form is nil or not"
	self assert: (aForm isNotNil or: [(aGtkImage isNil or: [ aGtkImage isNull])]).
	self assert: (aGtkImage isNotNil and: [ aGtkImage isNull not])
	
]

{ #category : #'as yet unclassified' }
GtkBackendForTest >> assertImage: aGtkImage equals: aForm [ 
	
	| pixbuf |
	pixbuf := aGtkImage asGdkPixbuf.
	(aForm isNil and: [ pixbuf isNull ]) ifTrue: [ ^ self ].

	self assert: pixbuf isNull not.	
	self assert: pixbuf width = aForm width.
	self assert: pixbuf height = aForm height.
	self assert: pixbuf depth = aForm depth.

]

{ #category : #asserting }
GtkBackendForTest >> assertList: aTreeTableAdapter displayItems: aCollection [ 
	| iter |
	
	iter := aTreeTableAdapter innerWidget model iteratorFromPath: (GtkTreePath newFromArray: #(1)).
	aCollection do: [ :aValue |  
		self assert: (iter stringAt: 0) = aValue.
		iter next ]
]

{ #category : #asserting }
GtkBackendForTest >> assertListHeaderOf: aGtkTreeView equals: aCollection [

	self assert: (aGtkTreeView columns collect: [ :c | c title ]) asArray = aCollection asArray
	
]

{ #category : #testing }
GtkBackendForTest >> canChangeFonts [
	
	^ false
]

{ #category : #emulating }
GtkBackendForTest >> clickFirstRowAndColumn: anAdapter [ 
	| path |
	path := (GtkTreePath newFromArray: #(1)) autoRelease.	
	anAdapter innerWidgetDo: [ :w |
		w 
			activateRow: path 
			column: w columns first ]
]

{ #category : #accessing }
GtkBackendForTest >> denyHasHeader: anAdapter [ 
	
	self assert: anAdapter innerWidget isHeadersVisible not
]

{ #category : #simulating }
GtkBackendForTest >> doubleClickFirstRowAndColumn: anAdapter [ 
	
	self clickFirstRowAndColumn: anAdapter
]

{ #category : #testing }
GtkBackendForTest >> isGtkBackend [

	^ true
]

{ #category : #running }
GtkBackendForTest >> openInstanceOf: aTest [ 
		
	aTest window ifNil: [ 
		aTest presenter application: app.
		aTest window: aTest presenter openWithSpec ].

]

{ #category : #running }
GtkBackendForTest >> runTest: aBlockClosure [ 
		
	GtkEngine ensureRunning. 
	app := SpApplication new.
	app useBackend: #Gtk.
	aBlockClosure value
]
