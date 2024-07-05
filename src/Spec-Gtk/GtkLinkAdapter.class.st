Class {
	#name : 'GtkLinkAdapter',
	#superclass : 'GtkButtonAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkLinkAdapter >> addModelTo: gtkButton [

	widget := gtkButton.
	
	self flag: #TODO. "Add SpTAlignable to SpLinkPresenter. Now I have no time nor the requirement"
	gtkButton hAlignStart.
	gtkButton connectActivateLink: [ true ].

	gtkButton connectClicked: [ 
		self runInSystem: [ self presenter performAction ] ].

	self presenter label isEmptyOrNil 
		ifFalse: [ self updateLabel ].
	
	model whenLabelChangedDo: [ self updateLabel ]
]

{ #category : 'private' }
GtkLinkAdapter >> labelAndIcon [
	| box |

	box := GtkBox newHorizontal
		hAlignCenter;
		spacing: 3;
		yourself.

	self getLabelText ifNotNil: [ :label | | gtkLabel |
		label ifNotEmpty: [
			gtkLabel := (GtkLabel newLabel: label).
			box append: gtkLabel ] ].

	^ box
]

{ #category : 'factory' }
GtkLinkAdapter >> newWidget [ 
	
	^ GtkLinkButton 
		buttonNewWithUri: ''
		withLabel: self getLabelText 
]
