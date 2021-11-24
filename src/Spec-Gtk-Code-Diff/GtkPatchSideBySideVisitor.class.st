Class {
	#name : #GtkPatchSideBySideVisitor,
	#superclass : #DiffVisitor,
	#instVars : [
		'leftSide',
		'rightSide'
	],
	#category : #'Spec-Gtk-Code-Diff'
}

{ #category : #initialization }
GtkPatchSideBySideVisitor >> initialize [

	super initialize.
	leftSide := OrderedCollection new.
	rightSide := OrderedCollection new
]

{ #category : #accessing }
GtkPatchSideBySideVisitor >> leftMarks [

	^ self leftSide 
		reject: [ :each | each first isNil ]
		thenCollect: [ :each | each first ]
]

{ #category : #accessing }
GtkPatchSideBySideVisitor >> leftSide [

	^ leftSide
]

{ #category : #accessing }
GtkPatchSideBySideVisitor >> leftText [

	^ (self leftSide collect: #second) asStringWithCr
]

{ #category : #accessing }
GtkPatchSideBySideVisitor >> rightMarks [

	^ self rightSide 
		reject: [ :each | each first isNil ] 
		thenCollect: [ :each | each first ]
]

{ #category : #accessing }
GtkPatchSideBySideVisitor >> rightSide [

	^ rightSide
]

{ #category : #accessing }
GtkPatchSideBySideVisitor >> rightText [

	^ (self rightSide collect: #second) asStringWithCr
]

{ #category : #visiting }
GtkPatchSideBySideVisitor >> visitDelete: anElement [

	leftSide add: { ((leftSide size + 1) -> #delete). anElement element }
]

{ #category : #visiting }
GtkPatchSideBySideVisitor >> visitInsert: anElement [

	rightSide add: { ((rightSide size + 1) -> #insert). anElement element }
]

{ #category : #visiting }
GtkPatchSideBySideVisitor >> visitMatch: anElement [

	leftSide add: { nil. anElement element }.
	rightSide add: { nil. anElement element }
]
