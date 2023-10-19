Class {
	#name : 'GtkSpinnerAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkSpinnerAdapter >> addModelTo: aSpinner [

	super addModelTo: aSpinner.
	"self updateSpinner: aSpinner withState: self presenter state.
	self presenter property: #state whenChangedDo: [ :state |
		self updateSpinner: aSpinner withState: state. ]"
]

{ #category : 'building' }
GtkSpinnerAdapter >> updateSpinner: aSpinner withState: state [

	state
		ifTrue: [ aSpinner start ]
		ifFalse: [ aSpinner stop ]
]

{ #category : 'building' }
GtkSpinnerAdapter >> widgetClass [

	^ GtkSpinner
]
