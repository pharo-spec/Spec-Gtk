Class {
	#name : 'GtkSelectionModelListGenerationTestAdapter',
	#superclass : 'GtkBaseListViewAdapter',
	#instVars : [
		'updateCount',
		'lastUpdate'
	],
	#category : 'Spec-GtkBackendTests',
	#package : 'Spec-GtkBackendTests'
}

{ #category : 'accessing' }
GtkSelectionModelListGenerationTestAdapter >> lastUpdate [

	^ lastUpdate
]

{ #category : 'accessing' }
GtkSelectionModelListGenerationTestAdapter >> updateCount [

	^ updateCount ifNil: [ 0 ]
]

{ #category : 'private - updating' }
GtkSelectionModelListGenerationTestAdapter >> updatePresenterSelection: position numItems: numItems [

	updateCount := self updateCount + 1.
	lastUpdate := { position. numItems }
]
