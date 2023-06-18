"
installs the actions into a presenter.
"
Class {
	#name : #GtkActionInstaller,
	#superclass : #GtkActionVisitor,
	#instVars : [
		'actionGroup'
	],
	#category : #'Spec-Gtk-Adapter-ListView'
}

{ #category : #visiting }
GtkActionInstaller >> visit: anObject [

	actionGroup := GSimpleActionGroup new.
	super visit: anObject.
   
	('installing group: ', self prefix) crTrace.
	self widget 
		insertActionGroup: self prefix 
		actions: actionGroup.
	^ actionGroup
]

{ #category : #visiting }
GtkActionInstaller >> visitCommand: aCommand [
	
	aCommand isVisible ifFalse: [ ^ self ].
	actionGroup insert: ((GSimpleAction newName: aCommand id)
		connectActivate: [ aCommand execute ];
		yourself)
]
