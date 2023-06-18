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
	#category : #'Spec-Gtk-Adapter-ListView'
}

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
			oldMenu 
				appendLabel: aCommandGroup name 
				submenu: menu ] ]	
	ensure: [ 
		menu := oldMenu ]
]
