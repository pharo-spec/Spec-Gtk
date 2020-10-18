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

	store addColumn: (GtkTreeDataBooleanColumn evaluated: aTableColumn evaluation)
]

{ #category : #visiting }
GtkTableDataStoreColumnCollector >> visitImageColumn: aTableColumn [

	store addColumn: (GtkTreeDataPixbufColumn evaluated: aTableColumn evaluation)
]

{ #category : #visiting }
GtkTableDataStoreColumnCollector >> visitStringColumn: aTableColumn [

	store addColumn: (GtkTreeDataStringColumn evaluated: aTableColumn evaluation)
]
