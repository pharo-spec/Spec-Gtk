"
Gtk adaptor for `SpListViewPresenter`.
"
Class {
	#name : #GtkListViewAdapter,
	#superclass : #GtkAdapter,
	#traits : 'GtkTHaveWrappingScrollBars',
	#classTraits : 'GtkTHaveWrappingScrollBars classTrait',
	#instVars : [
		'deferredAction',
		'selectionCompanion'
	],
	#category : #'Spec-Gtk-Adapter-ListView'
}

{ #category : #building }
GtkListViewAdapter >> addModelTo: gtkListView [

	super addModelTo: gtkListView.
		
	"gtkListView showSeparators: true."
	"gtkListView enableRubberband: true."

	"self configureDragAndDrop: gtkListView".
	"self addSearchTo: gtkListView"
	
	gtkListView factory: self newItemFactory.
	gtkListView selectionModel: self newSelectionModel.

	gtkListView singleClickActivate: 	self presenter isActiveOnSingleClick.

	self presenter hasHeaderTitle ifTrue: [ 
		gtkListView headerFactory: self newHeaderFactory ].
		
	self presenter selection isEmpty 
		ifFalse: [ self setDeferredAction: [ self updateSelectionFromPresenter ] ].
	self presenter selection 
		whenChangedDo: [ self updateSelectionFromPresenter ].

	gtkListView connectRowActivated: [ :position |
		self presenter doActivateAtIndex: position ].
	
	self configureScrolling
]

{ #category : #building }
GtkListViewAdapter >> configureScrolling [
	| vAlignment |

	vAlignment := self presenter verticalAlignment.
	vAlignment whenChangedDo: [ 
		self scrollToSelectionIfNeeded: vAlignment desiredVisibleRow ].
	self presenter whenDisplayDo: [
		self scrollToSelectionIfNeeded: vAlignment desiredVisibleRow ]
]

{ #category : #private }
GtkListViewAdapter >> doInitializationDeferredActions [

	deferredAction ifNil: [ ^ self ].
	deferredAction ensure: [ deferredAction := nil ]
]

{ #category : #accessing }
GtkListViewAdapter >> elementAt: index [
	| item |

	item := self innerWidgetDo: [ :w | w selectionModel model itemAt: index ].
	^ item ifNil: [ self presenter items at: index ]
]

{ #category : #'private - factory' }
GtkListViewAdapter >> newHeaderFactory [
	| factory |

	factory := GtkListViewAdapterHeaderFactory newPresenter: self presenter.
	factory connectSetup: [ :listItem | 
		factory setup: listItem ].
	factory connectBind: [ :listItem |
		factory 
			bind: listItem
			to: self presenter headerTitle ].

	^ factory
]

{ #category : #'private - factory' }
GtkListViewAdapter >> newItemFactory [
	| factory |

	factory := GtkListViewAdapterItemFactory newPresenter: self presenter.
	factory connectSetup: [ :listItem | 
		factory setup: listItem ].
	factory connectBind: [ :listItem |
		factory 
			bind: listItem
			to: (self presenter items at: (listItem position + 1)) ].

	^ factory
]

{ #category : #'private - factory' }
GtkListViewAdapter >> newSelectionModel [
	| selectionModel |

	selectionModel := self selectionCompanion newModel: self newStore.
	selectionModel connectSelectionChanged: [ :position :numItems |
		self updatePresenterSelection: position numItems: numItems ].
	
	^ selectionModel
]

{ #category : #'private - factory' }
GtkListViewAdapter >> newStore [
	
	^ GtkListViewAdapterDataStore newPresenter: self presenter
]

{ #category : #'private - updating' }
GtkListViewAdapter >> refreshList [

	self backendUpdatingDo: [
		self innerWidgetDo: [ :w |
			"IMPORTANT: Do not attempt to change the inner model of the selection model!
			 GTK will try to inform/notice the removal/addition of elements on it (and calling 
			 back a non existing anymore model reference objects), causing a crash.
			 ALSO: Apparently I need to change the factory along with the model to prevent 
			 some weird behavior on the factory referenced elements."
			w 
				selectionModel: self newSelectionModel;
				factory: self newItemFactory ] ]
]

{ #category : #'private - updating' }
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

{ #category : #private }
GtkListViewAdapter >> scrollToSelectionIfNeeded: index [

	self innerWidgetDo: [ :w |
		w scrollToPosition: index ]
]

{ #category : #private }
GtkListViewAdapter >> selectionCompanion [

	^ selectionCompanion ifNil: [ 
		selectionCompanion := self presenter selectionMode gtkAdapterCompanion on: self ]
]

{ #category : #private }
GtkListViewAdapter >> setDeferredAction: aBlock [

	deferredAction := aBlock
]

{ #category : #'private - updating' }
GtkListViewAdapter >> updatePresenterSelection: position numItems: numItems [
	
	self backendUpdatingDo: [
		self selectionCompanion 
			updatePresenterSelection: position 
			numItems: numItems ]
]

{ #category : #'private - updating' }
GtkListViewAdapter >> updateSelectionFromPresenter [

	self backendDetectCyclesDo: [ 
		self selectionCompanion updateSelectionFromPresenter ]
]

{ #category : #building }
GtkListViewAdapter >> widgetClass [

	^ GtkListView
]
