"
A data store to be used in `GtkListViewAdapter`
"
Class {
	#name : #GtkListViewAdapterDataStore,
	#superclass : #GListDataStore,
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

	self error: 'Should not arrive here'
]

{ #category : #accessing }
GtkListViewAdapterDataStore >> presenter: aPresenter [

	presenter := aPresenter.
	self reset
]
