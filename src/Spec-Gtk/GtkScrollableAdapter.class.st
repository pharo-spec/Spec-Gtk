Class {
	#name : #GtkScrollableAdapter,
	#superclass : #GtkLayoutAdapter,
	#category : #'Spec-Gtk-Layout-Box'
}

{ #category : #private }
GtkScrollableAdapter >> addConstraints: constraints toChild: childWidget [
	"adds constraits by child."

	^ childWidget
]

{ #category : #private }
GtkScrollableAdapter >> applyLayout: aLayout [

	widget := GtkScrolledWindow new.
	self connectToEvents: aLayout. 
	widget show
]

{ #category : #private }
GtkScrollableAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [
	| childWidget |

	childWidget := aPresenter buildWithSpec: constraints spec.
	gtkWidget add: childWidget.
			
	^ gtkWidget
]

{ #category : #scrolling }
GtkScrollableAdapter >> scrollTo: aPoint [

	self widgetDo: [ :w |
		w hAdjustment value: aPoint x.
		w vAdjustment value: aPoint y ]
]
