Class {
	#name : #GtkDiffAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Code-Diff'
}

{ #category : #factory }
GtkDiffAdapter >> buildWidget [

	^ GtkLabel newLabel: '@@TODO@@'
]

{ #category : #accessing }
GtkDiffAdapter >> leftLabel: aString [
]

{ #category : #accessing }
GtkDiffAdapter >> leftText: aString [

]

{ #category : #factory }
GtkDiffAdapter >> newSourceView [
			
	^ GtkSourceView new
		beWrapWord;
		showLineNumbers: true;
		autoIndent: true;
		yourself
]

{ #category : #accessing }
GtkDiffAdapter >> rightLabel: aString [
]

{ #category : #accessing }
GtkDiffAdapter >> rightText: aString [

]
