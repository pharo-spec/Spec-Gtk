"
A model to process smart characters in the code editor.
""Smart characters"" are the auto enclosing characters (like, it adds comments when you press "" and you have something selected).  
"
Class {
	#name : 'GtkCodeSmartCharacters',
	#superclass : 'Object',
	#instVars : [
		'open',
		'close'
	],
	#classVars : [
		'AllChars',
		'SmartCharsTable'
	],
	#category : 'Spec-Gtk-Code-Base',
	#package : 'Spec-Gtk-Code',
	#tag : 'Base'
}

{ #category : 'accessing' }
GtkCodeSmartCharacters class >> allChars [

	^ AllChars ifNil: [ 
		AllChars := self smartCharsTable flatCollect: [ :each | each pairs ] ]
]

{ #category : 'private' }
GtkCodeSmartCharacters class >> createSmartCharsTable [

	^ {
		self newOpen: $( close: $).
		self newOpen: ${ close: $}.
		self newOpen: $< close: $>.
		self newOpen: $[ close: $].
		self newEnclosing: $".
		self newEnclosing: $'.
		self newEnclosing: $|.
	}
]

{ #category : 'accessing' }
GtkCodeSmartCharacters class >> findMatching: aChar [ 

	^ self smartCharsTable detect: [ :each | each matches: aChar ]
]

{ #category : 'instance creation' }
GtkCodeSmartCharacters class >> newEnclosing: aChar [

	^ self newOpen: aChar close: nil
]

{ #category : 'instance creation' }
GtkCodeSmartCharacters class >> newOpen: openChar close: closeChar [

	^ self new 
		open: openChar close: closeChar;
		yourself
]

{ #category : 'accessing' }
GtkCodeSmartCharacters class >> reset [
	<script>
	
	SmartCharsTable := nil.
	AllChars := nil
]

{ #category : 'accessing' }
GtkCodeSmartCharacters class >> smartCharsTable [

	^ SmartCharsTable ifNil: [ 
		SmartCharsTable := self createSmartCharsTable ]
]

{ #category : 'applying' }
GtkCodeSmartCharacters >> applyTo: gtkTextView in: selection [
	| buffer |

	buffer := gtkTextView textBuffer.
	buffer 
		insertText: (close ifNil: [ open ]) asString at: selection last;
		insertText: open asString at: selection first - 1
]

{ #category : 'testing' }
GtkCodeSmartCharacters >> matches: aChar [ 

	^ open = aChar or: [ close = aChar ]
]

{ #category : 'initialization' }
GtkCodeSmartCharacters >> open: openChar close: closeChar [

	open := openChar.
	close := closeChar
]

{ #category : 'accessing' }
GtkCodeSmartCharacters >> pairs [

	^ close 
		ifNotNil: [ { open. close } ]
		ifNil: [ { open } ]
]

{ #category : 'as yet unclassified' }
GtkCodeSmartCharacters >> printOn: stream [

	super printOn: stream.
	stream << '(' << self pairs asString << ')'
]
