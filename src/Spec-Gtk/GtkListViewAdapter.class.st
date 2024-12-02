"
Gtk adaptor for `SpListViewPresenter`.
"
Class {
	#name : 'GtkListViewAdapter',
	#superclass : 'GtkBaseListViewAdapter',
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'building' }
GtkListViewAdapter >> addModelTo: gtkListView [

	super addModelTo: gtkListView.

	"gtkListView showSeparators: true."
	"gtkListView enableRubberband: true."

	"self configureDragAndDrop: gtkListView."
	"self addSearchTo: gtkListView"
	
	gtkListView factory: self newItemFactory.
	self refreshSelectionModelIn: gtkListView.

	gtkListView singleClickActivate: 	self presenter isActiveOnSingleClick.

	self presenter hasHeaderTitle ifTrue: [ 
		gtkListView headerFactory: self newHeaderFactory ].
		
	self presenter selection isEmpty 
		ifFalse: [ self setDeferredAction: [ self updateSelectionFromPresenter ] ].
	self presenter selection 
		whenChangedDo: [ self updateSelectionFromPresenter ].

	gtkListView connectRowActivated: [ :position |
		self runInSystem: [ 
			self presenter doActivateAtIndex: position + 1 ] ].
	
	self configureScrolling
]

{ #category : 'api' }
GtkListViewAdapter >> alternateRowsColor [

	self innerWidgetDo: [ :w | 
		w showSeparators: true ]
]

{ #category : 'building' }
GtkListViewAdapter >> configureScrolling [
	| vAlignment |

	vAlignment := self presenter verticalAlignment.
	vAlignment whenChangedDo: [ 
		self scrollToSelectionIfNeeded: vAlignment desiredVisibleRow ].
	self presenter whenDisplayDo: [
		self scrollToSelectionIfNeeded: vAlignment desiredVisibleRow ]
]

{ #category : 'private' }
GtkListViewAdapter >> doInitializationDeferredActions [

	deferredAction ifNil: [ ^ self ].
	deferredAction ensure: [ deferredAction := nil ]
]

{ #category : 'accessing' }
GtkListViewAdapter >> elementAt: index [
	| item |

	item := self innerWidgetDo: [ :w | w selectionModel model itemAt: index ].
	^ item ifNil: [ self presenter items at: index ]
]

{ #category : 'private - factory' }
GtkListViewAdapter >> newHeaderFactory [

	^ GtkListViewAdapterHeaderFactory newPresenter: self presenter
]

{ #category : 'private - factory' }
GtkListViewAdapter >> newItemFactory [

	^ GtkListViewAdapterItemFactory newPresenter: self presenter
]

{ #category : 'private - factory' }
GtkListViewAdapter >> newSelectionModel [
	| selectionModel |

	selectionModel := self selectionCompanion newModel: self newStore.
	selectionModel connectSelectionChanged: [ :position :numItems |
		self updatePresenterSelection: position numItems: numItems ].
	
	^ selectionModel
]

{ #category : 'private - factory' }
GtkListViewAdapter >> newStore [
	
	^ GtkListViewAdapterDataStore newPresenter: self presenter
]

{ #category : 'private - updating' }
GtkListViewAdapter >> refreshList [

	self backendUpdatingDo: [
		self innerWidgetDo: [ :w |
			"IMPORTANT: Do not attempt to change the inner model of the selection model!
			 GTK will try to inform/notice the removal/addition of elements on it (and calling 
			 back a non existing anymore model reference objects), causing a crash."
			w factory reset.
			self refreshSelectionModelIn: w ] ]
]

{ #category : 'building' }
GtkListViewAdapter >> refreshSelectionModelIn: gtkListView [
	
	gtkListView selectionModel: self newSelectionModel
]

{ #category : 'private - updating' }
GtkListViewAdapter >> refreshWidgetSelection [

	self flag: #TODO. "not sure this is needed?"

	"self innerWidgetDo: [ :w |
		| rowIndex selection |
		rowIndex := self presenter selection selectedIndex.
		selection :=  w selectionModel selected.
		selection = rowIndex ifTrue: [ ^ self ].
		rowIndex > 0
			ifTrue: [ w selectionModel select: rowIndex ]
			ifFalse: [ w selectionModel unselectAll ] ]"
]

{ #category : 'private' }
GtkListViewAdapter >> scrollToSelectionIfNeeded: index [

	index < 1 ifTrue: [ ^ self ].
	self innerWidgetDo: [ :w |
		w 
			scrollToPosition: index - 1 
			flags: GtkListScrollFlags GTK_LIST_SCROLL_FOCUS ]
]

{ #category : 'private' }
GtkListViewAdapter >> setDeferredAction: aBlock [

	deferredAction := aBlock
]

{ #category : 'private - updating' }
GtkListViewAdapter >> updateSelectionFromPresenter [

	self backendDetectCyclesDo: [ 
		self selectionCompanion updateSelectionFromPresenter ]
]

{ #category : 'building' }
GtkListViewAdapter >> widgetClass [

	^ GtkListView
]
