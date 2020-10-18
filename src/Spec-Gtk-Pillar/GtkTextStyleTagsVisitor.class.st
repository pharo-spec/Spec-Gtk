Class {
	#name : #GtkTextStyleTagsVisitor,
	#superclass : #SpRenderTreeVisitor,
	#instVars : [
		'tags',
		'styleProvider',
		'offset'
	],
	#category : #'Spec-Gtk-Pillar'
}

{ #category : #initialization }
GtkTextStyleTagsVisitor >> initialize [ 
	super initialize.
	tags := OrderedCollection new.
	offset := 1.
]

{ #category : #'as yet unclassified' }
GtkTextStyleTagsVisitor >> styleDocument: aDocument [
	self visit: aDocument.
	^  tags
]

{ #category : #accessing }
GtkTextStyleTagsVisitor >> styleProvider: aProvider [
	styleProvider := aProvider
]

{ #category : #'as yet unclassified' }
GtkTextStyleTagsVisitor >> tags [
	^ tags
]

{ #category : #'as yet unclassified' }
GtkTextStyleTagsVisitor >> visitCompositeObject: aRenderObject [ 
	| name offsetStart result |
	"(aRenderObject item isKindOf: PRAnnotatedParagraph ) ifTrue: [ self halt. ]."
	name := styleProvider itemNameFor: aRenderObject item.
	offsetStart := offset.
	result := super visitCompositeObject: aRenderObject.
	name ifNotNil: [ 
		tags add: (GtkTextStyleTag 
			newName: name 
			from: offsetStart  
			to: offset - 1).].
	offset := offset + aRenderObject extraOffset
]

{ #category : #'as yet unclassified' }
GtkTextStyleTagsVisitor >> visitText: aTextObject [	
	| name offsetStart |

	name := styleProvider itemNameFor: aTextObject item.
	offsetStart := offset.
	offset := offset + aTextObject item text size.
	name ifNotNil: [ 
		tags add: (GtkTextStyleTag 
			newName: name 
			from: offsetStart  
			to: offset - 1).].
	offset := offset + aTextObject extraOffset.

]
