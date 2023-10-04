"
A manager to handle actions for adapters.
Actions define different things: 

- shortcuts
- context menu
- potentially just ""actions"" (things to execute, add-ons to the presenters)
"
Class {
	#name : #GtkAdapterActionManager,
	#superclass : #Object,
	#instVars : [
		'adapter',
		'actionMap',
		'popoverContextMenu',
		'hasContextMenu'
	],
	#category : #'Spec-Gtk-Actions'
}

{ #category : #'instance creation' }
GtkAdapterActionManager class >> new [

	self error: 'Use #on:'
]

{ #category : #'instance creation' }
GtkAdapterActionManager class >> on: anAdapter [

	^ super new 
		adapter: anAdapter;
		yourself
]

{ #category : #accessing }
GtkAdapterActionManager >> adapter [

	^ adapter
]

{ #category : #initialization }
GtkAdapterActionManager >> adapter: anObject [

	adapter := anObject
]

{ #category : #'private - testing' }
GtkAdapterActionManager >> anyCommandHasShortcut [

	^ self presenter actionGroup allCommands anySatisfy: [ :each | each hasShortcutKey ]
]

{ #category : #'private - testing' }
GtkAdapterActionManager >> anyCommandIsVisible [
		
	^ self presenter actionGroup allCommands anySatisfy: [ :each | each isVisible ]
]

{ #category : #accessing }
GtkAdapterActionManager >> hasContextMenu [

	^ hasContextMenu

]

{ #category : #initialization }
GtkAdapterActionManager >> initialize [

	super initialize.
	actionMap := Dictionary new.
	hasContextMenu := false
]

{ #category : #'private - actions' }
GtkAdapterActionManager >> installAction: aCommand on: gtkWidget [
	| actionGroup action | 

	actionGroup := gtkWidget actionGroups at: 'global' ifAbsent: [ nil ]. 
	actionGroup ifNil: [ 
		actionGroup := GSimpleActionGroup new.
		gtkWidget insertActionGroup: 'global' actions: actionGroup ].
	
	action := (GSimpleAction newName: aCommand id)
		connectActivate: [ aCommand execute ];
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

{ #category : #'private - actions' }
GtkAdapterActionManager >> installActionsOn: gtkWidget [
	| map |

	"keeping an actionMap to be able to perform operations later (like enable/disable)"
	map := GtkActionInstaller new
		widget: gtkWidget;
		visit: self presenter actionGroup.
	actionMap addAll: map
]

{ #category : #'private - actions' }
GtkAdapterActionManager >> installContextMenuOn: gtkWidget [

	"already installed?"
	hasContextMenu ifTrue: [ ^ self ]. 
	hasContextMenu := true.

	popoverContextMenu := (GtkPopoverMenu newFromModelFull: GMenu new) ensureObjectRefAndAutoRelease.
	popoverContextMenu hasArrow: false.
	popoverContextMenu parent: gtkWidget.

	gtkWidget addRightClickEvent: [ :event |
		self updateEnabledActions.
		self 
			showPopoverMenuFor: self presenter actionGroup
			at: event position ]
]

{ #category : #actions }
GtkAdapterActionManager >> installOn: gtkWidget [

	"install actions"
	self installActionsOn: gtkWidget.
	"install shortcuts"
	self installShortcutsOn: gtkWidget.
	"install context menu (but just if any action is visible, because they can be 
	 just keybindings)"
	self anyCommandIsVisible ifTrue: [ 
		self installContextMenuOn: gtkWidget ]
]

{ #category : #'private - actions' }
GtkAdapterActionManager >> installShortcutsOn: gtkWidget [
	
	GtkActionShortcutInstaller new
		widget: gtkWidget;
		visit: self presenter actionGroup
]

{ #category : #accessing }
GtkAdapterActionManager >> presenter [

	^ self adapter presenter
]

{ #category : #actions }
GtkAdapterActionManager >> showContextMenu [

	self adapter innerWidgetDo: [ :w |
		self 
			showPopoverMenuFor: self presenter actionGroup
			at: w surface positionOfPointer ]
]

{ #category : #'private - actions' }
GtkAdapterActionManager >> showPopoverMenuFor: aGroup at: position [

	(actionMap keys noneSatisfy: [ :each | each isVisible ]) ifTrue: [ ^ self ].
	
	self adapter innerWidgetDo: [ :w |
		popoverContextMenu
			menuModel: (GtkActionMenuBuilder new visit: aGroup);
			pointingTo: (position extent: 1@1);
			popup ]
]

{ #category : #updating }
GtkAdapterActionManager >> updateEnabledActions [
	
	self adapter innerWidgetDo: [ :w | 
		actionMap keysAndValuesDo: [ :command :action | 
			action enable: command isEnabled ] ]
]

{ #category : #actions }
GtkAdapterActionManager >> updateOn: gtkWidget [

	"remove shortcuts"
	gtkWidget removeAllShortcuts.
	"remove actions"
	gtkWidget removeAllActions.
	
	self installOn: gtkWidget.

]
