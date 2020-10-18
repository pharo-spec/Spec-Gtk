Class {
	#name : #GtkNumberInputFieldAdapter,
	#superclass : #GtkTextInputFieldAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkNumberInputFieldAdapter >> addModelTo: gtkSpinButton [

	super addModelTo: gtkSpinButton.
	
	gtkSpinButton 
		beNumber;
		rangeMinimum: (self model minimum ifNil: [ Float fmin ]) 
			maximum: (self model maximum ifNil: [ Float fmax ]).
	
	self model isFloat ifTrue: [ 
		gtkSpinButton digits: self model digits ].
	self model climbRate ifNotNil: [ :rate |
		gtkSpinButton climbRate: rate ]
]

{ #category : #building }
GtkNumberInputFieldAdapter >> newWidget [ 

	^ self widgetClass 
		newAdjustment: GtkAdjustment newDefault
		climbRate: 1.0 
		digits: 0
]

{ #category : #private }
GtkNumberInputFieldAdapter >> refreshText [
	
	self widgetDo: [ :w |
		w value: self model number ]
]

{ #category : #accessing }
GtkNumberInputFieldAdapter >> setText: aStringOrNumber to: gtkWidget [

	gtkWidget value: (aStringOrNumber isString 
		ifTrue: [ (Number readFrom: aStringOrNumber ifFail: [ 0.0 ]) asFloat ]
		ifFalse: [ aStringOrNumber ])
]

{ #category : #building }
GtkNumberInputFieldAdapter >> widgetClass [ 

	^ GtkSpinButton
]
