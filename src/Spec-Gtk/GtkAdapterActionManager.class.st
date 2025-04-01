"
A manager to handle actions for adapters.
Actions define different things: 

- shortcuts
- context menu
- potentially just ""actions"" (things to execute, add-ons to the presenters)
"
Class {
	#name : 'GtkAdapterActionManager',
	#superclass : 'Object',
	#instVars : [
		'adapter',
		'actionMap',
		'popoverContextMenu',
		'hasContextMenu'
	],
	#category : 'Spec-Gtk-Actions',
	#package : 'Spec-Gtk',
	#tag : 'Actions'
}

{ #category : 'instance creation' }
GtkAdapterActionManager class >> new [

	self error: 'Use #on:'
]

{ #category : 'instance creation' }
GtkAdapterActionManager class >> on: anAdapter [

	^ super new 
		adapter: anAdapter;
		yourself
]

{ #category : 'private - actions' }
GtkAdapterActionManager >> actionGroups [

	^ { self presenter actions }
]

{ #category : 'accessing' }
GtkAdapterActionManager >> adapter [

	^ adapter
]

{ #category : 'initialization' }
GtkAdapterActionManager >> adapter: anObject [

	adapter := anObject
]

{ #category : 'private - testing' }
GtkAdapterActionManager >> anyCommandHasShortcut [

	^ self presenter actions allCommands 
		anySatisfy: [ :each | each hasShortcutKey ]
]

{ #category : 'private - testing' }
GtkAdapterActionManager >> anyCommandInActionGroupIsVisible: anActionGroup [ 
		
	^ anActionGroup 
		ifNotNil: [ :actionGroup | actionGroup allCommands anySatisfy: [ :each | each isVisible ] ]
		ifNil: [ false ]
]

{ #category : 'private - testing' }
GtkAdapterActionManager >> anyCommandIsVisible [
		
	^ self anyCommandInActionGroupIsVisible: self presenter actions
]

{ #category : 'private - actions' }
GtkAdapterActionManager >> deferredShowPopoverMenuFor: anArrayOfGroups at: position owner: gtkWidget [
	| menuModel |
	
	menuModel := GtkActionMenuBuilder new 
		visit: anArrayOfGroups first;
		in: [ :this | 
			anArrayOfGroups allButFirstDo: [ :each | each acceptVisitor: this ] ];
		root.

	popoverContextMenu := (GtkPopoverMenu newFromModelFull: menuModel)
			ensureObjectRefAndAutoRelease.
	popoverContextMenu parent: gtkWidget.
	popoverContextMenu hasArrow: false.
	popoverContextMenu autohide: true.
	popoverContextMenu pointingTo: (position extent: 10@10).
	
	popoverContextMenu connectClosed: [
		"release when closed, to ensure a finalize will happen before 
		 close the window."
		popoverContextMenu := nil ].
	
	popoverContextMenu popup
]

{ #category : 'accessing' }
GtkAdapterActionManager >> hasContextMenu [

	^ hasContextMenu

]

{ #category : 'initialization' }
GtkAdapterActionManager >> initialize [

	super initialize.
	actionMap := Dictionary new.
	hasContextMenu := false
]

{ #category : 'private - actions' }
GtkAdapterActionManager >> installAction: aCommand on: gtkWidget [
	| actionGroup action | 

	actionGroup := gtkWidget actionGroups at: 'global' ifAbsent: [ nil ]. 
	actionGroup ifNil: [ 
		actionGroup := GSimpleActionGroup new.
		gtkWidget insertActionGroup: 'global' actions: actionGroup ].
	
	action := (GSimpleAction newName: aCommand id)
		connectActivate: [ self runInSystem: [ [ aCommand execute ] fork ] ];
		yourself.	
	actionMap at: aCommand put: action.
	actionGroup insert: action.
	
	aCommand hasShortcutKey ifTrue: [ 
		gtkWidget addShortcut: (GtkShortcut 
			newKeyCombination: aCommand shortcutKey 
			actionName: ('global.', aCommand id)) ].	
	
	aCommand isVisible ifTrue: [ 
		self installContextMenuOn: gtkWidget ]
]

{ #category : 'private - actions' }
GtkAdapterActionManager >> installActionGroup: actionGroup on: gtkWidget [
	| map |

	map := GtkActionInstaller new
		widget: gtkWidget;
		visit: actionGroup.
	actionMap addAll: map
]

{ #category : 'private - actions' }
GtkAdapterActionManager >> installActionGroupShortcuts: anActionGroup on: gtkWidget [
	
	GtkActionShortcutInstaller new
		widget: gtkWidget;
		visit: anActionGroup
]

{ #category : 'private - actions' }
GtkAdapterActionManager >> installContextMenuOn: gtkWidget [

	"already installed?"
	hasContextMenu ifTrue: [ ^ self ]. 
	hasContextMenu := true.

	gtkWidget addRightClickEvent: [ :event |
		self updateEnabledActions.
		self 
			showPopoverMenuFor: self actionGroups
			at: event position ]
]

{ #category : 'actions' }
GtkAdapterActionManager >> installGroup: anActionGroup on: gtkWidget [

	anActionGroup ifNil: [ ^ self ].
	"install actions"
	self installActionGroup: anActionGroup on: gtkWidget.
	"install shortcuts"
	self installActionGroupShortcuts: anActionGroup on: gtkWidget
]

{ #category : 'actions' }
GtkAdapterActionManager >> installGroupsOn: gtkWidget [
		
	self presenter internalActions ifNotNil: [ :actionGroup |
		self installGroup: actionGroup on: gtkWidget ].
	self presenter actions ifNotNil: [ :actionGroup |
		self installGroup: actionGroup on: gtkWidget ]
]

{ #category : 'actions' }
GtkAdapterActionManager >> installOn: gtkWidget [

	"install groups"
	self installGroupsOn: gtkWidget.	
	"install context menu (but just if any action is visible, because they can be 
	 just keybindings), and just for root action group"
	self anyCommandIsVisible 
		ifTrue: [ self installContextMenuOn: gtkWidget ]	
]

{ #category : 'accessing' }
GtkAdapterActionManager >> presenter [

	^ self adapter presenter
]

{ #category : 'private' }
GtkAdapterActionManager >> runInSystem: aBlock [
	
	GRunLoop enterSystem: aBlock
]

{ #category : 'actions' }
GtkAdapterActionManager >> showContextMenu [

	self adapter innerWidgetDo: [ :w |
		self 
			showPopoverMenuFor: self actionGroups
			at: (w root computePositionOfPointerTarget: w) ]
]

{ #category : 'private - actions' }
GtkAdapterActionManager >> showPopoverMenuFor: anArrayOfGroups at: position [

	self 
		deferredShowPopoverMenuFor: anArrayOfGroups 
		at: position 
		owner: self adapter innerWidget
]

{ #category : 'updating' }
GtkAdapterActionManager >> updateEnabledActions [
	
	self adapter innerWidgetDo: [ :w | 
		actionMap keysAndValuesDo: [ :command :action | 
			action enable: command isEnabled ] ]
]

{ #category : 'actions' }
GtkAdapterActionManager >> updateOn: gtkWidget [

	"remove shortcuts"
	gtkWidget removeAllShortcuts.
	"remove actions"
	gtkWidget removeAllActions.
	
	self installOn: gtkWidget
]
