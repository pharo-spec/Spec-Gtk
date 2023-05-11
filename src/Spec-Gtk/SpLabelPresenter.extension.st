Extension { #name : #SpLabelPresenter }

{ #category : #'*Spec-Gtk' }
SpLabelPresenter >> beNotWrap [

	self withAdapterPerformOrDefer:  [ :anAdapter | anAdapter beNotWrap ]
]

{ #category : #'*Spec-Gtk' }
SpLabelPresenter >> beWrap [

	self withAdapterPerformOrDefer:  [ :anAdapter | anAdapter beWrap ]
]

{ #category : #'*Spec-Gtk' }
SpLabelPresenter >> isWrap [

	self withAdapterDo: [ :anAdapter | ^ anAdapter isWrap ].
	
	^ false
]
