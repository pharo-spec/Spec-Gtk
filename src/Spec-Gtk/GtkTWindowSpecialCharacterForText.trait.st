"
This trait will add ""special key"" treatment for text components.
Text components (the GtkAbstractTextAdapter family) will not react correctly when mapping characters like ESC and ENTER (because there are already internal functions there? Don't know), and we want to be able to catch those too, as any other keybinding.
This is useful e.g. to make texts in dialogs react to ESC (which will cancel the dialog) or to spotter commands (shift+ENTER and that).

"
Trait {
	#name : 'GtkTWindowSpecialCharacterForText',
	#category : 'Spec-Gtk-Adapter-Window',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Window'
}

{ #category : 'private - building' }
GtkTWindowSpecialCharacterForText >> addSpecialActionsToTextWidget: anAdapter [
	"add special actions to a text family widget. 
	 a special action is one that has a shortcut that cannot be let pass by the widget unless 
	 explicitly defined"
	| specialUserActions specialInternalActions |

	specialInternalActions := self specialActionsOn: self presenter internalActions.
	specialUserActions := self specialActionsOn: self presenter actions.
	(specialUserActions isEmpty and: [ specialInternalActions isEmpty ])
		ifTrue: [ ^ self ].
	
	anAdapter addActionGroup: (SpActionGroup new 
		name: #'window-special-characters-text';
		addAll: specialInternalActions;
		addAll: specialUserActions;
		yourself)
]

{ #category : 'private - building' }
GtkTWindowSpecialCharacterForText >> isSpecialCharacterForText: aKeyCombination [

	aKeyCombination combinationsDo: [ :each |  
		each isForPlatform ifTrue: [ 
			({ KeyboardKey escape. KeyboardKey enter } includes: each key) 
				ifTrue: [ ^ true ] ] ].
		
	^ false
]

{ #category : 'private - building' }
GtkTWindowSpecialCharacterForText >> specialActionsOn: anActionGroup [

	anActionGroup ifNil: [ ^ #() ].

	^ anActionGroup allCommands 
		select: [ :each | self isSpecialCharacterForText: each shortcutKey  ]
]
