Class {
	#name : #GtkAdapterSelection,
	#superclass : #Object,
	#instVars : [
		'adapter'
	],
	#category : #'Spec-Gtk-Adapter-ListView'
}

{ #category : #'instance creation' }
GtkAdapterSelection class >> on: anAdapter [

	^ self new 
		adapter: anAdapter;
		yourself
]

{ #category : #accessing }
GtkAdapterSelection >> adapter [

	^ adapter
]

{ #category : #accessing }
GtkAdapterSelection >> adapter: anAdapter [

	adapter := anAdapter
]

{ #category : #'instance creation' }
GtkAdapterSelection >> newModel: aModel [ 

	self subclassResponsibility
]

{ #category : #accessing }
GtkAdapterSelection >> presenter [

	^ self adapter presenter
]

{ #category : #updating }
GtkAdapterSelection >> updateSelectionFromPresenter [

	self subclassResponsibility
]
