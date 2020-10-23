Class {
	#name : #SpecFormExample,
	#superclass : #SpPresenter,
	#instVars : [
		'textInputLabel',
		'textInput',
		'numberInputLabel',
		'numberInput',
		'textAreaLabel',
		'textArea',
		'checkBoxLabel',
		'checkBox'
	],
	#category : #'Spec-Gtk-Examples'
}

{ #category : #specs }
SpecFormExample class >> defaultSpec [ 
	<spec: #grid>
	
	^ SpGridLayout new 
		add: #textInputLabel 				at: 1@1;
		add: #textInput 					at: 2@1;
		add: #numberInputLabel 			at: 1@2;
		add: #numberInput 					at: 2@2;
		add: #textAreaLabel 				at: 1@3;
		add: #textArea 						at: 2@3 span: 1@2;
		add: #checkBoxLabel 				at: 1@5;
		add: #checkBox 						at: 2@5;
		yourself
]

{ #category : #examples }
SpecFormExample class >> show [ 
	<example>
	
	self new openWithSpec
]

{ #category : #'accessing ui' }
SpecFormExample >> checkBox [
	^ checkBox
]

{ #category : #'accessing ui' }
SpecFormExample >> checkBox: anObject [
	checkBox := anObject
]

{ #category : #'accessing ui' }
SpecFormExample >> checkBoxLabel [
	^ checkBoxLabel
]

{ #category : #'accessing ui' }
SpecFormExample >> checkBoxLabel: anObject [
	checkBoxLabel := anObject
]

{ #category : #initialization }
SpecFormExample >> initializeWidgets [
	
	textInputLabel := self newLabel label: 'Text input'.
	textInput := self newTextInput 
		placeholder: 'a ghost text'.
		
	numberInputLabel := self newLabel label: 'Number input'.
	numberInput := self newNumberInput 
		placeholder: 'a ghost number';
		beFloat;
		rangeMinimum: 0 maximum: 1000000.

	textAreaLabel := self newLabel label: 'Text area'.
	textArea := self newText.

	checkBoxLabel := self newLabel label: 'Check box'.
	checkBox := self newCheckBox
		label: 'Mark this'.
	
	self focusOrder 
		add: self textInput;
		add: self numberInput;
		add: self textArea;
		add: self checkBox
]

{ #category : #'accessing ui' }
SpecFormExample >> numberInput [
	^ numberInput
]

{ #category : #'accessing ui' }
SpecFormExample >> numberInput: anObject [
	numberInput := anObject
]

{ #category : #'accessing ui' }
SpecFormExample >> numberInputLabel [
	^ numberInputLabel
]

{ #category : #'accessing ui' }
SpecFormExample >> numberInputLabel: anObject [
	numberInputLabel := anObject
]

{ #category : #'accessing ui' }
SpecFormExample >> textArea [
	^ textArea
]

{ #category : #'accessing ui' }
SpecFormExample >> textArea: anObject [
	textArea := anObject
]

{ #category : #'accessing ui' }
SpecFormExample >> textAreaLabel [
	^ textAreaLabel
]

{ #category : #'accessing ui' }
SpecFormExample >> textAreaLabel: anObject [
	textAreaLabel := anObject
]

{ #category : #'accessing ui' }
SpecFormExample >> textInput [
	^ textInput
]

{ #category : #'accessing ui' }
SpecFormExample >> textInput: anObject [
	textInput := anObject
]

{ #category : #'accessing ui' }
SpecFormExample >> textInputLabel [
	^ textInputLabel
]

{ #category : #'accessing ui' }
SpecFormExample >> textInputLabel: anObject [
	textInputLabel := anObject
]
