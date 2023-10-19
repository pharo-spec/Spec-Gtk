Extension { #name : 'SpCodePresenter' }

{ #category : '*Spec-Gtk-Code' }
SpCodePresenter >> highlightSearchText: aBoolean [

	self withAdapterDo: [ :anAdapter | anAdapter highlightSearchText: aBoolean ]
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
SpCodePresenter >> searchText: aString [

	self withAdapterDo: [ :anAdapter | anAdapter searchText: aString ]
]
