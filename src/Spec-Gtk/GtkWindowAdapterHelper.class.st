"
A window adapter helper is here because windows in gtk can be of different classes. 
Most typical case is GtkWindow (simple gtk) and AdwWindow (adwaita).

In presence of adwaita package, we want to use it because it better integrated with the gnome system.
"
Class {
	#name : 'GtkWindowAdapterHelper',
	#superclass : 'Object',
	#instVars : [
		'owner'
	],
	#category : 'Spec-Gtk-Adapter-Window',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Window'
}

{ #category : 'testing' }
GtkWindowAdapterHelper class >> canBeUsed [

	^ false
]

{ #category : 'instance creation' }
GtkWindowAdapterHelper class >> new [

	self error: 'Use #on:'
]

{ #category : 'instance creation' }
GtkWindowAdapterHelper class >> on: anAdapter [

	
	^ self realHelperClass basicNew
		owner: anAdapter;
		initialize;
		yourself
]

{ #category : 'instance creation' }
GtkWindowAdapterHelper class >> realHelperClass [

	^ self withAllSubclasses
		detect: [ :each | each canBeUsed ]
		ifNone: [ self ]
]

{ #category : 'accessing' }
GtkWindowAdapterHelper >> add: aWidget toWindow: aWindow [

	aWindow child: aWidget
]

{ #category : 'accessing' }
GtkWindowAdapterHelper >> owner [

	^ owner
]

{ #category : 'initialization' }
GtkWindowAdapterHelper >> owner: anAdapter [

	owner := anAdapter
]

{ #category : 'accessing' }
GtkWindowAdapterHelper >> setDecorated: aBoolean to: gtkWindow [

	gtkWindow decorated: aBoolean
]

{ #category : 'accessing' }
GtkWindowAdapterHelper >> widgetClass [

	^ GtkWindow
]
