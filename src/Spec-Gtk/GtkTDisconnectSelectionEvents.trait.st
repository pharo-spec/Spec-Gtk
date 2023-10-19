Trait {
	#name : 'GtkTDisconnectSelectionEvents',
	#category : 'Spec-Gtk-Adapter-Table',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Table'
}

{ #category : 'private' }
GtkTDisconnectSelectionEvents >> disconnectSelectionEventsOf: aWidget during: aBlock [

	aWidget selection 
		blockCallback: GChangedCallback signalName
		during: aBlock
]
