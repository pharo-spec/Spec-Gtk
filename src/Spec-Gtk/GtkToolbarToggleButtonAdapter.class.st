Class {
	#name : 'GtkToolbarToggleButtonAdapter',
	#superclass : 'GtkToolbarBaseButtonAdapter',
	#category : 'Spec-Gtk-Adapter-Toolbar',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Toolbar'
}

{ #category : 'building' }
GtkToolbarToggleButtonAdapter >> addModelTo: gtkToolButton [
	
	super addModelTo: gtkToolButton.	
	gtkToolButton active: self presenter state
]

{ #category : 'building' }
GtkToolbarToggleButtonAdapter >> newWidget [
	
	^ GtkToggleButton new 
		addClass: 'image-button';
		addClass: 'toolbar-button';
		yourself
]

{ #category : 'private' }
GtkToolbarToggleButtonAdapter >> performAction [

	self widgetDo: [ :w | 
		self presenter state: w isActive ]. 
	super performAction
]

{ #category : 'building' }
GtkToolbarToggleButtonAdapter >> updatePresenterState [
	| state |

	self widgetDo: [ :w |
		state := self presenter state.
		state ifTrue: [
			self presenter associatedToggleButtons 
				do: [ :each | each state: false ] ].
		w active: state ]
]

{ #category : 'building' }
GtkToolbarToggleButtonAdapter >> updateState [
	| state |

	self widgetDo: [ :w |
		state := w active.
		state ifTrue: [
			self presenter associatedToggleButtons 
				do: [ :each | each state: false ] ]. 
		self presenter execute: state ]
]
