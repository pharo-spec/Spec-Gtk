"
installs the shortcuts defined in the actions into a widget. 
"
Class {
	#name : 'GtkActionShortcutInstaller',
	#superclass : 'GtkActionVisitor',
	#instVars : [
		'filters'
	],
	#category : 'Spec-Gtk-Actions',
	#package : 'Spec-Gtk',
	#tag : 'Actions'
}

{ #category : 'accessing' }
GtkActionShortcutInstaller >> filters: aCollection [

	filters := aCollection
]

{ #category : 'initialization' }
GtkActionShortcutInstaller >> initialize [

	super initialize.
	filters := #()
]

{ #category : 'private - testing' }
GtkActionShortcutInstaller >> isFiltered: aCommand [

	^ filters includes: aCommand name
]

{ #category : 'visiting' }
GtkActionShortcutInstaller >> visitCommand: aCommand [
	| shortcut |
	
	aCommand hasShortcutKey ifFalse: [ ^ self ].
	(self isFiltered: aCommand) ifTrue: [ ^ self ].
	
	"I need to install an action for each key combination"
	aCommand shortcutKey withAllKeyCombinationsDo: [ :aKeyCombination |
		aKeyCombination isForPlatform ifTrue: [  
			shortcut := GtkShortcut 
				newKeyCombination: aKeyCombination 
				actionName: (self actionNameFor: aCommand).
			self widget addShortcut: shortcut ] ]
]
