Class {
	#name : #GtkMorphAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Morphic-Adapter'
}

{ #category : #building }
GtkMorphAdapter >> addModelTo: gtkWidget [

	self presenter whenMorphChangedDo: [ :aMorph |
		aMorph presenter: self presenter. 
		gtkWidget morph: aMorph ].
	self presenter morph ifNotNil: [ :aMorph |
		aMorph presenter: self presenter. 
		gtkWidget morph: aMorph ]
]

{ #category : #building }
GtkMorphAdapter >> widgetClass [

	^ GtkMorphView
]
