"
I'm an adapter for Paned Layouts.
A paned layout will split (horizontally or vertically) a panel and allow its resize. 
"
Class {
	#name : #GtkPanedAdapter,
	#superclass : #GtkLayoutAdapter,
	#instVars : [
		'initializationDeferredAction'
	],
	#category : #'Spec-Gtk-Layout-Box'
}

{ #category : #private }
GtkPanedAdapter >> addConstraints: constraints toChild: childWidget [
	"adds constraits by child."

	^ childWidget
]

{ #category : #private }
GtkPanedAdapter >> applyLayout: aLayout [

	widget := aLayout direction newWidgetOn: self.

	self connectToEvents: aLayout.

	aLayout positionOfSlider ifNotNil: [ :pos | 
		pos < 1
			ifTrue: [ self setPositionDeferred: aLayout positionOfSlider to: widget ]
			ifFalse: [ self setPosition: aLayout positionOfSlider to: widget ] ].
	widget wideHandle: true
]

{ #category : #private }
GtkPanedAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [
	| childWidget position |

	childWidget := aPresenter buildWithSelector: constraints spec.
	self addConstraints: constraints toChild: childWidget.

	position := layout children indexOf: (aPresenter isSpLayout
		ifTrue: [ aPresenter layout ]
		ifFalse: [ aPresenter ]).

	position = 0 ifTrue: [ 
		"Not found, check for symbols. If is symbol, I need to get the presenter"
		layout children withIndexDo: [ :each :index | 
			(each isSymbol and: [ 
				 (layout presenter presenterAt: each) = aPresenter ]) ifTrue: [ 
				position := index ] ].
		"If I still do not find it, there is an error"
		position = 0 ifTrue: [ 
			layout children size < 2 ifTrue: [ 
				position := layout children size + 1 ].
			"Still zero? Then there is an error"
			position = 0 ifTrue: [ self error: 'Can''t find a child.' ] ] ].

	position = 1
		ifTrue: [ 
			gtkWidget
				startChild: childWidget
				resize: constraints canResize
				shrink: constraints canShrink ]
		ifFalse: [ 
			gtkWidget
				endChild: childWidget
				resize: constraints canResize
				shrink: constraints canShrink ].

	^ gtkWidget
]

{ #category : #private }
GtkPanedAdapter >> calculatePercentAtDirectionOf: aWidget extent: aPoint [
	| pos |

	pos := layout isHorizontal
		ifTrue: [ aPoint x ]
		ifFalse: [ aPoint y ].
	^ (pos * layout positionOfSlider) asInteger
]

{ #category : #private }
GtkPanedAdapter >> doInitializationDeferredActions [

	initializationDeferredAction ifNil: [ ^ self ].
	initializationDeferredAction ensure: [
		initializationDeferredAction := nil ].
]

{ #category : #factory }
GtkPanedAdapter >> newHorizontal [

	^ GtkPaned newHorizontal
]

{ #category : #factory }
GtkPanedAdapter >> newVertical [

	^ GtkPaned newVertical
]

{ #category : #private }
GtkPanedAdapter >> setInitializationDeferredAction: aBlock [

	initializationDeferredAction := aBlock
]

{ #category : #private }
GtkPanedAdapter >> setPosition: aNumber to: aWidget [

	aWidget position: (aNumber < 1 
		ifTrue: [ 
			self 
				calculatePercentAtDirectionOf: aWidget 
				extent: aWidget allocation extent ]
		ifFalse: [ 
			aNumber ])
]

{ #category : #private }
GtkPanedAdapter >> setPositionDeferred: aNumber to: aWidget [
	"executes the sizing in deferred way (once the widget receives the allocated signal, 
	 marking the widget has been asigned bounds"
	
	self setInitializationDeferredAction: [
		self setPosition: aNumber to: aWidget ]
]
