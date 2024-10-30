Class {
	#name : 'GtkTreeColumnViewAdapterItemFactory',
	#superclass : 'GtkColumnViewAdapterItemFactory',
	#instVars : [
		'store'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'accessing' }
GtkTreeColumnViewAdapterItemFactory >> bind: listItem [
	| child row itemReference itemStore item |

	row := GtkTreeListRow fromHandleUnreferenced: listItem item getHandle.
	child := self presenterAtHandle: listItem child getHandle.
	child ifNil: [ ^ self ].
	
	itemReference := row item.
	itemStore := store storeAt: (itemReference dataAt: 'store').
	item := itemStore itemAtHandle: itemReference getHandle.
	itemReference objectUnref.

	self column bindAction
		value: child 
		value: item
]

{ #category : 'accessing' }
GtkTreeColumnViewAdapterItemFactory >> bind: listItem to: anObject [
	
	self error: 'Should not arrive here'
]

{ #category : 'accessing' }
GtkTreeColumnViewAdapterItemFactory >> setup: listItem [
	| child |

	child := self column setupAction cull: presenter.
	child build.

	self storePresenter: child.
	listItem child: child adapter widget
]

{ #category : 'accessing' }
GtkTreeColumnViewAdapterItemFactory >> store: aRootStore [

	store := aRootStore.
	storedObjects removeAll
]
