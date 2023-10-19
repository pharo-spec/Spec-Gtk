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
	
	aCommand hasShortcutKey ifFalse: [ ^ self ].
	self widget addShortcut: (GtkShortcut 
		newKeyCombination: aCommand shortcutKey 
		actionName: (self actionNameFor: aCommand))
]
