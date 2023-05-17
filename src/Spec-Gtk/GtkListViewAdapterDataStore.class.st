"
A data store to be used in `GtkListViewAdapter`
"
Class {
	#name : #GtkListViewAdapterDataStore,
	#superclass : #GListReferenceStore,
	#instVars : [
		'presenter'
	],
	#category : #'Spec-Gtk-Adapter-ListView'
}

{ #category : #'instance creation' }
GtkListViewAdapterDataStore class >> newPresenter: aPresenter [ 

	^ self new
		presenter: aPresenter;
		yourself
]

{ #category : #accessing }
GtkListViewAdapterDataStore >> items [

	^ presenter items
]

{ #category : #accessing }
GtkListViewAdapterDataStore >> items: aCollection [

	self reset
]

{ #category : #accessing }
GtkListViewAdapterDataStore >> presenter: aPresenter [

	presenter := aPresenter.
	self reset
]
