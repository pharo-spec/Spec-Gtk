Class {
	#name : #GtkLinkAdapter,
	#superclass : #GtkButtonAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkLinkAdapter >> addModelTo: gtkButton [

	widget := gtkButton.
	
	self flag: #TODO. "Add SpTAlignable to SpLinkPresenter. Now I have no time nor the requirement"
	gtkButton hAlignStart.
	gtkButton connectActivateLink: [ true ].

	gtkButton connectClicked: [ 
		self presenter performAction ].

	self presenter label isEmptyOrNil 
		ifFalse: [ self updateLabel ].
	
	model whenLabelChangedDo: [ self updateLabel ]
]

{ #category : #factory }
GtkLinkAdapter >> newWidget [ 
	
	^ GtkLinkButton 
		buttonNewWithUri: ''
		withLabel: self getLabelText 
]
