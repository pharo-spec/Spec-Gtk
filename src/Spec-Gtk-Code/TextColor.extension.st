Extension { #name : 'TextColor' }

{ #category : '*Spec-Gtk-Code' }
TextColor >> acceptTag: aTag [

	aTag foreground: self color
]
