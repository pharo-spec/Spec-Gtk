"
installs the shortcuts defined in the actions into a widget. 
"
Class {
	#name : #GtkActionShortcutInstaller,
	#superclass : #GtkActionVisitor,
	#category : #'Spec-Gtk-Adapter-ListView'
}

{ #category : #visiting }
GtkActionShortcutInstaller >> visitCommand: aCommand [
	
	aCommand hasShortcutKey ifFalse: [ ^ self ].
	self widget addShortcut: (GtkShortcut 
		newKeyCombination: aCommand shortcutKey 
		actionName: (self actionNameFor: aCommand))
]
