Extension { #name : #SpSingleSelectionMode }

{ #category : #'*Spec-Gtk' }
SpSingleSelectionMode >> unsubscribe: anObject [ 

	(self observablePropertyNamed: #selectedIndex) unsubscribe: anObject.

]

{ #category : #'*Spec-Gtk' }
SpSingleSelectionMode >> unsubscribeOuterContextReceiver: anObject [ 

	(self observablePropertyNamed: #selectedIndex) unsubscribeOuterContextReceiver: anObject.
]
