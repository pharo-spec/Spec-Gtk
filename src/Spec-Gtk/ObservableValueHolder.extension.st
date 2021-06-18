Extension { #name : #ObservableValueHolder }

{ #category : #'*Spec-Gtk' }
ObservableValueHolder >> unsubscribeOuterContextReceiver: anObject [ 

	"this is a hackish way how to unsubscribe a block with a given recevier that is encapsulated in another outer context"

	subscriptions := subscriptions reject: [ :each | (each at: 1) receiver = anObject ].
]
