Extension { #name : 'TextEmphasis' }

{ #category : '*Spec-Gtk-Code' }
TextEmphasis >> acceptTag: aTag [
	
	self attributeSelectors 
		do: [ :aSelector | aTag perform: aSelector ]

]

{ #category : '*Spec-Gtk-Code' }
TextEmphasis >> attributeSelectors [ 
	
	^ Array streamContents: [ :stream | 
		self class attributeSelectors keysAndValuesDo: [ :code :selector | 
			(emphasisCode & code) = code ifTrue: [ 
				stream nextPut: selector ] ] ]
]
