"
adapter to handle simple selections (maps a presenter selection with a gtk selection) 
"
Class {
	#name : 'GtkAdapterSingleSelection',
	#superclass : 'GtkAdapterSelection',
	#instVars : [
		'oldIndex'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'instance creation' }
GtkAdapterSingleSelection >> newModel: aModel [ 

	^ GtkSingleSelection new
		autoSelect: false;
		model: aModel;
		yourself
]

{ #category : 'private - updating' }
GtkAdapterSingleSelection >> updateSelectionFromGtk [

	self adapter updateSingleSelectionFromGtk
]

{ #category : 'updating' }
GtkAdapterSingleSelection >> updateSelectionFromPresenter [

	oldIndex := self adapter updateSingleSelectionFromPresenter: oldIndex
]
