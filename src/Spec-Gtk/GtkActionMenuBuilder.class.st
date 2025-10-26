"
creates a `GMenu` from the defined actions and groups. 
"
Class {
	#name : 'GtkActionMenuBuilder',
	#superclass : 'GtkActionVisitor',
	#instVars : [
		'menu',
		'root',
		'filters'
	],
	#category : 'Spec-Gtk-Actions',
	#package : 'Spec-Gtk',
	#tag : 'Actions'
}

{ #category : 'private' }
GtkActionMenuBuilder >> allPrefixes [
	"| allPrefixes |

	allPrefixes := super allPrefixes.
	allPrefixes isEmptyOrNil ifTrue: [ ^ allPrefixes ].
	
	^ allPrefixes first 
		ifNotNil: [ allPrefixes allButFirst ]
		ifNil: [ allPrefixes ]"
	^ super allPrefixes
]

{ #category : 'visiting' }
GtkActionMenuBuilder >> appendSection: aMenu label: aName to: parentMenu [
	
	parentMenu 
		appendLabel: nil
		section: menu
]

{ #category : 'visiting' }
GtkActionMenuBuilder >> appendSubmenu: aMenu label: aName to: parentMenu [
	
	parentMenu 
		appendLabel: aName 
		submenu: menu
]

{ #category : 'accessing' }
GtkActionMenuBuilder >> filters: aCollection [

	filters := aCollection
]

{ #category : 'initialization' }
GtkActionMenuBuilder >> initialize [

	super initialize. 
	filters := #()
]

{ #category : 'private - testing' }
GtkActionMenuBuilder >> isFiltered: aCommand [

	^ filters includes: aCommand name
]

{ #category : 'accessing' }
GtkActionMenuBuilder >> root [

	^ root
]

{ #category : 'visiting' }
GtkActionMenuBuilder >> visit: anObject [

	root := GMenu new.
	super visit: anObject.
	^ root
]

{ #category : 'visiting' }
GtkActionMenuBuilder >> visitCommand: aCommand [
	
	aCommand isVisible ifFalse: [ ^ self ].
	(self isFiltered: aCommand) ifTrue: [ ^ self ].

	menu 
		appendLabel: aCommand dynamicName 
		actionName: (self actionNameFor: aCommand)
]

{ #category : 'visiting' }
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
