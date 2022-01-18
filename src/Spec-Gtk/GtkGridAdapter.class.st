Class {
	#name : #GtkGridAdapter,
	#superclass : #GtkLayoutAdapter,
	#category : #'Spec-Gtk-Layout-Grid'
}

{ #category : #private }
GtkGridAdapter >> addConstraints: constraints toChild: childWidget [
	"adds constraits by child."
	
	(layout rowConstraintsAt: constraints row) ifNotNil: [ :c |
		c expand ifNotNil: [ :expand | childWidget vExpand: expand ].
		self basicApplyAlignmentTo: childWidget constraints: c ].

	(layout columnConstraintsAt: constraints column) ifNotNil: [ :c |
		c expand ifNotNil: [ :expand | childWidget hExpand: expand ].
		self basicApplyAlignmentTo: childWidget constraints: c ].
	
	self basicApplyAlignmentTo: childWidget constraints: constraints
]

{ #category : #private }
GtkGridAdapter >> applyLayout: aLayout [
	
	widget := GtkGrid new.
	
	self connectToEvents: aLayout. 
	
	self widgetDo: [ :w |
		w 
			borderWidth: aLayout borderWidth;
			columnSpacing: aLayout columnSpacing;
			rowSpacing: aLayout rowSpacing;
			columnHomogeneous: aLayout isColumnHomogeneous;
			rowHomogeneous: aLayout isRowHomogeneous ]
]

{ #category : #private }
GtkGridAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [
	| childWidget |

	childWidget := aPresenter buildWithSpec: constraints spec.
	childWidget data: aPresenter.
	self addConstraints: constraints toChild: childWidget.
	gtkWidget 
		attach: childWidget 
		at: constraints position 
		span: constraints span.
		
	^ gtkWidget
]

{ #category : #private }
GtkGridAdapter >> basicApplyAlignmentTo: childWidget constraints: constraints [

	constraints hAlign ifNotNil: [ :hAlign | childWidget hAlign: hAlign asGtkAlign ].
	constraints vAlign ifNotNil: [ :vAlign | childWidget vAlign: vAlign asGtkAlign ]
]
