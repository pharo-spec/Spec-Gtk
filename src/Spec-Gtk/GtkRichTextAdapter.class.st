Class {
	#name : 'GtkRichTextAdapter',
	#superclass : 'GtkTextAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkRichTextAdapter >> addTextTo: gtkTextView [
	| table attributes |
	table := GtkTextTagTable new.
	attributes := self model styleAttributes.
	attributes
		keysAndValuesDo: [ :name :value | 
			| tag |
			tag := GtkTextTag newName: name.
			value do: [ :attribute | attribute acceptTag: tag ].
			table add: tag ].
	gtkTextView textBuffer: (self bufferClass newTable: table).
	gtkTextView textBuffer connectChanged: [ self applyStyleTo: gtkTextView ].
	super addTextTo: gtkTextView
]

{ #category : 'building' }
GtkRichTextAdapter >> applyStyleTo: textBuffer [
	
	self halt
	"| tags visitor |
	
	visitor := GtkTextStyleTagsVisitor new.
	visitor styleProvider: self model styleAttributes.
	tags := visitor styleDocument: self model renderTree.
	tags do: [ :tag | tag acceptTextBuffer: textBuffer textBuffer ]"
]

{ #category : 'building' }
GtkRichTextAdapter >> setText: text to: gtkWidget [
	
	super 
		setText: self presenter plaintext 
		to: gtkWidget
]

{ #category : 'building' }
GtkRichTextAdapter >> widgetClass [

	^ GtkRichTextView
]
