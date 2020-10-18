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

{ #category : #updating }
GtkBaseButtonAdapter >> updateIcon [

	self widgetDo: [ :w |
		w
			alwaysShowImage;
			image: self presenter icon asGtkImage ]
]

{ #category : #updating }
GtkBaseButtonAdapter >> updateLabel [

	self widgetDo: [ :w | 
		w label: self getLabelText ]
]

{ #category : #updating }
GtkBaseButtonAdapter >> updateTooltip [

	self widgetDo: [ :w | 
		w tooltipText: self getHelpText ]
]
