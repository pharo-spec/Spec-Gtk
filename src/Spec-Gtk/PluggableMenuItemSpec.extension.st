Extension { #name : #PluggableMenuItemSpec }

{ #category : #'*Spec-Gtk' }
PluggableMenuItemSpec >> asMenuItemPresenter [
	"self haltIf: (self separator notNil and: [ self separator ~= false ]). "
	| shortcut |

	shortcut := self keyText ifNotNil: [ 
		self keyText substrings allButFirst 
			inject: KMMetaModifier new + self keyText substrings first first
			into: [ :all :each | all, (each first) ] ].
			
	^ SpMenuItemPresenter new
		name: self label;
		icon: self icon;
		description: self help;
		shortcut: shortcut;
		action: (self action selector ifNotNil: [ self action ]);
		subMenu: (self subMenu ifNotNil: [ self subMenu asMenuPresenter ]);
		yourself
]
