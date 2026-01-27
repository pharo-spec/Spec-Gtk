Class {
	#name : 'GtkColumnViewAdapterItemFactory',
	#superclass : 'GtkListViewAdapterBaseFactory',
	#instVars : [
		'column',
		'storeModel',
		'modelsAndPresenters'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'instance creation' }
GtkColumnViewAdapterItemFactory class >> newPresenter: aPresenter column: aColumn [

	^ self new 
		presenter: aPresenter;
		column: aColumn;
		yourself
]

{ #category : 'accessing' }
GtkColumnViewAdapterItemFactory >> bind: listItem to: anObject [
	| child |

	child := self presenterAtHandle: listItem child.
	child ifNil: [ ^ self ].
	
	storeModel ifTrue: [
		self storeModelPresenter: child model: anObject ].
	
	self column bindAction
		value: child 
		value: anObject.
		
	
]

{ #category : 'accessing' }
GtkColumnViewAdapterItemFactory >> column [

	^ column
]

{ #category : 'accessing' }
GtkColumnViewAdapterItemFactory >> column: aColumn [

	column := aColumn
]

{ #category : 'initialization' }
GtkColumnViewAdapterItemFactory >> initialize [

	super initialize.
	storeModel := false
]

{ #category : 'accessing' }
GtkColumnViewAdapterItemFactory >> presenterForModel: anObject [

	modelsAndPresenters ifNil: [ ^ nil ].
	
	^ modelsAndPresenters 
		at: anObject 
		ifAbsent: [ nil ]
]

{ #category : 'accessing' }
GtkColumnViewAdapterItemFactory >> setup: listItem [
	| child |

	child := self column setupAction cull: presenter.
	child build.

	self storePresenter: child.

	listItem child: child adapter widget
]

{ #category : 'accessing' }
GtkColumnViewAdapterItemFactory >> storeModel [

	storeModel := true
]

{ #category : 'private' }
GtkColumnViewAdapterItemFactory >> storeModelPresenter: aPresenter model: anObject [

	modelsAndPresenters ifNil: [ modelsAndPresenters := WeakValueDictionary new ].
	modelsAndPresenters 
		at: anObject 
		put: aPresenter
]
