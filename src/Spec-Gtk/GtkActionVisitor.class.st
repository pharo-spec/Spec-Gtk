"
A base visitor for actions, to use to install them as actions, shortcuts or menus 
"
Class {
	#name : #GtkActionVisitor,
	#superclass : #CmVisitor,
	#instVars : [
		'widget',
		'prefix'
	],
	#category : #'Spec-Gtk-Adapter-ListView'
}

{ #category : #private }
GtkActionVisitor >> actionNameFor: aCommand [

	^ '{1}.{2}' format: { self prefix. aCommand id }
]

{ #category : #accessing }
GtkActionVisitor >> prefix [

	^ prefix ifNil: [ 'action' ]
]

{ #category : #accessing }
GtkActionVisitor >> prefix: aString [

	prefix := aString
]

{ #category : #accessing }
GtkActionVisitor >> widget [

	^ widget
]

{ #category : #accessing }
GtkActionVisitor >> widget: aGtkWidget [

	widget := aGtkWidget
]
