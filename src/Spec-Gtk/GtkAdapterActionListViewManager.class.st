Class {
	#name : 'GtkAdapterActionListViewManager',
	#superclass : 'GtkAdapterActionManager',
	#category : 'Spec-Gtk-Actions',
	#package : 'Spec-Gtk',
	#tag : 'Actions'
}

{ #category : 'private - actions' }
GtkAdapterActionListViewManager >> installActionGroupShortcuts: anActionGroup on: gtkWidget [

	super installActionGroupShortcuts: anActionGroup on: gtkWidget.
	self maybeInstallSpaceOn: gtkWidget
]

{ #category : 'private - actions' }
GtkAdapterActionListViewManager >> maybeInstallSpaceOn: gtkListView [
	| space |

	"As a GtkListView has already defined the space, I need to fake its usage"
	space := KeyboardKey space asKeyCombination.
	actionMap keysDo: [ :each | 
		(each hasShortcutKey 
			and: [ each shortcutKey = space ])
			ifTrue: [ 
				gtkListView addKeyPressEvent: [ :event |
					(event keyCharacter = Character space) 
						ifTrue: [ self runInSystem: [ each execute ] ].
					"take event as not handled so processing can continue"
					false ] ] ]
]
