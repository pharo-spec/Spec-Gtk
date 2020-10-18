Class {
	#name : #GtkGtkWidgetAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #protocol }
GtkGtkWidgetAdapter >> doTakeKeyboardFocus: aWidget [

	self 
		firstNotContainer: aWidget 
		ifFound: [ :foundWidget | foundWidget grabFocus ]
		
]

{ #category : #protocol }
GtkGtkWidgetAdapter >> firstNotContainer: aWidget ifFound: aBlock [

	(aWidget isKindOf: GtkContainer) 
		ifFalse: [ 
			aBlock value: aWidget.
			^ self ].
		
	aWidget children do: [ :each |
		self firstNotContainer: each ifFound: aBlock ].

]

{ #category : #building }
GtkGtkWidgetAdapter >> newWidget [

	^ self presenter widget
]
