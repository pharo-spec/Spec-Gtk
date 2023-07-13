Extension { #name : #SpCommand }

{ #category : #'*Spec-Gtk' }
SpCommand >> id [

	^ String streamContents: [ :stream |
		| parts name |
		
		name := self name 
			ifNil: [ 
				self shortcutKey
					ifNotNil: [ 'shortcut ', self shortcutKey asString ]
					ifNil: [ 'unknown' ] ].
		parts := name substrings.
		stream << parts first asLowercase.
		parts allButFirstDo: [ :each | stream << each capitalized ] ]
]