Class {
	#name : 'GtkTreeListViewAdapterItemFactory',
	#superclass : 'GtkListViewAdapterItemFactory',
	#instVars : [
		'store'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'accessing' }
GtkTreeListViewAdapterItemFactory >> bind: listItem [
	| child expander row itemReference itemStore item |

	expander :=  self objectAtHandle: listItem child.
	
	row := GtkTreeListRow fromHandleUnreferenced: listItem item getHandle.
	expander listRow: row.
	child := self presenterAtHandle: expander child getHandle.
	child ifNil: [ ^ self ].
	
	itemReference := row item.
	itemStore := store storeAt: (itemReference dataAt: 'store').
	item := itemStore itemAtHandle: itemReference getHandle.
	itemReference objectUnref.

	presenter bindAction
		value: child 
		value: item
]

{ #category : 'accessing' }
GtkTreeListViewAdapterItemFactory >> bind: listItem to: anObject [
	
	self error: 'Should not arrive here'
]

{ #category : 'accessing' }
GtkTreeListViewAdapterItemFactory >> setup: listItem [
	| child expander |

	child := presenter setupAction cull: presenter.
	child build.

	self storePresenter: child.
	expander := GtkTreeExpander newWidget: child adapter widget.
	self storeObject: expander.

	listItem child: expander
]

{ #category : 'accessing' }
GtkTreeListViewAdapterItemFactory >> store: aRootStore [

	store := aRootStore.
	storedObjects removeAll
]
