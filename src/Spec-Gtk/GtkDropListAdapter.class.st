Class {
	#name : #GtkDropListAdapter,
	#superclass : #GtkAbstractListAdapter,
	#category : #'Spec-Gtk-Adapter-List'
}

{ #category : #building }
GtkDropListAdapter >> addModelTo: gtkDropDown [
	
	super addModelTo: gtkDropDown.
	self setModelTo: gtkDropDown.
	
	gtkDropDown connectChanged: [ self selectionChangedOnGtk ].
	self presenter whenSelectionChangedDo: [ self selectionChangedOnPresenter ].
	self presenter model whenChangedDo: [ self modelChangedOnPresenter ].
	
	(self presenter isStartWithSelection
		and: [ self presenter model isEmpty not
		and: [ self presenter selectedIndex = 0 ] ]) 
		ifTrue: [ gtkDropDown selectIndex: 1 ]
		ifFalse: [ 
			self presenter selectedIndex 
				ifNotNil: [ :index | gtkDropDown activeIndex: index - 1 ] ]
]

{ #category : #private }
GtkDropListAdapter >> disconnectSelectionEventsOf: aWidget during: aBlock [

	aWidget 
		blockCallback: GChangedCallback signalName
		during: aBlock
]

{ #category : #accessing }
GtkDropListAdapter >> displayedIcon [
	| selectedIndex |

	selectedIndex := widget activeIndex.
	
	selectedIndex = -1 ifTrue: [ ^ nil ].

	self hasIcons ifFalse: [ ^ nil ].
	^ (widget model iteratorFromString: selectedIndex asString) gdkPixbufAt: 0 
]

{ #category : #accessing }
GtkDropListAdapter >> elementAt: index [

	^ self presenter model at: index
]

{ #category : #testing }
GtkDropListAdapter >> hasIcons [

	^ self presenter hasIcons
]

{ #category : #private }
GtkDropListAdapter >> modelChangedOnPresenter [
			
	self innerWidgetDo: [ :w |
		self
			disconnectSelectionEventsOf: w
			during: [ self setModelTo: w ] ]
]

{ #category : #building }
GtkDropListAdapter >> modelItemsAsDisplay [
	
	^ self presenter model items 
		collect: [ :each | self presenter displayForItem: each ]
]

{ #category : #building }
GtkDropListAdapter >> newTreeStore [

	self hasIcons 
		ifFalse: [ ^ GtkTreeStore newStrings: self modelItemsAsDisplay ].
		
	^ self newTreeStoreWithIcons
]

{ #category : #building }
GtkDropListAdapter >> newTreeStoreWithIcons [
	| store |

	store := GtkTreeStore newColumnTypes: { GType GDK_TYPE_PIXBUF. GType G_TYPE_STRING }.

	self presenter model items do: [ :each | 
		store appendNew
			at: 0 putObject: (GdkPixbuf newForm: (self model getIconFor: each));
			at: 1 putString: (self model displayForItem: each)].

	^ store
]

{ #category : #accessing }
GtkDropListAdapter >> selectIndex: anInteger [ 
	
	self widgetDo: [ :w |
		w selectIndex: anInteger ]
]

{ #category : #accessing }
GtkDropListAdapter >> selectedIndexes [
	
	^ self widgetDo: #selectedIndexes 
]

{ #category : #private }
GtkDropListAdapter >> selectionChanged [

	self widgetDo: [ :w |
		self presenter selectIndex: w activeIndex + 1 ] 
]

{ #category : #private }
GtkDropListAdapter >> selectionChangedOnGtk [

	self backendDetectCyclesDo: [ 
		self selectionChanged ]
]

{ #category : #private }
GtkDropListAdapter >> selectionChangedOnPresenter [
			
	self backendUpdatingDo: [
		self innerWidgetDo: [ :w | w activeIndex: self presenter selectedIndex - 1 ] ]
]

{ #category : #building }
GtkDropListAdapter >> setModelTo: gtkDrowDown [

	self hasIcons 
		ifTrue: [  ]
		ifFalse: [ ].
	
	gtkDrowDown model: self newTreeStore
]

{ #category : #building }
GtkDropListAdapter >> takeKeyboardFocus [ 

	^ self doTakeKeyboardFocus
]

{ #category : #building }
GtkDropListAdapter >> unsubscribe [ 

	self presenter selection unsubscribeOuterContextReceiver: self.
	
	"unsubscribe subscription made in SpCollectionListModel>>#whenChangedDo:"
	self presenter model announcer unsubscribe: self presenter model.
	
	super unsubscribe
]

{ #category : #building }
GtkDropListAdapter >> widgetClass [

	^ GtkDropDown
]
