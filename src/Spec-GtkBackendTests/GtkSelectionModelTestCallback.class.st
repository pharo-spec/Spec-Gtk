Class {
	#name : 'GtkSelectionModelTestCallback',
	#superclass : 'Object',
	#instVars : [
		'signalName'
	],
	#category : 'Spec-GtkBackendTests',
	#package : 'Spec-GtkBackendTests'
}

{ #category : 'instance creation' }
GtkSelectionModelTestCallback class >> signalName: aString [

	^ self new
		signalName: aString;
		yourself
]

{ #category : 'accessing' }
GtkSelectionModelTestCallback >> signalName [

	^ signalName
]

{ #category : 'accessing' }
GtkSelectionModelTestCallback >> signalName: aString [

	signalName := aString
]
