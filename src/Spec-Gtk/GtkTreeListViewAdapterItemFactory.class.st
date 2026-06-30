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
	| child expander row item |

	expander :=  self objectAtHandle: listItem child.
	
	row := GtkTreeListRow fromHandleUnowned: listItem item getHandle.

	self ensureExpandSignalOn: listItem.

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

	logger trace.
	expandAction := aBlock
]

{ #category : 'private' }
GtkTreeListViewAdapterItemFactory >> ensureExpandSignalOn: listItem [
	"I am using this mechanism because on setup there is no list row yet, it will 
	 be created at a point between setup and bind. As I want to avoid multiple
	 registration of the signal, I mark the item on setup, then I realise on bind."
	| row |

	(listItem dataAt: 'first-setup') asInteger = 1 ifFalse: [ ^ self ].
	
	listItem dataAt: 'first-setup' put: ExternalAddress null.

	expandAction ifNotNil: [ 
		row := GtkTreeListRow fromHandleUnowned: listItem item getHandle.
		row isValidHandle ifTrue: [
			| callback |
			callback := self expandCallback.
			row 
				signal: 'notify::expanded' 
				connectAfter: callback ] ]
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
	| storeReference itemReference itemStore item |

	itemReference := row item.
	itemReference isNullOrNil ifTrue: [ ^ nil ].
	
	storeReference := itemReference dataAt: 'store'.
	itemStore := store storeAt: storeReference ifAbsent: [ nil ].
	itemStore ifNil: [ ^ nil ].
	
	item := itemStore itemAtHandle: itemReference getHandle.
	itemReference objectUnref.

	^ item
]

{ #category : 'private' }
GtkTreeListViewAdapterItemFactory >> rowExpanded: rowHandle [
	| row |
	
	expandAction ifNil: [ ^ self ].
	
	row := GtkTreeListRow fromHandleUnowned: rowHandle.
	
	(self itemFromRow: row) ifNotNil: [ :item |
		expandAction
			cull: item
			cull: row isExpanded ]
]

{ #category : 'accessing' }
GtkTreeListViewAdapterItemFactory >> setup: listItem [
	| child expander |

	child := presenter setupAction cull: presenter.
	child build.

	listItem dataAt: 'first-setup' put: (ExternalAddress fromAddress: 1).

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
