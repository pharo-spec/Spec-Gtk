Extension { #name : #SpFixedProgressBarState }

{ #category : #'*Spec-Gtk' }
SpFixedProgressBarState >> applyTo: anAdapter [

	^ anAdapter fixedValue: self value
]
