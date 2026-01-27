Class {
	#name : 'GtkScrollableAdapter',
	#superclass : 'GtkLayoutAdapter',
	#pools : [
		'GtkPolicyType'
	],
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
	
	widget propagateNaturalHeight: aLayout isPropagateNaturalHeight.
	widget propagateNaturalWidth: aLayout isPropagateNaturalWidth.

	widget 
		policyHScrollbar: (aLayout hasHScrollbar 
			ifTrue: [ GTK_POLICY_AUTOMATIC ] 
			ifFalse: [ GTK_POLICY_NEVER ])
		vScrollbar: (aLayout hasVScrollbar 
			ifTrue: [ GTK_POLICY_AUTOMATIC ] 
			ifFalse: [ GTK_POLICY_NEVER ]).
	
	self connectToEvents: aLayout
]

{ #category : 'private' }
GtkScrollableAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [
	| childWidget |

	childWidget := aPresenter buildWithSelector: constraints spec.
	gtkWidget child: childWidget.
			
	^ gtkWidget
]

{ #category : 'removing' }
GtkScrollableAdapter >> remove: aPresenter [

	^ self widgetDo: [ :w |
		| widgetToRemove |
		widgetToRemove := aPresenter adapter widget.
		logger trace: widgetToRemove.
		widgetToRemove = w child ifTrue: [
			self ensureRetained: widgetToRemove.
			w removeChild ] ]
]

{ #category : 'scrolling' }
GtkScrollableAdapter >> scrollTo: aPoint [

	self widgetDo: [ :w |
		w hAdjustment value: aPoint x.
		w vAdjustment value: aPoint y ]
]
