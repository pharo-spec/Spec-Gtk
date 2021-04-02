Class {
	#name : #GtkLinkAdapter,
	#superclass : #GtkButtonAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkLinkAdapter >> addModelTo: gtkButton [

	widget := gtkButton.

	"self presenter contextMenu ifNotNil: [ :menu |
		self addMenu: menu to: gtkButton ]."

	gtkButton connectClicked: [ 
		self presenter performAction ].	

	self presenter label isEmptyOrNil ifFalse: [ self updateLabel ].
	
	model whenLabelChangedDo: [ self updateLabel ].

]

{ #category : #factory }
GtkLinkAdapter >> newWidget [ 
	
	^ GtkLinkButton 
		buttonNewWithUri: ''
		withLabel: self getLabelText 
]
