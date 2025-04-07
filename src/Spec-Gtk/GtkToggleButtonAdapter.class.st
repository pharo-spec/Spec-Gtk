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
		self state ifTrue: [ 
			self presenter associatedToggleButtons 
				do: [ :each | each state: false ] ]. 
		super updateState ]
]

{ #category : 'factory' }
GtkToggleButtonAdapter >> widgetClass [

	^ GtkToggleButton
]
