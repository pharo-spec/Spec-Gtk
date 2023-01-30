Class {
	#name : #GtkDialogWindowAdapter,
	#superclass : #GtkWindowAdapter,
	#instVars : [
		'wasModal',
		'waitForAnswer',
		'contentsWidget'
	],
	#category : #'Spec-Gtk-Adapter-Window'
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
GtkDialogWindowAdapter >> centeredRelativeTo: aWindowPresenter [

	"in dialogs, centering a window relative to a presenter would mean 
	 make it transient to that window (to blur the main window). This does not 
	 seems to work if applied to a regular window (but we need to verify)"
	self widgetDo: [ :w | w transientTo: aWindowPresenter window ]
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
GtkDialogWindowAdapter >> openWithDeferredAction: aBlock [

	^ self widgetDo: [ :w | 
		w present.
		self processInitializationDeferredActions.
		self presenter presenter takeKeyboardFocus.
		"To be executed in the event loop of the dialog"
		GRunLoop forceDefer: [ self announceOpened ].
		aBlock value.
		w run ]
]
