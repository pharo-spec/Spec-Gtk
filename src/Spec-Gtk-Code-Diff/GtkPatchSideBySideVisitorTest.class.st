Class {
	#name : #GtkPatchSideBySideVisitorTest,
	#superclass : #TestCase,
	#category : #'Spec-Gtk-Code-Diff'
}

{ #category : #tests }
GtkPatchSideBySideVisitorTest >> testPatchIncludesLastLine [
	| patch visitor fileA fileB |

	fileA := 'newSourceView
			
	^ GtkSourceView new
		beWrapWord;
		showLineNumbers: true;
		autoIndent: true;
		yourself'.

	fileB := 'newSourceView

	^ GtkSourceView new
		beWrapWord;
		monospace: true;
		showLineNumbers: "self presenter hasLineNumbers" false;
		showLineMarks: true;
		autoIndent: true;
		indentOnTab: true;
		tabWidth: 4;
		yourself'.

	patch := DiffBuilder 
		buildPatchFrom: fileA lines
		to: fileB lines.
	
	visitor := GtkPatchSideBySideVisitor new.
	patch accept: visitor.

	self assert: visitor leftText lines last trimmed equals: 'yourself'.
	self assert: visitor rightText lines last trimmed equals: 'yourself'.

]
