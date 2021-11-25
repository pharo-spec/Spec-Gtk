Class {
	#name : #GtkPatchAdapter,
	#superclass : #GtkAdapter,
	#traits : 'GtkTHaveWrappingScrollBars',
	#classTraits : 'GtkTHaveWrappingScrollBars classTrait',
	#category : #'Spec-Gtk-Code-Diff'
}

{ #category : #'private - accessing' }
GtkPatchAdapter >> addMark: tagName line: lineNumber to: aTextBuffer [
	| start |

	start := aTextBuffer iterAtLine: lineNumber - 1.
	
	aTextBuffer 
		createSourceMarkNamed: ('{1}_{2}' format: { tagName. lineNumber }) 
		category: tagName 
		where: start
]

{ #category : #building }
GtkPatchAdapter >> addMarksTo: gtkSourceView [
	
	self presenter marks valuesDo: [ :each |
		gtkSourceView 
			markAttributesForCategory: each name 
				attributes: (GtkSourceMarkAttributes new 
					background: each backgroundColor asGdkRGBA;
					pixbuf: (self presenter application iconNamed: each iconName) asGdkPixbuf;
					yourself) 
				priority: 0 ]
]

{ #category : #building }
GtkPatchAdapter >> addModelTo: gtkSourceView [

	super addModelTo: gtkSourceView.

	gtkSourceView monospace: true.
	gtkSourceView 
		showLineNumbers: "self presenter hasLineNumbers" false;
		showLineMarks: true;
		autoIndent: true;
		indentOnTab: true;
		tabWidth: 4.

	gtkSourceView editable: false.
	gtkSourceView beWrapNone.
	gtkSourceView styleContext addClass: 'code'.
	
	self addMarksTo: gtkSourceView. 
		
	self setPatchTo: gtkSourceView.
	self presenter whenPatchChangedDo: [ :aPatch | self setPatch: aPatch ]
]

{ #category : #'private - accessing' }
GtkPatchAdapter >> bufferClass [ 
	
	^ GtkSourceBuffer
]

{ #category : #'private - factory' }
GtkPatchAdapter >> newTagTable [
	
	^ GtkTextTagTable newForCode: self styleTable
]

{ #category : #'private - factory' }
GtkPatchAdapter >> newTextBufferForHighlight [
	| textBuffer |

	textBuffer := self bufferClass newTable: self newTagTable.

	^ textBuffer
]

{ #category : #'private - factory' }
GtkPatchAdapter >> newTextBufferForText: aString [
	| textBuffer |

	textBuffer := self newTextBufferForHighlight.

	aString ifNotNil: [ 
		textBuffer text: aString ].

	textBuffer highlightMatchingBrackets: true.

	^ textBuffer
]

{ #category : #'private - accessing' }
GtkPatchAdapter >> setPatch: aPatchModel [

	self innerWidgetDo: [ :w | 
		self setPatch: aPatchModel patch to: w ]
]

{ #category : #'private - accessing' }
GtkPatchAdapter >> setPatch: patch to: gtkTextView [ 
	| visitor |
	
	visitor := GtkPatchLineVisitor new 
		visitPatch: patch;
		yourself.	

	self setText: visitor contents to: gtkTextView.
	visitor lineMarks do: [ :eachAssoc |
		self 
			addMark: eachAssoc value 
			line: eachAssoc key
			to: gtkTextView textBuffer ]
]

{ #category : #'private - accessing' }
GtkPatchAdapter >> setPatchTo: gtkTextView [ 

	(self presenter model isNil 
		or: [ self presenter model isEmpty ])
		ifTrue: [  
			self setText: '' to: gtkTextView. 
			^ self ].
		
	self 
		setPatch: self presenter model patch
		to: gtkTextView
]

{ #category : #'private - accessing' }
GtkPatchAdapter >> setText: aString to: gtkWidget [

	self backendDetectCyclesDo: [
		gtkWidget textBuffer: (self newTextBufferForText: aString) ]
]

{ #category : #'private - accessing' }
GtkPatchAdapter >> styleTable [
	| styleTableName |	

	styleTableName := self presenter syntaxHighlightTheme 	
		ifNil: [ 
			self presenter application 
				propertyAt: #syntaxHighlightTheme 
				ifAbsent: [ 
					"answer the default"
					^ SHRBTextStyler newAttributesForStyleTable: SHRBTextStyler styleTable ] ].

	^ SHRBTextStyler newAttributesForStyleTableNamed: styleTableName
]

{ #category : #building }
GtkPatchAdapter >> widgetClass [

	^ GtkSourceView
]

{ #category : #building }
GtkPatchAdapter >> wrapWidget: gtkWidget [
	| wrapWidget |
	
	innerWidget := gtkWidget.
	wrapWidget := self wrapWithScrollableWindow: innerWidget.
	
	^ wrapWidget
]
