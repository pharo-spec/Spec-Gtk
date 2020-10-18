Class {
	#name : #GtkKMDispatcherTest,
	#superclass : #TestCase,
	#category : #'Spec-GtkBackendTests'
}

{ #category : #utilities }
GtkKMDispatcherTest >> eventKey: character [
 
	^ self 
		eventKey: character
		alt: false
		ctrl: false
		meta: false
		shift: false
]

{ #category : #utilities }
GtkKMDispatcherTest >> eventKey: character alt: aBoolean [

	^ self 
		eventKey: character
		alt: aBoolean
		ctrl: false
		meta: false
		shift: false
]

{ #category : #utilities }
GtkKMDispatcherTest >> eventKey: character alt: useAlt ctrl: useCtrl meta: useMeta shift: useShift [
	
	^ GdkEventKey 
		newKeyPressValue: character asciiValue 
		shift: useShift 
		meta: useMeta 
		control: useCtrl 
		option: useAlt
]

{ #category : #utilities }
GtkKMDispatcherTest >> eventKey: character ctrl: aBoolean [

	^ self 
		eventKey: character
		alt: false
		ctrl: aBoolean
		meta: false
		shift: false
]

{ #category : #utilities }
GtkKMDispatcherTest >> eventKey: character meta: aBoolean [

	^ self 
		eventKey: character
		alt: false
		ctrl: false
		meta: aBoolean
		shift: false
]

{ #category : #utilities }
GtkKMDispatcherTest >> eventKey: character shift: aBoolean [

	^ self 
		eventKey: character
		alt: false
		ctrl: false
		meta: false
		shift: aBoolean
]

{ #category : #running }
GtkKMDispatcherTest >> setUp [

	GtkApplication ensureRunning
]

{ #category : #tests }
GtkKMDispatcherTest >> testBuffering [
	| dispatcher flag category event1 event2 event3 |
	
	category := KMCategory named: #TestBlah.
	
	flag := false.

	category addKeymapEntry: (KMKeymap 
		named: #Foo 
		shortcut: $a meta, $b meta, $c meta
		action: [ flag := true ]).
	category addKeymapEntry: (KMKeymap 
		named: #Bar 
		shortcut: $p meta, $p meta 
		action: [ ]).
	
	dispatcher := GtkKMDispatcher new.
	dispatcher attachCategory: category.

	event1 := self eventKey: $a meta: true.
	dispatcher dispatchKeyEvent: event1.
	self assert: dispatcher buffer size equals: 1.
	self assert: dispatcher buffer first equals: event1.
	
	event2 := self eventKey: $b meta: true.
	dispatcher dispatchKeyEvent: event2.
	self assert: dispatcher buffer size equals: 2.
	self assert: dispatcher buffer first equals: event1.
	self assert: dispatcher buffer second equals: event2.
	
	event3 := self eventKey: $c meta: true.
	dispatcher dispatchKeyEvent: event3.
	self assert: dispatcher buffer isEmpty.
	
	self assert: flag
]

{ #category : #tests }
GtkKMDispatcherTest >> testDispatchKeyEvent [
	| dispatcher flag category event |
	
	category := KMCategory named: #TestBlah.
	flag := false.

	category addKeymapEntry: (KMKeymap 
		named: #Foo
		shortcut: $a meta
		action: [ flag := true ]).
	
	dispatcher := GtkKMDispatcher new.
	dispatcher attachCategory: category.

	event := self eventKey: $a meta: true.
	dispatcher dispatchKeyEvent: event.
	
	self assert: flag
]
