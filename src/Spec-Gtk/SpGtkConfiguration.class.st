"
I'm a base configuration for GTK applications. 
I have some convenience methods useful to configure GTK applications
"
Class {
	#name : 'SpGtkConfiguration',
	#superclass : 'SpApplicationConfiguration',
	#instVars : [
		'listSelectedColor',
		'providers',
		'syntaxHighlightThemeName',
		'styleScheme'
	],
	#category : 'Spec-Gtk-Base',
	#package : 'Spec-Gtk',
	#tag : 'Base'
}

{ #category : 'accessing - style' }
SpGtkConfiguration >> addCSSProviderFromPath: aString [
	| provider |

	GRunLoop defer: [
		provider := GtkCssProvider newFromPath: aString. 
		provider addForApplicationToDefaultDisplay.
		self keepProvider: provider ]
]

{ #category : 'accessing - style' }
SpGtkConfiguration >> addCSSProviderFromReference: aReference [
	| provider |

	GRunLoop defer: [
		provider := GtkCssProvider newFromReference: aReference.
		provider addForApplicationToDefaultDisplay.
		self keepProvider: provider ]
]

{ #category : 'accessing - style' }
SpGtkConfiguration >> addCSSProviderFromString: aString [
	| provider |

	GRunLoop defer: [
		provider := GtkCssProvider newFromString: aString. 
		provider addForApplicationToDefaultDisplay.
		self keepProvider: provider ]
]

{ #category : 'configuring' }
SpGtkConfiguration >> addPredefinedStyles [
	
	self addCSSProviderFromString: self baseStyle.
	self addCSSProviderFromString: (self isDarkTheme 
		ifTrue: [ self styleForToolbarDark ]
		ifFalse: [ self styleForToolbarLight ])
]

{ #category : 'configuring' }
SpGtkConfiguration >> baseStyle [

	^ '
/* compact toolbar */
box.toolbar { font-size: 0.6em; font-weight: lighter; }
box.toolbar .toolbarButton > button { padding: 1px; margin: 1px; }

/* action areas for dialogs */
box.action_area { min-height: 50px; }
box.action_area > button:first-child { 
	border-radius: 0;
	border-bottom-left-radius: 13px; 
	border-left: none; 
}
box.action_area > button:last-child { 
	border-radius: 0;
	border-bottom-right-radius: 13px;
	border-right: none; 
}
'
]

{ #category : 'accessing - colors' }
SpGtkConfiguration >> buttonBackgroundColor [
	"Taking the background color of a GtkTextView is a hack to determine if we are in presence of a
	 dark or light theme"

	self deprecated: #Gtk4
]

{ #category : 'accessing - colors' }
SpGtkConfiguration >> buttonSelectedColor [

	self deprecated: #Gtk4
]

{ #category : 'configuring' }
SpGtkConfiguration >> configure: anApplication [

	GRunLoop defer: [
		self addPredefinedStyles.
		self configureGeneral: anApplication.
		super configure: anApplication ]
]

{ #category : 'configuring' }
SpGtkConfiguration >> configureGeneral: anApplication [
	"A hook to configure a gtk application for all platforms"
]

{ #category : 'private - accessing' }
SpGtkConfiguration >> defaultStyleScheme [

	^ self isDarkTheme
		ifTrue: [ 'Adwaita-dark' ]
		ifFalse: [ 'Adwaita' ]
]

{ #category : 'private' }
SpGtkConfiguration >> detectDarkTheme [

	self flag: #TODO. "Find a way to actually detect this"
	^ false
]

{ #category : 'private' }
SpGtkConfiguration >> getButtonBackgroundColor [

	self deprecated: #Gtk4
]

{ #category : 'private' }
SpGtkConfiguration >> getButtonSelectedColor [

	self deprecated: #Gtk4
]

{ #category : 'private' }
SpGtkConfiguration >> getListActiveColor [

	self deprecated: #Gtk4
]

{ #category : 'private' }
SpGtkConfiguration >> getListSelectedColor [

	^ GRunLoop defer: [
		| widget |
		widget := GtkListView new.
		widget autoRelease.
		widget styleContext getSelectedRGBAColor asColor ]
]

{ #category : 'private' }
SpGtkConfiguration >> getPanelBackgroundColor [

	self deprecated: #Gtk4
]

{ #category : 'private' }
SpGtkConfiguration >> getTextBackgroundColor [

	self deprecated: #Gtk4
]

{ #category : 'private' }
SpGtkConfiguration >> installTheme: aString [

	self settings themeName: aString
]

{ #category : 'testing' }
SpGtkConfiguration >> isDarkTheme [

	^ self detectDarkTheme
]

{ #category : 'private' }
SpGtkConfiguration >> keepProvider: aProvider [

	providers ifNil: [ providers := #() ].
	providers := providers copyWith: aProvider
]

{ #category : 'accessing - colors' }
SpGtkConfiguration >> listActiveColor [

	self deprecated: #Gtk4
]

{ #category : 'accessing - colors' }
SpGtkConfiguration >> listSelectedColor [

	^ listSelectedColor ifNil: [ listSelectedColor := self getListSelectedColor ]
]

{ #category : 'accessing - colors' }
SpGtkConfiguration >> panelBackgroundColor [

	self deprecated: #Gtk4
]

{ #category : 'accessing' }
SpGtkConfiguration >> preferDarkTheme: aBoolean [

	GRunLoop defer: [ GtkSettings default preferDarkTheme: aBoolean ]
]

{ #category : 'private - accessing' }
SpGtkConfiguration >> settings [

	^ GtkSettings default
]

{ #category : 'configuring' }
SpGtkConfiguration >> styleForToolbarDark [
		
	^ '
box.toolbar label { 
	color: #C0C0C0; 
}
'
]

{ #category : 'configuring' }
SpGtkConfiguration >> styleForToolbarLight [
		
	^ '
box.toolbar label { 
	color: #808080; 
}
'
]

{ #category : 'accessing - style' }
SpGtkConfiguration >> styleScheme [

	^ styleScheme ifNil: [ self defaultStyleScheme ]
]

{ #category : 'accessing - style' }
SpGtkConfiguration >> styleScheme: aName [
	"The name of the style scheme theme to use (e.g. 'Adwaita', 'Adwaita-dark', 'classic', 'classic-dark', 'cobalt', 'cobalt-light', 'kate', 'kate-dark', 'oblivion', 'solarized-dark', 'solarized-light', 'tango'"

	styleScheme := aName
]

{ #category : 'accessing - style' }
SpGtkConfiguration >> syntaxHighlightTheme [
	"Name of theme: Blue, Dark, Vintage, Solarized, Tango"

	^ syntaxHighlightThemeName
]

{ #category : 'accessing - style' }
SpGtkConfiguration >> syntaxHighlightTheme: aName [
	"Name of theme: Blue, Dark, Vintage, Solarized, Tango"

	syntaxHighlightThemeName := aName
]

{ #category : 'accessing - colors' }
SpGtkConfiguration >> textBackgroundColor [
	"Taking the background color of a GtkTextView is a hack to determine if we are in presence of a
	 dark or light theme"

	self deprecated: #Gtk4
]
