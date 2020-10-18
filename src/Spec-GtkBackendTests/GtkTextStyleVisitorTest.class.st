Class {
	#name : #GtkTextStyleVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'visitor'
	],
	#category : #'Spec-GtkBackendTests'
}

{ #category : #accessing }
GtkTextStyleVisitorTest class >> syntaxInAPostcard [

	^ 'exampleWithNumber: x

"A method that illustrates every part of Smalltalk method syntax
except primitives. It has unary, binary, and keyword messages,
declares arguments and temporaries, accesses a global variable
(but not and instance variable), uses literals (array, character,
symbol, string, integer, float), uses the pseudo variables
true false, nil, self, and super, and has sequence, assignment,
return and cascade. It has both zero argument and one argument blocks."	

    |y|
    true & false not & (nil isNil) ifFalse: [self halt].
    y := self size + super size.
    #($a #a "a" 1 1.0)
        do: [:each | 
				Transcript 
					show: (each class name);
     				show: '' ''].
    ^ x < y'
]

{ #category : #running }
GtkTextStyleVisitorTest >> setUp [
	
	super setUp.
	visitor := GtkTextStyleVisitor new
]

{ #category : #tests }
GtkTextStyleVisitorTest >> testStyleMethod [
	| tags |

	"smoke test"
	visitor 
		contextClass: Object;
		styleMethod: self class syntaxInAPostcard.
	"basic test"
	tags := visitor 
		contextClass: Object;
		styleMethod: 'self asString'.
	
	self assert: tags size equals: 2
]
