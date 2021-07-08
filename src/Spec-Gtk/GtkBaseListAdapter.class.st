Class {
	#name : #GtkBaseListAdapter,
	#superclass : #GtkAbstractListAdapter,
	#traits : 'GtkTHaveWrappingScrollBars',
	#classTraits : 'GtkTHaveWrappingScrollBars classTrait',
	#category : #'Spec-Gtk-Adapter-List'
}

{ #category : #building }
GtkBaseListAdapter >> addKeyBindingsTo: gtkWidget [

	super addKeyBindingsTo: gtkWidget.
	self addContextMenuKeyBindings: gtkWidget
]

{ #category : #building }
GtkBaseListAdapter >> addModelTo: gtkList [

	super addModelTo: gtkList.
	gtkList activateOnSingleClick: self presenter activatesOnSingleClick.
	self addSearchTo: gtkList.
	self presenter contextMenu ifNotNil: [ :menu |
		self addMenu: menu to: gtkList ].
]

{ #category : #building }
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

{ #category : #testing }
GtkBaseListAdapter >> columns [
	
	^ innerWidget columns
]

{ #category : #testing }
GtkBaseListAdapter >> isNonEditableRow: aRow column: aColumn [
	
	^ (innerWidget columns at: aColumn) isEditable not
]

{ #category : #'widget API' }
GtkBaseListAdapter >> refreshWidgetList [

	self refreshList
]

{ #category : #testing }
GtkBaseListAdapter >> selectedIndexes [
	^ innerWidget selection allSelected collect: #first as: Array
]

{ #category : #testing }
GtkBaseListAdapter >> selection [
	
	^ innerWidget selection
]

{ #category : #emulating }
GtkBaseListAdapter >> type: aString [
	"this will be used to test search"
	| entry |

	GRunLoop defer: [ 
		entry := self innerWidget searchEntry ].
	entry isNull inspect
]

{ #category : #testing }
GtkBaseListAdapter >> unselectAll [
	
	innerWidget selection unselectAll
]
