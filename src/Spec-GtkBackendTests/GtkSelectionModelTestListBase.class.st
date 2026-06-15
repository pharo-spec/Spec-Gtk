Class {
	#name : 'GtkSelectionModelTestListBase',
	#superclass : 'GtkListBase',
	#instVars : [
		'setModels'
	],
	#category : 'Spec-GtkBackendTests',
	#package : 'Spec-GtkBackendTests'
}

{ #category : 'accessing' }
GtkSelectionModelTestListBase >> factory [

	^ factory ifNil: [ factory := GtkSelectionModelTestFactory new ]
]

{ #category : 'accessing' }
GtkSelectionModelTestListBase >> setModel: aSelectionModel [

	self setModels add: aSelectionModel
]

{ #category : 'accessing' }
GtkSelectionModelTestListBase >> setModels [

	^ setModels ifNil: [ setModels := OrderedCollection new ]
]
