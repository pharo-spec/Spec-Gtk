Class {
	#name : 'GtkListViewAdapterBaseFactory',
	#superclass : 'GtkPharoListItemFactory',
	#instVars : [
		'presenter',
		'items',
		'mutex'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'testing' }
GtkListViewAdapterBaseFactory class >> isAbstract [

	^ super isAbstract or: [ self = GtkListViewAdapterBaseFactory ]
]

{ #category : 'instance creation' }
GtkListViewAdapterBaseFactory class >> newPresenter: aPresenter [

	^ self new
		presenter: aPresenter;
		yourself
]

{ #category : 'accessing' }
GtkListViewAdapterBaseFactory >> bind: listItem [

	self 
		bind: listItem 
		to: (self itemAt: (listItem position + 1))
]

{ #category : 'accessing' }
GtkListViewAdapterBaseFactory >> bind: listItem to: aPosition [

	self subclassResponsibility
]

{ #category : 'finalization' }
GtkListViewAdapterBaseFactory >> finalize [

	self isValidHandle ifFalse: [ ^ self ].
	GRunLoop defer: [
		self freeStoredObjects.
		super finalize ]
]

{ #category : 'finalization' }
GtkListViewAdapterBaseFactory >> finalizedOnGtk [

	self freeStoredObjects.	
	super finalizedOnGtk
]

{ #category : 'finalization' }
GtkListViewAdapterBaseFactory >> freeStoredObjects [

	mutex critical: [ 
		storedObjects 
			"keysDo: [ :key | 
				('freeing: ', key printString) crTrace.
				GObject objectUnref: key ];"
			removeAll ]
]

{ #category : 'private' }
GtkListViewAdapterBaseFactory >> getItems [

	^ self presenter items
]

{ #category : 'initialization' }
GtkListViewAdapterBaseFactory >> initialize [

	super initialize.
	mutex := Mutex new
]

{ #category : 'private' }
GtkListViewAdapterBaseFactory >> itemAt: aPosition [ 

	self items size < aPosition ifTrue: [ ^ nil ].
	^ self items at: aPosition
]

{ #category : 'accessing' }
GtkListViewAdapterBaseFactory >> items [

	^ items ifNil: [ items := self getItems  ]
]

{ #category : 'accessing' }
GtkListViewAdapterBaseFactory >> items: aCollection [

	items := aCollection
]

{ #category : 'accessing' }
GtkListViewAdapterBaseFactory >> presenter [

	^ presenter
]

{ #category : 'accessing' }
GtkListViewAdapterBaseFactory >> presenter: aPresenter [

	presenter := aPresenter
]

{ #category : 'private' }
GtkListViewAdapterBaseFactory >> presenterAtHandle: anAddress [

	^ storedObjects at: anAddress ifAbsent: [ nil ]
]

{ #category : 'private' }
GtkListViewAdapterBaseFactory >> removeStoredPresenterAtHandle: aHandle [

	mutex critical: [ 
		"GObject objectUnref: aHandle."
		storedObjects removeKey: aHandle ifAbsent: [ ] ]
]

{ #category : 'accessing' }
GtkListViewAdapterBaseFactory >> reset [

	super reset.
	items := nil
]

{ #category : 'private' }
GtkListViewAdapterBaseFactory >> storePresenter: aPresenter [
	| widget |

	mutex critical: [  
		widget := aPresenter adapter widget.
		storedObjects 
			at: widget getHandle
			put: aPresenter.
		"widget objectRef" ].
		
	^ aPresenter
]

{ #category : 'accessing' }
GtkListViewAdapterBaseFactory >> teardown: item [

	"no idea what to do here"
]

{ #category : 'accessing' }
GtkListViewAdapterBaseFactory >> unbind: listItem [
	| childHandle |

	childHandle := listItem child.
	self removeStoredPresenterAtHandle: childHandle
]
