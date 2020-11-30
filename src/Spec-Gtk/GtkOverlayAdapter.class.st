Class {
	#name : #GtkOverlayAdapter,
	#superclass : #GtkLayoutAdapter,
	#category : #'Spec-Gtk-Layout-Box'
}

{ #category : #private }
GtkOverlayAdapter >> applyLayout: aLayout [

	widget := GtkOverlay new.
	self connectToEvents: aLayout. 
	widget showAll.
]

{ #category : #private }
GtkOverlayAdapter >> basicAdd: aPresenter constraints: constraints to: aWidget [ 
	| childWidget |

	childWidget := aPresenter buildWithSpec: constraints spec.
	constraints isOverlay
		ifFalse: [
			aWidget add: childWidget ]
		ifTrue: [
			childWidget
				beHAlignCenter;
				beVAlignCenter.
			aWidget addOverlay: childWidget ].
		
	self basicApplyAlignmentTo: childWidget constraints: constraints.
	
	^ aWidget
]

{ #category : #accessing }
GtkOverlayAdapter >> basicApplyAlignmentTo: childWidget constraints: constraints [

	constraints hAlign ifNotNil: [ :hAlign | childWidget hAlign: hAlign asGtkAlign ].
	constraints vAlign ifNotNil: [ :vAlign | childWidget vAlign: vAlign asGtkAlign ]
]
