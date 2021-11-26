Class {
	#name : #GtkMorphAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Morphic-Adapter'
}

{ #category : #building }
GtkMorphAdapter >> addModelTo: gtkWidget [

	self presenter whenMorphChangedDo: [ :aMorph |
		self widgetDo: [ :w | self setMorph: aMorph to: w ] ].
	self setMorph: self presenter morph to: gtkWidget
	
]

{ #category : #building }
GtkMorphAdapter >> setMorph: aMorph to: gtkWidget [

	aMorph ifNil: [ ^ self ].

	aMorph presenter: self presenter. 
	gtkWidget morph: aMorph.
	"if morph is rigid, then widget is not resizable"
	((aMorph vResizing = #rigid) 
		and: [ aMorph hResizing = #rigid ])
		ifTrue: [ gtkWidget beMorphNotResizable ]
		ifFalse: [ gtkWidget beMorphResizable ]
]

{ #category : #building }
GtkMorphAdapter >> widgetClass [

	^ GtkMorphView
]
