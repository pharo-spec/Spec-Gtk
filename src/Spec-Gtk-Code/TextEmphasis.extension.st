Extension { #name : 'TextEmphasis' }

{ #category : '*Spec-Gtk-Code' }
TextEmphasis >> acceptTag: aTag [
	
	self attributeSelectors 
		do: [ :aSelector | aTag perform: aSelector ]

]

{ #category : '*Spec-Gtk-Code' }
TextEmphasis class >> attributeSelectors [

	^ {   	
		1	-> #beBold.
		2	-> #beItalic.
		4	-> #beUnderlined.
		8	-> #beNarrow.
		16	-> #beStrikeThrough } 
	asDictionary 
]

{ #category : '*Spec-Gtk-Code' }
TextEmphasis >> attributeSelectors [ 
	
	^ Array streamContents: [ :stream | 
		self class attributeSelectors keysAndValuesDo: [ :code :selector | 
			(emphasisCode & code) = code ifTrue: [ 
				stream nextPut: selector ] ] ]
]
