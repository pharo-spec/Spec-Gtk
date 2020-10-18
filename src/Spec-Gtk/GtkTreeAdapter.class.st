Class {
	#name : #GtkTreeAdapter,
	#superclass : #GtkTreeTableAdapter,
	#instVars : [
		'columns'
	],
	#category : #'Spec-Gtk-Adapter-Table'
}

{ #category : #'private accessing' }
GtkTreeAdapter >> columns [

	^ columns ifNil: [ columns := { self defaultColumn } ]
]

{ #category : #building }
GtkTreeAdapter >> connectToSpecColumnsChangedEventTo: gtkWidget [
]

{ #category : #'private accessing' }
GtkTreeAdapter >> defaultColumn [
	| stringColumn |

	stringColumn := SpStringTableColumn evaluated: self presenter display.
	^ self presenter icon 
		ifNotNil: [ 
			SpCompositeTableColumn new 
				addColumn: (SpImageTableColumn evaluated: self presenter icon) beNotExpandable;
				addColumn: stringColumn;
				yourself ]
		ifNil: [ stringColumn ]
]
