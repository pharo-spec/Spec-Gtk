"
I'm an adapter to render a TablePresenter with Gtk3.
"
Class {
	#name : #GtkTableAdapter,
	#superclass : #GtkBaseListAdapter,
	#traits : 'GtkTTableAccessing',
	#classTraits : 'GtkTTableAccessing classTrait',
	#category : #'Spec-Gtk-Adapter-Table'
}

{ #category : #building }
GtkTableAdapter >> addModelTo: gtkTreeView [
		
	super addModelTo: gtkTreeView.
	
	gtkTreeView connectDestroy: [ 
		gtkTreeView model roots: #() ].
		
	gtkTreeView headersVisible: self model isShowingColumnHeaders.

	self model selection isMultipleSelection 
		ifTrue: [ gtkTreeView beMultipleSelectionMode ] 
		ifFalse: [ gtkTreeView beSingleSelectionMode ].
				
	self addColumnsTo: gtkTreeView.
	
	self model columns ifNotEmpty: [
		gtkTreeView model: self newTreeStore.
		self addSortableColumnsTo: gtkTreeView ].
	
	gtkTreeView selection unselectAll.

	self presenter selection isEmpty ifFalse: [ 
		self presenter selection selectedIndexes 
			do: [ :anIndex | gtkTreeView selection selectPath: { anIndex } ]  ].
	
	self presenter selection whenChangedDo: [ 
		self presenter selection selectedIndexes 
			do: [ :anIndex | gtkTreeView selection selectPath: { anIndex } ] ].
	
	self presenter whenShowColumnHeadersChangedDo: [ 	
		gtkTreeView headersVisible: self model isShowingColumnHeaders ].
		
	gtkTreeView connectRowActivated: [ :path | 
		self model doActivateAtIndex: path toArray first ].

	self presenter whenColumnsChangedDo: [ 
		self refreshWidgetHeaderTitle. 
		self refreshList ].
	
	self refreshWidgetHeaderTitleTo: gtkTreeView.
	
	gtkTreeView connectSelectionChanged: [ 
		self presenter selection selectIndexes: gtkTreeView allSelected flattened ].
]

{ #category : #private }
GtkTableAdapter >> appendAddedColumns [
	| columns |
	
	self innerWidgetDo: [ :w |
		columns := self presenter columns.  
		(columns last: (columns size - w columns size)) 
			do: [ :aTableColumn | 
				self addColumn: aTableColumn to: w.
				GtkTableDataStoreColumnCollector new 
					store: w model;
					visit: aTableColumn ] ]
]

{ #category : #testing }
GtkTableAdapter >> columns [

	^ self presenter columns
]

{ #category : #building }
GtkTableAdapter >> doRefreshList: gtkWidget [

	super doRefreshList: gtkWidget.
	self addSortableColumnsTo: gtkWidget
]

{ #category : #testing }
GtkTableAdapter >> isShowColumnHeaders [

	^ self innerWidget isHeadersVisible
]

{ #category : #events }
GtkTableAdapter >> refreshWidgetHeaderTitle [
	
	self innerWidgetDo: [ :w |
		self refreshWidgetHeaderTitleTo: w ]
]

{ #category : #events }
GtkTableAdapter >> refreshWidgetHeaderTitleTo: gtkTreeView [
	
	"By now I only accept to add columns, as the data should be all generated. It is not so easy"
	(gtkTreeView columns size < self model columns size) 
		ifTrue: [ self appendAddedColumns ].
	
	self model columns 
		with: gtkTreeView columns 
		do: [ :modelColumn :widgetColumn | widgetColumn title: modelColumn title ]
]

{ #category : #testing }
GtkTableAdapter >> unselectAll [
	innerWidget selection unselectAll
]
