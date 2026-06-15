Class {
	#name : 'GtkSelectionModelTreeGenerationTestAdapter',
	#superclass : 'GtkBaseTreeListViewAdapter',
	#instVars : [
		'updateCount',
		'lastUpdate'
	],
	#category : 'Spec-GtkBackendTests',
	#package : 'Spec-GtkBackendTests'
}

{ #category : 'accessing' }
GtkSelectionModelTreeGenerationTestAdapter >> lastUpdate [

	^ lastUpdate
]

{ #category : 'accessing' }
GtkSelectionModelTreeGenerationTestAdapter >> updateCount [

	^ updateCount ifNil: [ 0 ]
]

{ #category : 'private - updating' }
GtkSelectionModelTreeGenerationTestAdapter >> updatePresenterSelection: position numItems: numItems [

	updateCount := self updateCount + 1.
	lastUpdate := { position. numItems }
]
