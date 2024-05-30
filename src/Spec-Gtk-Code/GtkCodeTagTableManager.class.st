"
This is an util to provide the code adapter of style tables.
Is for internal usage, but useful because this can change and I do not want to pollute the adapter with any future changes.
"
Class {
	#name : 'GtkCodeTagTableManager',
	#superclass : 'Object',
	#instVars : [
		'tagTables'
	],
	#classInstVars : [
		'session'
	],
	#category : 'Spec-Gtk-Code-Base',
	#package : 'Spec-Gtk-Code',
	#tag : 'Base'
}

{ #category : 'instance creation' }
GtkCodeTagTableManager class >> for: anApplication [

	^ anApplication 
		propertyAt: #codeTagTableManager
		ifAbsentPut: [ self basicNew initialize ]
]

{ #category : 'instance creation' }
GtkCodeTagTableManager class >> new [

	self error: 'Use #for:'
]

{ #category : 'initialization' }
GtkCodeTagTableManager >> initialize [

	super initialize.
	tagTables := SmallDictionary new
]

{ #category : 'private' }
GtkCodeTagTableManager >> newTagTableFor: aName [
	
	self flag: #TODO. "highlight color in the style table? In any case, not here :P"
	^ (GtkTextTagTable newForCode: (self styleTableFor: aName))
		add: ((GtkTextTag newName: 'highlight')
			background: (Color orange alpha: 0.2);
			yourself);
		yourself
]

{ #category : 'private' }
GtkCodeTagTableManager >> styleTableFor: aName [
	
	^ aName = #default
		ifTrue: [ SHRBTextStyler newAttributesForStyleTable: SHRBTextStyler styleTable ]
		ifFalse: [ SHRBTextStyler newAttributesForStyleTableNamed: aName ]
]

{ #category : 'private' }
GtkCodeTagTableManager >> styleTableNameFor: aPresenter [

	^ aPresenter syntaxHighlightTheme
		ifNil: [ 
			aPresenter application 
				propertyAt: #syntaxHighlightTheme 
				ifAbsent: [ #default ] ]
]

{ #category : 'accessing' }
GtkCodeTagTableManager >> tagTableFor: aPresenter [
	| styleName |

	styleName := self styleTableNameFor: aPresenter. 
	^ tagTables 
		at: styleName
		ifAbsentPut: [ self newTagTableFor: styleName ]
]
