Class {
	#name : 'GtkSelectionModelTestFactory',
	#superclass : 'Object',
	#instVars : [
		'resetCount'
	],
	#category : 'Spec-GtkBackendTests',
	#package : 'Spec-GtkBackendTests'
}

{ #category : 'actions' }
GtkSelectionModelTestFactory >> reset [

	resetCount := self resetCount + 1
]

{ #category : 'accessing' }
GtkSelectionModelTestFactory >> resetCount [

	^ resetCount ifNil: [ 0 ]
]
