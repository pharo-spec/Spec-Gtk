Class {
	#name : #GtkTreeTableColumnBuilder,
	#superclass : #GtkTableColumnBuilder,
	#category : #'Spec-Gtk-Adapter-Table'
}

{ #category : #private }
GtkTreeTableColumnBuilder >> nodeFromPath: path [
	
	^ self model itemAtPath: ((path substrings: ':') collect: [ :each | each asNumber + 1 ])
]
