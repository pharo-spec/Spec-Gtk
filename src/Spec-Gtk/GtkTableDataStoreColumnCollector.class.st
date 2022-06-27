"
! GtkTableDataStoreColumnCollector

A visitor to add columns (*class:GtkTreeDataColumn*) to a *class:GtkTreeDataStore*
"
Class {
	#name : #GtkTableDataStoreColumnCollector,
	#superclass : #GtkTableColumnVisitor,
	#instVars : [
		'store'
	],
	#category : #'Spec-Gtk-Adapter-Table'
}

{ #category : #private }
GtkTableDataStoreColumnCollector >> addAlignmentColumn: aTableColumn [

	aTableColumn displayAlignment ifNil: [ ^ self ]. 
	store addColumn: (GtkTreeDataIntegerColumn new 
		column: aTableColumn;
		tag: #alignment;
		evaluated: [ :aClass | 
			(aTableColumn displayAlignment cull: aClass) asXAlign ]).
]

{ #category : #private }
GtkTableDataStoreColumnCollector >> addBackgroundColorColumn: aTableColumn [

	aTableColumn displayBackgroundColor ifNil: [ ^ self ]. 
	store addColumn: (GtkTreeDataStringColumn new
		column: aTableColumn;
		tag: #background; 
		evaluated: [ :aClass | 
			(aTableColumn displayBackgroundColor cull: aClass) 
				ifNotNil: [ :color | '#', (color asHexString) ] ]).
]

{ #category : #private }
GtkTableDataStoreColumnCollector >> addBoldColumn: aTableColumn [

	aTableColumn displayBold ifNil: [ ^ self ]. 
	store addColumn: (GtkTreeDataIntegerColumn new 
		column: aTableColumn;
		tag: #weight;
		evaluated: [ :aClass | 
			(aTableColumn displayBold cull: aClass) 
				ifTrue: [ 700 "PANGO_WEIGHT_BOLD" ]
				ifFalse: [ 400 "PANGO_WEIGHT_NORMAL" ] ]).
]

{ #category : #private }
GtkTableDataStoreColumnCollector >> addColorColumn: aTableColumn [

	aTableColumn displayColor ifNil: [ ^ self ]. 
	store addColumn: (GtkTreeDataStringColumn new 
		column: aTableColumn;
		tag: #foreground;
		evaluated: [ :aClass | 
			(aTableColumn displayColor cull: aClass) 
				ifNotNil: [ :color | '#', (color asHexString) ] ]).
]

{ #category : #private }
GtkTableDataStoreColumnCollector >> addItalicColumn: aTableColumn [

	aTableColumn displayItalic ifNil: [ ^ self ]. 
	store addColumn: (GtkTreeDataIntegerColumn new 
		column: aTableColumn;
		tag: #style;
		evaluated: [ :aClass | 
			(aTableColumn displayItalic cull: aClass) 
				ifTrue: [ 2 "PANGO_STYLE_ITALIC" ]
				ifFalse: [ 0 "PANGO_STYLE_NORMAL" ] ]).
]

{ #category : #private }
GtkTableDataStoreColumnCollector >> addUnderlineColumn: aTableColumn [

	aTableColumn displayUnderline ifNil: [ ^ self ]. 

	store addColumn: (GtkTreeDataIntegerColumn new 
		column: aTableColumn;
		tag: #underline;
		evaluated: [ :aClass | 
			(aTableColumn displayUnderline cull: aClass) 
				ifTrue: [ 1  "PANGO_UNDERLINE_SINGLE" ]
				ifFalse: [ 0 "PANGO_UNDERLINE_NONE" ] ]).
]

{ #category : #accessing }
GtkTableDataStoreColumnCollector >> store [

	^ store
]

{ #category : #accessing }
GtkTableDataStoreColumnCollector >> store: aStore [

	store := aStore
]

{ #category : #visiting }
GtkTableDataStoreColumnCollector >> visitCheckboxColumn: aTableColumn [

	store addColumn: (GtkTreeDataBooleanColumn on: aTableColumn)
]

{ #category : #visiting }
GtkTableDataStoreColumnCollector >> visitImageColumn: aTableColumn [

	store addColumn: (GtkTreeDataPixbufColumn on: aTableColumn)
]

{ #category : #visiting }
GtkTableDataStoreColumnCollector >> visitIndexColumn: aTableColumn [

	store addColumn: (GtkTreeDataIndexColumn new 
		column: aTableColumn;
		yourself)
]

{ #category : #visiting }
GtkTableDataStoreColumnCollector >> visitLinkColumn: aTableColumn [

	store addColumn: (GtkTreeDataStringColumn on: aTableColumn)
]

{ #category : #visiting }
GtkTableDataStoreColumnCollector >> visitStringColumn: aTableColumn [

	store addColumn: (GtkTreeDataStringColumn on: aTableColumn).
	"text properties"
	self addAlignmentColumn: aTableColumn.
	self addColorColumn: aTableColumn.
	self addBackgroundColorColumn: aTableColumn.
	self addItalicColumn: aTableColumn.
	self addBoldColumn: aTableColumn.
	self addUnderlineColumn: aTableColumn
]
