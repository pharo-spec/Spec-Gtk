Class {
	#name : #GtkDropListAdapter,
	#superclass : #GtkAbstractListAdapter,
	#category : #'Spec-Gtk-Adapter-List'
}

{ #category : #building }
GtkDropListAdapter >> addModelTo: gtkComboBox [
	
	super addModelTo: gtkComboBox.
	self setModelTo: gtkComboBox.
	
	gtkComboBox connectChanged: [ self selectionChanged ].
	self model whenSelectionChangedDo: [ 
		gtkComboBox activeIndex: self model selectedIndex - 1 ].
	self model model whenChangedDo: [ 
		self
			disconnectSelectionEventsOf: gtkComboBox
			during: [ self setModelTo: gtkComboBox ] ].
		
	self model selectedIndex 
		ifNotNil: [ :index | gtkComboBox activeIndex: index - 1 ]
]

{ #category : #private }
GtkDropListAdapter >> disconnectSelectionEventsOf: aWidget during: aBlock [

	aWidget 
		blockCallback: 'changed'
		during: aBlock
]

{ #category : #accessing }
GtkDropListAdapter >> displayedIcon [
	
	| selectedIndex |
	selectedIndex := widget activeIndex.
	
	selectedIndex = -1 ifTrue: [ ^ nil ].
	
	self model hasIcons ifFalse: [ ^ nil ].
	
	^ (widget model iteratorFromString: selectedIndex asString) gdkPixbufAt: 0 
]

{ #category : #accessing }
GtkDropListAdapter >> elementAt: index [

	^ self presenter model at: index
]

{ #category : #building }
GtkDropListAdapter >> modelItemsAsDisplay [
	
	^ self presenter model items 
		collect: [ :each | self presenter displayForItem: each]
	
]

{ #category : #building }
GtkDropListAdapter >> newTreeStore [

	self presenter hasIcons 
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

{ #category : #building }
GtkDropListAdapter >> setModelTo: gtkComboBox [
	| columnIndex |

	columnIndex := 0.
	gtkComboBox clear.
	self presenter hasIcons ifTrue: [ 
		gtkComboBox appendPixbufColumn: columnIndex.
		columnIndex := columnIndex + 1 ].
	gtkComboBox appendTextColumn: columnIndex.
	gtkComboBox model: self newTreeStore

]

{ #category : #building }
GtkDropListAdapter >> takeKeyboardFocus [ 

	^ self doTakeKeyboardFocus
]

{ #category : #building }
GtkDropListAdapter >> unsubscribe [ 

	| subscriptionsToRemove |
	self presenter selection unsubscribeOuterContextReceiver: self.
	
	"please, pretend you haven't seen this"
	subscriptionsToRemove := self presenter model announcer subscriptions subscriptions select: [:sub | (sub action at: 1) receiver = self ].
	subscriptionsToRemove do: [ :sub |
		self presenter model announcer subscriptions remove: sub ].
	
	super unsubscribe.
]

{ #category : #building }
GtkDropListAdapter >> widgetClass [
	
	^ GtkComboBox
]
