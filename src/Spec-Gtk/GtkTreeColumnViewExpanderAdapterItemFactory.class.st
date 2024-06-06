Class {
	#name : 'GtkTreeColumnViewExpanderAdapterItemFactory',
	#superclass : 'GtkTreeColumnViewAdapterItemFactory',
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'accessing' }
GtkTreeColumnViewExpanderAdapterItemFactory >> bind: listItem [
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

	self column bindAction
		value: child 
		value: item
]

{ #category : 'accessing' }
GtkTreeColumnViewExpanderAdapterItemFactory >> setup: listItem [
	| child expander |

	child := self column setupAction cull: presenter.
	child build.

	self storePresenter: child.
	expander := GtkTreeExpander newWidget: child adapter widget.
	self storeObject: expander.

	listItem child: expander
]
