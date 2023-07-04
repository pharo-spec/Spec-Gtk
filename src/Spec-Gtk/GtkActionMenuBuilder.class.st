"
creates a `GMenu` from the defined actions and groups. 
"
Class {
	#name : #GtkActionMenuBuilder,
	#superclass : #GtkActionVisitor,
	#instVars : [
		'menu',
		'root'
	],
	#category : #'Spec-Gtk-Actions'
}

{ #category : #visiting }
GtkActionMenuBuilder >> appendSection: aMenu label: aName to: parentMenu [
	
	parentMenu 
		appendLabel: nil
		section: menu
]

{ #category : #visiting }
GtkActionMenuBuilder >> appendSubmenu: aMenu label: aName to: parentMenu [
	
	parentMenu 
		appendLabel: aName 
		submenu: menu
]

{ #category : #visiting }
GtkActionMenuBuilder >> visit: anObject [

	root := GMenu new.
	super visit: anObject.
	^ root
]

{ #category : #visiting }
GtkActionMenuBuilder >> visitCommand: aCommand [
	
	aCommand isVisible ifFalse: [ ^ self ].
	menu 
		appendLabel: aCommand name 
		actionName: (self actionNameFor: aCommand)
]

{ #category : #visiting }
GtkActionMenuBuilder >> visitCommandGroup: aCommandGroup [
	| oldMenu |
	
	oldMenu := menu.
	menu := menu 
		ifNotNil: [ GMenu new ]
		ifNil: [ root ].
	[ 
		super visitCommandGroup: aCommandGroup.
	  	oldMenu ifNotNil: [
			aCommandGroup displayStrategy 
				appendGroup: menu 
				label: aCommandGroup name
				to: oldMenu
				in: self ] 
	]	
	ensure: [ 
		menu := oldMenu ]
]
