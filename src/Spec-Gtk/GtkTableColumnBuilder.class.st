Class {
	#name : #GtkTableColumnBuilder,
	#superclass : #GtkTableColumnVisitor,
	#instVars : [
		'model',
		'view',
		'sortColumnId'
	],
	#category : #'Spec-Gtk-Adapter-Table'
}

{ #category : #'instance creation' }
GtkTableColumnBuilder class >> on: aModel [

	^ self new model: aModel
]

{ #category : #private }
GtkTableColumnBuilder >> columnEdited: aTableColumn path: path text: text [
	| node iter |
	
	node := self nodeFromPath: path.
	
	"process edition"
	aTableColumn acceptAction 
		value: node 
		value: text.
	"store the new value (or restore the old valur)"
	iter := self store iteratorFromString: path.
	iter 
		at: (self columnIndexOf: aTableColumn) 
		putString: (aTableColumn readObject: node)
]

{ #category : #accessing }
GtkTableColumnBuilder >> columnIndexOf: aTableColumn [

	^ (self store indexOf: aTableColumn) - 1
]

{ #category : #accessing }
GtkTableColumnBuilder >> model [

	^ model
]

{ #category : #accessing }
GtkTableColumnBuilder >> model: anObject [
	model := anObject
]

{ #category : #'private factory' }
GtkTableColumnBuilder >> newColumnFor: aTableColumn [
	| column |

	column := GtkTreeViewColumn new.
	column title: aTableColumn title.
	aTableColumn width 
		ifNotNil: [ :w | column minWidth: w ].
	self model isResizable 
		ifTrue: [ column beResizable ].
	
	^ column
]

{ #category : #'private factory' }
GtkTableColumnBuilder >> newColumnPackerFor: column [

	^ GtkTableColumnPacker new 
		columns: self columns;
		column: column;
		builder: self;
		yourself
]

{ #category : #private }
GtkTableColumnBuilder >> nodeFromPath: path [
	
	^ self model itemAt: 	((path substrings: ':') first asNumber + 1)
]

{ #category : #private }
GtkTableColumnBuilder >> store [

	^ self view model
]

{ #category : #accessing }
GtkTableColumnBuilder >> view [
	^ view
]

{ #category : #accessing }
GtkTableColumnBuilder >> view: anObject [
	view := anObject
]

{ #category : #visiting }
GtkTableColumnBuilder >> visitCheckboxColumn: aTableColumn [
	
	self visitStringColumn: aTableColumn
]

{ #category : #visiting }
GtkTableColumnBuilder >> visitCompositeColumn: aTableColumn [
	| column packer |
	
	column := self newColumnFor: aTableColumn.
	packer := self newColumnPackerFor: column.	

	aTableColumn columns do: [ :each |
		packer 
			expand: each isExpandable;
			visit: each.
		self nextColumnIndex ].
	self prevColumnIndex.
	
	self view appendColumn: column
]

{ #category : #visiting }
GtkTableColumnBuilder >> visitImageColumn: aTableColumn [
	
	self visitStringColumn: aTableColumn
]

{ #category : #visiting }
GtkTableColumnBuilder >> visitLinkColumn: aColumn [

	self visitStringColumn: aColumn
]

{ #category : #visiting }
GtkTableColumnBuilder >> visitStringColumn: aTableColumn [
	| column |

	column := self newColumnFor: aTableColumn.
	(self newColumnPackerFor: column) visit: aTableColumn.
	
	self view appendColumn: column
	
]
