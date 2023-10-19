Extension { #name : 'SpCollectionListModel' }

{ #category : '*Spec-Gtk' }
SpCollectionListModel >> unsubscribe: anObject [

	self announcer unsubscribe: anObject
]
