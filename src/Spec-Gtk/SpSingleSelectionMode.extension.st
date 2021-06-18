Extension { #name : #SpSingleSelectionMode }

{ #category : #'*Spec-Gtk' }
SpSingleSelectionMode >> unsubscribeOuterContextReceiver: anObject [ 

	(self observablePropertyNamed: #selectedIndex) unsubscribeOuterContextReceiver: anObject.
]
