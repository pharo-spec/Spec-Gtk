"
installs the actions into a presenter.
"
Class {
	#name : #GtkActionInstaller,
	#superclass : #GtkActionVisitor,
	#instVars : [
		'actionGroup',
		'actionMap'
	],
	#category : #'Spec-Gtk-Actions'
}

{ #category : #visiting }
GtkActionInstaller >> visit: anObject [

	actionMap := Dictionary new.
	super visit: anObject.
	^ actionMap
]

{ #category : #visiting }
GtkActionInstaller >> visitCommand: aCommand [
	| action |
	
	action := (GSimpleAction newName: aCommand id)
		connectActivate: [ aCommand execute ];
		yourself.	
	actionMap at: aCommand put: action.
	actionGroup insert: action
]

{ #category : #visiting }
GtkActionInstaller >> visitCommandGroup: aCommandGroup [

	self pushPrefix: aCommandGroup.
	[
		actionGroup := GSimpleActionGroup new.
		aCommandGroup entries do: [ :entry | entry acceptVisitor: self ].
		self widget 
			insertActionGroup: self prefix
			actions: actionGroup ]
	ensure: [ self popPrefix ]
]
