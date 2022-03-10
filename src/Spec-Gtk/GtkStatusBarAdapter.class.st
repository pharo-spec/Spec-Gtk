Class {
	#name : #GtkStatusBarAdapter,
	#superclass : #GtkAdapter,
	#instVars : [
		'contextName'
	],
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkStatusBarAdapter >> addModelTo: gtkStatusBar [

	self model message ifNotNil: [ :message | 
		(gtkStatusBar contextNamed: self contextName)
			pushMessage: message ].
		
	unsubscribed := false.
]

{ #category : #private }
GtkStatusBarAdapter >> contextName [
	"Answer a the current context name."
	 
	self flag: #TODO. "For now, I'm just creating an UUID string, 
	maybe this will need to change later"
	^ contextName ifNil: [  contextName := UUID new asString ]
]

{ #category : #api }
GtkStatusBarAdapter >> popMessage [

	unsubscribed ifTrue: [ ^ self ].
	
	self widgetDo: [ :w | 
		(w contextNamed: self contextName)
			popMessage ]
]

{ #category : #api }
GtkStatusBarAdapter >> pushMessage [

	unsubscribed ifTrue: [ ^ self ].
	
	self widgetDo: [ :w | 
		(w contextNamed: self contextName)
			pushMessage: self model message ]
]

{ #category : #api }
GtkStatusBarAdapter >> unsubscribe [ 

	super unsubscribe.
	
	unsubscribed := true.
]

{ #category : #updating }
GtkStatusBarAdapter >> update: aSymbol [ 

	aSymbol = #pushMessage ifTrue: [ self pushMessage ].
	aSymbol = #popMessage ifTrue: [ self popMessage ].

	^ super update: aSymbol
]

{ #category : #building }
GtkStatusBarAdapter >> widgetClass [

	^ GtkStatusBar
]
