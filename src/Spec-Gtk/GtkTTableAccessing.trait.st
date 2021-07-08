Trait {
	#name : #GtkTTableAccessing,
	#category : #'Spec-Gtk-Adapter-Table'
}

{ #category : #building }
GtkTTableAccessing >> addColumn: aTableColumn to: aGtkTreeView [ 
	| addColumnVisitor |
	
	addColumnVisitor := GtkTableColumnBuilder new
		model: self presenter;
		columns: self presenter columns;
		view: aGtkTreeView;
		yourself.
		
	aTableColumn acceptColumnVisitor: addColumnVisitor
]

{ #category : #building }
GtkTTableAccessing >> addColumnsTo: gtkWidget [

	self model columns do: [ :aColumn | 
		self addColumn: aColumn to: gtkWidget ].	
]

{ #category : #factory }
GtkTTableAccessing >> newTreeStore [
	
	^ self newTreeStoreFrom: self presenter model items
]

{ #category : #factory }
GtkTTableAccessing >> newTreeStoreFrom: items [
	| store |
	
	store := GtkTreeDataStore new.
	store beList.
	GtkTableDataStoreColumnCollector new
		store: store;
		visitAll: self model columns.

	store roots: items.

	^ store
]
