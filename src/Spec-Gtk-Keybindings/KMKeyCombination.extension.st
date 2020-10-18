Extension { #name : #KMKeyCombination }

{ #category : #'*Spec-Gtk-Keybindings' }
KMKeyCombination class >> fromEventKey: evt [
	| modifier control command shift alt |

	control := evt hasControlModifier.
	command := evt hasCommandModifier | evt hasMetaModifier | evt hasMod3.
	shift := evt hasShiftModifier.
	alt := evt hasAltModifier.
	(shift | command | control | alt)
		ifFalse: [
			^ KMSingleKeyCombination from: evt keyCharacter ].
	
	modifier := KMNoShortcut new.
	control ifTrue: [ modifier := modifier + KMModifier ctrl ].
	command ifTrue: [ modifier := modifier + KMModifier command ].
	shift ifTrue: [ modifier := modifier + KMModifier shift ].
	alt ifTrue: [ modifier := modifier + KMModifier alt ].
	
	^ modifier + evt keyCharacter
]
