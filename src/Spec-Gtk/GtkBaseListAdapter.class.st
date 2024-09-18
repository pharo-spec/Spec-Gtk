Class {
	#name : 'GtkBaseListAdapter',
	#superclass : 'GtkAbstractListAdapter',
	#traits : 'GtkTHaveWrappingScrollBars',
	#classTraits : 'GtkTHaveWrappingScrollBars classTrait',
	#category : 'Spec-Gtk-Adapter-List',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-List'
}

{ #category : 'building' }
GtkBaseListAdapter >> addModelTo: gtkTreeView [

	super addModelTo: gtkTreeView.
	gtkTreeView activateOnSingleClick: self presenter isActiveOnSingleClick.
	self configureDragAndDrop: gtkTreeView.
	self addSearchTo: gtkTreeView.
	self presenter contextMenu ifNotNil: [ :menu |
		self addMenu: menu to: gtkTreeView ]
]

{ #category : 'building' }
GtkBaseListAdapter >> addSearchTo: gtkTreeView [
	
	self presenter isSearchEnabled ifFalse: [ ^ self ].
	
	gtkTreeView enableSearch: true.
	self presenter hasCustomSearch ifTrue: [
		gtkTreeView searchFunction: [ :key :column :iter |
			iter store: gtkTreeView model.
			self presenter 
				performSearch: (self presenter itemAt: iter toPathArray first)
				matching: key ] ]
]

{ #category : 'testing' }
GtkBaseListAdapter >> columns [
	
	^ innerWidget columns
]

{ #category : 'building' }
GtkBaseListAdapter >> configureDragAndDrop: gtkTreeView [
	"Configure drag&drop. This is related to GtkTreeDataStore too, if you want to understand how 
	 it works you need to check for GtkTreeDataStore creation/configuration too (e.g. #newTreeStore)"
	
	self presenter dragEnabled 
		ifTrue: [ 
			gtkTreeView enableModelDragSourceDefault ].
	self presenter dropEnabled
		ifTrue: [ gtkTreeView enableModelDragDestDefault ]
]

{ #category : 'testing' }
GtkBaseListAdapter >> isNonEditableRow: aRow column: aColumn [
	
	^ (innerWidget columns at: aColumn) isEditable not
]

{ #category : 'widget API' }
GtkBaseListAdapter >> refreshWidgetList [

	self refreshList
]

{ #category : 'testing' }
GtkBaseListAdapter >> selectedIndexes [
	^ innerWidget selection allSelected collect: #first as: Array
]

{ #category : 'testing' }
GtkBaseListAdapter >> selection [
	
	^ innerWidget selection
]

{ #category : 'emulating' }
GtkBaseListAdapter >> type: aString [
	"this will be used to test search"
	| entry |

	GRunLoop defer: [ 
		entry := self innerWidget searchEntry ].
	entry isNull inspect
]

{ #category : 'testing' }
GtkBaseListAdapter >> unselectAll [
	
	innerWidget selection unselectAll
]
