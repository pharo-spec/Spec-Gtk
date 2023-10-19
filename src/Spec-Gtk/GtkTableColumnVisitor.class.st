Class {
	#name : 'GtkTableColumnVisitor',
	#superclass : 'Object',
	#instVars : [
		'columns',
		'flattenColumns'
	],
	#category : 'Spec-Gtk-Adapter-Table',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Table'
}

{ #category : 'accessing' }
GtkTableColumnVisitor >> columns [

	^ columns
]

{ #category : 'accessing' }
GtkTableColumnVisitor >> columns: aCollection [

	columns := aCollection
]

{ #category : 'accessing' }
GtkTableColumnVisitor >> flattenColumns [

	flattenColumns ifNil: [ 
		flattenColumns := self obtainFlattenColumns: OrderedCollection new ].

	^ flattenColumns
]

{ #category : 'initialization' }
GtkTableColumnVisitor >> initialize [

	super initialize.
	self resetColumnIndex
]

{ #category : 'accessing' }
GtkTableColumnVisitor >> nextColumnIndex [

	self flag: #REMOVE.
	"columnIndex := columnIndex + 1"
]

{ #category : 'accessing' }
GtkTableColumnVisitor >> obtainFlattenColumns: aCollection [
	
	self 
		obtainFlattenColumns: self columns 
		in: aCollection.
	^ aCollection
]

{ #category : 'accessing' }
GtkTableColumnVisitor >> obtainFlattenColumns: columnsCollection in: aCollection [

	columnsCollection do: [ :each |
		each isComposite
			ifTrue: [ self obtainFlattenColumns: each columns in: aCollection ]
			ifFalse: [ aCollection add: each ] ].

]

{ #category : 'accessing' }
GtkTableColumnVisitor >> prevColumnIndex [

	self flag: #REMOVE.
	"columnIndex := columnIndex - 1"
]

{ #category : 'accessing' }
GtkTableColumnVisitor >> resetColumnIndex [

	self flag: #REMOVE.
	"columnIndex := 0"
]

{ #category : 'visiting' }
GtkTableColumnVisitor >> visit: aTableColumn [

	aTableColumn acceptColumnVisitor: self.
	self nextColumnIndex
]

{ #category : 'visiting' }
GtkTableColumnVisitor >> visitAll: aCollection [

	aCollection do: [ :each |
		self visit: each ]
]

{ #category : 'visiting' }
GtkTableColumnVisitor >> visitCheckboxColumn: aTableColumn [
]

{ #category : 'visiting' }
GtkTableColumnVisitor >> visitCompositeColumn: aTableColumn [
	
	aTableColumn columns do: [ :each |
		self visit: each  ]
]

{ #category : 'visiting' }
GtkTableColumnVisitor >> visitImageColumn: aTableColumn [
]

{ #category : 'visiting' }
GtkTableColumnVisitor >> visitIndexColumn: aTableColumn [
	
	^ self visitStringColumn: aTableColumn
]

{ #category : 'visiting' }
GtkTableColumnVisitor >> visitLinkColumn: aColumn [

]

{ #category : 'visiting' }
GtkTableColumnVisitor >> visitStringColumn: aTableColumn [
]
