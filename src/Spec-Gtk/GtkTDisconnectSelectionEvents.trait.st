Trait {
	#name : #GtkTDisconnectSelectionEvents,
	#category : #'Spec-Gtk-Adapter-Table'
}

{ #category : #private }
GtkTDisconnectSelectionEvents >> disconnectSelectionEventsOf: aWidget during: aBlock [

	aWidget selection 
		blockCallback: 'changed' 
		during: aBlock
]
