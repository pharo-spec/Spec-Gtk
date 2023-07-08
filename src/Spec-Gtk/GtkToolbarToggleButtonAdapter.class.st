Class {
	#name : #GtkToolbarToggleButtonAdapter,
	#superclass : #GtkToolbarBaseButtonAdapter,
	#category : #'Spec-Gtk-Adapter-Toolbar'
}

{ #category : #building }
GtkToolbarToggleButtonAdapter >> addModelTo: gtkToolButton [
	
	super addModelTo: gtkToolButton.

	gtkToolButton connectToggled: [ self updateState ].
	self presenter whenToggledDo: [ self updatePresenterState ].
	
	gtkToolButton active: self presenter state
]

{ #category : #building }
GtkToolbarToggleButtonAdapter >> newWidget [
	| button  |
	
	button := GtkToggleToolButton new 
		label: self presenter label;
		yourself.
		
	self presenter icon ifNotNil: [ :icon | 
		button iconWidget: icon asGtkImage ].

	^ button 
]

{ #category : #building }
GtkToolbarToggleButtonAdapter >> updatePresenterState [
	| state |

	self widgetDo: [ :w |
		state := self presenter state.
		state ifTrue: [
			self presenter associatedToggleButtons 
				do: [ :each | each state: false ] ].
		w active: state ]
]

{ #category : #building }
GtkToolbarToggleButtonAdapter >> updateState [
	| state |

	self widgetDo: [ :w |
		state := w active.
		state ifTrue: [
			self presenter associatedToggleButtons 
				do: [ :each | each state: false ] ]. 
		self presenter execute: state ]
]
