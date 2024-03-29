Class {
	#name : #SpLayoutLeaksTest,
	#superclass : #TestCase,
	#category : #'Spec-Gtk-TestLayoutLeaks'
}

{ #category : #tests }
SpLayoutLeaksTest >> testOpen [

	| win testPresenter oldAdapters finder | 
	finder := GtkLeakFinder new.
	finder start.
	win := SpLayoutLeaksTestPresenter openGtk.
	testPresenter := win presenter.
	oldAdapters := testPresenter adapters.
	testPresenter swapLayouts.
	30 timesRepeat: [ Smalltalk garbageCollect ].
	self assert: (oldAdapters allSatisfy: [ :e | e isNil ]).
	win close. 
	finder stop.
	self assert: finder leaks isEmpty.
]
