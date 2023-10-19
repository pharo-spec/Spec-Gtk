Trait {
	#name : 'GtkTTableAccessing',
	#category : 'Spec-Gtk-Adapter-Table',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Table'
}

{ #category : 'building' }
GtkTTableAccessing >> addColumn: aTableColumn to: aGtkTreeView [ 
	| addColumnVisitor |
	
	addColumnVisitor := GtkTableColumnBuilder new
		model: self presenter;
		resizable: self presenter isResizable;
		columns: self presenter columns;
		view: aGtkTreeView;
		yourself.
		
	aTableColumn acceptColumnVisitor: addColumnVisitor
]

{ #category : 'building' }
GtkTTableAccessing >> addColumnsTo: gtkWidget [

	self model columns do: [ :aColumn | 
		self addColumn: aColumn to: gtkWidget ].	
]

{ #category : 'factory' }
GtkTTableAccessing >> newTreeStore [
	
	^ self newTreeStoreFrom: self presenter model items
]

{ #category : 'factory' }
GtkTTableAccessing >> newTreeStoreFrom: items [
	| store |
	
	store := GtkTreeDataStore new.
	store beList.
	GtkTableDataStoreColumnCollector new
		store: store;
		visitAll: self tableColumns.

	store roots: items.

	"configure drag&drop"
	store dragEnabled: self presenter dragEnabled.
	self presenter dropEnabled ifTrue: [ 
		store 
			dropEnabled: true;
			acceptDrop: self presenter acceptDrop ].	

	^ store
]

{ #category : 'factory' }
GtkTTableAccessing >> tableColumns [
	
	^ self model columns
]
