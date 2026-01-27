Class {
	#name : 'GtkToggleButtonAdapter',
	#superclass : 'GtkButtonAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'updating' }
GtkToggleButtonAdapter >> addActionTo: gtkToggleButton [

	gtkToggleButton connectToggled: [
		self backendUpdatingDo: [ self updatePresenterState ] ].
	self presenter whenChangedDo: [
		self withCycleDetectionOnBackendDo: [ self updateState ] ]
]

{ #category : 'building' }
GtkToggleButtonAdapter >> addGroupTo: gtkToggleButton [
	| associated |
	
	associated := self presenter associatedToggleButtons.
	"if there is no associated buttons I have nothing to do"
	associated isEmptyOrNil ifTrue: [ ^ self ].
	"doit at the end (after all the others have been do)"
	(associated allSatisfy: [ :each | each hasAdapter ]) ifFalse: [ ^ self ].
	"traverse all associated and set the group"
	associated do: [ :each |
		each adapter widget groupTo: gtkToggleButton ]
]

{ #category : 'building' }
GtkToggleButtonAdapter >> addModelTo: gtkToggleButton [

	gtkToggleButton active: self presenter state.
	super addModelTo: gtkToggleButton.
	self addGroupTo: gtkToggleButton
]

{ #category : 'building' }
GtkToggleButtonAdapter >> setIconTo: gtkToggleButton [

	gtkToggleButton image: self presenter icon asGtkImage
]

{ #category : 'updating' }
GtkToggleButtonAdapter >> updatePresenterState [

	self widgetDo: [ :w |
		self updatePresenterStateOn: w ]
]

{ #category : 'updating' }
GtkToggleButtonAdapter >> updatePresenterStateOn: gtkToggleButton [
	| active |

	active := gtkToggleButton isActive.
	active ifTrue: [
		self presenter associatedToggleButtons
			do: [ :each | each state: false ] ].
	self presenter state: active
]

{ #category : 'updating' }
GtkToggleButtonAdapter >> updateState [

	self widgetDo: [ :w |
		self presenter state ifTrue: [ 
			self presenter associatedToggleButtons 
				do: [ :each | each state: false ] ] ]
]

{ #category : 'factory' }
GtkToggleButtonAdapter >> widgetClass [

	^ GtkToggleButton
]
