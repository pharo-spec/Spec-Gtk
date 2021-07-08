Trait {
	#name : #GtkTDisconnectSelectionEvents,
	#category : #'Spec-Gtk-Adapter-Table'
}

{ #category : #private }
GtkTDisconnectSelectionEvents >> disconnectSelectionEventsOf: aWidget during: aBlock [

	aWidget selection 
		blockCallback: GChangedCallback signalName
		during: aBlock
]
