Class {
	#name : 'GtkMenuBuilder',
	#superclass : 'Object',
	#instVars : [
		'currentMenu',
		'menu',
		'actionNumber',
		'groupName'
	],
	#category : 'Spec-Gtk-Adapter-Menu',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Menu'
}

{ #category : 'accessing' }
GtkMenuBuilder class >> defaultGroupName [

	^ 'action'
]

{ #category : 'accessing' }
GtkMenuBuilder >> groupName [

	^ groupName ifNil: [ groupName := self class defaultGroupName ]
]

{ #category : 'accessing' }
GtkMenuBuilder >> groupName: aName [

	groupName := aName
]

{ #category : 'private' }
GtkMenuBuilder >> nextActionName [

	^ 'action_{1}' format: { actionNumber := actionNumber + 1 }
]

{ #category : 'visiting' }
GtkMenuBuilder >> visitMenu: aMenuPresenter [
	
	self 
		withCurrentMenu: GMenu new
		do: [
			menu ifNil: [ 
				"first menu creates the compound"
				menu := GMenuCompound newMenu: currentMenu ].
			aMenuPresenter groups 
				do: [ :each | each accept: self ] ]
]

{ #category : 'visiting' }
GtkMenuBuilder >> visitMenuGroup: aMenuGroupPresenter [
	| section |

	section := GMenu new.
	currentMenu appendSection: section.
	self 
		withCurrentMenu: section  
		do: [ 
			aMenuGroupPresenter menuItems
				do: [ :each | each accept: self ] ]
]

{ #category : 'visiting' }
GtkMenuBuilder >> visitMenuItem: aMenuItemPresenter [
	| action |

	action := (GMenuItemActionCompound 
		newPresenter: aMenuItemPresenter
		action: self nextActionName).
	
	currentMenu appendItem: action menuItem.	
	menu addAction: action.
	
	"add submenu if it there is one"
	aMenuItemPresenter subMenu 
		ifNotNil: [ :aMenuPresenter | | subMenu |
			subMenu := GMenu new.
			self 
				withCurrentMenu: subMenu 
				do: [ aMenuPresenter accept: self ].
			action menuItem subMenu: subMenu ]
]

{ #category : 'private' }
GtkMenuBuilder >> withCurrentMenu: aMenu do: aBlock [
	| oldMenu |
	
	oldMenu := currentMenu.
	currentMenu := aMenu.
	aBlock ensure: [ 
		currentMenu := oldMenu ]
	
]
