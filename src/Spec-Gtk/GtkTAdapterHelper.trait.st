"
This is a base to be used when an adapter requires to use a strategy to delegate behavior.
This is very useful if we want, for example, to use a `GtkWindow` or an `AdwWindow`, etc.

"
Trait {
	#name : 'GtkTAdapterHelper',
	#instVars : [
		'owner'
	],
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'testing' }
GtkTAdapterHelper classSide >> canBeUsed [

	^ false
]

{ #category : 'instance creation' }
GtkTAdapterHelper classSide >> new [

	self error: 'Use #on:'
]

{ #category : 'instance creation' }
GtkTAdapterHelper classSide >> on: anAdapter [

	
	^ self realHelperClass basicNew
		owner: anAdapter;
		initialize;
		yourself
]

{ #category : 'private' }
GtkTAdapterHelper classSide >> realHelperClass [

	^ self withAllSubclasses
		detect: [ :each | each canBeUsed ]
		ifNone: [ self ]
]

{ #category : 'accessing' }
GtkTAdapterHelper >> owner [

	^ owner
]

{ #category : 'accessing' }
GtkTAdapterHelper >> owner: anAdapter [

	owner := anAdapter
]
