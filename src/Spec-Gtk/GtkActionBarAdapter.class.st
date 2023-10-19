Class {
	#name : 'GtkActionBarAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkActionBarAdapter >> addModelTo: gtkWidget [
	
	(self itemsAt: #start) 
		do: [ :each | gtkWidget packStart: each build ].
	(self itemsAt: #end) 
		reverseDo: [ :each | gtkWidget packEnd: each build ]
]

{ #category : 'private' }
GtkActionBarAdapter >> itemsAt: placeSymbol [

	^ self model items 
		at: placeSymbol
		ifAbsent: [ #() ] 

]

{ #category : 'building' }
GtkActionBarAdapter >> widgetClass [

	^ GtkActionBar
]
