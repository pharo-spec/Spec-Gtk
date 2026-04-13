Extension { #name : 'KeyboardKey' }

{ #category : '*Spec-Gtk-Keybindings' }
KeyboardKey class >> atValue: aKeyValue ifAbsent: aBlock [

	^ KeyCodeTable 
		at: aKeyValue
		ifAbsent: aBlock
]
