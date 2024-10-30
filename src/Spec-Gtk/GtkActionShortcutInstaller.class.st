"
installs the shortcuts defined in the actions into a widget. 
"
Class {
	#name : 'GtkActionShortcutInstaller',
	#superclass : 'GtkActionVisitor',
	#category : 'Spec-Gtk-Actions',
	#package : 'Spec-Gtk',
	#tag : 'Actions'
}

{ #category : 'visiting' }
GtkActionShortcutInstaller >> visitCommand: aCommand [
	| shortcut |
	
	aCommand hasShortcutKey ifFalse: [ ^ self ].
	
	"I need to install an action for each key combination"
	aCommand shortcutKey withAllKeyCombinationsDo: [ :aKeyCombination |
		aKeyCombination isForPlatform ifTrue: [  
			shortcut := GtkShortcut 
				newKeyCombination: aKeyCombination 
				actionName: (self actionNameFor: aCommand).
			self widget addShortcut: shortcut ] ]
]
