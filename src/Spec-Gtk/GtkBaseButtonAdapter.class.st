Class {
	#name : #GtkBaseButtonAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkBaseButtonAdapter >> addModelTo: gtkButton [

	super addModelTo: gtkButton.

	widget := gtkButton.

	self presenter label isEmptyOrNil ifFalse: [ self updateLabel ].
	self presenter icon ifNotNil: [ self updateIcon ].
	
	model whenLabelChangedDo: [ self updateLabel ].
	model whenIconChangedDo: [ self updateIcon ]
]

{ #category : #updating }
GtkBaseButtonAdapter >> getLabelText [

	^ self presenter label ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : #accessing }
GtkBaseButtonAdapter >> icon [
	^ widget image
]

{ #category : #private }
GtkBaseButtonAdapter >> labelAndIcon [
	| box |

	box := GtkBox newHorizontal
		hAlignCenter;
		spacing: 3;
		yourself.

	self presenter icon ifNotNil: [ :icon | | gtkIcon |
		gtkIcon := self presenter icon asGtkImage.
		gtkIcon hExpand: false.
		box append: gtkIcon ].

	self getLabelText ifNotNil: [ :label | | gtkLabel |
		label ifNotEmpty: [
			gtkLabel := (GtkLabel newLabel: label).
			box append: gtkLabel ] ].

	^ box
]

{ #category : #updating }
GtkBaseButtonAdapter >> updateIcon [

	self widgetDo: [ :w |
		w child: self labelAndIcon ]
]

{ #category : #updating }
GtkBaseButtonAdapter >> updateLabel [

	self widgetDo: [ :w | 
		w child: self labelAndIcon ]
]

{ #category : #updating }
GtkBaseButtonAdapter >> updateTooltip [

	self widgetDo: [ :w | 
		w tooltipText: self getHelpText ]
]
