Class {
	#name : #GtkDiffAdapter,
	#superclass : #GtkPatchSideBySideAdapter,
	#instVars : [
		'leftText',
		'rightText'
	],
	#category : #'Spec-Gtk-Code-Diff'
}

{ #category : #adding }
GtkDiffAdapter >> addPatchTo: aView [
	
	leftText := self presenter leftText.
	rightText := self presenter rightText.
	self setPatch
]

{ #category : #accessing }
GtkDiffAdapter >> leftLabel: aString [
	"not supported"
]

{ #category : #accessing }
GtkDiffAdapter >> leftText: aString [

	leftText := aString.
	self innerWidgetDo: [ :w | self setPatch ]
]

{ #category : #accessing }
GtkDiffAdapter >> rightLabel: aString [
	"not supported"
]

{ #category : #accessing }
GtkDiffAdapter >> rightText: aString [

	rightText := aString.
	self innerWidgetDo: [ :w | self setPatch ]
]

{ #category : #initialization }
GtkDiffAdapter >> setPatch [
	| patch |

	patch := DiffBuilder 
		buildPatchFrom: (leftText ifNil: [ '' ]) lines 
		to: (rightText ifNil: [ '' ]) lines.
		
	self setPatch: patch
]
