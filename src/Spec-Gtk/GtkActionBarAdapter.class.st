Class {
	#name : #GtkActionBarAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkActionBarAdapter >> addModelTo: gtkWidget [
	
	(self itemsAt: #start) 
		do: [ :each | gtkWidget packStart: each buildWithSpec ].
	(self itemsAt: #end) 
		reverseDo: [ :each | gtkWidget packEnd: each buildWithSpec ]
]

{ #category : #private }
GtkActionBarAdapter >> itemsAt: placeSymbol [

	^ self model items 
		at: placeSymbol
		ifAbsent: [ #() ] 

]

{ #category : #building }
GtkActionBarAdapter >> widgetClass [

	^ GtkActionBar
]
