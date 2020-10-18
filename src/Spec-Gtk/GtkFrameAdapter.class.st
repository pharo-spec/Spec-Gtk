Class {
	#name : #GtkFrameAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkFrameAdapter >> addModelTo: gtkFrame [

	gtkFrame label: self presenter label.
	gtkFrame add: self presenterWidget.
		
	self presenter whenLabelChangedDo: [ 
		gtkFrame label: self presenter label ].
	self presenter whenPresenterChangedDo: [ 
		gtkFrame 
			removeAll;
			add: self presenterWidget ]
]

{ #category : #building }
GtkFrameAdapter >> presenterWidget [

	^ self presenter presenter adapter 
		ifNotNil: [ :anAdapter | anAdapter widget ]
		ifNil: [ self presenter presenter buildWithSpec ]
]

{ #category : #building }
GtkFrameAdapter >> widgetClass [

	^ GtkFrame
]
