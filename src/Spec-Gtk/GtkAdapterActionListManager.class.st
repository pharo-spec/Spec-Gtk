"
A manager for lists, they have some differences with the standar manager: 

- there is already a context menu, the actions we define add ""extras"" to it
"
Class {
	#name : #GtkAdapterActionListManager,
	#superclass : #GtkAdapterActionManager,
	#category : #'Spec-Gtk-Actions'
}

{ #category : #'private - actions' }
GtkAdapterActionListManager >> installContextMenuOn: gtkEntry [
	
	(actionMap keys noneSatisfy: [ :each | each isVisible ]) 
		ifTrue: [ ^ self ].

	gtkEntry extraMenu: (GtkActionMenuBuilder new visit: self presenter actionGroup)
]

{ #category : #actions }
GtkAdapterActionListManager >> showContextMenu [

	self adapter innerWidgetDo: [ :w | 
		w activateAction: 'popup.menu' ]
]
