"
I'm an adapter for Paned Layouts.
A paned layout will split (horizontally or vertically) a panel and allow its resize. 
"
Class {
	#name : #GtkPanedAdapter,
	#superclass : #GtkLayoutAdapter,
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
	widget wideHandle: true.
	widget show
]

{ #category : #private }
GtkPanedAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [
	| childWidget |

	childWidget := aPresenter buildWithSpec: constraints spec.
	self addConstraints: constraints toChild: childWidget.
	((layout children indexOf: aPresenter) = 1)
		ifTrue: [ 
			gtkWidget 
				pack1: childWidget 
				resize: constraints canResize 
				shrink: constraints canShrink ]
		ifFalse: [
			gtkWidget 
				pack2: childWidget 
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

{ #category : #factory }
GtkPanedAdapter >> newHorizontal [

	^ GtkPaned newHorizontal
]

{ #category : #factory }
GtkPanedAdapter >> newVertical [

	^ GtkPaned newVertical
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
	
	widget connectSizeAllocate: [ :aRect |
		aWidget position: (aNumber < 1 
			ifTrue: [ self calculatePercentAtDirectionOf: aWidget extent: aRect extent ]
			ifFalse: [ aNumber ]).
		widget disconnect: 'size-allocate' ]
]
