Class {
	#name : #GtkToggleButtonAdapter,
	#superclass : #GtkCheckBoxAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkToggleButtonAdapter >> addModelTo: gtkToggleButton [

	super addModelTo: gtkToggleButton.
	
	self presenter icon ifNotNil: [ 
		self setIconTo: gtkToggleButton ].
	
	self presenter whenIconChangedDo: [ 
		self setIconTo: gtkToggleButton ].
	
]

{ #category : #building }
GtkToggleButtonAdapter >> setIconTo: gtkToggleButton [

	gtkToggleButton 
		alwaysShowImage: true;
		image: self presenter icon asGtkImage
]

{ #category : #updating }
GtkToggleButtonAdapter >> updatePresenterState [

	self widgetDo: [ :w |
		self state ifTrue: [ 
			self presenter associatedToggleButtons 
				do: [ :each | each state: false ] ]. 
		super updatePresenterState ]
]

{ #category : #updating }
GtkToggleButtonAdapter >> updateState [

	self widgetDo: [ :w |
		self state ifTrue: [ 
			self presenter associatedToggleButtons 
				do: [ :each | each state: false ] ]. 
		super updateState ]
]

{ #category : #factory }
GtkToggleButtonAdapter >> widgetClass [

	^ GtkToggleButton
]
