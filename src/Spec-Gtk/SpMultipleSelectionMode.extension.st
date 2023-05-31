Extension { #name : #SpMultipleSelectionMode }

{ #category : #'*Spec-Gtk' }
SpMultipleSelectionMode >> gtkAdapterCompanion [

	^ GtkAdapterMultiSelection
]

{ #category : #'*Spec-Gtk' }
SpMultipleSelectionMode >> unsubscribeOuterContextReceiver: anObject [ 

	(self observablePropertyNamed: #selectedIndexes) unsubscribeOuterContextReceiver: anObject.
]
