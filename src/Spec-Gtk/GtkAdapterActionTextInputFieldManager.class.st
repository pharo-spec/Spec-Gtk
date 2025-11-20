Class {
	#name : 'GtkAdapterActionTextInputFieldManager',
	#superclass : 'GtkAdapterActionTextManager',
	#instVars : [
		'actions'
	],
	#category : 'Spec-Gtk-Actions',
	#package : 'Spec-Gtk',
	#tag : 'Actions'
}

{ #category : 'private - actions' }
GtkAdapterActionTextInputFieldManager >> installActionGroupShortcuts: anActionGroup on: gtkWidget [

	super installActionGroupShortcuts: anActionGroup on: gtkWidget.
	self maybeInstallCROn: gtkWidget
]

{ #category : 'private - actions' }
GtkAdapterActionTextInputFieldManager >> maybeInstallCROn: gtkEntry [
	| enter |

	"GtkEntry implements the activation signal, which means if we have a CR shortcut 
	 defined (Pharo can do this time to time), it will not work, because it will send 
	 the signal instead. To fix this (since spec does not implement activation signal 
	 for input fields), I detect if I have defined it and if that's the case, I install 
	 the shortcut as a signal"
	enter := KeyboardKey enter asKeyCombination.
	actionMap keysDo: [ :each | 
		(each hasShortcutKey 
			and: [ each shortcutKey = enter 
			"2025-11-17: for some reason there are extra registrations of the activation on certain 
			 cases and this is not good. I suspect I am registering several times the same because 
			 of some weird logic. For now I just filter it (but obviously, this will explode in my 
			 face later... :( )"
			and: [ gtkEntry callbacks noneSatisfy: [ :each | each signalName = 'activate' ] ] ])
			ifTrue: [ 
				gtkEntry connectActivate: [
					self runInSystem: [ each execute ] ] ] ]
]
