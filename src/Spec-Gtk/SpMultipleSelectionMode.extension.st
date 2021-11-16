Extension { #name : #SpMultipleSelectionMode }

{ #category : #'*Spec-Gtk' }
SpMultipleSelectionMode >> unsubscribeOuterContextReceiver: anObject [ 

	(self observablePropertyNamed: #selectedIndexes) unsubscribeOuterContextReceiver: anObject.
]
