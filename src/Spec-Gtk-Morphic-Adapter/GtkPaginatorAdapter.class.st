Class {
	#name : 'GtkPaginatorAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Morphic-Adapter',
	#package : 'Spec-Gtk-Morphic-Adapter'
}

{ #category : 'private' }
GtkPaginatorAdapter >> accentColor [

	^ self presenter application configuration accentColor
]

{ #category : 'building' }
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
		self withCycleDetectionOnBackendDo: [ 
			self widgetDo: [ :w |
				morph selectPage: aNumber ] ] ].
	morph whenSelectedPageChangedDo: [ :aNumber |
		self backendUpdatingDo: [ 
			self presenter selectPage: aNumber ] ].
	
	self presenter whenVisiblePagesChangedDo: [ :aNumber |
		self withCycleDetectionOnBackendDo: [ 
			morph numberOfPagesShown: aNumber ] ].
	morph whenNumberOfPagesShownChangedDo: [ :aNumber |
		self backendUpdatingDo: [
			self presenter visiblePages: aNumber ] ].
	
	self presenter whenPageAddedDo: [ :anObject | 
		self widgetDo: [ :w |
			morph 
				addPage: anObject; 
				selectLastPage ] ].
	self presenter whenPageRemovedDo: [ :anObject |
		self widgetDo: [ :w |
			anObject 
				ifNotNil: [ morph removePage: anObject ]
				ifNil: [ morph removeAllPages ] ] ]

]

{ #category : 'private' }
GtkPaginatorAdapter >> backgroundColor [

	^ Color transparent
]

{ #category : 'private' }
GtkPaginatorAdapter >> defaultMarginBottom [

	^ 5
]

{ #category : 'private' }
GtkPaginatorAdapter >> defaultPaginatorHeight [

	^ 22
]

{ #category : 'private' }
GtkPaginatorAdapter >> panelBackgroundColor [

	^ self presenter application configuration panelBackgroundColor
]

{ #category : 'private' }
GtkPaginatorAdapter >> selectedColor [

	^ self accentColor alpha: 0.3
]

{ #category : 'building' }
GtkPaginatorAdapter >> widgetClass [

	^ GtkMorphView
]
