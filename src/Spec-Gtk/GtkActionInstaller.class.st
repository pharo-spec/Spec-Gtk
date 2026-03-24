"
installs the actions into a presenter.

# Dynamic groups
In addition, this class will collect **dynamic groups** (which actions cannot be installed directly).  
This groups can be kept by the action manager to install them later (when menu is shown).
 
"
Class {
	#name : 'GtkActionInstaller',
	#superclass : 'GtkActionVisitor',
	#instVars : [
		'actionGroup',
		'actionMap',
		'dynamicGroups',
		'replaceGroup'
	],
	#category : 'Spec-Gtk-Actions',
	#package : 'Spec-Gtk',
	#tag : 'Actions'
}

{ #category : 'accessing' }
GtkActionInstaller >> actionGroup [

	^ actionGroup ifNil: [ actionGroup := GSimpleActionGroup new ]
]

{ #category : 'accessing' }
GtkActionInstaller >> actionGroup: anActionGroup [

	actionGroup := anActionGroup
]

{ #category : 'accessing' }
GtkActionInstaller >> actionMap [

	^ actionMap
]

{ #category : 'accessing' }
GtkActionInstaller >> beReplaceGroup [

	replaceGroup := true
]

{ #category : 'accessing' }
GtkActionInstaller >> dynamicGroups [

	^ dynamicGroups
]

{ #category : 'initialization' }
GtkActionInstaller >> initialize [ 

	replaceGroup := false.
	super initialize
]

{ #category : 'visiting' }
GtkActionInstaller >> visit: anObject [

	actionMap := Dictionary new.
	super visit: anObject.
	^ actionMap
]

{ #category : 'visiting' }
GtkActionInstaller >> visitCommand: aCommand [
	| action |
	
	action := aCommand hasState 
		ifTrue: [ GSimpleAction newNameStateful: aCommand id state: aCommand state ]
		ifFalse: [ GSimpleAction newName: aCommand id ].
	action connectActivate: [
		self runInSystem: [
			aCommand canBeExecuted ifTrue: [ 
				aCommand hasState ifTrue: [ 
					aCommand toggleState.
					GRunLoop defer: [ 
						action state: aCommand state ] ].
				[ aCommand execute ] fork ] ] ].

	actionMap at: aCommand put: action.
	self actionGroup insert: action
]

{ #category : 'visiting' }
GtkActionInstaller >> visitCommandDynamicGroup: aCommandGroup [

	dynamicGroups ifNil: [ dynamicGroups := OrderedCollection new ].
	dynamicGroups add: aCommandGroup
]

{ #category : 'visiting' }
GtkActionInstaller >> visitCommandGroup: aCommandGroup [
	| oldActionGroup |

	self pushPrefix: aCommandGroup.
	oldActionGroup := actionGroup.
	[	
		actionGroup := GSimpleActionGroup new.
		aCommandGroup entries do: [ :entry | entry acceptVisitor: self ].
		"if replaceGroup is true I want to replace any existing group. So I try first to remove it"
		replaceGroup ifTrue: [
			self widget removeActionGroupNamed: self prefix ].
		self widget 
			insertActionGroup: self prefix
			actions: self actionGroup ]
	ensure: [ 
		actionGroup := oldActionGroup.
		self popPrefix ]
]
