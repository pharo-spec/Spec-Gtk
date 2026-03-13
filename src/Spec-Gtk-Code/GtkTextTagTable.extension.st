Extension { #name : 'GtkTextTagTable' }

{ #category : '*Spec-Gtk-Code' }
GtkTextTagTable class >> newForCode: attrArray [
	| table |
	
	table := self new.
	attrArray keysAndValuesDo: [ :aName :attributes | | tag |
		tag := GtkTextTag newUnownedName: aName asString.
		attributes do: [ :each | each acceptTag: tag ].
		table add: tag ].

	^ table
]
