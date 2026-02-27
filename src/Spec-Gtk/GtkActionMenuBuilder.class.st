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

{ #category : 'private' }
GtkActionMenuBuilder >> appendCommand: aCommand withIcon: anIcon [
	| item icon |

	icon := anIcon asGIcon.
	item := GMenuItem 
		newLabel: aCommand dynamicName 
		action: (self actionNameFor: aCommand). 
	
	item label: aCommand dynamicName.
	item icon: icon.
	
	menu appendItem: item.
	
	item objectUnref
]

{ #category : 'visiting' }
GtkActionMenuBuilder >> appendSection: aMenu label: aName to: parentMenu [
	
	parentMenu 
		appendLabel: nil
		section: aMenu
]

{ #category : 'visiting' }
GtkActionMenuBuilder >> appendSubmenu: aMenu label: aName to: parentMenu [
	
	parentMenu 
		appendLabel: aName 
		submenu: aMenu
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
	menu := root.
	super visit: anObject.
	^ root
]

{ #category : 'visiting' }
GtkActionMenuBuilder >> visitCommand: aCommand [
	
	aCommand isVisible ifFalse: [ ^ self ].
	(self isFiltered: aCommand) ifTrue: [ ^ self ].
	
	"aCommand icon ifNotNil: [ :anIcon | 
		self appendCommand: aCommand withIcon: anIcon.		
		^ self ]."
	
	menu 
		appendLabel: aCommand dynamicName 
		actionName: (self actionNameFor: aCommand)
]

{ #category : 'visiting' }
GtkActionMenuBuilder >> visitCommandGroup: aCommandGroup [
	| oldMenu |
	
	oldMenu := menu.
	[ 
		menu := GMenu new.
		super visitCommandGroup: aCommandGroup.
 		aCommandGroup displayStrategy 
			appendGroup: menu 
			label: aCommandGroup name
			to: oldMenu
			in: self.
	]	
	ensure: [ 
		menu := oldMenu ]
]
