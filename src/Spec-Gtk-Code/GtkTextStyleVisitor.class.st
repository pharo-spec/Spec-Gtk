Class {
	#name : 'GtkTextStyleVisitor',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'parentheseLevel',
		'bracketLevel',
		'requestor',
		'contextClass',
		'tags'
	],
	#category : 'Spec-Gtk-Code-Base',
	#package : 'Spec-Gtk-Code',
	#tag : 'Base'
}

{ #category : 'private' }
GtkTextStyleVisitor >> addStyle: style from: start to: end [ 
	
	tags add: (GtkTextStyleTag newName: style from: start to: end)
]

{ #category : 'accessing' }
GtkTextStyleVisitor >> contextClass: aClass [

	contextClass := aClass
]

{ #category : 'private' }
GtkTextStyleVisitor >> currentClosedBracketStyleName [
	
	bracketLevel isZero ifTrue: [ ^ #blockEnd ].
	^ (#blockEnd asString, bracketLevel asString) asSymbol
]

{ #category : 'private' }
GtkTextStyleVisitor >> currentClosedParenthesisStyleName [

	parentheseLevel isZero ifTrue: [ ^ #rightParenthesis ].
	^ (#rightParenthesis asString, parentheseLevel asString) asSymbol
]

{ #category : 'private' }
GtkTextStyleVisitor >> currentOpenedBracketStyleName [

	bracketLevel isZero ifTrue: [ ^ #blockStart ].
	^ (#blockStart asString, bracketLevel asString) asSymbol
]

{ #category : 'private' }
GtkTextStyleVisitor >> currentOpenedParenthesisStyleName [

	parentheseLevel isZero ifTrue: [ ^ #leftParenthesis ].
	^ (#leftParenthesis asString, parentheseLevel asString) asSymbol
]

{ #category : 'private' }
GtkTextStyleVisitor >> literalStyleSymbol: aValue [

	aValue isSymbol 		ifTrue: [ ^ #symbol ].
	aValue isString 		ifTrue: [ ^ #string ].
	aValue isCharacter 	ifTrue: [ ^ #character ].
	aValue isNumber 		ifTrue: [ ^ #number ].
	aValue == true 			ifTrue: [ ^ #true ].
	aValue == false 		ifTrue: [ ^ #false ].
	aValue isNil 			ifTrue: [ ^ #nil ].

	^ #default
]

{ #category : 'private' }
GtkTextStyleVisitor >> methodOrBlockArgStyleFor: aRBArgumentNode [ 
	
	^ aRBArgumentNode isDefinedByBlock
		ifTrue: [ 
			aRBArgumentNode isDefinition 
				ifTrue: [ #blockPatternArg ]
				ifFalse: [ #blockArg ] ]
		ifFalse: [ 
			#methodArg ]
]

{ #category : 'private' }
GtkTextStyleVisitor >> methodOrBlockTempDeclStyleFor: aSequenceNode [
	
	^ aSequenceNode scope isBlockScope
		ifTrue: [ #blockPatternTempVar ]
		ifFalse: [ #patternTempVar ]
]

{ #category : 'private' }
GtkTextStyleVisitor >> methodOrBlockTempStyleFor: aRBTemporaryNode [

	^ aRBTemporaryNode isDefinedByBlock
		  ifTrue: [ #blockTempVar ]
		  ifFalse: [ #tempVar ]
]

{ #category : 'styling' }
GtkTextStyleVisitor >> processOverlapedTags [
	"Seems that GtkSourceView does not process fine the fact that some tags may be overlapped"
	
]

{ #category : 'accessing' }
GtkTextStyleVisitor >> requestor: anObject [

	requestor := anObject
]

{ #category : 'private' }
GtkTextStyleVisitor >> reset [
	
	tags := OrderedCollection new.
	parentheseLevel := 0.
	bracketLevel := 0
]

{ #category : 'private' }
GtkTextStyleVisitor >> resolveStyleFor: aVariableNode [

	aVariableNode binding 						ifNil:  [ ^ #default].
	aVariableNode isArgumentVariable 			ifTrue: [ ^ #methodArg].
	aVariableNode isTempVariable 				ifTrue: [ ^ #tempVar].
	aVariableNode isGlobalVariable 			ifTrue: [ ^ #globalVar].
	"here we should add support for #classVar"
	aVariableNode isClassVariable 				ifTrue: [ ^ #globalVar].
	aVariableNode isInstanceVariable 			ifTrue: [ ^ #instVar]. 
	"for now we use temp variable here, we could now color them with their own color"
	aVariableNode isWorkspaceVariable 		ifTrue: [ ^ #tempVar]. 
	aVariableNode hasIncompleteIdentifier 	ifTrue: [ ^ #incompleteIdentifier ].

	^ #invalid
]

{ #category : 'styling' }
GtkTextStyleVisitor >> styleAST: ast [

	self reset.
	ast acceptVisitor: self
]

{ #category : 'private' }
GtkTextStyleVisitor >> styleCloseBracket: aRBBlockNode [ 
	
	bracketLevel := bracketLevel - 1.
	(aRBBlockNode right isZero or: [ aRBBlockNode value isNil ]) ifTrue:[ ^ self ].
	self 
		addStyle: self currentClosedBracketStyleName 
		from: aRBBlockNode right 
		to: aRBBlockNode right
]

{ #category : 'private' }
GtkTextStyleVisitor >> styleCloseParenthese: aMessageNode [
	
	aMessageNode parentheses ifNotEmpty: [ 
		aMessageNode parentheses reverseDo: [ :interval | 
			| pos |
			pos := interval last.
			parentheseLevel := parentheseLevel - 1.
			self addStyle: self currentClosedParenthesisStyleName from: pos to: pos ] ]
]

{ #category : 'styling' }
GtkTextStyleVisitor >> styleExpression: aString [
	| ast |

	ast := (contextClass ifNil: [ UndefinedObject ]) compiler
		source: aString;
		noPattern: true;
		options:  #(+ optionParseErrors + optionSkipSemanticWarnings);
		requestor: requestor;
		parse.				

	self styleAST: ast.
	
	^ self tags
]

{ #category : 'styling' }
GtkTextStyleVisitor >> styleMethod: aString [
	| ast |

	ast := (contextClass ifNil: [ UndefinedObject ]) compiler
       source: aString;
       isScripting: false;
       requestor: nil;
       failBlock: [ ^ nil ];
       options: #( #+ optionParseErrors #+ optionSkipSemanticWarnings );
       parse.

	self styleAST: ast.

	self processOverlapedTags.

	^ self tags
]

{ #category : 'private' }
GtkTextStyleVisitor >> styleOpenBracket: aRBBlockNode [
	| style |

	style := aRBBlockNode isFaulty
		ifTrue: [ #invalid ]
		ifFalse: [ self currentOpenedBracketStyleName ].
	self addStyle: style from: aRBBlockNode left to: aRBBlockNode left.
	bracketLevel := bracketLevel + 1
]

{ #category : 'private' }
GtkTextStyleVisitor >> styleOpenParenthese: aMessageNode [
	
	aMessageNode parentheses ifNotEmpty: [ 
		aMessageNode parentheses
			do: [ :interval | 
				| pos |
				pos := interval first.
				self addStyle:  self currentOpenedParenthesisStyleName from: pos to: pos.
				parentheseLevel := parentheseLevel + 1 ] ]
]

{ #category : 'private' }
GtkTextStyleVisitor >> styleTempBars: aRBSequenceNode [ 
	| tempBarAttribute |

	tempBarAttribute := aRBSequenceNode scope isMethodScope
		ifTrue: [ #methodTempBar ]
		ifFalse: [ #blockTempBar ].
	aRBSequenceNode leftBar ifNotNil: [ :pos | 
		self addStyle: tempBarAttribute from: pos to: pos ].
	aRBSequenceNode rightBar ifNotNil: [ :pos | 
		self addStyle: tempBarAttribute from: pos to: pos ]
]

{ #category : 'private' }
GtkTextStyleVisitor >> styleVariable: aVariableNode [
		
	self flag: #TODO. "Here we can add link attributes (to inspect, etc.) 
	or other ways of complement variables"
]

{ #category : 'accessing' }
GtkTextStyleVisitor >> tags [

	^ tags
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitArgumentNode: aRBArgumentNode [ 
	| blockOrMethodArgStyle |
	
	blockOrMethodArgStyle := self methodOrBlockArgStyleFor: aRBArgumentNode.
	self 
		addStyle: blockOrMethodArgStyle 
		from: aRBArgumentNode start
		to: aRBArgumentNode stop
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitArrayNode: anArrayNode [ 

	anArrayNode children do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitAssignmentNode: aRBAssignmentNode [

	self visitNode: aRBAssignmentNode variable.
	self visitNode: aRBAssignmentNode value.
	aRBAssignmentNode variable binding isWritable
		ifFalse: [ self addStyle: #invalid forNode: aRBAssignmentNode ]
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitBlockNode: aRBBlockNode [ 

	aRBBlockNode comments do: [ :comment | self addStyle: #comment from: comment start to: comment stop ].
	aRBBlockNode arguments do: [ :argument | self addStyle: #blockPatternArg from: argument start to: argument stop ].
	aRBBlockNode bar ifNotNil: [ :pos | self addStyle: #blockArgsBar from: pos to: pos ].
	aRBBlockNode colons do: [ :pos | self addStyle: #blockArgColon from: pos to: pos ].
	
	self styleOpenBracket: aRBBlockNode.
	self visitNode: aRBBlockNode body.
	self styleCloseBracket: aRBBlockNode
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitCascadeNode: aRBCascadeNode [

	aRBCascadeNode messages do: [ :each | self visitNode: each ].
	aRBCascadeNode semicolons do: [ :pos | self addStyle: #cascadeSeparator from: pos to: pos ]
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitEnglobingErrorNode: aRBUnfinishedStatementErrorNode [
	self flag: #TODO. "here the best is to add a marker in the border?" 
	self visitParseErrorNode: aRBUnfinishedStatementErrorNode
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitGlobalNode: aRBGlobalNode [

	^ self visitVariableNode: aRBGlobalNode
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitLiteralArrayNode: aRBLiteralArrayNode [
	"in a (valid) byte array all elements are of the same type, style the whole 
	 contents at once, but for ordinary literal arrays, style every node"

	(aRBLiteralArrayNode isForByteArray 
		and: [ aRBLiteralArrayNode isFaulty not 
		and: [ aRBLiteralArrayNode contents isNotEmpty ] ]) 
		ifTrue: [ 
			self addStyle: #number 
				from: aRBLiteralArrayNode start + 2 
				to: aRBLiteralArrayNode stop - 1 ]
		ifFalse: [ 
			aRBLiteralArrayNode contents do: [ :each | self visitNode: each ] ]
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitLiteralNode: aRBLiteralValueNode [ 
	| value |
	
	value := aRBLiteralValueNode value.
	self 
		addStyle: (self literalStyleSymbol: value)
		from: aRBLiteralValueNode start
		to: aRBLiteralValueNode stop
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitMessageNode: aRBMessageNode [ 
	| style |
	
	style := #keyword.
	aRBMessageNode selector isSelectorSymbol 
		ifFalse: [ 
			style := (Symbol selectorThatStartsCaseSensitive: aRBMessageNode selector asString skipping: nil) isNil
				ifTrue: [ #undefinedKeyword ]
				ifFalse: [ #incompleteKeyword ] ].

	self styleOpenParenthese: aRBMessageNode.
	aRBMessageNode selectorParts
		with: aRBMessageNode keywordsPositions
		do: [ :keyword :position | 
			self
				addStyle: style
				from: position
				to: position + keyword size - 1 ].
	(aRBMessageNode isCascaded not or: [ aRBMessageNode isFirstCascaded ])
		ifTrue: [ self visitNode: aRBMessageNode receiver ].
	aRBMessageNode arguments do: [ :each | self visitNode: each ].
	self styleCloseParenthese: aRBMessageNode
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitMethodArguments: arguments [ 

	arguments ifEmpty: [ ^ self ].
	arguments do: [ :argument | 
		self 
			addStyle: #patternArg 
			from: argument start
			to: argument stop ]
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitMethodComments: comments [

	comments do: [ :comment | self addStyle: #comment from: comment start to: comment stop ].
	"PharoDocCommentNode docCommentEnabled
		ifTrue: [ comments do: [ :comment | self styleDocComment: comment ] ]"
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitMethodNode: aRBMethodNode [ 
	
	self visitMethodComments: aRBMethodNode comments.
	self visitMethodArguments: aRBMethodNode arguments. 

	aRBMethodNode selectorParts
		with: aRBMethodNode keywordsPositions
		do: [ :keyword :position | 
			self
				addStyle: #patternKeyword
				from: position
				to: position + keyword size - 1 ].
	aRBMethodNode pragmas do: [ :each | self visitNode: each ].	
	
	self visitNode: aRBMethodNode body
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitNode: aRBNode [ 
	
	aRBNode comments do: [ :comment |
		self 
			addStyle: #comment
			from: comment start
			to: comment stop ].

	^ aRBNode acceptVisitor: self
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitParseErrorNode: aRBParseErrorNode [ 
	
	self 
		addStyle: #invalid
		from: aRBParseErrorNode  start 
		to: aRBParseErrorNode  stop
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitPragmaNode: aRBPragmaNode [ 

	aRBPragmaNode selectorParts 
		with: aRBPragmaNode keywordsPositions 
		do: [ :keyword : position |
			self 
				addStyle: #pragmaKeyword
				from: position
				to: position + keyword size ].
	
	aRBPragmaNode arguments do: [ :each | self visitNode: each ]	
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitReturnNode: aRBReturnNode [ 

	self 
		addStyle: #return
		from: aRBReturnNode start
		to: aRBReturnNode children first start - 1.
		
	self visitNode: aRBReturnNode value
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitSelfNode: aRBSelfNode [
	
	self 
		addStyle: #self
		from: aRBSelfNode start
		to: aRBSelfNode stop
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitSequenceNode: aRBSequenceNode [ 
	| patternTempStyle |
	
	patternTempStyle := self methodOrBlockTempDeclStyleFor: aRBSequenceNode.
	self styleTempBars: aRBSequenceNode.
	aRBSequenceNode temporaries do: [ :temporary | 
		self 
			addStyle: patternTempStyle 
			from: temporary start
			to: temporary stop ].
	aRBSequenceNode statements do: [ :each | self visitNode: each ].
	aRBSequenceNode periods do: [ :pos | 
		self 
			addStyle: #statementSeparator 
			from: pos 
			to: pos ]
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitSuperNode: aRBSuperNode [ 

	self 
		addStyle: #super 
		from: aRBSuperNode start
		to: aRBSuperNode stop
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitTemporaryNode: aRBTemporaryNode [ 
	| methodOrBlockTempStyle |
		
	methodOrBlockTempStyle := self methodOrBlockTempStyleFor: aRBTemporaryNode.
	self 
		addStyle: methodOrBlockTempStyle 
		from: aRBTemporaryNode start
		to: aRBTemporaryNode stop
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitThisContextNode: aThisContextNode [ 
	
	self 
		addStyle: #thisContext 
		from: aThisContextNode start 
		to: aThisContextNode stop
]

{ #category : 'visiting' }
GtkTextStyleVisitor >> visitVariableNode: aVariableNode [ 
	
	self 
		addStyle: (self resolveStyleFor: aVariableNode) 
		from: aVariableNode start
		to: aVariableNode stop.
	"extra styles"
	self styleVariable: aVariableNode
]
