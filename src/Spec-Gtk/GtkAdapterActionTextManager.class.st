"
A manager for texts, they have some differences with the standar manager: 

- there is already a context menu, the actions we define add ""extras"" to it.
- the CR keybinding, if present, needs to be handled different (using the ""activate"" signal).
"
Class {
	#name : 'GtkAdapterActionTextManager',
	#superclass : 'GtkAdapterActionManager',
	#category : 'Spec-Gtk-Actions',
	#package : 'Spec-Gtk',
	#tag : 'Actions'
}

{ #category : 'private' }
GtkAdapterActionTextManager >> actions [

	^ self presenter actions
]

{ #category : 'accessing' }
GtkAdapterActionTextManager >> hasContextMenu [

	^ true
]

{ #category : 'private - actions' }
GtkAdapterActionTextManager >> installContextMenuOn: gtkWidget [

	hasContextMenu := true.	
	gtkWidget extraMenu: (GtkActionMenuBuilder new visit: self actions)
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
