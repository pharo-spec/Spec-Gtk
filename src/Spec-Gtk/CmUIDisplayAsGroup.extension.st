Extension { #name : #CmUIDisplayAsGroup }

{ #category : #'*Spec-Gtk' }
CmUIDisplayAsGroup >> appendGroup: aMenu label: aLabel to: parentMenu in: aVisitor [

	^ aVisitor 
		appendSection: aMenu 
		label: aLabel 
		to: parentMenu
]
