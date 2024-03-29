Class {
	#name : #GtkPatchSideBySideAdapter,
	#superclass : #GtkAdapter,
	#instVars : [
		'leftSourceView',
		'rightSourceView'
	],
	#category : #'Spec-Gtk-Code-Diff'
}

{ #category : #adding }
GtkPatchSideBySideAdapter >> addMark: tagName line: lineNumber to: aTextBuffer [
	| start |

	start := aTextBuffer iterAtLine: lineNumber - 1.
	
	aTextBuffer 
		createSourceMarkNamed: ('{1}_{2}' format: { tagName. lineNumber }) 
		category: tagName 
		where: start
]

{ #category : #adding }
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

{ #category : #adding }
GtkPatchSideBySideAdapter >> addModelTo: aView [

	super addModelTo: aView.
	
	self addMarksTo: leftSourceView.
	self addMarksTo: rightSourceView.
	
	self addPatchTo: aView
]

{ #category : #adding }
GtkPatchSideBySideAdapter >> addPatchTo: aView [
	
	self setPatch.
	self presenter whenPatchChangedDo: [ :aPatch | self setPatch: aPatch ]
]

{ #category : #private }
GtkPatchSideBySideAdapter >> marks [
	
	^ self presenter marks
]

{ #category : #factory }
GtkPatchSideBySideAdapter >> newSourceView [

	^ GtkSourceView new
		beWrapWord;
		monospace: true;
		showLineNumbers: "self presenter hasLineNumbers" false;
		showLineMarks: true;
		editable: false;
		tabWidth: 4;
		yourself

]

{ #category : #factory }
GtkPatchSideBySideAdapter >> newWidget [

	leftSourceView := self newSourceView.
	rightSourceView := self newSourceView.
	
	^ GtkScrolledWindow new 
		add: (GtkBox newHorizontal 
			homogeneous: true;
			packStart: leftSourceView;
			packStart: rightSourceView;
			yourself);
		showAll
]

{ #category : #'private - accessing' }
GtkPatchSideBySideAdapter >> setPatch [

	(self presenter model isNil 
		or: [ self presenter model isEmpty ])
		ifTrue: [ 
			leftSourceView text: ''.
			rightSourceView text: ''. 
			^ self ].

	self setPatch: self presenter model patch
]

{ #category : #'private - accessing' }
GtkPatchSideBySideAdapter >> setPatch: patch [
	| visitor |
	
	visitor := GtkPatchSideBySideVisitor new 
		visitPatch: patch;
		yourself.	

	leftSourceView text: visitor leftText.
	visitor leftMarks do: [ :aMark | 
		self 
			addMark: aMark value 
			line: aMark key 
			to: leftSourceView textBuffer ].
	
	rightSourceView text: visitor rightText.
	visitor rightMarks do: [ :aMark | 
		self 
			addMark: aMark value 
			line: aMark key 
			to: rightSourceView textBuffer ]
]
