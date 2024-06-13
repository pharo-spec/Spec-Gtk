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
		reverseDo: [ :each | gtkWidget packEnd: each build ].

	self presenter centerPresenter 
		ifNotNil: [ :aPresenter | gtkWidget centerWidget: aPresenter build ].
		
	self presenter whenCenterPresenterChangedDo: [ :aPresenter |
		 self updateCenterPresenter ]
]

{ #category : 'private' }
GtkActionBarAdapter >> itemsAt: placeSymbol [

	^ self model items 
		at: placeSymbol
		ifAbsent: [ #() ] 

]

{ #category : 'private - updating' }
GtkActionBarAdapter >> updateCenterPresenter [

	self widgetDo: [ :w |
		w centerWidget: self presenter centerPresenter build ]
]

{ #category : 'building' }
GtkActionBarAdapter >> widgetClass [

	^ GtkActionBar
]
