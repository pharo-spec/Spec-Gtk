Class {
	#name : 'GtkBaseButtonAdapter',
	#superclass : 'GtkAdapter',
	#instVars : [
		'labelWidget'
	],
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkBaseButtonAdapter >> addModelTo: gtkButton [

	super addModelTo: gtkButton.

	gtkButton child: self labelAndIcon.
	
	self hasLabelOrIcon
		ifTrue: [ self updateLabelAndIconTo: gtkButton ] .
	
	self connectToSpecEvents: gtkButton
]

{ #category : 'building' }
GtkBaseButtonAdapter >> connectToSpecEvents: gtkButton [

	self presenter 
		whenLabelChangedDo: [ self updateLabel ];
		whenIconChangedDo: [ self updateIcon ]
]

{ #category : 'updating' }
GtkBaseButtonAdapter >> getLabelText [

	^ self presenter label 
		ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : 'private - testing' }
GtkBaseButtonAdapter >> hasIcon [

	^ self presenter icon isNotNil
]

{ #category : 'private - testing' }
GtkBaseButtonAdapter >> hasLabel [

	^ self presenter label isEmptyOrNil not
]

{ #category : 'private - testing' }
GtkBaseButtonAdapter >> hasLabelOrIcon [

	^ self hasLabel
		or: [ self hasIcon ]
]

{ #category : 'accessing' }
GtkBaseButtonAdapter >> icon [

	^ widget image
]

{ #category : 'private' }
GtkBaseButtonAdapter >> labelAndIcon [
	| box gtkIcon gtkLabel |

	box := GtkBox newHorizontal
		hAlignCenter;
		spacing: 3;
		yourself.

	gtkIcon := GtkImage new.
	gtkIcon hExpand: false.
	box append: gtkIcon.
	gtkIcon visible: false.

	gtkLabel := GtkLabel new.
	box append: gtkLabel.
	gtkLabel visible: false.

	^ box
]

{ #category : 'updating' }
GtkBaseButtonAdapter >> updateIcon [

	self updateLabel
]

{ #category : 'updating' }
GtkBaseButtonAdapter >> updateLabel [

	self widgetDo: [ :w | 
		self updateLabelAndIconTo: w ]
]

{ #category : 'private - updating' }
GtkBaseButtonAdapter >> updateLabelAndIconTo: gtkButton [
	| label gtkIcon gtkLabel |
	
	gtkIcon := gtkButton child children first.
	self hasIcon
		ifTrue: [ gtkIcon setFromPaintable: self presenter icon asGdkPaintable; beVisible ]
		ifFalse: [ gtkIcon beNotVisible ].

	label := self getLabelText.
	gtkLabel := gtkButton child children second.
	self hasLabel
		ifTrue: [ gtkLabel label: label; beVisible ]
		ifFalse: [ gtkLabel beNotVisible ]
]

{ #category : 'updating' }
GtkBaseButtonAdapter >> updateTooltip [

	self widgetDo: [ :w | 
		w tooltipText: self getHelpText ]
]

{ #category : 'building' }
GtkBaseButtonAdapter >> widgetClass [

	^ GtkButton
]
