Extension { #name : #TextFontReference }

{ #category : #'*Spec-Gtk-Code' }
TextFontReference >> acceptTag: aTag [
	aTag
		fontFamily: font familyName 
		size: font pointSize
		weight: font weightValue  
]
