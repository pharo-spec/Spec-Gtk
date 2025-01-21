Class {
	#name : 'GtkBaseTreeListViewAdapter',
	#superclass : 'GtkAdapter',
	#traits : 'GtkTHaveWrappingScrollBars',
	#classTraits : 'GtkTHaveWrappingScrollBars classTrait',
	#instVars : [
		'deferredAction',
		'selectionCompanion'
	],
	#pools : [
		'GtkListScrollFlags'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'building' }
GtkBaseTreeListViewAdapter >> addActionGroup: anActionGroup [
	"this is used to install 'special' actions ported from a window"

	self ensureActionManager 
		installGroup: anActionGroup
		on: self innerWidget
]

{ #category : 'building' }
GtkBaseTreeListViewAdapter >> addModelTo: gtkWidget [

	super addModelTo: gtkWidget.
	gtkWidget connectRealize: [
		self addSpecialActions.
		"I want this just once"
		gtkWidget disconnect: 'realize' ]	
]

{ #category : 'building' }
GtkBaseTreeListViewAdapter >> addSpecialActions [

	self presenter allWindowLike do: [ :each |
		each withAdapterDo: [ :anAdapter |
			anAdapter addSpecialActionsToListWidget: self ] ]
]

{ #category : 'expanding-collapsing' }
GtkBaseTreeListViewAdapter >> collapsePath: aPath [
	| path |
	
	"same as expand, but collapse at the end"
	path := aPath collect: [ :each | each - 1 ].
	self innerWidgetDo: [ :w |
		| treeModel |
		treeModel := w selectionModel model.
		self presenter roots do: [ :each | 
			| row |
			row := self findAndExpandPath: path in: treeModel.
			row ifNotNil: [ 
				row expand: false ] ] ]
]

{ #category : 'private' }
GtkBaseTreeListViewAdapter >> doInitializationDeferredActions [

	deferredAction ifNil: [ ^ self ].
	deferredAction ensure: [ deferredAction := nil ]
]

{ #category : 'expanding-collapsing' }
GtkBaseTreeListViewAdapter >> expandAll [

	self innerWidgetDo: [ :w |
		self 
			expandAll: self presenter roots 
			basePath: #()
			in: w selectionModel model ]
]

{ #category : 'private' }
GtkBaseTreeListViewAdapter >> expandAll: aCollection basePath: aPath in: aModel [

	aCollection withIndexDo: [ :each :index |
		| path |
		path := aPath copyWith: index - 1.
		self findAndExpandPath: path in: aModel.
		self 
			expandAll: (self presenter childrenFor: each) 
			basePath: path 
			in: aModel ]
]

{ #category : 'expanding-collapsing' }
GtkBaseTreeListViewAdapter >> expandPath: aPath [
	| path |
	
	path := aPath collect: [ :each | each - 1 ].
	self innerWidgetDo: [ :w |
		| treeModel |
		treeModel := w selectionModel model.
		self presenter roots do: [ :each | 
			| row |
			row := self findAndExpandPath: path in: treeModel.
			row ifNotNil: [ 
				row expand: true ] ] ]
]

{ #category : 'expanding-collapsing' }
GtkBaseTreeListViewAdapter >> expandRoots [
	
	self innerWidgetDo: [ :w |
		| treeModel |
		treeModel := w selectionModel model.
		self presenter roots withIndexDo: [ :each :index | 
			| row |
			row := self findAndExpandPath: { index - 1 } in: treeModel.
			row ifNotNil: [ row expand: true ] ] ]
]

{ #category : 'private - updating' }
GtkBaseTreeListViewAdapter >> findAndExpandPath: aPath in: aModel [
	
	aPath ifEmpty: [ ^ nil ].

	^ aModel
		withRowAt: aPath first 
		do: [ :row |
			aPath size = 1 
				ifFalse: [ row expand: true ].
			aPath allButFirst 
				ifNotEmpty: [ :nextPath | self findAndExpandPath: nextPath in: row ]
				ifEmpty: [ row ] ]
]

{ #category : 'accessing' }
GtkBaseTreeListViewAdapter >> itemAtPath: aPath [

	^ self 
		itemAtPath: aPath 
		from: self presenter roots
]

{ #category : 'private' }
GtkBaseTreeListViewAdapter >> itemAtPath: aPath from: aCollection [
	| currentItem |
	
	currentItem := aCollection at: aPath first.
	aPath size = 1 ifTrue: [ ^ currentItem ].
	
	^ self 
		itemAtPath: aPath allButFirst
		from: (self presenter childrenFor: currentItem)
]

{ #category : 'private - factory' }
GtkBaseTreeListViewAdapter >> newSelectionModel [
	| selectionModel |

	selectionModel := self selectionCompanion newModel: self newStore.
	selectionModel connectSelectionChanged: [ :position :numItems |
		self updatePresenterSelection: position numItems: numItems ].
	
	^ selectionModel
]

{ #category : 'private - factory' }
GtkBaseTreeListViewAdapter >> newStore [
	| store |
	
	store := GtkTreeListViewAdapterDataStore newPresenter: self presenter.
	^ (GtkTreeListModel
		newRootModel: store 
		children: [ :itemHandle |
			store 
				itemAtHandle: itemHandle 
				children: self presenter children ])
]

{ #category : 'private - updating' }
GtkBaseTreeListViewAdapter >> refreshSelectionModelIn: gtkWidget [

	self subclassResponsibility
]

{ #category : 'building' }
GtkBaseTreeListViewAdapter >> selectionCompanion [

	^ selectionCompanion ifNil: [ 
		selectionCompanion := self presenter selectionMode gtkAdapterCompanion on: self ]
]

{ #category : 'building' }
GtkBaseTreeListViewAdapter >> setDeferredAction: aBlock [

	deferredAction := aBlock
]

{ #category : 'private - updating' }
GtkBaseTreeListViewAdapter >> updateMultiSelectionFromGtk [
	| paths |

	paths := OrderedCollection new.
	self innerWidgetDo: [ :w |
		| selection row  |
		selection :=  w selectionModel.
		selection selectedItems do: [ :rowHandle |
			row := GtkTreeListRow fromHandleUnreferenced: rowHandle getHandle.
			paths add: (row withItemDo: [ :item | 
				selection model store pathOfItem: item ]) ] ].

	self runInSystem: [ 
		self backendUpdatingDo: [  
			self presenter selection selectPaths: paths asArray ] ]
]

{ #category : 'private - updating' }
GtkBaseTreeListViewAdapter >> updateMultiSelectionFromPresenter: oldPaths [
	| paths |
	
	self isBackendUpdating ifTrue: [ ^ self ].

	paths := self presenter selection selectedPaths collect: [ :each | each - 1 ].
	paths = oldPaths ifTrue: [ ^ paths ].  

	paths ifEmpty: [ 
		self innerWidgetDo: [ :w | w selectionModel unselectAll ].
		^ paths ].

	self innerWidgetDo: [ :w | 
		| treeModel lastRow |
		treeModel := w selectionModel model.
		paths do: [ :path |
			lastRow := self findAndExpandPath: path in: treeModel.
			lastRow ifNotNil: [ 
				w selectionModel 
					selectItem: lastRow position
					unselectRest: false ] ] ].
	
	^ paths
]

{ #category : 'private - updating' }
GtkBaseTreeListViewAdapter >> updatePresenterSelection: position numItems: numItems [
	
	self backendUpdatingDo: [
		self selectionCompanion updateSelectionFromGtk ]
]

{ #category : 'private - updating' }
GtkBaseTreeListViewAdapter >> updateRoots [

	self backendUpdatingDo: [
		self innerWidgetDo: [ :w |
			"IMPORTANT: Do not attempt to change the inner model of the selection model!
			 GTK will try to inform/notice the removal/addition of elements on it (and calling 
		 	back a non existing anymore model reference objects), causing a crash."
			self refreshSelectionModelIn: w ] ]
]

{ #category : 'building' }
GtkBaseTreeListViewAdapter >> updateSelectionFromPresenter [

	self backendDetectCyclesDo: [ 
		self selectionCompanion updateSelectionFromPresenter ]
]

{ #category : 'private - updating' }
GtkBaseTreeListViewAdapter >> updateSingleSelectionFromGtk [
	| path |

	self innerWidgetDo: [ :w |
		| selection row |
		selection :=  w selectionModel.
		row := GtkTreeListRow fromHandleUnreferenced: selection selectedItem getHandle.
		path := row withItemDo: [ :item |
			selection model store pathOfItem: item ] ].
	
	self runInSystem: [ 
		self backendUpdatingDo: [ 
			self presenter selection selectPath: path ] ]
]

{ #category : 'private - updating' }
GtkBaseTreeListViewAdapter >> updateSingleSelectionFromPresenter: oldPath [
	| path |
	
	self isBackendUpdating ifTrue: [ ^ self ].
	
	path := self presenter selection selectedPath collect: [ :each | each - 1 ].
	path = oldPath ifTrue: [ ^ path ].  

	path ifEmpty: [ 
		self innerWidgetDo: [ :w | w selectionModel unselectAll ].
		^ path ].

	self innerWidgetDo: [ :w | 
		| treeModel row |
		treeModel := w selectionModel model.
		row := self findAndExpandPath: path in: treeModel.
		row ifNotNil: [ 
			w 
				scrollToPosition: row position - 1
				flags: GTK_LIST_SCROLL_FOCUS | GTK_LIST_SCROLL_SELECT.
			"w selectionModel select: row position" ] ].
	
	^ path
]
