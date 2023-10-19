Extension { #name : 'SpCommandGroup' }

{ #category : '*Spec-Gtk' }
SpCommandGroup >> id [

	^ String streamContents: [ :stream |
		| parts |
		parts := (self name ifNil: [ 'unknown' ]) substrings.
		stream << parts first asLowercase.
		parts allButFirstDo: [ :each | stream << each capitalized ] ]
]
