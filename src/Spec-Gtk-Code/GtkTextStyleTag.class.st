Class {
	#name : #GtkTextStyleTag,
	#superclass : #Object,
	#instVars : [
		'name',
		'start',
		'stop'
	],
	#category : #'Spec-Gtk-Code-Base'
}

{ #category : #'instance creation' }
GtkTextStyleTag class >> newName: aString from: start to: stop [

	^ self basicNew 
		initializeName: aString from: start to: stop;
		yourself
]

{ #category : #visiting }
GtkTextStyleTag >> acceptTextBuffer: textBuffer [

	textBuffer 
		applyTagByName: self name asString
		start: self start - 1
		end: self stop
]

{ #category : #initialization }
GtkTextStyleTag >> initializeName: aString from: startNumber to: stopNumber [

	self initialize.
	name := aString.
	start := startNumber.
	stop := stopNumber
]

{ #category : #accessing }
GtkTextStyleTag >> name [

	^ name
]

{ #category : #printing }
GtkTextStyleTag >> printOn: aStream [ 
	
	aStream << self name << ' (' << self start asString << '-' << self stop asString << ')'
]

{ #category : #accessing }
GtkTextStyleTag >> start [

	^ start
]

{ #category : #accessing }
GtkTextStyleTag >> stop [

	^ stop
]
