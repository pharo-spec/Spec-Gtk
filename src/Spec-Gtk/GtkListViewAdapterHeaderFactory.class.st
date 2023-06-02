Class {
	#name : #GtkListViewAdapterHeaderFactory,
	#superclass : #GtkSignalListItemFactory,
	#instVars : [
		'presenter'
	],
	#category : #'Spec-Gtk-Adapter-ListView'
}

{ #category : #private }
GtkListViewAdapterHeaderFactory class >> gtkNew [ 

	self ffiCall: #(#GtkListViewAdapterHeaderFactory *gtk_signal_list_item_factory_new())
]

{ #category : #'instance creation' }
GtkListViewAdapterHeaderFactory class >> newPresenter: aPresenter [

	^ self new
		presenter: aPresenter;
		yourself
]

{ #category : #accessing }
GtkListViewAdapterHeaderFactory >> bind: listItem to: anObject [
	| child |

	child := self presenterAtHandle: listItem child.
	child label: anObject asString
]

{ #category : #private }
GtkListViewAdapterHeaderFactory >> itemClass [
	
	^ GtkListHeader
]

{ #category : #initialization }
GtkListViewAdapterHeaderFactory >> presenter: aPresenter [

	presenter := aPresenter
]

{ #category : #private }
GtkListViewAdapterHeaderFactory >> presenterAtHandle: anAddress [

	^ storedObjects at: anAddress
]

{ #category : #accessing }
GtkListViewAdapterHeaderFactory >> setup: listItem [
	| child |

	child := presenter newLabel.
	child build.

	self storePresenter: child.

	listItem child: child adapter widget
]

{ #category : #private }
GtkListViewAdapterHeaderFactory >> storePresenter: child [
	| widget |

	widget := child adapter widget.
	storedObjects 
		at: widget getHandle
		put: child.
	widget objectRef.
		
	^ child
]
