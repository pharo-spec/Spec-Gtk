Extension { #name : #ObservableValueHolder }

{ #category : #'*Spec-Gtk' }
ObservableValueHolder >> unsubscribeOuterContextReceiver: anObject [ 

	"This is a hackish way how to unsubscribe a block with a given recevier that is encapsulated in another outer context. 
	One part of the problem is that subscriptions themeselves can be plain blocks so there is there is no place to register the subscriber. So it cannot be easily unsubscribed and the subscriber needs to be extracted from the block itself"

	subscriptions := subscriptions reject: [ :each | 
		each size = 1 and: [ 
			| subscriber |
			subscriber := each at: 1.
			subscriber isClosure and: [ subscriber receiver = anObject ] ] ].
]
