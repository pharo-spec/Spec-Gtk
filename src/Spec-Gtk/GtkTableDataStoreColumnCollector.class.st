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
GtkTableDataStoreColumnCollector >> addColorColumn: aTableColumn [

	aTableColumn displayColor ifNil: [ ^ self ]. 
	store addColumn: (GtkTreeDataStringColumn new 
		column: aTableColumn;
		tag: #foreground;
		evaluated: [ :aClass | 
			(aTableColumn displayColor cull: aClass) 
				ifNotNil: [ :color | '#', (color asHexString) ] ]).
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
GtkTableDataStoreColumnCollector >> visitStringColumn: aTableColumn [

	store addColumn: (GtkTreeDataStringColumn on: aTableColumn).
	"text properties"
	self addColorColumn: aTableColumn.
	self addBackgroundColorColumn: aTableColumn.
	
]
