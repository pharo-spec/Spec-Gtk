Extension { #name : 'SpHorizontalLayoutDirection' }

{ #category : '*Spec-Gtk' }
SpHorizontalLayoutDirection >> applyDirectionConstraintsTo: aWidget constraints: constraints in: layout [

	^ layout 
		applyHorizontalConstraintsTo: aWidget
		constraints: constraints
]
