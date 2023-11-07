"
Gtk adapter for `SpDropListPresenter`
"
Class {
	#name : 'GtkDropListAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Adapter-List',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-List'
}

{ #category : 'building' }
GtkDropListAdapter >> addModelTo: gtkDropDown [
	
	super addModelTo: gtkDropDown.
	
	gtkDropDown factory: self newItemFactory.	
	gtkDropDown expression: (GtkCClosureExpression newStringCallback: [ :handle |
		(gtkDropDown model itemAtHandle: handle)
			ifNotNil: [ :item | self presenter displayForItem: item ] ]).
	
	self setModelTo: gtkDropDown.
	
	gtkDropDown connectSelectedItem: [ self selectionChangedOnGtk ].
	self presenter whenSelectionChangedDo: [ self selectionChangedOnPresenter ].
	self presenter model whenChangedDo: [ self modelChangedOnPresenter ].
	
	self presenter selection selectedIndex ~= 0
		ifTrue: [ 
			gtkDropDown select: self presenter selection selectedIndex - 1 ]
		ifFalse: [
			self flag: #TODO. "This may lead to a desync between component value and widget? VERIFY!"
			(self presenter isStartWithSelection
				and: [ self presenter model isEmpty not
				and: [ self presenter selectedIndex = 0 ] ]) 
				ifTrue: [ gtkDropDown select: 1 ]
				ifFalse: [ gtkDropDown unselectAll ] ]
]

{ #category : 'private' }
GtkDropListAdapter >> disconnectSelectionEventsOf: aWidget during: aBlock [

	aWidget 
		blockCallback: GChangedCallback signalName
		during: aBlock
]

{ #category : 'accessing' }
GtkDropListAdapter >> elementAt: index [

	^ self presenter model at: index
]

{ #category : 'testing' }
GtkDropListAdapter >> hasIcons [

	^ self presenter hasIcons
]

{ #category : 'private' }
GtkDropListAdapter >> modelChangedOnPresenter [
			
	self innerWidgetDo: [ :w |
		self
			disconnectSelectionEventsOf: w
			during: [ self setModelTo: w ] ]
]

{ #category : 'private - factory' }
GtkDropListAdapter >> newItemFactory [

	^ GtkDropListAdapterItemFactory newPresenter: self presenter
]

{ #category : 'private - factory' }
GtkDropListAdapter >> newStore [

	^ GtkFilterListModel new
		model: (GListReferenceStore new
			items: self presenter getList;
			yourself);
		yourself
]

{ #category : 'accessing' }
GtkDropListAdapter >> selectIndex: index [ 
	
	self widgetDo: [ :w |
		w select: index + 1 ]
]

{ #category : 'private - updating' }
GtkDropListAdapter >> selectionChanged [

	self widgetDo: [ :w |
		self presenter selectIndex: w selected + 1 ] 
]

{ #category : 'private - updating' }
GtkDropListAdapter >> selectionChangedOnGtk [

	self backendDetectCyclesDo: [ 
		self selectionChanged ]
]

{ #category : 'private - updating' }
GtkDropListAdapter >> selectionChangedOnPresenter [
			
	self backendUpdatingDo: [
		self innerWidgetDo: [ :w | w select: self presenter selectedIndex - 1 ] ]
]

{ #category : 'building' }
GtkDropListAdapter >> setModelTo: gtkDropDown [

	gtkDropDown model: self newStore.
	gtkDropDown factory reset
]

{ #category : 'building' }
GtkDropListAdapter >> takeKeyboardFocus [ 

	^ self doTakeKeyboardFocus
]

{ #category : 'building' }
GtkDropListAdapter >> unsubscribe [ 

	self presenter selection unsubscribeOuterContextReceiver: self.
	
	"unsubscribe subscription made in SpCollectionListModel>>#whenChangedDo:"
	self presenter model announcer unsubscribe: self presenter model.
	
	super unsubscribe
]

{ #category : 'building' }
GtkDropListAdapter >> widgetClass [

	^ GtkDropDown
]
