Class {
	#name : #SpLayoutLeaksTestFromSelection,
	#superclass : #TestCase,
	#category : #'Spec-Gtk-TestLayoutLeaks'
}

{ #category : #tests }
SpLayoutLeaksTestFromSelection >> testOpen [

	| win testPresenter oldAdapters finder | 
	finder := GtkLeakFinder new.
	finder start.
	win := SpLayoutLeaksTestPresenterFromSelection openGtk.
	testPresenter := win presenter.
	oldAdapters := testPresenter adapters.
	testPresenter swapLayouts.
	30 timesRepeat: [ Smalltalk garbageCollect ].
	self assert: (oldAdapters allSatisfy: [ :e | e isNil ]).
	"ReferenceFinder findPathTo: oldAdapters last."
	win close. 
	finder stop.
	self assert: finder leaks isEmpty.
]
