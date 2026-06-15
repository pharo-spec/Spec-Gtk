Class {
	#name : 'GtkSelectionModelCallbackTest',
	#superclass : 'TestCase',
	#category : 'Spec-GtkBackendTests',
	#package : 'Spec-GtkBackendTests'
}

{ #category : 'tests' }
GtkSelectionModelCallbackTest >> testListStaleSelectionChangedCallbackDoesNotUpdateSelection [
	| adapter newSelectionModel oldSelectionModel |

	adapter := GtkSelectionModelListGenerationTestAdapter new.
	oldSelectionModel := GtkSelectionModelTestSelectionModel new.
	newSelectionModel := GtkSelectionModelTestSelectionModel new.

	adapter connectSelectionChangedOn: oldSelectionModel.
	adapter connectSelectionChangedOn: newSelectionModel.

	oldSelectionModel emitSelectionChanged.
	self assert: adapter updateCount equals: 0.
	self assert: adapter lastUpdate isNil.

	newSelectionModel emitSelectionChanged.
	self assert: adapter updateCount equals: 1.
	self assert: adapter lastUpdate equals: #(1 1)
]

{ #category : 'tests' }
GtkSelectionModelCallbackTest >> testOldSelectionModelDisconnectsSelectionChangedOnReplacement [
	| newSelectionModel oldSelectionModel widget |

	widget := GtkSelectionModelTestListBase basicNew.
	oldSelectionModel := GtkSelectionModelTestSelectionModel new.
	oldSelectionModel connectSelectionChanged: [ :position :numItems | nil ].
	newSelectionModel := GtkSelectionModelTestSelectionModel new.

	widget selectionModel: oldSelectionModel.
	self assert: oldSelectionModel hasSelectionChangedCallback.

	widget selectionModel: newSelectionModel.

	self deny: oldSelectionModel hasSelectionChangedCallback.
	self assert: (oldSelectionModel wasBlocked: GSelectionChangedCallback signalName).
	self assert: (oldSelectionModel wasDisconnected: GSelectionChangedCallback signalName).
	self assert: oldSelectionModel objectRefCount equals: 1.
	self assert: oldSelectionModel objectUnrefCount equals: 1.
	self assert: oldSelectionModel resetHandleCount equals: 1
]

{ #category : 'tests' }
GtkSelectionModelCallbackTest >> testTreeRefreshBlocksOldSelectionChangedWhileUnselecting [
	| adapter newSelectionModel oldSelectionModel widget |

	widget := GtkSelectionModelTestListBase basicNew.
	oldSelectionModel := GtkSelectionModelTestSelectionModel new.
	oldSelectionModel connectSelectionChanged: [ :position :numItems | nil ].
	newSelectionModel := GtkSelectionModelTestSelectionModel new.
	widget selectionModel: oldSelectionModel.

	adapter := GtkSelectionModelRefreshTreeAdapter new.
	adapter
		widget: widget;
		nextSelectionModel: newSelectionModel.

	adapter refreshList.

	self assert: oldSelectionModel unselectAllWasBlocked.
	self assert: widget selectionModel identicalTo: newSelectionModel.
	self assert: widget factory resetCount equals: 1
]

{ #category : 'tests' }
GtkSelectionModelCallbackTest >> testTreeStaleSelectionChangedCallbackDoesNotUpdateSelection [
	| adapter newSelectionModel oldSelectionModel |

	adapter := GtkSelectionModelTreeGenerationTestAdapter new.
	oldSelectionModel := GtkSelectionModelTestSelectionModel new.
	newSelectionModel := GtkSelectionModelTestSelectionModel new.

	adapter connectSelectionChangedOn: oldSelectionModel.
	adapter connectSelectionChangedOn: newSelectionModel.

	oldSelectionModel emitSelectionChanged.
	self assert: adapter updateCount equals: 0.
	self assert: adapter lastUpdate isNil.

	newSelectionModel emitSelectionChanged.
	self assert: adapter updateCount equals: 1.
	self assert: adapter lastUpdate equals: #(1 1)
]
