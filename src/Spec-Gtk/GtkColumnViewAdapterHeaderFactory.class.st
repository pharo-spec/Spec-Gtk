"
Header factory for to be used with `GtkColumnViewAdapter`
"
Class {
	#name : 'GtkColumnViewAdapterHeaderFactory',
	#superclass : 'GtkListViewAdapterHeaderFactory',
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'private' }
GtkColumnViewAdapterHeaderFactory >> itemAt: aPosition [ 

	^ (self presenter columns at: aPosition) title ifNil: [ '' ]
]
