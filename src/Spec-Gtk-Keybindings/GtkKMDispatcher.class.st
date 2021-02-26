Class {
	#name : #GtkKMDispatcher,
	#superclass : #Object,
	#instVars : [
		'buffer',
		'categories',
		'target'
	],
	#category : #'Spec-Gtk-Keybindings'
}

{ #category : #'instance creation' }
GtkKMDispatcher class >> on: aTarget [

	^ self new 
		target: aTarget;
		yourself
]

{ #category : #accessing }
GtkKMDispatcher >> attachCategory: aCategory [

	categories := categories copyWith: aCategory
]

{ #category : #compatibility }
GtkKMDispatcher >> bindKeyCombination: aShortcut toAction: aBlock [

	^ self directCategory 
		addKeymapEntry: (KMKeymap
			shortcut: aShortcut 
			action: aBlock)
]

{ #category : #accessing }
GtkKMDispatcher >> buffer [

	^ buffer buffer
]

{ #category : #accessing }
GtkKMDispatcher >> categories [

	^ categories
]

{ #category : #matching }
GtkKMDispatcher >> completeMatch: aKeymapEntry buffer: aBuffer [

	"KMLog logCompleteMatchBetween: morph and: aKeymapEntry."
	buffer completeMatch.
	aKeymapEntry action 
		cull: target
		cull: nil "this was a morph in Morphic"
		cull: aBuffer first
	"self announcer announce: (KMCompleteMatch event: currentEvent from: self)."
]

{ #category : #building }
GtkKMDispatcher >> detachAllKeymapCategories [
	
	categories := { KMCategory new }.
]

{ #category : #private }
GtkKMDispatcher >> directCategory [

	^ categories first
]

{ #category : #dispatching }
GtkKMDispatcher >> dispatch: anEventBuffer [

	self categories do: [ :aCategory | 
		"nice hack to stop in the first listener"
		aCategory 
			onMatchWith: anEventBuffer
			notify: self
			andDo: [ ^ self ]  ].
		
	self noMatch
]

{ #category : #dispatching }
GtkKMDispatcher >> dispatchKeyEvent: aKeyEvent [

	KMLog log: aKeyEvent.
	buffer addEvent: aKeyEvent.
	self dispatch: buffer buffer copy.
	aKeyEvent wasHandled ifFalse: [ 
		buffer clearBuffer ]
]

{ #category : #initialization }
GtkKMDispatcher >> initialize [
	
	super initialize.
	categories := { KMCategory new }.
	buffer := KMBuffer new
]

{ #category : #matching }
GtkKMDispatcher >> noMatch [
]

{ #category : #matching }
GtkKMDispatcher >> partialMatch [
	| event |
	
	buffer partialMatch.
	event := buffer currentEvent.
	"self announcer announce: (KMPartialMatch event: event from: self)."
]

{ #category : #compatibility }
GtkKMDispatcher >> removeKeyCombination: aShortcut [

	self categories do: [ :each |
		(each keymapForShortcut: aShortcut) ifNotNil: [ :keymap |
			each removeKeymapEntry: keymap ] ]
]

{ #category : #accessing }
GtkKMDispatcher >> target [

	^ target
]

{ #category : #accessing }
GtkKMDispatcher >> target: aTarget [

	target := aTarget
]
