"
A manager for texts, they have some differences with the standar manager: 

- there is already a context menu, the actions we define add ""extras"" to it.
- the CR keybinding, if present, needs to be handled different (using the ""activate"" signal).
"
Class {
	#name : 'GtkAdapterActionTextManager',
	#superclass : 'GtkAdapterActionManager',
	#instVars : [
		'filters'
	],
	#category : 'Spec-Gtk-Actions',
	#package : 'Spec-Gtk',
	#tag : 'Actions'
}

{ #category : 'private' }
GtkAdapterActionTextManager >> actions [

	^ self presenter actions
]

{ #category : 'accessing' }
GtkAdapterActionTextManager >> filters [

	^  filters ifNil: [ #() ]
]

{ #category : 'accessing' }
GtkAdapterActionTextManager >> filters: aCollection [

	filters := aCollection
]

{ #category : 'accessing' }
GtkAdapterActionTextManager >> hasContextMenu [

	^ true
]

{ #category : 'private - actions' }
GtkAdapterActionTextManager >> installActionGroupShortcuts: anActionGroup on: gtkWidget [ 

	GtkActionShortcutInstaller new
		widget: gtkWidget;
		filters: self filters;
		visit: anActionGroup
]

{ #category : 'private - actions' }
GtkAdapterActionTextManager >> installContextMenuOn: gtkWidget [

	hasContextMenu := true.	
	gtkWidget extraMenu: (GtkActionMenuBuilder new 
		filters: self filters;
		visit: self actions)
]

{ #category : 'actions' }
GtkAdapterActionTextManager >> installGroupsOn: gtkWidget [
		
	self presenter internalActions ifNotNil: [ :actionGroup |
		self installGroup: actionGroup on: gtkWidget ].
	self actions ifNotNil: [ :actionGroup |
		self installGroup: actionGroup on: gtkWidget ]
]

{ #category : 'actions' }
GtkAdapterActionTextManager >> showContextMenu [

	self adapter innerWidgetDo: [ :w |
		w activateAction: 'menu.popup' ]
]
