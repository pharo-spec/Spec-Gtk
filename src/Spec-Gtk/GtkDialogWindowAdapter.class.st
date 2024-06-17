Class {
	#name : 'GtkDialogWindowAdapter',
	#superclass : 'GtkWindowAdapter',
	#instVars : [
		'runLoop',
		'buttonBox'
	],
	#category : 'Spec-Gtk-Adapter-Window',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Window'
}

{ #category : 'private' }
GtkDialogWindowAdapter >> add: gtkBox toWindow: gtkDialog [
	| containerBox |
	
	containerBox := GtkBox newVertical.
	containerBox spacing: 2.
	containerBox append: gtkBox.
	
	buttonBox := GtkBox newHorizontal.
	buttonBox spacing: 0.
	buttonBox addClass: 'action_area'.
	self presenter buttons do: [ :buttonPresenter |
		buttonPresenter = self presenter defaultButton
			ifTrue: [ buttonPresenter addStyle: 'suggested-action' ]. 
		buttonBox append: (buttonPresenter build
			hExpand: true;
			yourself) ].
	buttonBox vExpand: false.
	buttonBox visible: self presenter hasButtonDecorations.
	containerBox append: buttonBox.
	
	super add: containerBox toWindow: gtkDialog
]

{ #category : 'private - building' }
GtkDialogWindowAdapter >> addDefaultKeyBindings: gtkWindow [

	super addDefaultKeyBindings: gtkWindow.
	self 
		addKeyCombination: Character escape asKeyCombination 
			action: [ self closeFromKeyboard ]
			toWidget: gtkWindow;
		addKeyCombination: $s actionModifier | Character cr asKeyCombination
			action: [ self defaultFromKeyboard ]
			toWidget: gtkWindow
]

{ #category : 'accessing' }
GtkDialogWindowAdapter >> centeredRelativeTo: aWindowPresenter [

	"in dialogs, centering a window relative to a presenter would mean 
	 make it transient to that window (to blur the main window). This does not 
	 seems to work if applied to a regular window (but we need to verify)"
	self widgetDo: [ :w | w transientTo: aWindowPresenter window ]
]

{ #category : 'accessing' }
GtkDialogWindowAdapter >> close [

	self widgetDo: [ :w | w visible: false ]
]

{ #category : 'private' }
GtkDialogWindowAdapter >> closeFromSignal [

	super closeFromSignal.
	runLoop done
]

{ #category : 'private - building' }
GtkDialogWindowAdapter >> defaultFromKeyboard [

	self presenter hasDefaultButton ifFalse: [ ^ self ].

	self presenter 
		executeDefaultAction;
		beOk
]

{ #category : 'private' }
GtkDialogWindowAdapter >> deferredAddPresenterIn: gtkWindow withSpecLayout: aSpec [

	"self model isCentered ifTrue: [ gtkWindow center ]."
	super
		deferredAddPresenterIn: gtkWindow
		withSpecLayout: aSpec.
		
	self presenter whenButtonDecorationsChangedDo: [
		self updateButtonDecorations ]
]

{ #category : 'building' }
GtkDialogWindowAdapter >> newWidget [

	^ super newWidget
		hideOnClose: true;
		defaultSize: self presenter initialExtent;
		yourself
]

{ #category : 'accessing' }
GtkDialogWindowAdapter >> openWithDeferredAction: aBlock [

	runLoop := GtkContextRunLoop new.
	self widgetDo: [ :w |
		self presenter owner 
			ifNotNil: [ :parent | w transientTo: parent adapter widget ].
		w beModal.
		w present.
		self processInitializationDeferredActions.
		self presenter presenter takeKeyboardFocus ].
	self announceOpened.
	aBlock value.	
	"This will block until dialog is closed (see `closeFromSignal`)"
	GRunLoop defer: [ runLoop run ].
	self widgetDo: [ :w |
		w withObjectReferenceDo: [ w destroy ] ]
]

{ #category : 'private - updating' }
GtkDialogWindowAdapter >> updateButtonDecorations [

	self widgetDo: [ :w | buttonBox visible: self presenter hasButtonDecorations ]
]
