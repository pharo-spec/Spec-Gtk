Class {
	#name : #GtkNotebookAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #private }
GtkNotebookAdapter >> addContentPage: gtkPage [	
	| box presenter |
	
	box := gtkPage content.
	box hasChildren ifTrue: [ ^ self ].
	
	presenter := gtkPage data retrievePresenter.
	presenter owner: self model.
	box packStart: (self buildPage: presenter)
]

{ #category : #building }
GtkNotebookAdapter >> addModelTo: gtkWidget [

	gtkWidget beScrollable.

	self model pages do: [ :each | self appendPage: each to: gtkWidget ].

	"I add contents to fist page because this will shown anyway (and like this I allow
	 the layout to act correctly)"
	self presenter pages
		ifNotEmpty: [ self presenter selectedPage
				ifNil: [ self presenter selectPageIndex: 1 ].
			self
				addContentPage: (gtkWidget pageWithData: self model selectedPage) ].
	self presenter
		whenSelectedPageChangedDo: [ :page | self selectPage: page ].

	"get when page changed"
	gtkWidget
		connectSwitchPage: [ :aPage | 
			self addContentPage: aPage.
			self backendUpdatingDo: [ self presenter selectPage: aPage data ] ].

	"get when model changed"
	self presenter
		whenPagesChangedDo: [ :pages | self updatePagesWith: pages ]
]

{ #category : #building }
GtkNotebookAdapter >> appendPage: each to: gtkWidget [
	| page |
	page := gtkWidget
		newPageLabel: (self buildLabelForTab: each)
		content:
			(GtkBox newVertical
				show;
				yourself).
	page data: each.
	^ gtkWidget append: page
]

{ #category : #building }
GtkNotebookAdapter >> buildLabelForTab: aPage [
	| label |

	label := GtkLabel newLabel: aPage title asString.
	aPage icon ifNotNil: [ :icon |
		label := GtkBox newHorizontal
			packStart: icon asGtkImage
				expand: false 
				fill: false 
				padding: 0;
			packStart: label;
			showAll ].

	^ label
]

{ #category : #building }
GtkNotebookAdapter >> buildPage: aPresenter [

	^ SpBindings 
	 	value: self model application adapterBindings
		during: [ aPresenter buildWithSpec ]
]

{ #category : #private }
GtkNotebookAdapter >> clickTab: index [
	"used for testing purposes"
	
	(self widget children at: index) select
]

{ #category : #private }
GtkNotebookAdapter >> numberOfTabs [

	^ self widget children size
]

{ #category : #private }
GtkNotebookAdapter >> removePageContent: gtkPage [
	| box |

	box := gtkPage content.
	box hasChildren ifFalse: [ ^ self ].
	box removeAll
]

{ #category : #updating }
GtkNotebookAdapter >> selectPage: aPage [ 
	
	self widgetDo: [ :w |
		(w pageWithData: aPage) select ]
]

{ #category : #updating }
GtkNotebookAdapter >> selectedPage [ 
	
	self selectPage: self model selectedPage
]

{ #category : #private }
GtkNotebookAdapter >> selectedPageName [
	"used for testing purposes"
	| index |

	index := self model selectedPageIndex. 
	^ index > 0 
		ifTrue: [ (self widget children at: index) labelText ]
		ifFalse: [ nil ]
]

{ #category : #updating }
GtkNotebookAdapter >> updatePageContent: aPage [

	self widgetDo: [ :w | | widgetPage |
		widgetPage := w pageWithData: aPage. 
		self removePageContent: widgetPage.
		self model selectedPage = aPage ifTrue: [ 
			self addContentPage: widgetPage ] ]
]

{ #category : #updating }
GtkNotebookAdapter >> updatePageTitle: aPage [

	self widgetDo: [ :w | | widgetPage |
		widgetPage := w pageWithData: aPage.
		widgetPage updateLabel: (self buildLabelForTab: aPage) ]
]

{ #category : #building }
GtkNotebookAdapter >> updatePagesWith: aCollection [
	
	self widgetDo: [ :w | | pagesToRemove |
		pagesToRemove := w children 
			reject: [ :eachPage | aCollection includes: eachPage data ].
		pagesToRemove do: [ :eachPage | w remove: eachPage ].
		aCollection 
			reject: [ :page | (w pageWithData: page ifNone: [ nil ]) notNil ]
			thenDo: [ :page | self appendPage: page to: w ] ]
]

{ #category : #building }
GtkNotebookAdapter >> widgetClass [

	^ GtkNotebook
]
