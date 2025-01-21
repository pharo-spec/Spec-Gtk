"
This trait will add ""special key"" treatment for list components.
List components (the `GtkBaseListViewAdapter` and `GtkBaseTreeListViewAdapter` families) will not react correctly when mapping characters like ARROW UP and ARROW DOWN (because there are already internal functions there? Don't know), and we want to be able to catch those too, as any other keybinding.

"
Trait {
	#name : 'GtkTSpecialCharacterForList',
	#category : 'Spec-Gtk-Actions',
	#package : 'Spec-Gtk',
	#tag : 'Actions'
}

{ #category : 'special characters' }
GtkTSpecialCharacterForList classSide >> specialCharactersForList [

	^ { 
	KeyboardKey down. 
	KeyboardKey up.
	KeyboardKey left.
	KeyboardKey right }
]

{ #category : 'private - building' }
GtkTSpecialCharacterForList >> addSpecialActionsToListWidget: anAdapter [
	"add special actions to a text family widget. 
	 a special action is one that has a shortcut that cannot be let pass by the widget unless 
	 explicitly defined"
	| specialUserActions specialInternalActions |

	specialInternalActions := self specialActionsForListWidgetOn: self presenter internalActions.
	specialUserActions := self specialActionsForListWidgetOn: self presenter actions.
	(specialUserActions isEmpty and: [ specialInternalActions isEmpty ])
		ifTrue: [ ^ self ].
	
	anAdapter addActionGroup: (SpActionGroup new 
		name: self specialActionsForListWidgetGroupName;
		addAll: specialInternalActions;
		addAll: specialUserActions;
		yourself)
]

{ #category : 'private - building' }
GtkTSpecialCharacterForList >> isSpecialCharacterForListWidget: aKeyCombination [

	aKeyCombination combinationsDo: [ :each |  
		each isForPlatform ifTrue: [ 
			(self class specialCharactersForList includes: each key) 
				ifTrue: [ ^ true ] ] ].
		
	^ false
]

{ #category : 'private - building' }
GtkTSpecialCharacterForList >> specialActionsForListWidgetGroupName [
		
	^ #'widget-special-characters-list'
]

{ #category : 'private - building' }
GtkTSpecialCharacterForList >> specialActionsForListWidgetOn: anActionGroup [

	anActionGroup ifNil: [ ^ #() ].

	^ anActionGroup allCommands 
		select: [ :each | self isSpecialCharacterForListWidget: each shortcutKey ]
]
