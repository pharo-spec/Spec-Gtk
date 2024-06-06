"
A data store to be used in `GtkListViewAdapter`
"
Class {
	#name : 'GtkTreeListViewAdapterDataStore',
	#superclass : 'GTreeListReferenceStore',
	#instVars : [
		'presenter'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'instance creation' }
GtkTreeListViewAdapterDataStore class >> newPresenter: aPresenter [ 

	^ self new
		presenter: aPresenter;
		yourself
]

{ #category : 'accessing' }
GtkTreeListViewAdapterDataStore >> items [

	^ items ifNil: [ 
		items := self presenter items 
			ifNotNil: [ :aCollection | aCollection copy ]
			ifNil: [ #() ] ]
]

{ #category : 'accessing' }
GtkTreeListViewAdapterDataStore >> items: aCollection [

	items := aCollection
]

{ #category : 'accessing' }
GtkTreeListViewAdapterDataStore >> presenter [

	^ presenter
]

{ #category : 'accessing' }
GtkTreeListViewAdapterDataStore >> presenter: aPresenter [

	presenter := aPresenter.
	self reset
]

{ #category : 'private' }
GtkTreeListViewAdapterDataStore >> pushStore: aStore [

	^ (super pushStore: aStore)
		presenter: self presenter;
		yourself
]
