Class {
	#name : #SpLayoutLeaksTest,
	#superclass : #TestCase,
	#category : #'Spec-Gtk-TestLayoutLeaks'
}

{ #category : #tests }
SpLayoutLeaksTest >> testOpen [

	| win testPresenter oldAdapters | 
	win := SpLayoutLeaksTestPresenter openGtk.
	testPresenter := win presenter.
	oldAdapters := testPresenter adapters.
	testPresenter swapLayouts.
	3 timesRepeat: [ Smalltalk garbageCollect ].
	self assert: (oldAdapters allSatisfy: [ :e | e isNil ]).
	win close. 
]
