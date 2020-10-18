Class {
	#name : #GtkCodeUserAction,
	#superclass : #Object,
	#instVars : [
		'registerChange'
	],
	#category : #'Spec-Gtk-Code'
}

{ #category : #testing }
GtkCodeUserAction >> hasChanged [

	^ registerChange > 0

	
]

{ #category : #initialization }
GtkCodeUserAction >> initialize [

	super initialize.
	self reset
]

{ #category : #accessing }
GtkCodeUserAction >> registerChange [

	registerChange := registerChange + 1
]

{ #category : #accessing }
GtkCodeUserAction >> reset [

	registerChange := 0
]
