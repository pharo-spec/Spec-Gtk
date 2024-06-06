"
adapter to handle multiple selections (maps a presenter selection with a gtk selection) 
"
Class {
	#name : 'GtkAdapterMultiSelection',
	#superclass : 'GtkAdapterSelection',
	#instVars : [
		'oldIndexes'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'instance creation' }
GtkAdapterMultiSelection >> newModel: aModel [ 

	^ GtkMultiSelection newModel: aModel
]

{ #category : 'private - updating' }
GtkAdapterMultiSelection >> updateSelectionFromGtk [

	self adapter updateMultiSelectionFromGtk
]

{ #category : 'updating' }
GtkAdapterMultiSelection >> updateSelectionFromPresenter [
	
	oldIndexes := self adapter updateMultiSelectionFromPresenter: (oldIndexes ifNil: [ #() ])
]
