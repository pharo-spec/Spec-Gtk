Class {
	#name : #GtkPatchLineVisitor,
	#superclass : #DiffPatchVisitor,
	#instVars : [
		'lineNumber',
		'textBuffer',
		'lineMarks'
	],
	#category : #'Spec-Gtk-Code-Diff'
}

{ #category : #accessing }
GtkPatchLineVisitor >> addLineMark: anAssociation [

	lineMarks add: anAssociation
]

{ #category : #'as yet unclassified' }
GtkPatchLineVisitor >> incrementLineNumber [

	lineNumber := lineNumber + 1
]

{ #category : #initialization }
GtkPatchLineVisitor >> initialize [

	super initialize.
	lineNumber := 0.
	lineMarks := OrderedCollection new
]

{ #category : #accessing }
GtkPatchLineVisitor >> lineMarks [

	^ lineMarks
]

{ #category : #accessing }
GtkPatchLineVisitor >> lineNumber [

	^ lineNumber
]

{ #category : #accessing }
GtkPatchLineVisitor >> textBuffer [

	^ textBuffer
]

{ #category : #accessing }
GtkPatchLineVisitor >> textBuffer: anObject [

	textBuffer := anObject
]

{ #category : #visiting }
GtkPatchLineVisitor >> visitDelete: anElement [

	self incrementLineNumber.
	self addLineMark: lineNumber -> #delete.
	stream << anElement element << String cr
]

{ #category : #visiting }
GtkPatchLineVisitor >> visitInsert: anElement [

	self incrementLineNumber.
	self addLineMark: lineNumber -> #insert.
	stream << anElement element << String cr
]

{ #category : #visiting }
GtkPatchLineVisitor >> visitMatch: anElement [

	self incrementLineNumber.
	stream << anElement element << String cr
]
