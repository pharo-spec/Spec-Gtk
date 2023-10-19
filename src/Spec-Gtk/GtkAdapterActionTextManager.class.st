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

{ #category : 'accessing' }
GtkAdapterActionTextManager >> hasContextMenu [

	^ true
]

{ #category : 'private - actions' }
GtkAdapterActionTextManager >> installContextMenuOn: gtkWidget [

	hasContextMenu := true.	
	gtkWidget extraMenu: (GtkActionMenuBuilder new visit: self presenter actionGroup)
]

{ #category : 'private - actions' }
GtkAdapterActionTextManager >> installShortcutsOn: gtkWidget [

	super installShortcutsOn: gtkWidget.
	self maybeInstallCROn: gtkWidget
]

{ #category : 'private - actions' }
GtkAdapterActionTextManager >> maybeInstallCROn: gtkEntry [
	| enter |

	"GtkEntry implements the activation signal, which means if we have a CR shortcut 
	 defined (Pharo can do this time to time), it will not work, because it will send 
	 the signal instead. To fix this (since spec does not implement activation signal 
	 for input fields), I detect if I have defined it and if that's the case, I install 
	 the shortcut as a signal"
	enter := KeyboardKey enter asKeyCombination.
	actionMap keysDo: [ :each | 
		(each hasShortcutKey and: [ each shortcutKey  = enter ])
			ifTrue: [ 
				gtkEntry connectActivate: [ each execute ] ] ]
]

{ #category : 'actions' }
GtkAdapterActionTextManager >> showContextMenu [

	self adapter innerWidgetDo: [ :w |
		w activateAction: 'menu.popup' ]
]
