Class {
	#name : #GtkSliderAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkSliderAdapter >> addModelTo: gtkWidget [

	super addModelTo: gtkWidget.
	gtkWidget drawValue: false.
	
	self marks: self presenter marks into: gtkWidget.
	self presenter whenMarksChangedDo: [ :newValue | self updateMarks: newValue ].
	
	gtkWidget setValue: self presenter absoluteValue.
	gtkWidget connectValueChanged: [ 
		self backendUpdatingDo: [ self presenter absoluteValue: gtkWidget value ] ].
	self presenter whenAbsoluteValueChangedDo: [ :newValue | 
		self backendDetectCyclesDo: [ self updateValue: newValue ] ]
]

{ #category : #building }
GtkSliderAdapter >> marks: newValue into: gtkWidget [

	gtkWidget clearMarks.
	newValue
		do: [ :m | 
			gtkWidget
				addMarkAtValue: (self presenter valueToAbsoluteValue:  m value)
				withPosition: GtkPositionType GTK_POS_BOTTOM
				withText: m text ]
]

{ #category : #building }
GtkSliderAdapter >> newWidget [

	^ self presenter isHorizontal
		ifTrue: [ 
			self widgetClass
				newHorizontalMin: self presenter min asFloat
				max: self presenter max asFloat
				step: (self presenter quantum / self presenter max) asFloat ]
		ifFalse: [ 
			self widgetClass
				newVerticalMin: self presenter max
				max: self presenter min
				step: (self presenter quantum / self presenter max) asFloat ]
]

{ #category : #'private updating' }
GtkSliderAdapter >> updateMarks: newValue [ 

	self widgetDo: [ :w | 
		self marks: newValue into: w ]
]

{ #category : #'private updating' }
GtkSliderAdapter >> updateValue: newValue [

	self widgetDo: [ :w | 
		w setValue: newValue asFloat ]
]

{ #category : #building }
GtkSliderAdapter >> widgetClass [

	^ GtkScale
]
