Extension { #name : 'KMKeyCombination' }

{ #category : '*Spec-Gtk' }
KMKeyCombination >> isForPlatform [

	^ self platform = #all or: [ self platform = OSPlatform current platformFamily ]
]

{ #category : '*Spec-Gtk' }
KMKeyCombination >> spGtkCurrentCharacter [

	^ ''
]

{ #category : '*Spec-Gtk' }
KMKeyCombination >> withAllKeyCombinationsDo: aBlock [

	aBlock value: self
]
