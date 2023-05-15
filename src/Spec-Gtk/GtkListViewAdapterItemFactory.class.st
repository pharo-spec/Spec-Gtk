"
Item factory for to be used with `GtkListViewAdapter`
"
Class {
	#name : #GtkListViewAdapterItemFactory,
	#superclass : #GtkSignalListItemFactory,
	#instVars : [
		'presenter'
	],
	#category : #'Spec-Gtk-Adapter-ListView'
}

{ #category : #private }
GtkListViewAdapterItemFactory class >> gtkNew [ 

	self ffiCall: #(#GtkListViewAdapterItemFactory *gtk_signal_list_item_factory_new())
]

{ #category : #'instance creation' }
GtkListViewAdapterItemFactory class >> newPresenter: aPresenter [

	^ self new
		presenter: aPresenter;
		yourself
]

{ #category : #accessing }
GtkListViewAdapterItemFactory >> bind: listItem to: anObject [
	| child |

	child := self presenterAtHandle: listItem child.
	presenter bindAction
		value: child 
		value: anObject
]

{ #category : #initialization }
GtkListViewAdapterItemFactory >> presenter: aPresenter [

	presenter := aPresenter
]

{ #category : #private }
GtkListViewAdapterItemFactory >> presenterAtHandle: anAddress [

	^ storedObjects at: anAddress
]

{ #category : #accessing }
GtkListViewAdapterItemFactory >> setup: listItem [
	| child |

	child := presenter setupAction value.
	child owner: presenter.
	
	child build.
	self storePresenter: child.
	
	listItem child: child adapter widget
]

{ #category : #private }
GtkListViewAdapterItemFactory >> storePresenter: child [

	storedObjects 
		at: child adapter widget getHandle
		put: child.
		
	^ child
]
