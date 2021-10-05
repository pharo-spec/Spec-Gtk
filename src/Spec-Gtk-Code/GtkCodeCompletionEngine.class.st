Class {
	#name : #GtkCodeCompletionEngine,
	#superclass : #Object,
	#instVars : [
		'scripting',
		'completionClass',
		'doItContext',
		'doItRequestor'
	],
	#category : #'Spec-Gtk-Code-Base'
}

{ #category : #accessing }
GtkCodeCompletionEngine >> completionClass [

	^ completionClass
]

{ #category : #accessing }
GtkCodeCompletionEngine >> completionClass: anObject [

	completionClass := anObject
]

{ #category : #accessing }
GtkCodeCompletionEngine >> doItContext [

	^ doItContext
]

{ #category : #accessing }
GtkCodeCompletionEngine >> doItContext: aContext [

	doItContext := aContext
]

{ #category : #accessing }
GtkCodeCompletionEngine >> doItRequestor [

	^ doItRequestor
]

{ #category : #accessing }
GtkCodeCompletionEngine >> doItRequestor: aRequestor [

	doItRequestor := aRequestor
]

{ #category : #testing }
GtkCodeCompletionEngine >> isScripting [

	^ scripting
]

{ #category : #accessing }
GtkCodeCompletionEngine >> scripting: aBoolean [ 

	scripting := aBoolean
]

{ #category : #accessing }
GtkCodeCompletionEngine >> variableBindingNames [

	^ self doItRequestor variableBindingNames
]
