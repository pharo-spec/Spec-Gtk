Extension { #name : 'KMPlatformSpecificKeyCombination' }

{ #category : '*Spec-Gtk' }
KMPlatformSpecificKeyCombination >> spGtkCurrentCharacter [

	^ (self platform = #all or: [ self platform = OSPlatform current platformFamily ])
		ifTrue: [ self shortcut spGtkCurrentCharacter ]
		ifFalse: [ nil ]
]
