Extension { #name : 'SpLabelPresenter' }

{ #category : '*Spec-Gtk' }
SpLabelPresenter >> beJustifyCenter [

	self withAdapterPerformOrDefer:  [ :anAdapter | anAdapter beJustifyCenter ]
]

{ #category : '*Spec-Gtk' }
SpLabelPresenter >> beJustifyLeft [

	self withAdapterPerformOrDefer:  [ :anAdapter | anAdapter beJustifyLeft ]
]

{ #category : '*Spec-Gtk' }
SpLabelPresenter >> beJustifyRight [

	self withAdapterPerformOrDefer:  [ :anAdapter | anAdapter beJustifyRight ]
]

{ #category : '*Spec-Gtk' }
SpLabelPresenter >> beNotWrap [

	self withAdapterPerformOrDefer:  [ :anAdapter | anAdapter beNotWrap ]
]

{ #category : '*Spec-Gtk' }
SpLabelPresenter >> beWrap [

	self withAdapterPerformOrDefer:  [ :anAdapter | anAdapter beWrap ]
]

{ #category : '*Spec-Gtk' }
SpLabelPresenter >> isWrap [

	self withAdapterDo: [ :anAdapter | ^ anAdapter isWrap ].
	
	^ false
]

{ #category : '*Spec-Gtk' }
SpLabelPresenter >> useMarkup [

	self withAdapterPerformOrDefer:  [ :anAdapter | anAdapter useMarkup ]
]
