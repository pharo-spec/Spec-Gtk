Class {
	#name : 'GtkWindowAdapter',
	#superclass : 'GtkBaseWindowAdapter',
	#category : 'Spec-Gtk-Adapter-Window',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Window'
}

{ #category : 'private' }
GtkWindowAdapter class >> adapterClass [

	^ self allSubclasses 
		detect: [ :each | each canBeUsed ]
		ifNone: [ self ]
]

{ #category : 'private' }
GtkWindowAdapter class >> canBeUsed [

	^ false
]

{ #category : 'instance creation' }
GtkWindowAdapter class >> new [

	"Then, I can use variants (like Adwaita based windows)"
	^ self adapterClass
		basicNew
		initialize
]
