Extension { #name : 'KMPlatformSpecificKeyCombination' }

{ #category : '*Spec-Gtk' }
KMPlatformSpecificKeyCombination >> isForPlatform [

	^ self platform = #all or: [ self platform = OSPlatform current platformFamily ]
]

{ #category : '*Spec-Gtk' }
KMPlatformSpecificKeyCombination >> key [

	^ self shortcut key
]

{ #category : '*Spec-Gtk' }
KMPlatformSpecificKeyCombination >> spGtkCurrentCharacter [

	^ (self platform = #all or: [ self platform = OSPlatform current platformFamily ])
		ifTrue: [ self shortcut spGtkCurrentCharacter ]
		ifFalse: [ nil ]
]
