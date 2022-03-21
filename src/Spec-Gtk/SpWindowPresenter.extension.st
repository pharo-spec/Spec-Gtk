Extension { #name : #SpWindowPresenter }

{ #category : #'*Spec-Gtk' }
SpWindowPresenter >> inform: aString [

	self withAdapterDo: [ :anAdapter | 
		anAdapter notifyInfo: aString ]
]

{ #category : #'*Spec-Gtk' }
SpWindowPresenter >> informError: aString [

	self withAdapterDo: [ :anAdapter | 
		anAdapter notifyError: aString ]
]
