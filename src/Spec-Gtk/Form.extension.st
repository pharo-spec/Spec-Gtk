Extension { #name : 'Form' }

{ #category : '*Spec-Gtk' }
Form >> asGdkPaintableOnApplication: anApplication [
	"Return a cached GdkPaintable for this form, storing it in the application properties."
	
	^ GdkMemoryTexture fromForm: self inApplication: anApplication
]
