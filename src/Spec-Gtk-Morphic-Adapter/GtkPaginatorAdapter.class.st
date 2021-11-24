Class {
	#name : #GtkPaginatorAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Morphic-Adapter'
}

{ #category : #building }
GtkPaginatorAdapter >> addModelTo: gtkWidget [
	| morph |

	gtkWidget beMorphNotResizable.
	gtkWidget vExpand: false.
	gtkWidget marginBottom: self defaultMarginBottom.
	gtkWidget morph: (morph := SpPaginatorMorph new
		height: self defaultPaginatorHeight;
		addPages: self presenter pages;
		selectPage: self presenter pages size;
		color: self backgroundColor;
		selectionColor: self selectedColor;
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

{ #category : #private }
GtkPaginatorAdapter >> backgroundColor [

	^ self presenter application configuration panelBackgroundColor
]

{ #category : #private }
GtkPaginatorAdapter >> defaultMarginBottom [

	^ 5
]

{ #category : #private }
GtkPaginatorAdapter >> defaultPaginatorHeight [

	^ 22
]

{ #category : #private }
GtkPaginatorAdapter >> panelBackgroundColor [

	^ self presenter application configuration panelBackgroundColor
]

{ #category : #private }
GtkPaginatorAdapter >> selectedColor [

	^ self presenter application configuration listSelectedColor alpha: 0.3
]

{ #category : #building }
GtkPaginatorAdapter >> widgetClass [

	^ GtkMorphView
]
