Extension { #name : 'Form' }

{ #category : '*Spec-Gtk' }
Form >> asGdkPaintableOnApplication: anApplication [
	"Return a cached GdkPaintable for this form, storing it in the application properties."
	| cache paintable size |
	
	cache := anApplication 
		propertyAt: #gtkPaintablesByForm 
		ifAbsentPut: [ IdentityDictionary new ].

	^ cache 
		at: self 
		ifAbsentPut: [
			paintable := self asGdkPaintable.
			size := self width @ self height.
			paintable computeConcreteSize: size defaults: size.
			paintable ]
]
