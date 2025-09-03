Class {
	#name : 'GtkLinkAdapter',
	#superclass : 'GtkBaseButtonAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkLinkAdapter >> addModelTo: gtkButton [
	
	super addModelTo: gtkButton.
	
	self flag: #TODO. "Add SpTAlignable to SpLinkPresenter. Now I have no time nor the requirement"
	gtkButton hAlignStart.
	gtkButton connectActivateLink: [ true ].

	gtkButton connectClicked: [ 
		self runInSystem: [ self presenter performAction ] ].

	self presenter label isEmptyOrNil 
		ifFalse: [ self updateLabelAndIconTo: gtkButton ].
	
	model whenLabelChangedDo: [ self updateLabel ]
]

{ #category : 'building' }
GtkLinkAdapter >> connectToSpecEvents: gtkButton [

	self presenter 
		whenLabelChangedDo: [ self updateLabel ]
]

{ #category : 'private - testing' }
GtkLinkAdapter >> hasLabelOrIcon [
	
	^ self hasLabel
]

{ #category : 'private' }
GtkLinkAdapter >> labelAndIcon [
	| box gtkLabel |

	box := GtkBox newHorizontal
		hAlignCenter;
		spacing: 3;
		yourself.

	gtkLabel := GtkLabel new.
	box append: gtkLabel.

	^ box
]

{ #category : 'building' }
GtkLinkAdapter >> newWidget [ 
	
	^ GtkLinkButton newWithUri: ''
]

{ #category : 'private - updating' }
GtkLinkAdapter >> updateLabelAndIconTo: gtkButton [
	| label gtkLabel |
	
	label := self getLabelText.
	gtkLabel := gtkButton child children first.
	label isEmptyOrNil 
		ifTrue: [ gtkLabel beNotVisible ]
		ifFalse: [ gtkLabel label: label; beVisible ]
]
