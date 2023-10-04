"
A base visitor for actions, to use to install them as actions, shortcuts or menus 
"
Class {
	#name : #GtkActionVisitor,
	#superclass : #CmVisitor,
	#instVars : [
		'widget',
		'prefixes'
	],
	#category : #'Spec-Gtk-Actions'
}

{ #category : #'instance creation' }
GtkActionVisitor class >> newWidget: aGtkWidget [

	^ self new 
		widget: aGtkWidget;
		yourself
]

{ #category : #private }
GtkActionVisitor >> actionNameFor: aCommand [

	^ '{1}.{2}' format: { self prefix. aCommand id }
]

{ #category : #initialization }
GtkActionVisitor >> initialize [

	super initialize.
	prefixes := OrderedCollection new
]

{ #category : #private }
GtkActionVisitor >> popPrefix [

	prefixes removeLast
]

{ #category : #private }
GtkActionVisitor >> prefix [

	^ String streamContents: [ :stream | 
		prefixes asStringOn: stream delimiter: '-' ]
]

{ #category : #private }
GtkActionVisitor >> pushPrefix: aCommandGroup [

	prefixes add: (aCommandGroup isRoot
		ifTrue: [ 'action' ]
		ifFalse: [ aCommandGroup id ])
]

{ #category : #visiting }
GtkActionVisitor >> visitCommandGroup: aCommandGroup [

	self pushPrefix: aCommandGroup.
	[ super visitCommandGroup: aCommandGroup ]
	ensure: [ self popPrefix ]
]

{ #category : #accessing }
GtkActionVisitor >> widget [

	^ widget
]

{ #category : #accessing }
GtkActionVisitor >> widget: aGtkWidget [

	widget := aGtkWidget
]
