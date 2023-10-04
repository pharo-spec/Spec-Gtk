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
	| containerBox buttonBox |
	
	containerBox := GtkBox newVertical.
	containerBox spacing: 2.
	containerBox append: gtkBox.
	
	buttonBox := GtkBox newHorizontal.
	buttonBox spacing: 2.
	self presenter buttons
		do: [ :buttonPresenter | 
			buttonBox append: (buttonPresenter build
				hExpand: true;
				yourself) ].
	buttonBox vExpand: false.
	containerBox append: buttonBox.
	
	super add: containerBox toWindow: gtkDialog

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

{ #category : #private }
GtkDialogWindowAdapter >> closeFromSignal [

	super closeFromSignal.
	waitSemaphore signal	
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

	^ GtkWindow new 
		autoRelease;
		defaultSize: self presenter initialExtent;
		yourself
]

{ #category : #accessing }
GtkDialogWindowAdapter >> openWithDeferredAction: aBlock [

	waitSemaphore := Semaphore new.
	self widgetDo: [ :w |
		w beModal.
		w present.
		self processInitializationDeferredActions.
		self presenter presenter takeKeyboardFocus ].
	self announceOpened.
	"the semaphore will be signaled when closing the modal (see #closeFromSignal)"
	waitSemaphore wait.
	aBlock value
]
