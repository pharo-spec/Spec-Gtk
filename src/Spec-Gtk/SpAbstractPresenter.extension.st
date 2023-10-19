Extension { #name : 'SpAbstractPresenter' }

{ #category : '*Spec-Gtk' }
SpAbstractPresenter >> openModalWithParent: aParent [

	^ self asModalWindow 
		owner: aParent;
		open
]
