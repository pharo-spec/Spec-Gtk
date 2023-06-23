Extension { #name : #CmUIDisplayAsSubMenu }

{ #category : #'*Spec-Gtk' }
CmUIDisplayAsSubMenu >> appendGroup: aMenu label: aLabel to: parentMenu in: aVisitor [

	^ aVisitor 
		appendSection: aMenu 
		label: aLabel 
		to: parentMenu
]
