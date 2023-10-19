Extension { #name : 'GtkTextTagTable' }

{ #category : '*Spec-Gtk-Code' }
GtkTextTagTable class >> newForCode [

	^ self newForCode: (SHRBTextStyler initialTextAttributesForPixelHeight: 1) 

	
]

{ #category : '*Spec-Gtk-Code' }
GtkTextTagTable class >> newForCode: attrArray [
	| table |
	
	table := self new.
	attrArray keysAndValuesDo: [ :aName :attributes | | tag |
		tag := GtkTextTag newName: aName asString.
		attributes do: [ :each | each acceptTag: tag ].
		table add: tag ].

	^ table
]
