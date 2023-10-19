Class {
	#name : 'GMenuCompound',
	#superclass : 'Object',
	#instVars : [
		'menu',
		'actionGroup',
		'menuItemActions'
	],
	#category : 'Spec-Gtk-Adapter-Menu',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Menu'
}

{ #category : 'instance creation' }
GMenuCompound class >> newMenu: aMenu [

	^ self new 
		menu: aMenu;
		yourself
]

{ #category : 'accessing' }
GMenuCompound >> actionGroup [

	^ actionGroup
]

{ #category : 'accessing' }
GMenuCompound >> addMenuItemAction: aMenuItemAction [

	actionGroup insert: aMenuItemAction action.
	menuItemActions add: aMenuItemAction
]

{ #category : 'initialization' }
GMenuCompound >> initialize [

	super initialize.
	menuItemActions := Set new
]

{ #category : 'accessing' }
GMenuCompound >> menu [

	^ menu
]

{ #category : 'initialization' }
GMenuCompound >> menu: anObject [

	menu := anObject
]

{ #category : 'accessing' }
GMenuCompound >> menuItemActions [

	^ menuItemActions
]
