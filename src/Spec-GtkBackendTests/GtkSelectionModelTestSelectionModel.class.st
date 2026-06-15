Class {
	#name : 'GtkSelectionModelTestSelectionModel',
	#superclass : 'Object',
	#instVars : [
		'callbacks',
		'selectionChangedBlock',
		'blockingSignals',
		'blockedSignals',
		'disconnectedSignals',
		'objectRefCount',
		'objectUnrefNowCount',
		'objectUnrefCount',
		'resetHandleCount',
		'doNotAutoReleaseCount',
		'unselectAllWasBlocked'
	],
	#category : 'Spec-GtkBackendTests',
	#package : 'Spec-GtkBackendTests'
}

{ #category : 'signaling' }
GtkSelectionModelTestSelectionModel >> blockCallback: aString during: aBlock [

	self blockedSignals add: aString.
	self blockingSignals add: aString.
	^ aBlock ensure: [
		self blockingSignals remove: aString ifAbsent: [ nil ] ]
]

{ #category : 'accessing' }
GtkSelectionModelTestSelectionModel >> blockedSignals [

	^ blockedSignals ifNil: [ blockedSignals := OrderedCollection new ]
]

{ #category : 'accessing' }
GtkSelectionModelTestSelectionModel >> blockingSignals [

	^ blockingSignals ifNil: [ blockingSignals := OrderedCollection new ]
]

{ #category : 'accessing' }
GtkSelectionModelTestSelectionModel >> callbacks [

	^ callbacks ifNil: [ callbacks := OrderedCollection new ]
]

{ #category : 'signaling' }
GtkSelectionModelTestSelectionModel >> connectSelectionChanged: aBlock [

	selectionChangedBlock := aBlock.
	self callbacks add:
		(GtkSelectionModelTestCallback
			signalName: GSelectionChangedCallback signalName)
]

{ #category : 'signaling' }
GtkSelectionModelTestSelectionModel >> disconnect: aString [

	self disconnectedSignals add: aString.
	self callbacks
		removeAllSuchThat: [ :each | each signalName = aString ]
]

{ #category : 'accessing' }
GtkSelectionModelTestSelectionModel >> disconnectedSignals [

	^ disconnectedSignals ifNil: [ disconnectedSignals := OrderedCollection new ]
]

{ #category : 'actions' }
GtkSelectionModelTestSelectionModel >> doNotAutoRelease [

	doNotAutoReleaseCount := self doNotAutoReleaseCount + 1
]

{ #category : 'accessing' }
GtkSelectionModelTestSelectionModel >> doNotAutoReleaseCount [

	^ doNotAutoReleaseCount ifNil: [ 0 ]
]

{ #category : 'signaling' }
GtkSelectionModelTestSelectionModel >> emitSelectionChanged [

	selectionChangedBlock value: 1 value: 1
]

{ #category : 'testing' }
GtkSelectionModelTestSelectionModel >> hasSelectionChangedCallback [

	^ self callbacks anySatisfy: [ :each |
		each signalName = GSelectionChangedCallback signalName ]
]

{ #category : 'actions' }
GtkSelectionModelTestSelectionModel >> objectRef [

	objectRefCount := self objectRefCount + 1
]

{ #category : 'accessing' }
GtkSelectionModelTestSelectionModel >> objectRefCount [

	^ objectRefCount ifNil: [ 0 ]
]

{ #category : 'actions' }
GtkSelectionModelTestSelectionModel >> objectUnref [

	objectUnrefCount := self objectUnrefCount + 1
]

{ #category : 'accessing' }
GtkSelectionModelTestSelectionModel >> objectUnrefCount [

	^ objectUnrefCount ifNil: [ 0 ]
]

{ #category : 'actions' }
GtkSelectionModelTestSelectionModel >> objectUnrefNow [

	objectUnrefNowCount := self objectUnrefNowCount + 1
]

{ #category : 'accessing' }
GtkSelectionModelTestSelectionModel >> objectUnrefNowCount [

	^ objectUnrefNowCount ifNil: [ 0 ]
]

{ #category : 'actions' }
GtkSelectionModelTestSelectionModel >> resetHandle [

	resetHandleCount := self resetHandleCount + 1
]

{ #category : 'accessing' }
GtkSelectionModelTestSelectionModel >> resetHandleCount [

	^ resetHandleCount ifNil: [ 0 ]
]

{ #category : 'actions' }
GtkSelectionModelTestSelectionModel >> unselectAll [

	unselectAllWasBlocked := self blockingSignals
		includes: GSelectionChangedCallback signalName
]

{ #category : 'testing' }
GtkSelectionModelTestSelectionModel >> unselectAllWasBlocked [

	^ unselectAllWasBlocked ifNil: [ false ]
]

{ #category : 'testing' }
GtkSelectionModelTestSelectionModel >> wasBlocked: aString [

	^ self blockedSignals includes: aString
]

{ #category : 'testing' }
GtkSelectionModelTestSelectionModel >> wasDisconnected: aString [

	^ self disconnectedSignals includes: aString
]
