Class {
	#name : 'GtkScrollableAdapter',
	#superclass : 'GtkLayoutAdapter',
	#category : 'Spec-Gtk-Layout-Box',
	#package : 'Spec-Gtk',
	#tag : 'Layout-Box'
}

{ #category : 'private' }
GtkScrollableAdapter >> addConstraints: constraints toChild: childWidget [
	"adds constraits by child."

	^ childWidget
]

{ #category : 'accessing' }
GtkScrollableAdapter >> addWidgetAlignment: constraints to: gtkWidget [

 	layout vAlign
		ifNotNil: [ :align | gtkWidget vAlign: align asGtkAlign ].
 	layout hAlign 
		ifNotNil: [ :align | gtkWidget hAlign: align asGtkAlign ]
]

{ #category : 'private' }
GtkScrollableAdapter >> applyLayout: aLayout [

	widget := GtkScrolledWindow new.
	self connectToEvents: aLayout
]

{ #category : 'private' }
GtkScrollableAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [
	| childWidget |

	childWidget := aPresenter buildWithSelector: constraints spec.
	gtkWidget child: childWidget.
			
	^ gtkWidget
]

{ #category : 'scrolling' }
GtkScrollableAdapter >> scrollTo: aPoint [

	self widgetDo: [ :w |
		w hAdjustment value: aPoint x.
		w vAdjustment value: aPoint y ]
]
