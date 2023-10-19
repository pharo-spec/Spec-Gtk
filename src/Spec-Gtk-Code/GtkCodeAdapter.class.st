Class {
	#name : 'GtkCodeAdapter',
	#superclass : 'GtkTextAdapter',
	#instVars : [
		'completionProvider',
		'lastPopover',
		'userAction'
	],
	#category : 'Spec-Gtk-Code-Base',
	#package : 'Spec-Gtk-Code',
	#tag : 'Base'
}

{ #category : 'building' }
GtkCodeAdapter >> addModelTo: gtkTextView [ 

	self addSourceFeaturesTo: gtkTextView.	
	self addSmartCharactersTo: gtkTextView.
	super addModelTo: gtkTextView
]

{ #category : 'building' }
GtkCodeAdapter >> addMonospaceStyleFor: gtkTextView [

	gtkTextView addClass: 'code'
]

{ #category : 'building' }
GtkCodeAdapter >> addSmartCharactersTo: gtkTextView [
	
	gtkTextView addKeyPressEvent: [ :event | 
		self handleSmartCharacters: event ]
]

{ #category : 'building' }
GtkCodeAdapter >> addSourceCompletionProviderTo: gtkSourceView [

	gtkSourceView completion
		showHeaders: false;
		showIcons: true;
		addProvider: (completionProvider := GtkPharoSourceCompletionProvider new
			completionEngine: (self newCompletionEngine: self presenter interactionModel);
			yourself)
]

{ #category : 'building' }
GtkCodeAdapter >> addSourceFeaturesTo: gtkSourceView [

	self flag: #TODO. "Find a better way to validate this"
	(gtkSourceView isKindOf: GtkSourceView) ifFalse: [ ^ self ].
	  
	self flag: #TODO. "All this needs to come from settings"
	gtkSourceView 
		showLineNumbers: self presenter hasLineNumbers;
		autoIndent: true;
		indentOnTab: true;
		tabWidth: 4.

	self presenter interactionModel ifNotNil: [
		self addSourceCompletionProviderTo: gtkSourceView ].
	
	self presenter whenLineNumbersChangedDo: [ :hasLineNumbers |
		gtkSourceView showLineNumbers: hasLineNumbers ]
]

{ #category : 'building' }
GtkCodeAdapter >> addTextBufferTo: gtkTextView [

	"this is solved in #newTextBufferForText:"
]

{ #category : 'api - segments' }
GtkCodeAdapter >> addTextSegmentDecoration: aDecoration [
	
	self innerWidgetDo: [ :w | 
		w textBuffer 
			applyTagByName: 'highlight' 
			start: aDecoration start - 1 
			end: aDecoration stop ]
]

{ #category : 'building' }
GtkCodeAdapter >> addTextTo: gtkTextView [
	
	"gtkTextView monospace: true."
	self addMonospaceStyleFor: gtkTextView.
	super addTextTo: gtkTextView
]

{ #category : 'visiting' }
GtkCodeAdapter >> applyFullStyleTo: textBuffer [

	"If I am in an user action, I will not do anything now, just register for change (it 
	 will be executed later)."
	self userActionDo: [ :anUserAction | 
		anUserAction registerChange.
		^ self ].

	textBuffer userActionDuring: [ 
		self applyStyleTo: textBuffer ]
]

{ #category : 'visiting' }
GtkCodeAdapter >> applyStyleTo: textBuffer [

	self presenter hasSyntaxHighlight ifFalse: [ ^ self ].
	self presenter text isEmptyOrNil ifTrue: [ ^ self ].
	textBuffer removeAllTags.
	(self isScripting or: [ self behavior isNil ])
		ifTrue: [
			self 
				setExpressionText: textBuffer text 
				class: self behavior 
				toBuffer: textBuffer  ]
		ifFalse: [ 
			self 
				setMethodText: textBuffer text 
				class: self behavior 
				toBuffer: textBuffer ]
]

{ #category : 'api - shout' }
GtkCodeAdapter >> behavior [

	^ self presenter behavior
]

{ #category : 'api - shout' }
GtkCodeAdapter >> bindingOf: aString [

	^ self presenter bindingOf: aString
]

{ #category : 'building' }
GtkCodeAdapter >> bufferClass [

	^ GtkSourceViewLibrary uniqueInstance isAvailable 
		ifTrue: [ GtkSourceBuffer ]
		ifFalse: [ super bufferClass ]
]

{ #category : 'private - shout' }
GtkCodeAdapter >> classOrMetaClass: aClass [
	"I will take the behavior from model, I just need to fire a refresh"

	self innerWidgetDo: [ :w | 
		self applyFullStyleTo: w textBuffer ].
	self updateCompletionProvider
]

{ #category : 'api - shout' }
GtkCodeAdapter >> doItContext [ 

	^ self presenter doItContext
]

{ #category : 'api - shout' }
GtkCodeAdapter >> doItReceiver [

	^ self presenter doItReceiver
]

{ #category : 'building' }
GtkCodeAdapter >> handleSmartCharacters: event [
	| char selection |
		
	char := event character.
	(self presenter hasSmartCharacters 
		and: [ (GtkCodeSmartCharacters allChars includes: char)  
		and: [ (selection := self selection) notEmpty ] ])
		ifTrue: [ 
			self userActionDuring: [
				(GtkCodeSmartCharacters findMatching: char) 
					applyTo: self innerWidget 
					in: selection ].
			true ]
		ifFalse: [ 
			false ]
]

{ #category : 'api - shout' }
GtkCodeAdapter >> hasBindingOf: aString [

	^ self presenter hasBindingOf: aString
]

{ #category : 'api - shout' }
GtkCodeAdapter >> hasBindingThatBeginsWith: aString [

	^ self presenter hasBindingThatBeginsWith: aString
]

{ #category : 'api' }
GtkCodeAdapter >> hasSyntaxHighlightEnabled [
	"this is used just for testing"
	
	^ self presenter hasSyntaxHighlight
]

{ #category : 'api - search' }
GtkCodeAdapter >> highlightSearchText: aBoolean [ 

	self innerWidgetDo: [ :w |
		w textBuffer searchContext highlight: aBoolean ]
]

{ #category : 'api' }
GtkCodeAdapter >> insertPopoverAfterCurrentSelection: aPresenter style: styleName [

	self innerWidgetDo: [ :w | | endIter |

		lastPopover := self presenter newPopover
			bePositionRight;
			presenter: aPresenter;
			yourself.

		styleName ifNotNil: [ 
			lastPopover addStyle: styleName ].
		
		lastPopover build.

		endIter := w textBuffer 
			selectionIteratorsDo: [ :start :end | end ] 
			ifNone: [ w textBuffer iterAtOffset: w textBuffer cursorPosition ].
		"18@0 is a magic number to place the popover where I want. 
		 Not cool, but hard to do better :( "
		lastPopover popupPointingTo: ((w iterLocation: endIter) translateBy: (18@0)).
		lastPopover takeKeyboardFocus ]
]

{ #category : 'api' }
GtkCodeAdapter >> interactionModel: anInteractionModel [

	self classOrMetaClass: anInteractionModel behavior
]

{ #category : 'api - shout' }
GtkCodeAdapter >> isScripting [

	^ self presenter isScripting
]

{ #category : 'private - factory' }
GtkCodeAdapter >> newCompletionEngine: anInteractionModel [

	^ GtkCodeCompletionEngine new 
		scripting: anInteractionModel isScripting;
		doItRequestor: anInteractionModel;
		doItContext: anInteractionModel doItContext;
		completionClass: anInteractionModel selectedClassOrMetaClass;
		yourself
]

{ #category : 'private - factory' }
GtkCodeAdapter >> newTagTable [
	
	self flag: #TODO. "highlight color in a setting"
	^ (GtkTextTagTable newForCode: self styleTable)
		add: ((GtkTextTag newName: 'highlight')
			background: (Color orange alpha: 0.2);
			yourself);
		yourself
]

{ #category : 'private - factory' }
GtkCodeAdapter >> newTextBuffer [

	^ self bufferClass new
]

{ #category : 'private - factory' }
GtkCodeAdapter >> newTextBufferForHighlight [
	| textBuffer |

	textBuffer := self bufferClass newTable: self newTagTable.
	textBuffer connectChanged: [ 
		self applyFullStyleTo: textBuffer ].

	^ textBuffer
]

{ #category : 'private - factory' }
GtkCodeAdapter >> newTextBufferForText: aString [
	| textBuffer |

	"add style table"
	textBuffer := self model hasSyntaxHighlight 
		ifTrue: [ self newTextBufferForHighlight ]
		ifFalse: [ self newTextBuffer ].

	textBuffer styleScheme: self styleScheme.

	aString ifNotNil: [ 
		textBuffer text: aString ].

	self presenter hasUndoRedoHistory 
		ifTrue: [ textBuffer infiniteUndoLevels ]
 		ifFalse: [ textBuffer disableUndo ].
	
	textBuffer highlightMatchingBrackets: true.

	textBuffer connectChanged: [
		self backendDetectCyclesDo: [ 
			self innerWidgetDo: [ :w | self updatePresenterText: w text ] ] ].

	^ textBuffer
]

{ #category : 'interactive error protocol' }
GtkCodeAdapter >> notify: aString at: aNumber in: anObject [
	
	self flag: #TODO. "What to do here?"
]

{ #category : 'api' }
GtkCodeAdapter >> refreshStyling [

	self presenter hasSyntaxHighlight ifFalse: [ ^ self ].
	self innerWidgetDo: [ :w | 
		self applyStyleTo: w textBuffer ]
]

{ #category : 'api - segments' }
GtkCodeAdapter >> removeAllTextSegmentDecorations [
	
	self flag: #TODO.
]

{ #category : 'private' }
GtkCodeAdapter >> scrollToIter: iter in: gtkWidget [

	gtkWidget 
		scrollToIter: iter 
		withinMargin: 0.25
		useAlign: false 
		xalign: 0.0 
		yalign: 0.0 
]

{ #category : 'api - search' }
GtkCodeAdapter >> searchBackward [

	self innerWidgetDo: [ :w |
		| buffer |
		buffer := w textBuffer.
		buffer searchContext 
			backwardThenDo: [ :start :end :wrappedAround | 
				buffer
					selectRangeInsert: start 
					bound: end ] ]
]

{ #category : 'api - search' }
GtkCodeAdapter >> searchForward [

	self innerWidgetDo: [ :w |
		| buffer |
		buffer := w textBuffer.
		buffer searchContext 
			forwardThenDo: [ :start :end :wrappedAround | 
				buffer selectRangeInsert: start bound: end.
				self scrollToIter: start in: w ] ]
]

{ #category : 'api - search' }
GtkCodeAdapter >> searchText: aString [

	self innerWidgetDo: [ :w | | searchContext |
		searchContext := w textBuffer searchContext.
		searchContext searchText: aString.
		self startSearch: searchContext ]
]

{ #category : 'api - shout' }
GtkCodeAdapter >> selectedClassOrMetaClass [

	^ self presenter selectedClassOrMetaClass
]

{ #category : 'private - shout' }
GtkCodeAdapter >> setExpressionText: aString class: aClass toBuffer: textBuffer [ 

	(GtkTextStyleVisitor new 
		requestor: self;
		contextClass: aClass;
		styleExpression: aString)
		do: [ :each | each acceptTextBuffer: textBuffer ].

]

{ #category : 'private - shout' }
GtkCodeAdapter >> setMethodText: aString class: aClass toBuffer: textBuffer [ 

	(GtkTextStyleVisitor new
		requestor: self; 
		contextClass: aClass;
		styleMethod: aString)
		do: [ :each | each acceptTextBuffer: textBuffer ].

]

{ #category : 'building' }
GtkCodeAdapter >> setText: aString to: gtkWidget [

	self backendDetectCyclesDo: [
		| textBuffer |
		textBuffer := self newTextBufferForText: aString.
		gtkWidget textBuffer: textBuffer.
		self userActionDo: [ :action | action registerChange ] ]
]

{ #category : 'private' }
GtkCodeAdapter >> startSearch: aSearchContext [
	| start |

	self flag: #TODO. "maybe start this from cursor position"
	start := self innerWidget textBuffer startIter.
	aSearchContext 
		forwardAsync: start 
		onFirstPositionDo: [ :matchStart :matchEnd |
			self scrollToIter: matchStart in: self innerWidget ]
]

{ #category : 'private' }
GtkCodeAdapter >> styleScheme [
	| schemeName |

	schemeName := self presenter styleScheme 
		ifNil: [ self presenter application styleScheme ]. 
	^ GtkSourceStyleSchemeManager default schemeWithId: schemeName
]

{ #category : 'private - factory' }
GtkCodeAdapter >> styleTable [
	| styleTableName |	

	styleTableName := self presenter syntaxHighlightTheme 	
		ifNil: [ 
			self presenter application 
				propertyAt: #syntaxHighlightTheme 
				ifAbsent: [ 
					"answer the default"
					^ SHRBTextStyler newAttributesForStyleTable: SHRBTextStyler styleTable ] ].

	^ SHRBTextStyler newAttributesForStyleTableNamed: styleTableName
]

{ #category : 'private' }
GtkCodeAdapter >> textWithStyle [

	^ self innerWidget textBuffer asText
]

{ #category : 'private - shout' }
GtkCodeAdapter >> updateCompletionProvider [	
	
	completionProvider ifNotNil: [ :p | 
		p completionEngine completionClass: self behavior ]
]

{ #category : 'private' }
GtkCodeAdapter >> userActionDo: aBlock [

	userAction ifNil: [ ^ self ].
	aBlock value: userAction
]

{ #category : 'api' }
GtkCodeAdapter >> userActionDuring: aBlock [

	userAction := GtkCodeUserAction new.
	self innerWidgetDo: [ :w |
		w textBuffer 
			blockCallback: GChangedCallback signalName 
			during: [ 
				w textBuffer userActionDuring: aBlock.
				userAction hasChanged ifTrue: [
					userAction := nil.
					self applyFullStyleTo: w textBuffer ] ] ].
]

{ #category : 'building' }
GtkCodeAdapter >> widgetClass [

	^ GtkSourceViewLibrary uniqueInstance isAvailable 
		ifTrue: [ GtkSourceView ]
		ifFalse: [ super widgetClass ]
]
