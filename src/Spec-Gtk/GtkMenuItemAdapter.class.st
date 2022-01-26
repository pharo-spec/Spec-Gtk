Class {
	#name : #GtkMenuItemAdapter,
	#superclass : #GtkMenuBaseAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #accessing }
GtkMenuItemAdapter class >> defaultSpacing [

	^ 5
]

{ #category : #private }
GtkMenuItemAdapter >> addAcceleratorShortcut: shortcut to: gtkWidget [
	
	self flag: #HACK.	"this is to ensure is not a key combination (gtk does not allows them)"
	shortcut spGtkCurrentCharacter asString ifEmpty: [ ^ self ].

	gtkWidget
		addAccelerator: 'activate'
		group: self shortcutGroup
		shortcut: shortcut
]

{ #category : #private }
GtkMenuItemAdapter >> addAcceleratorShortcutLabel: shortcut to: gtkBox [
	
	self flag: #HACK. "this is to ensure is not a key combination (gtk does not allows them)"
	shortcut spGtkCurrentCharacter asString ifEmpty: [ ^ self ].
	
	gtkBox 
		packEnd: (GtkAccelLabel newAccelerator: shortcut)
		expand: false 
		fill: false
		padding: 0
]

{ #category : #building }
GtkMenuItemAdapter >> addModelTo: gtkWidget [
	"label (and icon if there)"

	self presenter icon
		ifNotNil: [ gtkWidget add: (self menuLabelWithIconAndAccelFor: gtkWidget) ]
		ifNil: [ 
			(self presenter name includes: $_) 
				ifTrue: [ gtkWidget useUnderline: true ].
			gtkWidget label: self presenter name ].
	
	self presenter whenNameChangedDo: [ self updateName ].
	self presenter whenIconChangedDo: [ self updateIcon ].
		
	"accel"
	self presenter shortcut ifNotNil: [ :shortcut | 
		self addAcceleratorShortcut: shortcut to: gtkWidget ].
	"enabled?"
	gtkWidget sensitive: self presenter isEnabled value.

	"action"
	self presenter action ifNotNil: [ :actionBlock |
		gtkWidget connectActivate: actionBlock ].

	"submenu"
	self presenter subMenu
		ifNotNil: [ :menuPresenter | gtkWidget submenu: menuPresenter build ]
]

{ #category : #'private accessing' }
GtkMenuItemAdapter >> getNameText [

	^ self presenter name ifNotNil: [ :aString | 
		aString localizedForPresenter: self presenter ]
]

{ #category : #building }
GtkMenuItemAdapter >> menuLabelWithIconAndAccelFor: gtkWidget [
	| gtkBox gtkLabel |
	
	gtkBox := (GtkBox newHorizontalSpacing: self class defaultSpacing)
		packStart: (self presenter icon value ifNil: [ self iconNamed: #blank ]) asGtkImage
			expand: false 
			fill: false 
			padding: 0;
		packStart: (gtkLabel := GtkLabel new);
		yourself.

	self presenter name ifNotNil: [ 
		(self presenter name includes: $_)
			ifTrue: [ 
				gtkLabel 
					useUnderline: true;
					textWithMnemonic: self presenter name;
					mnemonicWidget: gtkWidget ]
			ifFalse: [ 
				gtkLabel label: self presenter name ] ].		

	self presenter shortcut ifNotNil: [ :shortcut |
		self addAcceleratorShortcutLabel: shortcut to: gtkBox ].
		
	gtkBox showAll.

	^ gtkBox
]

{ #category : #private }
GtkMenuItemAdapter >> shortcutGroup [ 
	| root |
	
	root := self model rootMenu.
	^ root shortcutGroup ifNil: [ | group |
		group := GtkAccelGroup new.
		root shortcutGroup: group.
		group ]
]

{ #category : #'private updating' }
GtkMenuItemAdapter >> updateIcon [

	self innerWidgetDo: [ :w |
		w hasChildren ifTrue: [ w removeAll ].
		w add: (self menuLabelWithIconAndAccelFor: w) ].
]

{ #category : #'private updating' }
GtkMenuItemAdapter >> updateName [

	self innerWidgetDo: [ :w |
		"if it has children it means it already has a component with icon"
		w hasChildren 
			ifTrue: [ 
				w removeAll.
				w add: (self menuLabelWithIconAndAccelFor: w) ]
			ifFalse: [
				w label: self presenter name ] ].
]

{ #category : #accessing }
GtkMenuItemAdapter >> widgetClass [

	^ GtkMenuItem
]
