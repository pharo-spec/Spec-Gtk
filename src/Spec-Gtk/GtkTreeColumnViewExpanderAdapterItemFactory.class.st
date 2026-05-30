Class {
	#name : 'GtkTreeColumnViewExpanderAdapterItemFactory',
	#superclass : 'GtkTreeColumnViewAdapterItemFactory',
	#instVars : [
		'expandCallback',
		'expandAction'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'accessing' }
GtkTreeColumnViewExpanderAdapterItemFactory >> bind: listItem [
	| child expander row itemReference itemStore item |

	expander :=  self objectAtHandle: listItem child.
	
	row := GtkTreeListRow fromHandleUnowned: listItem item getHandle.
	expander listRow: row.
	child := self presenterAtHandle: expander child getHandle.
	child ifNil: [ ^ self ].
	
	itemReference := row item.
	itemStore := store storeAt: (itemReference dataAt: 'store').
	item := itemStore itemAtHandle: itemReference getHandle.
	itemReference objectUnref.
	storeModel ifTrue: [
		self storeModelPresenter: child model: item ].

	self column bindAction
		value: child 
		value: item
]

{ #category : 'accessing' }
GtkTreeColumnViewExpanderAdapterItemFactory >> connectNotifyExpand: aBlock [

	expandAction := aBlock
]

{ #category : 'private' }
GtkTreeColumnViewExpanderAdapterItemFactory >> expandCallback [

	^ expandCallback ifNil: [
			  expandCallback := GCallback
				                    signature: #( void #( void #* rowHandle #, void #* pspec #, gpointer user_data ) )
				                    block: [ :rowHandle :pspec :user_data | self rowExpanded: rowHandle ] ]
]

{ #category : 'private' }
GtkTreeColumnViewExpanderAdapterItemFactory >> itemFromRow: row [

	| itemReference itemStore item |
	itemReference := row item.
	itemStore := store storeAt: (itemReference dataAt: 'store').
	item := itemStore itemAtHandle: itemReference getHandle.
	itemReference objectUnref.
	^ item
]

{ #category : 'private' }
GtkTreeColumnViewExpanderAdapterItemFactory >> rowExpanded: rowHandle [

	| row |
	expandAction ifNil: [ ^ self ].

	row := GtkTreeListRow fromHandleUnowned: rowHandle.

	expandAction cull: (self itemFromRow: row) cull: row isExpanded
]

{ #category : 'accessing' }
GtkTreeColumnViewExpanderAdapterItemFactory >> setup: listItem [
	| child expander |
	
	child := self column setupAction cull: presenter.
	child build.

	expandAction ifNotNil: [
		| row |
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
