"
I'm a base configuration for GTK applications. 
I have some convenience methods useful to configure GTK applications
"
Class {
	#name : #SpGtkConfiguration,
	#superclass : #SpApplicationConfiguration,
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
		widget markForAutoRelease. 
		widget styleContext getBackgroundRGBAColor asColor ]
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> buttonSelectedColor [
	"Taking the background color of a GtkTextView is a hack to determine if we are in presence of a 
	 dark or light theme"
	
	^ GRunLoop defer: [ 
		| widget |
		widget := GtkButton new. 
		widget markForAutoRelease. 
		widget styleContext getSelectedRGBAColor asColor ]
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
	| backgroundColor |

	"Taking the background color of a GtkTextView is a hack to determine if we are in presence of a 
	 dark or light theme"
	backgroundColor := self textBackgroundColor.
	
	^ backgroundColor luminance < 0.5
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
	"Taking the background color of a GtkTextView is a hack to determine if we are in presence of a 
	 dark or light theme"
	
	^ GRunLoop defer: [ 
		| widget |
		widget := GtkTreeView new. 
		widget markForAutoRelease. 
		widget styleContext getActiveRGBAColor asColor ]
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> listSelectedColor [
	"Taking the background color of a GtkTextView is a hack to determine if we are in presence of a 
	 dark or light theme"
	
	^ GRunLoop defer: [ 
		| widget |
		widget := GtkTreeView new. 
		widget markForAutoRelease. 
		widget styleContext getSelectedRGBAColor asColor ]
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> panelBackgroundColor [
	"Taking the background color of a GtkTextView is a hack to determine if we are in presence of a 
	 dark or light theme"
	
	^ GRunLoop defer: [ 
		| widget |
		widget := GtkBox newVertical. 
		widget markForAutoRelease. 
		widget styleContext getBackgroundRGBAColor asColor ]
]

{ #category : #'private accessing' }
SpGtkConfiguration >> settings [ 

	^ GtkSettings default
]

{ #category : #'accessing - colors' }
SpGtkConfiguration >> textBackgroundColor [
	"Taking the background color of a GtkTextView is a hack to determine if we are in presence of a 
	 dark or light theme"
	
	^ GRunLoop defer: [ 
		| widget |
		widget := GtkTextView new. 
		widget markForAutoRelease. 
		widget styleContext getBackgroundRGBAColor asColor ]
]
