Extension { #name : 'CmUIDisplayAsSubMenu' }

{ #category : '*Spec-Gtk' }
CmUIDisplayAsSubMenu >> appendGroup: aMenu label: aLabel to: parentMenu in: aVisitor [

	^ aVisitor 
		appendSubmenu: aMenu 
		label: aLabel 
		to: parentMenu
]
