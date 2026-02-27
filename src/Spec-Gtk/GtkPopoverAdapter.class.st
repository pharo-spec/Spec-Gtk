Class {
	#name : 'GtkPopoverAdapter',
	#superclass : 'GtkAdapter',
	#instVars : [
		'runLoop',
		'popupTimestamp',
		'presented',
		'mutex'
	],
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkPopoverAdapter >> addModelTo: gtkPopover [

	gtkPopover child: self presenterWidget.	
	gtkPopover connectClosed: [ self unregister: gtkPopover ].
	
	self setPopoverPositionTo: gtkPopover.
	
	self presenter whenPresenterChangedDo: [
		self replaceChildPresenterOn: gtkPopover ]
]

{ #category : 'building' }
GtkPopoverAdapter >> addVisibleSettingsTo: gtkWidget [
	"popovers fo not have visibility settings, they are shown or hide"
]

{ #category : 'private - announcing' }
GtkPopoverAdapter >> announceClosed [

	self presenter popoverClosed
]

{ #category : 'private - announcing' }
GtkPopoverAdapter >> announceOpened [

	self presenter popoverOpened
]

{ #category : 'api' }
GtkPopoverAdapter >> dismiss [

	presented ifFalse: [ ^ self ].
	self widgetDo: [ :w |
		w popdown ]
]

{ #category : 'initialization' }
GtkPopoverAdapter >> initialize [

	presented := false.
	super initialize
]

{ #category : 'accessing' }
GtkPopoverAdapter >> mutex [

	^ mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'api' }
GtkPopoverAdapter >> popupModal: aBoolean pointingTo: aRectangle [

	"runLoop := GtkContextRunLoop new."
	logger trace.
	self widgetDo: [ :w | 
		| relativeTo |
		"try this to not grab input (which is probably causing the thing to not 
		 give me back control... is annoying, however).
		 Trying again setting it to boolean, to see if this is fixed by magic :P
		 (if this does not works, remember autohide: false
		 2025/11/27 - no, this is still not working :("
		w autohide: "aBoolean" false.
		self register: w.
		relativeTo := self presenter relativeTo adapter innerWidget.
		logger trace: relativeTo.
		w parent: relativeTo.
		logger trace:  aRectangle.
		aRectangle ifNotNil: [ 
			w setPointingTo: aRectangle asGdkRectangle ].
		popupTimestamp := DateAndTime now.
		w popup.
		presented := true.
		self processInitializationDeferredActions ].
	self presenter isTransferFocus 
		ifTrue: [ self presenter takeKeyboardFocus ].
	[ self announceOpened ] fork.
	"GRunLoop defer: [ runLoop run ]."
	runLoop := nil
]

{ #category : 'building' }
GtkPopoverAdapter >> presenterWidget [

	^ self presenter presenter build
]

{ #category : 'private' }
GtkPopoverAdapter >> processInitializationDeferredActions [
	
	logger trace.
	self presenter traversePresentersDo: [ :each | 
		each adapter ifNotNil: [ :anAdapter |
			anAdapter doInitializationDeferredActions ] ]
]

{ #category : 'building' }
GtkPopoverAdapter >> rebuild [
	
	self widgetDo: [ :w |
		self replaceChildPresenterOn: w ]
]

{ #category : 'private' }
GtkPopoverAdapter >> register: gtkPopover [

	(GEngine current isWindowRegistered: gtkPopover) ifTrue: [ ^ self ].
	
	logger trace: gtkPopover.
	
	gtkPopover objectRef.
	GEngine current registerWindow: gtkPopover
]

{ #category : 'private' }
GtkPopoverAdapter >> replaceChildPresenterOn: gtkPopover [

	gtkPopover child: self presenterWidget
]

{ #category : 'building' }
GtkPopoverAdapter >> setPopoverPositionTo: gtkPopover [
		
	^ self presenter position applyTo: gtkPopover
]

{ #category : 'private' }
GtkPopoverAdapter >> unregister: gtkPopover [
	| timeRunning |
		
	timeRunning := (DateAndTime now) - popupTimestamp.
	
	logger trace: gtkPopover.
	logger trace: timeRunning.

	self mutex critical: [ 
		| copyHandle |		
		
		presented := false.
		
		runLoop ifNotNil: [ runLoop done ].
		self presenter owner takeKeyboardFocus.
			
		"fire close announcement"
		self runInSystem: [  
			GEngine current unregisterWindow: gtkPopover.
			self announceClosed ].
		
		"do some cleanup"
		self widgetDo: [ :w | 
			| child |
			"ensure cleanup of adapters"
			self presenter presenter 
				traversePresentersDo: [ :aPresenter | aPresenter adapter: nil ].
			"clean up of widget"
			child := w child.
			child withObjectReferenceDo: [
				w child: GtkWidget null ].
			"unparent the popover before unreferencing it" 
			w unparent.
			"I take a copy because I will nil but I still need to unref it"
			copyHandle := w getHandle copy. 
			w getHandle beNull ].
		
		"I give time GTK to perform all tasks they need for unparenting before release. 
		 50 is a magic number get by 'guessing' technics"
		[
			50 milliSeconds wait.
			GRunLoop defer: [ GObject objectUnref: copyHandle ].
			logger debug: 'DELAYED UNREFERENCED'
		] fork 
	]
]

{ #category : 'building' }
GtkPopoverAdapter >> widgetClass [

	^ GtkPopover
]
