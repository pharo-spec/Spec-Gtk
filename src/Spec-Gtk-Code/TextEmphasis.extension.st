Extension { #name : #TextEmphasis }

{ #category : #'*Spec-Gtk-Code' }
TextEmphasis >> acceptTag: aTag [
	aTag perform: self attributeSelector 
]

{ #category : #'*Spec-Gtk-Code' }
TextEmphasis >> attributeSelector [ 
	^ self attributeSelectors at: emphasisCode 
]

{ #category : #'*Spec-Gtk-Code' }
TextEmphasis >> attributeSelectors [
	^  {   	
		1	-> #beBold.
		2	-> #beItalic.
		4	-> #beUnderlined.
		8	-> #beNarrow.
		16	-> #beStrikeThrough } asDictionary 
]
