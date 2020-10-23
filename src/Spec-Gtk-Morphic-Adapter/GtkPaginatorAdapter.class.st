Class {
	#name : #GtkPaginatorAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Morphic-Adapter'
}

{ #category : #building }
GtkPaginatorAdapter >> addModelTo: gtkWidget [
	| morph |

	gtkWidget morph: (morph := SpPaginatorMorph new
		addPages: self presenter pages;
		selectPage: self presenter pages size;
		yourself).

	self presenter whenSelectedPageChangedDo: [ :aNumber |
		self backendDetectCyclesDo: [ 
			morph selectPage: aNumber ] ].
	morph whenSelectedPageChangedDo: [ :aNumber |
		self backendUpdatingDo: [ 
			self presenter selectPage: aNumber ] ].
	
	self presenter whenVisiblePagesChangedDo: [ :aNumber |
		self backendDetectCyclesDo: [ 
			morph numberOfPagesShown: aNumber ] ].
	morph whenNumberOfPagesShownChangedDo: [ :aNumber |
		self backendUpdatingDo: [
			self presenter visiblePages: aNumber ] ].
	
	self presenter whenPageAddedDo: [ :anObject | 
		morph 
			addPage: anObject; 
			selectLastPage ].
	self presenter whenPageRemovedDo: [ :anObject |
		anObject 
			ifNotNil: [ morph removePage: anObject ]
			ifNil: [ morph removeAllPages ] ]

]

{ #category : #building }
GtkPaginatorAdapter >> widgetClass [

	^ GtkMorphView
]
