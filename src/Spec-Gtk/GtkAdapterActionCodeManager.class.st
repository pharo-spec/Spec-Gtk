Class {
	#name : 'GtkAdapterActionCodeManager',
	#superclass : 'GtkAdapterActionTextManager',
	#instVars : [
		'actions'
	],
	#category : 'Spec-Gtk-Actions',
	#package : 'Spec-Gtk',
	#tag : 'Actions'
}

{ #category : 'private' }
GtkAdapterActionCodeManager >> actions [

	^ actions ifNil: [ 
		actions := SpActionGroup new.
		self presenter isOverrideContextMenu ifFalse: [ 
			actions add: self presenter rootCommandsGroup beDisplayedAsGroup ].
		self presenter actions ifNotNil: [ :aGroup |
			actions add: aGroup beDisplayedAsGroup ].
		actions ]
]

{ #category : 'private - testing' }
GtkAdapterActionCodeManager >> anyCommandIsVisible [

	^ self presenter isOverrideContextMenu not 
		or: [ self presenter actions isNotNil ]
]
