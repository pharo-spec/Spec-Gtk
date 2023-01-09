Class {
	#name : #GMenuItemActionCompound,
	#superclass : #Object,
	#instVars : [
		'presenter',
		'menuItem',
		'action',
		'actionName'
	],
	#category : #'Spec-Gtk-Adapter-Menu'
}

{ #category : #'instance creation' }
GMenuItemActionCompound class >> newPresenter: aPresenter action: aName [

	^ self basicNew 
		initializePresenter: aPresenter action: aName;
		yourself
]

{ #category : #accessing }
GMenuItemActionCompound >> action [

	^ action
]

{ #category : #accessing }
GMenuItemActionCompound >> actionName [

	^ actionName
]

{ #category : #initialize }
GMenuItemActionCompound >> build [

	"menu item"
	menuItem := GMenuItem 
		newLabel: self presenter name
		action: actionName.

	self presenter icon 
		ifNotNil: [ :anIcon | menuItem icon: anIcon asGdkPixbuf ].
	
	self presenter whenNameChangedDo: [ self updateName ].
	self presenter whenIconChangedDo: [ self updateIcon ].
	
	"action"		
	action := GSimpleAction newName: actionName.
	self presenter action 
		ifNotNil: [ :aBlock | action connectActivate: aBlock ].
	action enabled: self presenter isEnabled value.
	
	"submenu?"
	self halt
]

{ #category : #initialize }
GMenuItemActionCompound >> initializePresenter: aPresenter action: aName [

	presenter := aPresenter.
	actionName := aName.

	self build
]

{ #category : #accessing }
GMenuItemActionCompound >> menuItem [

	^ menuItem
]

{ #category : #accessing }
GMenuItemActionCompound >> presenter [

	^ presenter
]

{ #category : #initialize }
GMenuItemActionCompound >> updateIcon [
	
	GRunLoop defer: [ 
		menuItem icon: self presenter icon asGdkPixbuf ]
]

{ #category : #initialize }
GMenuItemActionCompound >> updateName [
	
	GRunLoop defer: [ 
		menuItem label: (self presenter name localizedForPresenter: self presenter) ]
]
