Class {
	#name : #GtkDialogWindowAdapter,
	#superclass : #GtkWindowAdapter,
	#instVars : [
		'wasModal',
		'waitForAnswer',
		'contentsWidget',
		'waitSemaphore'
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
		addKeyCombination: Character escape asKeyCombination 
			action: [ self closeFromKeyboard ]
			toWidget: gtkWindow;
		addKeyCombination: $s actionModifier
			action: [ self defaultFromKeyboard ]
			toWidget: gtkWindow
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

	"self model isCentered ifTrue: [ gtkWindow center ]."
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
	| sem |

	sem := Semaphore new.
	self widgetDo: [ :w |
		w beHideOnClose.
		w connectHide: [ sem signal ].
		w present.
		self processInitializationDeferredActions.
		self presenter presenter takeKeyboardFocus ].

	self announceOpened.
	aBlock value.
	sem wait.
	self widgetDo: [ :w | w objectUnref ]
]
