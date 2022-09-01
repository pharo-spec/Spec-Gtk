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

{ #category : #'private - attributes' }
GtkTableColumnPacker >> addAlignmentAttribute: aTableColumn column: aColumn renderer: aRenderer [
	
	aTableColumn displayAlignment ifNil: [ ^ self ].
	aColumn 
		addAttribute: 'xalign' 
		column: (self columnIndexOf: aTableColumn tag: #xalign) 
		renderer: aRenderer
]

{ #category : #'private - attributes' }
GtkTableColumnPacker >> addBackgroundColorAttribute: aTableColumn column: aColumn renderer: aRenderer [

	aTableColumn displayBackgroundColor ifNil: [ ^ self ].
	aColumn
		addAttribute: 'background'
		column: (self columnIndexOf: aTableColumn tag: #background) 
		renderer: aRenderer
]

{ #category : #'private - attributes' }
GtkTableColumnPacker >> addBoldAttribute: aTableColumn column: aColumn renderer: aRenderer [

	aTableColumn displayBold ifNil: [ ^ self ]. 
	aColumn 
		addAttribute: 'weight'
		column: (self columnIndexOf: aTableColumn tag: #weight) 
		renderer: aRenderer
]

{ #category : #'private - attributes' }
GtkTableColumnPacker >> addColorAttribute: aTableColumn column: aColumn renderer: aRenderer [
	
	aTableColumn displayColor ifNil: [ ^ self ]. 
	aColumn 
		addAttribute: 'foreground' 
		column: (self columnIndexOf: aTableColumn tag: #foreground) 
		renderer: aRenderer
]

{ #category : #'private - attributes' }
GtkTableColumnPacker >> addItalicAttribute: aTableColumn column: aColumn renderer: aRenderer [

	aTableColumn displayItalic ifNil: [ ^ self ]. 
	aColumn 
		addAttribute: 'style'
		column: (self columnIndexOf: aTableColumn tag: #style) 
		renderer: aRenderer
]

{ #category : #private }
GtkTableColumnPacker >> addRendererPropertiesTo: renderer column: aTableColumn [
	
	aTableColumn width ifNotNil: [ :w | 
		renderer width: w ].

]

{ #category : #'private - attributes' }
GtkTableColumnPacker >> addUnderlineAttribute: aTableColumn column: aColumn renderer: aRenderer [

	aTableColumn displayUnderline ifNil: [ ^ self ].
	aColumn 
		addAttribute: 'underline'
		column: (self columnIndexOf: aTableColumn tag: #underline) 
		renderer: aRenderer
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

{ #category : #accessing }
GtkTableColumnPacker >> columnIndexOf: aTableColumn [

	^ (self store indexOf: aTableColumn) - 1
]

{ #category : #accessing }
GtkTableColumnPacker >> columnIndexOf: aTableColumn tag: anObject [

	^ (self store indexOf: aTableColumn tag: anObject) - 1
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

{ #category : #'private - factory' }
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

{ #category : #'private - factory' }
GtkTableColumnPacker >> newImageRenderer [

	^ GtkCellRendererPixbuf new
]

{ #category : #'private - factory' }
GtkTableColumnPacker >> newTextRenderer [

	^ GtkCellRendererText new
]

{ #category : #'private - factory' }
GtkTableColumnPacker >> newToggleRenderer [

	^ GtkCellRendererToggle new
]

{ #category : #accessing }
GtkTableColumnPacker >> store [

	^ self builder store
]

{ #category : #visiting }
GtkTableColumnPacker >> visitCheckboxColumn: aTableColumn [
	| renderer |

	renderer := self newToggleRenderer.
	(aTableColumn onActivation notNil 
		or: [ aTableColumn onDeactivation notNil ])
		ifTrue: [ 
			renderer activatable: true.
			renderer connectToggled: [ :pathString | self doToggle: pathString column: aTableColumn ] ].
	self addRendererPropertiesTo: renderer column: aTableColumn.
	column packStart: renderer expand: self isExpand.
	column 
		addAttribute: 'active' 
		column: (self columnIndexOf: aTableColumn)
		renderer: renderer.
	"attributes"
	self addAlignmentAttribute: aTableColumn column: column renderer: renderer.
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
		renderer: renderer.
	"attributes"
	self addAlignmentAttribute: aTableColumn column: column renderer: renderer
]

{ #category : #visiting }
GtkTableColumnPacker >> visitIndexColumn: aTableColumn [
	| renderer index |
	
	renderer := aTableColumn isEditable 
		ifTrue: [ self newEditableTextRendererFor: aTableColumn ]
		ifFalse: [ self newTextRenderer ].
	self addRendererPropertiesTo: renderer column: aTableColumn.
	
	index := self columnIndexOf: aTableColumn.
	column packStart: renderer expand: self isExpand.
	column addAttribute: 'text' column: index renderer: renderer.
	"attributes"
	self addAlignmentAttribute: aTableColumn column: column renderer: renderer
]

{ #category : #visiting }
GtkTableColumnPacker >> visitLinkColumn: aTableColumn [
	| renderer index |
	
	renderer := GtkCellRendererLink new.
	self addRendererPropertiesTo: renderer column: aTableColumn.
	
	index := self columnIndexOf: aTableColumn.
	column packStart: renderer expand: self isExpand.
	column addAttribute: 'text' column: index renderer: renderer.
	
	aTableColumn action ifNotNil: [ 	
		renderer onActivate: [ :event :widget :path | 
			| pathArray |
			pathArray := (path substrings: ':') collect: [ :each | each asNumber + 1 ].
			aTableColumn action value: (self store itemAtPath: pathArray) ] ].
	"attributes"
	self addAlignmentAttribute: aTableColumn column: column renderer: renderer
]

{ #category : #visiting }
GtkTableColumnPacker >> visitStringColumn: aTableColumn [
	| renderer index |
	
	renderer := aTableColumn isEditable 
		ifTrue: [ self newEditableTextRendererFor: aTableColumn ]
		ifFalse: [ self newTextRenderer ].
	self addRendererPropertiesTo: renderer column: aTableColumn.
	
	index := self columnIndexOf: aTableColumn.
	column packStart: renderer expand: self isExpand.
	column addAttribute: 'text' column: index renderer: renderer.
	"attributes"
	self addAlignmentAttribute: aTableColumn column: column renderer: renderer.
	self addColorAttribute: aTableColumn column: column renderer: renderer.
	self addBackgroundColorAttribute: aTableColumn column: column renderer: renderer.
	self addItalicAttribute: aTableColumn column: column renderer: renderer.	
	self addBoldAttribute: aTableColumn column: column renderer: renderer.	
	self addUnderlineAttribute: aTableColumn column: column renderer: renderer
]
