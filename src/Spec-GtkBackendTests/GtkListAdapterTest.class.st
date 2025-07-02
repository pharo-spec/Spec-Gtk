Class {
	#name : 'GtkListAdapterTest',
	#superclass : 'GtkAdapterTestCase',
	#category : 'Spec-GtkBackendTests',
	#package : 'Spec-GtkBackendTests'
}

{ #category : 'running' }
GtkListAdapterTest >> classToTest [

	^ SpListPresenter
]

{ #category : 'running' }
GtkListAdapterTest >> setUp [

	super setUp.

	presenter 
		items: Collection withAllSubclasses;
		display: [ :each | each name ].
		
]

{ #category : 'tests' }
GtkListAdapterTest >> testListWithNoIcons [

	self openInstance.
	self 
		assert: presenter adapter innerWidget model numberOfColumns
		equals: 1
]
