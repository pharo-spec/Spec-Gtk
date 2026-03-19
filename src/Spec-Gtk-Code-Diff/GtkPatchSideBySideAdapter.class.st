Class {
	#name : 'GtkPatchSideBySideAdapter',
	#superclass : 'GtkAdapter',
	#instVars : [
		'leftSourceView',
		'rightSourceView',
		'userAction'
	],
	#category : 'Spec-Gtk-Code-Diff',
	#package : 'Spec-Gtk-Code-Diff'
}

{ #category : 'building' }
GtkPatchSideBySideAdapter >> addMark: tagName line: lineNumber to: aTextBuffer [
	| start |

	start := aTextBuffer iterAtLine: lineNumber - 1.
	
	aTextBuffer 
		createSourceMarkNamed: ('{1}_{2}' format: { tagName. lineNumber }) 
		category: tagName 
		where: start
]

{ #category : 'building' }
GtkPatchSideBySideAdapter >> addMarksTo: gtkSourceView [
	
	self marks valuesDo: [ :each |
		gtkSourceView 
			markAttributesForCategory: each name 
				attributes: (GtkSourceMarkAttributes new 
					background: each backgroundColor asGdkRGBA;
					pixbuf: (self presenter application iconNamed: each iconName) asGdkPixbuf;
					yourself) 
				priority: 0 ]
]

{ #category : 'building' }
GtkPatchSideBySideAdapter >> addModelTo: aView [

	super addModelTo: aView.
	
	self addMarksTo: leftSourceView.
	self addMarksTo: rightSourceView.
	
	self addPatchTo: aView.
	
	self presenter whenLineNumbersChangedDo: [ :hasLineNumbers | 
		self updateLineNumbers: hasLineNumbers ]
]

{ #category : 'building' }
GtkPatchSideBySideAdapter >> addPatchTo: aView [
	
	self setPatch.
	self presenter whenPatchChangedDo: [ :aPatch |self updatePatch: aPatch ]
]

{ #category : 'private' }
GtkPatchSideBySideAdapter >> applyFullStyleTo: textBuffer [

	"If I am in an user action, I will not do anything now, just register for change (it 
	 will be executed later)."
	self userActionDo: [ :anUserAction | 
		anUserAction registerChange.
		^ self ].

	textBuffer userActionDuring: [ 
		self applyStyleTo: textBuffer ]
]

{ #category : 'private' }
GtkPatchSideBySideAdapter >> applyStyleTo: textBuffer [

	self presenter hasSyntaxHighlight ifFalse: [ ^ self ].
	self presenter text isEmptyOrNil ifTrue: [ ^ self ].
	
	logger trace: textBuffer.
	
	textBuffer removeAllTags.
	
	[ 
		(self isScripting or: [ self behavior isNil ])
			ifTrue: [
				self 
					setExpressionText: textBuffer text 
					class: self behavior 
					toBuffer: textBuffer  ]
			ifFalse: [ 
				self 
					setMethodText: textBuffer text 
					class: self behavior 
					toBuffer: textBuffer ] ]
	on: Error 
	fork: [ :e | e pass ]
]

{ #category : 'private' }
GtkPatchSideBySideAdapter >> bufferClass [ 
	
	^ GtkSourceBuffer
]

{ #category : 'private' }
GtkPatchSideBySideAdapter >> marks [
	
	^ self presenter marks
]

{ #category : 'factory' }
GtkPatchSideBySideAdapter >> newSourceView [

	^ GtkSourceView new
		beWrapWord;
		monospace: true;
		showLineNumbers: self presenter hasLineNumbers;
		showLineMarks: true;
		editable: false;
		tabWidth: 4;
		yourself

]

{ #category : 'private - factory' }
GtkPatchSideBySideAdapter >> newTextBufferForHighlight [
	| textBuffer |

	textBuffer := self bufferClass newTable: self usingTagTable.
	"textBuffer connectChanged: [ 
		self applyFullStyleTo: textBuffer ]."
	
	^ textBuffer
]

{ #category : 'private - factory' }
GtkPatchSideBySideAdapter >> newTextBufferForText: aString [

	^ self newTextBufferForHighlight
		styleScheme: self styleScheme;
		highlightMatchingBrackets: true;
		text: (aString ifNil: [ '' ]);
		yourself
]

{ #category : 'building' }
GtkPatchSideBySideAdapter >> newWidget [

	leftSourceView := self newSourceView.
	rightSourceView := self newSourceView.
	
	^ GtkBox newHorizontal 
		homogeneous: true;
		append: leftSourceView;
		append: rightSourceView;
		yourself
]

{ #category : 'private - accessing' }
GtkPatchSideBySideAdapter >> setPatch [
	(self presenter model isNil 
		or: [ self presenter model isEmpty ])
		ifTrue: [ 
			leftSourceView text: ''.
			rightSourceView text: ''. 
			^ self ].

	self setPatch: self presenter model patch
]

{ #category : 'private - accessing' }
GtkPatchSideBySideAdapter >> setPatch: patch [
	| visitor |
	
	visitor := GtkPatchSideBySideVisitor new 
		visitPatch: patch;
		yourself.	

	leftSourceView textBuffer: (self newTextBufferForText: visitor leftText).
	visitor leftMarks do: [ :aMark | 
		self 
			addMark: aMark value 
			line: aMark key 
			to: leftSourceView textBuffer ].
	
	rightSourceView textBuffer: (self newTextBufferForText: visitor rightText).
	visitor rightMarks do: [ :aMark | 
		self 
			addMark: aMark value 
			line: aMark key 
			to: rightSourceView textBuffer ]
]

{ #category : 'private' }
GtkPatchSideBySideAdapter >> styleScheme [
	| schemeName |

	schemeName := self presenter styleScheme 
		ifNil: [ self presenter application styleScheme ]. 
	^ GtkSourceStyleSchemeManager default schemeWithId: schemeName
]

{ #category : 'building' }
GtkPatchSideBySideAdapter >> updateLineNumbers: hasLineNumbers [

	self widgetDo: [ :w |
		leftSourceView showLineNumbers: hasLineNumbers.
		rightSourceView showLineNumbers: hasLineNumbers ]
]

{ #category : 'building' }
GtkPatchSideBySideAdapter >> updatePatch: aPatch [

	self widgetDo: [ :w | self setPatch: aPatch ]
]

{ #category : 'private' }
GtkPatchSideBySideAdapter >> userActionDo: aBlock [

	userAction ifNil: [ ^ self ].
	aBlock value: userAction
]

{ #category : 'private' }
GtkPatchSideBySideAdapter >> usingTagTable [

	^ (GtkCodeTagTableManager for: self presenter application) 
		tagTableFor: self presenter
]
