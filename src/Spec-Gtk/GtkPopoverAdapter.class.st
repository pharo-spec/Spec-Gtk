Class {
	#name : 'GtkPopoverAdapter',
	#superclass : 'GtkAdapter',
	#instVars : [
		'runLoop',
		'popupTimestamp'
	],
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkPopoverAdapter >> addModelTo: gtkPopover [

	gtkPopover child: self presenterWidget.	
	gtkPopover connectClosed: [
		self unregister: gtkPopover ].
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

{ #category : 'building' }
GtkPopoverAdapter >> buildWidget [
	
	^ super buildWidget
]

{ #category : 'api' }
GtkPopoverAdapter >> dismiss [ 

	self widgetDo: [ :w | 
		w popdown.
		"I need to disconnect explicitly because it may cause gtk to send callbacks to 
		 me and it may (most of the times it *will*) be already collected (then... 
		 well, crash)."
		"3/01/2025 -> testing without"
		"w disconnectAll."
		"unset parent (no idea if this is ok, but there is an error around saying: 
		 Funalizing X but it has children left
			- GtkPopover... etc.
		 which indicates I am not disposing correcly this guys..."
		 "w unparent"
		 "3/01/2025 -> I moved most of this to #unregister: (which is what happens on 
		  hide... no idea how all this will work out." ]
]

{ #category : 'api' }
GtkPopoverAdapter >> popup [

	self popupPointingTo: nil
]

{ #category : 'api' }
GtkPopoverAdapter >> popupModal [
	"is not really 'modal' but it will be hidden when lost focus/clicking 
	 outside..."

	self popupModalPointingTo: nil
]

{ #category : 'api' }
GtkPopoverAdapter >> popupModalPointingTo: aRectangle [

	"runLoop := GtkContextRunLoop new."
	logger trace.
	self widgetDo: [ :w | 
		| relativeTo |
		"try this to not grab input (which is probably causing the thing to not 
		 give me back control... is annoying, however)"
		w autohide: false.
		self register: w.
		relativeTo := self presenter relativeTo adapter innerWidget.
		logger trace: relativeTo.
		w parent: relativeTo.
		logger trace:  aRectangle.
		aRectangle ifNotNil: [ 
			w setPointingTo: aRectangle asGdkRectangle ].
		popupTimestamp := DateAndTime now.
		w popup.
		self processInitializationDeferredActions ].
	self presenter takeKeyboardFocus.
	[ self announceOpened ] fork.
	"GRunLoop defer: [ runLoop run ]."
	runLoop := nil
]

{ #category : 'api' }
GtkPopoverAdapter >> popupPointingTo: aRectangle [
	
	logger trace.
	self widgetDo: [ :w |
		| relativeTo |
		w autohide: false.
		self register: w.
		relativeTo := self presenter relativeTo adapter innerWidget.
		logger trace: relativeTo.
		w parent: relativeTo.
		logger trace:  aRectangle.
		aRectangle ifNotNil: [ 
			w setPointingTo: aRectangle asGdkRectangle ].
		popupTimestamp := DateAndTime now.		
		w popup.
		self processInitializationDeferredActions ].
	self presenter takeKeyboardFocus.
	[ self announceOpened ] fork
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
	runLoop ifNotNil: [ runLoop done ].
	self presenter owner takeKeyboardFocus.
	self runInSystem: [  
		GEngine current unregisterWindow: gtkPopover.
		self announceClosed.
		self widgetDo: [ :w | 
			| child |
			child := w child.
			w child: GtkWidget null.
			child objectUnref.
			w objectUnref ] ]
]

{ #category : 'building' }
GtkPopoverAdapter >> widgetClass [

	^ GtkPopover
]
