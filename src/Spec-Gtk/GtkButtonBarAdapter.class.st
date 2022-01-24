Class {
	#name : #GtkButtonBarAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #initialization }
GtkButtonBarAdapter class >> defaultBorderWidth [

	^ 5
]

{ #category : #building }
GtkButtonBarAdapter >> addModelTo: gtkWidget [
	
	self model isPlaceAtStart ifTrue: [ gtkWidget placeAtStart ].
	self model isPlaceAtEnd ifTrue: [ gtkWidget placeAtEnd ].
	
	gtkWidget borderWidth: self class defaultBorderWidth.
	self model items do: [ :each |
		gtkWidget packStart: each build ]
]

{ #category : #building }
GtkButtonBarAdapter >> newWidget [ 

	^ GtkButtonBox newHorizontal
]
