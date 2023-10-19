Class {
	#name : #GtkFrameAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkFrameAdapter >> addModelTo: gtkFrame [

	gtkFrame label: self presenter label.
	gtkFrame child: self presenterWidget.
		
	self presenter whenLabelChangedDo: [ 
		gtkFrame label: self presenter label ].
	self presenter whenPresenterChangedDo: [ 
		gtkFrame child: self presenterWidget ]
]

{ #category : #building }
GtkFrameAdapter >> presenterWidget [

	^ self presenter presenter adapter 
		ifNotNil: [ :anAdapter | anAdapter widget ]
		ifNil: [ self presenter presenter build ]
]

{ #category : #building }
GtkFrameAdapter >> widgetClass [

	^ GtkFrame
]
