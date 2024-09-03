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
	
	shortcut := GtkShortcut 
		newKeyCombination: aCommand shortcutKey 
		actionName: (self actionNameFor: aCommand).
	self widget addShortcut: shortcut
]
