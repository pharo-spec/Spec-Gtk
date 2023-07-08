"
I'm a base configuration for GTK applications. 
I have some convenience methods useful to configure GTK applications
"
Class {
	#name : #SpGtkConfiguration,
	#superclass : #SpApplicationConfiguration,
	#instVars : [
		'listSelectedColor',
		'providers'
	],
	#category : #'Spec-Gtk-Base'
}

{ #category : #'accessing - style' }
SpGtkConfiguration >> addCSSProviderFromPath: aString [
	| provider |

	GRunLoop defer: [
		provider := GtkCssProvider newFromPath: aString. 
		provider addForApplicationToDefaultDisplay.
		self keepProvider: provider ]
]

{ #category : #'accessing - style' }
SpGtkConfiguration >> addCSSProviderFromReference: aReference [
	| provider |

	GRunLoop defer: [
		provider := GtkCssProvider newFromReference: aReference.
		provider addForApplicationToDefaultDisplay.
		self keepProvider: provider ]
]

{ #category : #'accessing - style' }
SpGtkConfiguration >> addCSSProviderFromString: aString [
	| provider |

	GRunLoop defer: [
		provider := GtkCssProvider newFromString: aString. 
		provider addForApplicationToDefaultDisplay.
		self keepProvider: provider ]
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> buttonBackgroundColor [
	"Taking the background color of a GtkTextView is a hack to determine if we are in presence of a
	 dark or light theme"

	self deprecated: #Gtk4
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> buttonSelectedColor [

	self deprecated: #Gtk4
]

{ #category : #configuring }
SpGtkConfiguration >> configure: anApplication [

	GRunLoop defer: [
		self configureGeneral: anApplication.
		super configure: anApplication ]
]

{ #category : #configuring }
SpGtkConfiguration >> configureGeneral: anApplication [
	"A hook to configure a gtk application for all platforms"
]

{ #category : #private }
SpGtkConfiguration >> detectDarkTheme [

	"Taking the background color of a GtkTextView is a hack to determine if we are 
	 in presence of a dark or light theme"
	^ self textBackgroundColor luminance < 0.5
]

{ #category : #private }
SpGtkConfiguration >> getButtonBackgroundColor [

	self deprecated: #Gtk4
]

{ #category : #private }
SpGtkConfiguration >> getButtonSelectedColor [

	self deprecated: #Gtk4
]

{ #category : #private }
SpGtkConfiguration >> getListActiveColor [

	self deprecated: #Gtk4
]

{ #category : #private }
SpGtkConfiguration >> getListSelectedColor [

	^ GRunLoop defer: [
		| widget |
		widget := GtkListView new.
		widget autoRelease.
		widget styleContext getSelectedRGBAColor asColor ]
]

{ #category : #private }
SpGtkConfiguration >> getPanelBackgroundColor [

	self deprecated: #Gtk4
]

{ #category : #private }
SpGtkConfiguration >> getTextBackgroundColor [

	self deprecated: #Gtk4
]

{ #category : #private }
SpGtkConfiguration >> installTheme: aString [

	self settings themeName: aString
]

{ #category : #testing }
SpGtkConfiguration >> isDarkTheme [

	^ self detectDarkTheme
]

{ #category : #private }
SpGtkConfiguration >> keepProvider: aProvider [

	providers ifNil: [ providers := #() ].
	providers := providers copyWith: aProvider
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> listActiveColor [

	self deprecated: #Gtk4
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> listSelectedColor [

	^ listSelectedColor ifNil: [ listSelectedColor := self getListSelectedColor ]
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> panelBackgroundColor [

	self deprecated: #Gtk4
]

{ #category : #accessing }
SpGtkConfiguration >> preferDarkTheme: aBoolean [

	GRunLoop defer: [ GtkSettings default preferDarkTheme: aBoolean ]
]

{ #category : #'private - accessing' }
SpGtkConfiguration >> settings [

	^ GtkSettings default
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> textBackgroundColor [
	"Taking the background color of a GtkTextView is a hack to determine if we are in presence of a
	 dark or light theme"

	self deprecated: #Gtk4
]
