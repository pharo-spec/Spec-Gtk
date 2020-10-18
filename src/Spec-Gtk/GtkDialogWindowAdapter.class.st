Class {
	#name : #GtkDialogWindowAdapter,
	#superclass : #GtkWindowAdapter,
	#instVars : [
		'wasModal',
		'waitForAnswer',
		'contentsWidget'
	],
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #private }
GtkDialogWindowAdapter >> add: gtkBox toWindow: gtkDialog [

	gtkDialog contentArea packStart: gtkBox.
	self model buttons do: [ :buttonPresenter |
		gtkDialog 
			addButton: buttonPresenter label asString
			do: buttonPresenter action ].
	gtkDialog buttonBox showAll.
	gtkDialog defaultResponse: self model buttons size
]

{ #category : #'private building' }
GtkDialogWindowAdapter >> addDefaultKeyBindings: gtkWindow [

	super addDefaultKeyBindings: gtkWindow.
	self 
		bindKeyCombination: Character escape asKeyCombination 
			toAction: [ self closeFromKeyboard ]
			inWidget: gtkWindow;
		bindKeyCombination: $s command mac | $s control win | $s control unix
			toAction: [ self defaultFromKeyboard ]
			inWidget: gtkWindow
]

{ #category : #accessing }
GtkDialogWindowAdapter >> close [

	self widgetDo: [ :w | w respond ]
]

{ #category : #'private building' }
GtkDialogWindowAdapter >> defaultFromKeyboard [

	self presenter 
		executeDefaultAction;
		beOk
]

{ #category : #private }
GtkDialogWindowAdapter >> deferredAddPresenterIn: gtkWindow withSpecLayout: aSpec [

	self model isCentered ifTrue: [ gtkWindow center ].
	super 
		deferredAddPresenterIn: gtkWindow 
		withSpecLayout: aSpec	
]

{ #category : #building }
GtkDialogWindowAdapter >> newWidget [

	^ GtkDialogWindow new 
		autoRelease
		resize: self model initialExtent;
		yourself
]

{ #category : #accessing }
GtkDialogWindowAdapter >> open [ 

	^ self widgetDo: [ :w | 
		w showAll.
		self announceOpened.
		w run ]
]
