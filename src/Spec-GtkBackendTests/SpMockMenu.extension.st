Extension { #name : #SpMockMenu }

{ #category : #'*Spec-GtkBackendTests' }
SpMockMenu >> children [
	"hack for test. 
	 In populate-popup events (textview, entry) the callback will enter here 
	 as a prove I'm in the right callback. 
	 I answer empty to avoid after processing, but I'm already fine"
	
	self shown: true.
	
	^ #()
]

{ #category : #'*Spec-GtkBackendTests' }
SpMockMenu >> connectDestroy: aBlock [

	
]

{ #category : #'*Spec-GtkBackendTests' }
SpMockMenu >> popupAtPointer: event [

	self shown: true
]

{ #category : #'*Spec-GtkBackendTests' }
SpMockMenu >> showAll [
]
