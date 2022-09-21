"
I'm a base configuration for GTK applications. 
I have some convenience methods useful to configure GTK applications
"
Class {
	#name : #SpGtkConfiguration,
	#superclass : #SpApplicationConfiguration,
	#instVars : [
		'textBackgroundColor',
		'buttonBackgroundColor',
		'buttonSelectedColor',
		'listActiveColor',
		'listSelectedColor',
		'panelBackgroundColor'
	],
	#category : #'Spec-Gtk-Base'
}

{ #category : #private }
SpGtkConfiguration >> addCSSProviderFromPath: aString [

	GRunLoop defer: [ 	
		(GtkCssProvider newFromPath: aString) addForApplicationToDefaultScreen ]
]

{ #category : #private }
SpGtkConfiguration >> addCSSProviderFromReference: aReference [

	GRunLoop defer: [ 
		(GtkCssProvider newFromReference: aReference) addForApplicationToDefaultScreen ]
]

{ #category : #private }
SpGtkConfiguration >> addCSSProviderFromString: aString [

	GRunLoop defer: [ 
		(GtkCssProvider newFromString: aString) addForApplicationToDefaultScreen ]
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> buttonBackgroundColor [
	"Taking the background color of a GtkTextView is a hack to determine if we are in presence of a 
	 dark or light theme"
	
	^ GRunLoop defer: [ 
		| widget |
		widget := GtkButton new. 
		widget autoRelease. 
		widget styleContext getBackgroundRGBAColor asColor ]
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> buttonSelectedColor [
	
	^ buttonSelectedColor ifNil: [ buttonSelectedColor := self getButtonSelectedColor ]
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
	
	^ buttonBackgroundColor ifNil: [ buttonBackgroundColor := self getButtonBackgroundColor ]
]

{ #category : #private }
SpGtkConfiguration >> getButtonSelectedColor [
	
	^ GRunLoop defer: [ 
		| widget |
		widget := GtkButton new. 
		widget autoRelease. 
		widget styleContext getSelectedRGBAColor asColor ]
]

{ #category : #private }
SpGtkConfiguration >> getListActiveColor [
	
	^ GRunLoop defer: [ 
		| widget |
		widget := GtkTreeView new. 
		widget autoRelease. 
		widget styleContext getActiveRGBAColor asColor ]
]

{ #category : #private }
SpGtkConfiguration >> getListSelectedColor [
	
	^ GRunLoop defer: [ 
		| widget |
		widget := GtkTreeView new. 
		widget autoRelease. 
		widget styleContext getSelectedRGBAColor asColor ]
]

{ #category : #private }
SpGtkConfiguration >> getPanelBackgroundColor [
	
	^ GRunLoop defer: [ 
		| widget |
		widget := GtkBox newVertical. 
		widget autoRelease. 
		widget styleContext getBackgroundRGBAColor asColor ]
]

{ #category : #private }
SpGtkConfiguration >> getTextBackgroundColor [

	^ GRunLoop defer: [ 
		| widget |
		widget := GtkTextView new. 
		widget autoRelease. 
		widget styleContext getBackgroundRGBAColor asColor ]
]

{ #category : #private }
SpGtkConfiguration >> installTheme: aString [

	self settings themeName: aString
]

{ #category : #testing }
SpGtkConfiguration >> isDarkTheme [

	^ self detectDarkTheme
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> listActiveColor [
	
	^ listActiveColor ifNil: [ listActiveColor := self getListActiveColor ]
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> listSelectedColor [
	
	^ listSelectedColor ifNil: [ listSelectedColor := self getListSelectedColor ]
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> panelBackgroundColor [
	
	^ panelBackgroundColor ifNil: [ panelBackgroundColor := self getPanelBackgroundColor ]
]

{ #category : #private }
SpGtkConfiguration >> reset [ 

	super reset.
	textBackgroundColor := nil. 
	buttonBackgroundColor  := nil. 
	buttonSelectedColor  := nil. 
	listActiveColor  := nil. 
	listSelectedColor  := nil. 
	panelBackgroundColor  := nil
]

{ #category : #'private accessing' }
SpGtkConfiguration >> settings [ 

	^ GtkSettings default
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> textBackgroundColor [
	"Taking the background color of a GtkTextView is a hack to determine if we are in presence of a 
	 dark or light theme"
	
	^ textBackgroundColor ifNil: [ textBackgroundColor := self getTextBackgroundColor ]
]
