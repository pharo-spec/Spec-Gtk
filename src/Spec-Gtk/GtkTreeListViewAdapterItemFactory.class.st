Class {
	#name : 'GtkTreeListViewAdapterItemFactory',
	#superclass : 'GtkListViewAdapterItemFactory',
	#instVars : [
		'store',
		'expandCallback',
		'expandAction'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'accessing' }
GtkTreeListViewAdapterItemFactory >> bind: listItem [
	| child expander row itemReference itemStore item |

	expander :=  self objectAtHandle: listItem child.
	
	row := GtkTreeListRow fromHandleUnowned: listItem item getHandle.
	expander listRow: row.
	
child := self presenterAtHandle: expander child getHandle.
	child ifNil: [ ^ self ].
	
	item := self itemFromRow: row.

	presenter bindAction
		value: child 
		value: item
]

{ #category : 'accessing' }
GtkTreeListViewAdapterItemFactory >> bind: listItem to: anObject [
	
	self error: 'Should not arrive here'
]

{ #category : 'signaling' }
GtkTreeListViewAdapterItemFactory >> connectNotifyExpand: aBlock [

	expandAction := aBlock
]

{ #category : 'private' }
GtkTreeListViewAdapterItemFactory >> expandCallback [

	^ expandCallback ifNil: [
		expandCallback := GCallback 
			signature: #(void (void *rowHandle, void *pspec, gpointer user_data))
			block: [ :rowHandle :pspec :user_data | 
				self rowExpanded: rowHandle ] ]
]

{ #category : 'private' }
GtkTreeListViewAdapterItemFactory >> itemFromRow: row [
	| itemReference itemStore item |

	itemReference := row item.
	itemStore := store storeAt: (itemReference dataAt: 'store').
	item := itemStore itemAtHandle: itemReference getHandle.
	itemReference objectUnref.
	^ item
]

{ #category : 'private' }
GtkTreeListViewAdapterItemFactory >> rowExpanded: rowHandle [
	| row |
	
	expandAction ifNil: [ ^ self ].
	
	row := GtkTreeListRow fromHandleUnowned: rowHandle.
	
	expandAction
		cull: (self itemFromRow: row)
		cull: row isExpanded
]

{ #category : 'accessing' }
GtkTreeListViewAdapterItemFactory >> setup: listItem [
	| child expander row |

	child := presenter setupAction cull: presenter.
	child build.

	"we hang from the expand just if there is an action defined. 
	 (even if usually yes, this is cleaner)"
	expandAction ifNotNil: [ 
		row := GtkTreeListRow fromHandleUnowned: listItem item getHandle.
		row isValidHandle ifTrue: [
			| callback |
			callback := self expandCallback.
			row 
				signal: 'notify::expanded' 
				connectAfter: callback
				data: callback thunk ] ].

	self storePresenter: child.
	expander := GtkTreeExpander newWidget: child adapter widget.
	self storeObject: expander.	

	listItem child: expander
]

{ #category : 'accessing' }
GtkTreeListViewAdapterItemFactory >> store [

	^ store
]

{ #category : 'accessing' }
GtkTreeListViewAdapterItemFactory >> store: aRootStore [

	store := aRootStore.
	storedObjects removeAll
]
