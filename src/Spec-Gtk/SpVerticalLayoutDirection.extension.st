Extension { #name : 'SpVerticalLayoutDirection' }

{ #category : '*Spec-Gtk' }
SpVerticalLayoutDirection >> applyDirectionConstraintsTo: aWidget constraints: constraints in: layout [

	^ layout 
		applyVerticalConstraintsTo: aWidget
		constraints: constraints
]
