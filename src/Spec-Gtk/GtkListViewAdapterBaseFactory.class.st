Class {
	#name : #GtkListViewAdapterBaseFactory,
	#superclass : #GtkSignalListItemFactory,
	#instVars : [
		'presenter'
	],
	#category : #'Spec-Gtk-Adapter-ListView'
}

{ #category : #'instance creation' }
GtkListViewAdapterBaseFactory class >> newPresenter: aPresenter [

	^ self new
		presenter: aPresenter;
		yourself
]

{ #category : #accessing }
GtkListViewAdapterBaseFactory >> bind: listItem to: anObject [

	self subclassResponsibility
]

{ #category : #finalization }
GtkListViewAdapterBaseFactory >> finalizedOnGtk [

	GRunLoop defer: [ 
		self freeStoredObjects ]
]

{ #category : #finalization }
GtkListViewAdapterBaseFactory >> freeStoredObjects [

	storedObjects keysDo: [ :key |
		GObject objectUnref: key ]
]

{ #category : #initialization }
GtkListViewAdapterBaseFactory >> presenter: aPresenter [

	presenter := aPresenter
]

{ #category : #private }
GtkListViewAdapterBaseFactory >> presenterAtHandle: anAddress [

	^ storedObjects at: anAddress
]

{ #category : #accessing }
GtkListViewAdapterBaseFactory >> setup: listItem [

	self subclassResponsibility
]

{ #category : #private }
GtkListViewAdapterBaseFactory >> storePresenter: aPresenter [
	| widget |

	widget := aPresenter adapter widget.
	storedObjects 
		at: widget getHandle
		put: aPresenter.
	widget objectRef.
		
	^ aPresenter
]
