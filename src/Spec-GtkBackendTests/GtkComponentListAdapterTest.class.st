Class {
	#name : 'GtkComponentListAdapterTest',
	#superclass : 'GtkAdapterTestCase',
	#category : 'Spec-GtkBackendTests',
	#package : 'Spec-GtkBackendTests'
}

{ #category : 'running' }
GtkComponentListAdapterTest >> classToTest [
	^ SpComponentListPresenter
]

{ #category : 'running' }
GtkComponentListAdapterTest >> testAddingOnePresentersToAlreadyOpenedWidgetAddsOneRow [
	self openInstance.
	self assert: self adapter items size equals: 0.
	presenter
		addPresenter:
			(SpButtonPresenter new
				label: ' Test ';
				yourself).
	presenter
		addPresenter:
			(SpButtonPresenter new
				label: ' Test ';
				yourself).
	self assert: self adapter items size equals: 2
]

{ #category : 'running' }
GtkComponentListAdapterTest >> testAddingTwoPresentersToAlreadyOpenedWidgetAddsOneTwo [
	self openInstance.
	self assert: self adapter items size equals: 0.
	presenter
		addPresenter: (SpButtonPresenter new label: ' Test ' yourself).
	presenter
		addPresenter:
			(SpButtonPresenter new
				label: ' Test ';
				yourself).
	self assert: self adapter items size equals: 2
]

{ #category : 'running' }
GtkComponentListAdapterTest >> testOpeningAComponentListPresenterWithOnePresenterGeneratesAWidgetWithOneRow [
	presenter
		addPresenter:
			(SpButtonPresenter new
				label: ' Test ';
				yourself).
	self openInstance.
	self 
		assert: self adapter widget children size 
		equals: 1
]

{ #category : 'running' }
GtkComponentListAdapterTest >> testOpeningAComponentListPresenterWithTwoPresenterGeneratesAWidgetWithTwoRow [
	presenter
		addPresenter:
			(SpButtonPresenter new
				label: ' Test ';
				yourself);
		addPresenter:
			(SpLabelPresenter new
				label: 'Test2';
				yourself).
	self openInstance.
	self 
		assert: self adapter widget children size 
		equals: 2
]

{ #category : 'running' }
GtkComponentListAdapterTest >> testOpeningAnEmptyComponentListPresenterGeneratesAWidgetWithZeroRows [
	self openInstance.
	self assert: self adapter items isEmpty
]

{ #category : 'running' }
GtkComponentListAdapterTest >> testPresenterStartsWithNonePresenter [
	self assert: presenter presenters isEmpty
]
