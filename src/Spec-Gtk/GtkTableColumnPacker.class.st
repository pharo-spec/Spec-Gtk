Class {
	#name : #GtkTableColumnPacker,
	#superclass : #GtkTableColumnVisitor,
	#instVars : [
		'builder',
		'column',
		'expand'
	],
	#category : #'Spec-Gtk-Adapter-Table'
}

{ #category : #'instance creation' }
GtkTableColumnPacker class >> on: aModel [

	^ self new model: aModel
]

{ #category : #private }
GtkTableColumnPacker >> addRendererPropertiesTo: renderer column: aTableColumn [
	
	aTableColumn width ifNotNil: [ :w | 
		renderer width: w ].

]

{ #category : #accessing }
GtkTableColumnPacker >> builder [
	^ builder
]

{ #category : #accessing }
GtkTableColumnPacker >> builder: anObject [
	builder := anObject
]

{ #category : #accessing }
GtkTableColumnPacker >> column [
	^ column
]

{ #category : #accessing }
GtkTableColumnPacker >> column: anObject [
	column := anObject
]

{ #category : #private }
GtkTableColumnPacker >> doToggle: pathString column: aTableColumn [
	| path iter item store status | 

	path := (GtkTreePath newFromString: pathString) autoRelease.
	store := builder view model.

	item := builder model itemAtPath: path toArray.
	status := aTableColumn readObject: item.
	
	iter := store iteratorFromPath: path.
	iter 
		atColumnIndex: (builder columnIndexOf: aTableColumn) 
		setBoolean: status not.
	
	(status 
		ifTrue: [ aTableColumn onDeactivation ]
		ifFalse: [ aTableColumn onActivation ])
		ifNotNil: [ :aValuable | aValuable cull: item ]
]

{ #category : #accessing }
GtkTableColumnPacker >> expand: aBoolean [

	expand := aBoolean
]

{ #category : #visiting }
GtkTableColumnPacker >> initialize [

	super initialize.
	self expand: true
]

{ #category : #testing }
GtkTableColumnPacker >> isExpand [

	^ expand
]

{ #category : #'private factory' }
GtkTableColumnPacker >> newEditableTextRendererFor: aTableColumn [
	| renderer |
	
	renderer := GtkCellRendererText new.
	renderer beEditable.
	renderer connectEdited: [ :path :text | 
		self builder 
			columnEdited: aTableColumn 
			path: path 
			text: text ].

	^ renderer
]

{ #category : #'private factory' }
GtkTableColumnPacker >> newImageRenderer [

	^ GtkCellRendererPixbuf new
]

{ #category : #'private factory' }
GtkTableColumnPacker >> newTextRenderer [

	^ GtkCellRendererText new
]

{ #category : #'private factory' }
GtkTableColumnPacker >> newToggleRenderer [

	^ GtkCellRendererToggle new
]

{ #category : #visiting }
GtkTableColumnPacker >> visitCheckboxColumn: aTableColumn [
	| renderer |

	renderer := self newToggleRenderer.
	renderer connectToggled: [ :pathString | self doToggle: pathString column: aTableColumn ].
	self addRendererPropertiesTo: renderer column: aTableColumn.
	column packStart: renderer expand: self isExpand.
	column 
		addAttribute: 'active' 
		column: (self columnIndexOf: aTableColumn)
		renderer: renderer
]

{ #category : #visiting }
GtkTableColumnPacker >> visitCompositeColumn: aTableColumn [
	
	self error: 'Should now arrive here!'
]

{ #category : #visiting }
GtkTableColumnPacker >> visitImageColumn: aTableColumn [
	| renderer |

	renderer := self newImageRenderer.
	self addRendererPropertiesTo: renderer column: aTableColumn.
	column packStart: renderer expand: self isExpand.
	column 
		addAttribute: 'pixbuf' 
		column: (self columnIndexOf: aTableColumn)
		renderer: renderer
]

{ #category : #visiting }
GtkTableColumnPacker >> visitStringColumn: aTableColumn [
	| renderer |
	
	renderer := aTableColumn isEditable 
		ifTrue: [ self newEditableTextRendererFor: aTableColumn ]
		ifFalse: [ self newTextRenderer ].
	self addRendererPropertiesTo: renderer column: aTableColumn.
	
	column packStart: renderer expand: self isExpand.
	column 
		addAttribute: 'text' 
		column: (self columnIndexOf: aTableColumn)
		renderer: renderer
]
