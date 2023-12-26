"
Gtk adapter for the frame layout
"
Class {
	#name : 'GtkFrameLayoutAdapter',
	#superclass : 'GtkLayoutAdapter',
	#category : 'Spec-Gtk-Frame-Layout',
	#package : 'Spec-Gtk-Frame',
	#tag : 'Layout'
}

{ #category : 'private' }
GtkFrameLayoutAdapter >> addConstraits: constraints toChild: childWidget [
	"adds constraits by child."

	^ childWidget
]

{ #category : 'private' }
GtkFrameLayoutAdapter >> applyLayout: aLayout [

	"build of widget was differed up to here (to know what is the direction)"
	widget := aLayout label 
		ifNil: [ self newFrame ]
		ifNotNil: [ :aLabel | self newFrameWithLabel: aLabel ].

	self connectToEvents: aLayout
]

{ #category : 'private' }
GtkFrameLayoutAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [
	| childWidget |

	childWidget := aPresenter buildWithSelector: constraints spec.
	self addConstraits: constraints toChild: childWidget.
	
	gtkWidget child: childWidget.

	^ gtkWidget
]

{ #category : 'testing' }
GtkFrameLayoutAdapter >> childrenWidgets [
	
	^ self widget children
]

{ #category : 'factory' }
GtkFrameLayoutAdapter >> newFrame [

	^ GtkFrame new
]

{ #category : 'factory' }
GtkFrameLayoutAdapter >> newFrameWithLabel: aLabel [

	^ GtkFrame newLabel: aLabel
]

{ #category : 'accessing' }
GtkFrameLayoutAdapter >> replace: aPresenter with: otherPresenter withConstraints: constraints [
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
