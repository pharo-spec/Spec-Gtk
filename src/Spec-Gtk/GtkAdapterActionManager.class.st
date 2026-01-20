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
		'hasContextMenu',
		'dynamicGroups',
		'dynamicGroupMap',
		'dynamicGroupActionMap'
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

	dynamicGroupMap ifNil: [ ^ { self presenter actions } ].
	^ { self presenter actions }, (dynamicGroupMap values)
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

{ #category : 'private' }
GtkAdapterActionManager >> buildMenuModel [

	^ [ self buildMenuModelFor: self actionGroups ]
	on: Error 
	fork: [ :e | e pass ]
	return: [ nil ]
]

{ #category : 'private' }
GtkAdapterActionManager >> buildMenuModelFor: anArrayOfGroups [

	^ GtkActionMenuBuilder new 
		visit: anArrayOfGroups first;
		in: [ :this |
			anArrayOfGroups allButFirstDo: [ :each | each acceptVisitor: this ] ];
		root
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
GtkAdapterActionManager >> installAction: aCommand actionGroup: aGroupName on: gtkWidget [
	| actionGroup action | 

	actionGroup := gtkWidget actionGroups at: aGroupName ifAbsent: [ nil ]. 
	actionGroup ifNil: [ 
		actionGroup := GSimpleActionGroup new.
		gtkWidget insertActionGroup: aGroupName actions: actionGroup ].
	
	action := (GSimpleAction newName: aCommand id)
		connectActivate: [ self runInSystem: [ [ aCommand execute ] fork ] ];
		yourself.	
	actionMap at: aCommand put: action.
	actionGroup insert: action.
	
	aCommand hasShortcutKey ifTrue: [ 
		gtkWidget addShortcut: (GtkShortcut 
			newKeyCombination: aCommand shortcutKey 
			actionName: (aGroupName, '.', aCommand id)) ].	
	
	aCommand isVisible ifTrue: [ 
		self installContextMenuOn: gtkWidget ]
]

{ #category : 'private - actions' }
GtkAdapterActionManager >> installAction: aCommand on: gtkWidget [
	
	^ self 
		installAction: aCommand 
		actionGroup: 'global' 
		on: gtkWidget
]

{ #category : 'private - actions' }
GtkAdapterActionManager >> installActionGroup: actionGroup on: gtkWidget [
	| actionInstaller |

	actionInstaller := GtkActionInstaller new
		widget: gtkWidget;
		yourself.
		
	actionInstaller visit: actionGroup.

	actionMap addAll: actionInstaller actionMap.
	dynamicGroups := actionInstaller dynamicGroups
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
		(gtkWidget actionGroups flatCollect: #actions)
			detect: [ :each | each name = 'show-context-menu' ]
			ifFound: [ :anAction | anAction activate ] ]
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

{ #category : 'initialization' }
GtkAdapterActionManager >> resetContextMenu [

	popoverContextMenu := nil.
	dynamicGroupMap := nil.
	dynamicGroupActionMap := nil
]

{ #category : 'private' }
GtkAdapterActionManager >> runInSystem: aBlock [
	
	GRunLoop enterSystem: aBlock
]

{ #category : 'actions' }
GtkAdapterActionManager >> showContextMenu [

	self adapter innerWidgetDo: [ :w |
		self flag: #WARNING. "Is a mistery why, but if I put the update methods inside 
		the show method as it should be this will not work correctly :("
		self updateDynamicActions.
		self updateEnabledActions.
		self 
			showPopoverMenuFor: self actionGroups
			at: (w root computePositionOfPointerTarget: w)
			owner: w ]
]

{ #category : 'private - actions' }
GtkAdapterActionManager >> showPopoverMenuFor: anArrayOfGroups at: position owner: gtkWidget [
	| menuModel |
	
	menuModel := self buildMenuModelFor: anArrayOfGroups.
	menuModel ifNil: [ ^ self ].

	popoverContextMenu := GtkPopoverMenu newFromModelFull: menuModel.
	popoverContextMenu objectRef.
	popoverContextMenu parent: gtkWidget.
	popoverContextMenu hasArrow: false.
	popoverContextMenu autohide: true.
	popoverContextMenu pointingTo: (position extent: 10@10).
	
	popoverContextMenu connectClosed: [
		[ 	
			"I need to wait to dispose the popover because otherwise action will not  be fired. 
			 25 is a magic number"
			25 milliSeconds wait.
			GRunLoop defer: [
				popoverContextMenu unparent.
				popoverContextMenu objectUnref ].
			self resetContextMenu 
		] fork ].
	
	popoverContextMenu queueResize.
	popoverContextMenu queueAllocate.
		
	gtkWidget addOneShotTickCallback: [ popoverContextMenu popup ].
	
	popoverContextMenu grabFocus
]

{ #category : 'private' }
GtkAdapterActionManager >> updateDynamicActions [
	"dynamic actions need to be installed each time we will show the menu 
	 (as they are calculated dynamically)"
	
	dynamicGroups ifNil: [ ^ self ].
	
	dynamicGroupMap := Dictionary new.
	dynamicGroupActionMap := Dictionary new.
	dynamicGroups do: [ :eachGroup |
		| group installer |
		
		self adapter innerWidgetDo: [ :w |
			group := eachGroup resolve.
			installer := GtkActionInstaller new
				widget: w;
				beReplaceGroup;
				visit: group;
				yourself.
			dynamicGroupActionMap addAll: installer actionMap.
			dynamicGroupMap at: eachGroup put: group ] ]
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
