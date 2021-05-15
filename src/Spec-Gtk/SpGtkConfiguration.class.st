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

	(GtkCssProvider newFromPath: aString) addForApplicationToDefaultScreen
]

{ #category : #private }
SpGtkConfiguration >> addCSSProviderFromReference: aReference [

	(GtkCssProvider newFromReference: aReference) addForApplicationToDefaultScreen
]

{ #category : #private }
SpGtkConfiguration >> addCSSProviderFromString: aString [

	(GtkCssProvider newFromString: aString) addForApplicationToDefaultScreen
]

{ #category : #configuring }
SpGtkConfiguration >> configure: anApplication [

	GtkRunLoop defer: [
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
	backgroundColor := GtkRunLoop defer: [ 
		| widget |
		widget := GtkTextView new. 
		widget markForAutoRelease. 
		widget styleContext getBackgroundColor ].
	
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

{ #category : #'private accessing' }
SpGtkConfiguration >> settings [ 

	^ GtkSettings default
]
