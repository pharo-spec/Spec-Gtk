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

	self flag: #TODO. "This may be bad? no idea, but it prevents crashes :P"
	^ items ifNil: [ 
		items := presenter items 
			ifNotNil: [ :aCollection | aCollection copy ]
			ifNil: [ #() ] ]
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

{ #category : #private }
GtkListViewAdapterDataStore >> reset [

	super reset.
	items := nil
]
