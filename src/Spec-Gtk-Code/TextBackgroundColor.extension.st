Extension { #name : 'TextBackgroundColor' }

{ #category : '*Spec-Gtk-Code' }
TextBackgroundColor >> acceptTag: aTag [

	aTag background: self color
]
