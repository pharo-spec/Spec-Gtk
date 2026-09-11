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

{ #category : 'accessing' }
GtkTreeListViewAdapterItemFactory >> unbind: listItem [
	"Releasing model of cell presenter on unbind because 
	 - it will not be show anymore, is wrong to think is already binded.
	 - models can have announcements related to the living row, and keeping them there can cause 
	   crashes (as the model send events to a potenatial inexistent row.
	 
	 This method is mirrored with GtkTreeColumnViewAdapterItemFactory>>unbind:
	 Any change here needs to be replicated there!"
	| expander cellPresenter |
	
	logger trace.
	
	expander := self presenterAtHandle: listItem child.
	"child will be a an expander as this is a single column tree, but I validate, just in case :P"
	expander class = GtkTreeExpander ifFalse: [ ^ self ].	
	
	cellPresenter := self presenterAtHandle: expander child getHandle.
	logger trace: cellPresenter.
	"I check for model as a guard, but all cells of listView components should understand it"
	(cellPresenter isNil or: [ (cellPresenter respondsTo: #model:) not])
		ifTrue: [ ^ self ].
	
	cellPresenter model: nil
]
