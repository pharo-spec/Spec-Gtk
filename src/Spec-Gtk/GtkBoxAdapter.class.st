Class {
	#name : #GtkBoxAdapter,
	#superclass : #GtkLayoutAdapter,
	#category : #'Spec-Gtk-Layout-Box'
}

{ #category : #private }
GtkBoxAdapter >> addConstraits: constraints toChild: childWidget [
	"adds constraits by child."
	
	constraints isExpand ifFalse: [
		| min |
		min := childWidget preferredSizeMinimum.
		constraints width ifNotNil: [ :w | 
			childWidget sizeRequest: w@min y ].
		constraints height ifNotNil: [ :h | 
			childWidget sizeRequest: min x@h ] ].

	^ childWidget
]

{ #category : #accessing }
GtkBoxAdapter >> addWidgetAlignment: constraints to: gtkWidget [

 	layout vAlign
		ifNotNil: [ :align | gtkWidget vAlign: align asGtkAlign ].
 	layout hAlign 
		ifNotNil: [ :align | gtkWidget hAlign: align asGtkAlign ]
]

{ #category : #private }
GtkBoxAdapter >> applyLayout: aLayout [

	"build of widget was differed up to here (to know what is the direction)"
	widget := aLayout direction newWidgetOn: self.

	self connectToEvents: aLayout. 

	widget 
		homogeneous: aLayout isHomogeneous;
		spacing: aLayout spacing;
		borderWidth: aLayout borderWidth.
		
	self presenter isVisible 
		ifTrue: [ widget show ] 
		ifFalse: [ widget hide ].
	
]

{ #category : #private }
GtkBoxAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [
	| childWidget |

	childWidget := aPresenter buildWithSpec: constraints spec.
	self addConstraits: constraints toChild: childWidget.
	constraints isPlacedAtStart
		ifTrue: [ 
			gtkWidget 
				packStart: childWidget 
				expand: constraints isExpand 
				fill: constraints isFill
				padding: constraints padding ]
		ifFalse: [ 
			gtkWidget 
				reversePackEnd: childWidget 
				expand: constraints isExpand 
				fill: constraints isFill 
				padding: constraints padding ].

	^ gtkWidget
]

{ #category : #testing }
GtkBoxAdapter >> childrenWidgets [
	
	^ self widget children
]

{ #category : #factory }
GtkBoxAdapter >> newHorizontal [

	^ GtkBox newHorizontal
]

{ #category : #factory }
GtkBoxAdapter >> newVertical [

	^ GtkBox newVertical
]

{ #category : #accessing }
GtkBoxAdapter >> replace: aPresenter with: otherPresenter withConstraints: constraints [
	| index |
	
	"preserve aPresenter widget (in case it will be used later)"
	aPresenter adapter widget
		objectRef;
		autoRelease.
	index := widget children indexOf: aPresenter adapter widget.
	self remove: aPresenter.
	
	self add: otherPresenter constraints: constraints.
	
	self innerWidgetDo: [ :w |
		w reorderChild: otherPresenter adapter widget position: index ]
]
