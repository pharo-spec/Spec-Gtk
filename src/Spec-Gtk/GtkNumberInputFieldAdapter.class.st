Class {
	#name : 'GtkNumberInputFieldAdapter',
	#superclass : 'GtkAbstractTextAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkNumberInputFieldAdapter >> addModelTo: gtkSpinButton [

	"set this first because max/min and digits set may affect the value (and super 
	 will take care of setting it)"
	gtkSpinButton 
		beNumber;
		rangeMinimum: (self model minimum ifNil: [ Float fmin ]) 
			maximum: (self model maximum ifNil: [ Float fmax ]).

	self presenter isFloat
		ifTrue: [ gtkSpinButton digits: (self presenter digits max: 1) ].

	super addModelTo: gtkSpinButton.

	gtkSpinButton connectValueChanged: [ 
		self updatePresenterText: gtkSpinButton text ].
	
	self presenter climbRate 
		ifNotNil: [ :rate | gtkSpinButton climbRate: rate ]
]

{ #category : 'building' }
GtkNumberInputFieldAdapter >> newActionManager [

	^ GtkAdapterActionTextInputFieldManager on: self
]

{ #category : 'building' }
GtkNumberInputFieldAdapter >> newWidget [ 

	^ self widgetClass 
		newAdjustment: GtkAdjustment newDefault
		climbRate: 1.0 
		digits: 0
]

{ #category : 'private' }
GtkNumberInputFieldAdapter >> parseNumber: aString [

	^ (Number readFrom: aString ifFail: [ 0.0 ]) asFloat
]

{ #category : 'private' }
GtkNumberInputFieldAdapter >> refreshText [
	
	self widgetDo: [ :w |
		w value: self model number ]
]

{ #category : 'accessing' }
GtkNumberInputFieldAdapter >> setText: aStringOrNumber to: gtkWidget [

	gtkWidget value: (aStringOrNumber isString 
		ifTrue: [ self parseNumber: aStringOrNumber ]
		ifFalse: [ aStringOrNumber ])
]

{ #category : 'private' }
GtkNumberInputFieldAdapter >> updatePresenterText: aString [

	self runInSystem: [
		self backendUpdatingDo: [
			self presenter text: (aString copyReplaceAll: ',' with: '.') ] ] 
]

{ #category : 'building' }
GtkNumberInputFieldAdapter >> widgetClass [ 

	^ GtkSpinButton
]
