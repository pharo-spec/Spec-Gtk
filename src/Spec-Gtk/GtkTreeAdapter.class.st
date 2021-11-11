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
	| column |

	column := SpStringTableColumn evaluated: self presenter display.	
	
	self presenter displayColor 
		ifNotNil: [ :aBlock | column displayColor: aBlock ].
	self presenter displayBold
		ifNotNil: [ :aBlock | column displayBold: aBlock ].
	self presenter displayItalic
		ifNotNil: [ :aBlock | column displayItalic: aBlock ].
	self presenter displayUnderline
		ifNotNil: [ :aBlock | column displayUnderline: aBlock ].
	self presenter displayBackgroundColor 
		ifNotNil: [ :aBlock | column displayBackgroundColor: aBlock ].
		
	^ self presenter displayIcon 
		ifNotNil: [ 
			SpCompositeTableColumn new 
				addColumn: (SpImageTableColumn evaluated: self presenter displayIcon) beNotExpandable;
				addColumn: column;
				yourself ]
		ifNil: [ column ]
]

{ #category : #'private accessing' }
GtkTreeAdapter >> unsubscirbeSelectionMode [
 
	"do nothing here"
]
