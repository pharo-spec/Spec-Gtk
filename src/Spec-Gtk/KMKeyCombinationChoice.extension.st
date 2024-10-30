Extension { #name : 'KMKeyCombinationChoice' }

{ #category : '*Spec-Gtk' }
KMKeyCombinationChoice >> spGtkCurrentCharacter [
	| candidates |
	
	candidates := shortcuts 
		collect: [ :each | each spGtkCurrentCharacter ] 
		thenSelect: [ :each | each isNotNil ].
		
	^ candidates 
		ifEmpty: [ nil ]
		ifNotEmpty: [ candidates first ]
]

{ #category : '*Spec-Gtk' }
KMKeyCombinationChoice >> withAllKeyCombinationsDo: aBlock [

	shortcuts do: [ :each | 
		aBlock value: each ]
]
