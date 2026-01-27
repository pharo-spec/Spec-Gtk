Extension { #name : 'SpCodePresenter' }

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> caseSensitive: aBoolean [

	self withAdapterDo: [ :anAdapter | anAdapter caseSensitive: aBoolean ]
]

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> endSearch [

	self withAdapterDo: [ :anAdapter | anAdapter endSearch ]
]

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> highlightSearchText: aBoolean [

	self withAdapterDo: [ :anAdapter | anAdapter highlightSearchText: aBoolean ]
]

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> isCaseSensitive [

	self withAdapterDo: [ :anAdapter | ^ anAdapter isCaseSensitive ].
	
	^ false
]

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> isRegex [

	self withAdapterDo: [ :anAdapter | ^ anAdapter isRegex ].
	
	^ false
]

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> isWholeWord [

	self withAdapterDo: [ :anAdapter | ^ anAdapter isWholeWord ].
	
	^ false
]

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> regex: aBoolean [

	self withAdapterDo: [ :anAdapter | anAdapter regex: aBoolean ]
]

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> replaceAllMatchesWith: aString [

	self withAdapterDo: [ :anAdapter | anAdapter replaceAllMatchesWith: aString ]
]

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> replaceSelectionWith: aString [

	self withAdapterDo: [ :anAdapter | anAdapter replaceSelectionWith: aString ]
]

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> searchBackward [

	self withAdapterDo: [ :anAdapter | anAdapter searchBackward ]
]

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> searchForward [

	self withAdapterDo: [ :anAdapter | anAdapter searchForward ]
]

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> searchOccurrencesCount [

	self withAdapterDo: [ :anAdapter | 
		^ anAdapter searchOccurrencesCount ].
	
	^ 0
]

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> searchText: aString [

	self withAdapterDo: [ :anAdapter | anAdapter searchText: aString ]
]

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> wholeWord: aBoolean [

	self withAdapterDo: [ :anAdapter | anAdapter wholeWord: aBoolean ]
]
