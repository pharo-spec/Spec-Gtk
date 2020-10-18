Class {
	#name : #SpecFormExample2,
	#superclass : #SpPresenter,
	#instVars : [
		'morph'
	],
	#category : #'Spec-Gtk-Examples'
}

{ #category : #specs }
SpecFormExample2 class >> defaultSpec [ 
	<spec: #default>
	
	^ SpBoxLayout newVertical
		add: #morph;
		yourself
]

{ #category : #examples }
SpecFormExample2 class >> show [ 
	<example>
	
	self new openWithSpec
]

{ #category : #examples }
SpecFormExample2 class >> showWithGtk [
	<example>
	
	SpBindings 
		value: GtkAdapterBindings new
		during: [ self new openWithSpec ]
]

{ #category : #initialization }
SpecFormExample2 >> initializeWidgets [
	
	morph := self newRoassalMorph asSpecAdapter
]

{ #category : #accessing }
SpecFormExample2 >> morph [
	^ morph
]

{ #category : #accessing }
SpecFormExample2 >> morph: anObject [
	morph := anObject
]

{ #category : #initialization }
SpecFormExample2 >> newRoassalMorph [
	| p b  |
	
	p := RTPalette c6.
	b := RTCircularTreeMapBuilder new.
	b shape
		color: p second;
		if: [ :cls | '*Array*' match: cls name ] fillColor: [ p first ];
		if: [ :cls | '*Dictionary*' match: cls name ] fillColor: [ p third ];
		if: [ :cls | '*Identity*' match: cls name ] fillColor: [ p fourth ];
		if: [ :cls | '*Set*' match: cls name ] fillColor: [ p fifth ].
	b
		baseradius: 200;
		weight: [ :cls | cls withAllSubclasses size ].
	b explore: Collection using: #subclasses.
	b build.
	
	^ b view setUpCanvas buildMorph
]
