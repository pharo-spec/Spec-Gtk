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

	gtkListView tabBehavior: GtkListTabBehavior GTK_LIST_TAB_ITEM.
	
	"gtkListView showSeparators: true."
	"gtkListView enableRubberband: true."

	"self configureDragAndDrop: gtkListView."
	"self addSearchTo: gtkListView"
	
	self critical: [
		gtkListView factory: self newItemFactory ].
	self refreshSelectionModelIn: gtkListView.

	gtkListView singleClickActivate: self presenter isActiveOnSingleClick.

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

	item := self innerWidgetDo: [ :w | 
		[ 
			self isAlive 
				ifTrue: [ w selectionModel model itemAt: index ]
				ifFalse: [ nil ] ] 
		on: Error 
		fork: [ :e | e pass ]
		return: [ nil ] ].

	^ item ifNil: [ self presenter items at: index ]
]

{ #category : 'testing' }
GtkListViewAdapter >> isAlive [ 
	"if there is no factory around, means component has been destroyed. 
	 NOTE: I am using a trick that somehow violates demeters law: in spec-gtk factories 
	 are registered to know when they are destroyed in gtk (to avoid crashed), and its 
	 handle is reset when this happens. So, if I have a factory without a handle... 
	 then the list is not there anymore.
	 This is just a trick to avoid rwgistering *also the list* to the finalizeOnGtk 
	 mechanism... it may be ugly, but it avoids too many registrations :P"

	^ self innerWidget factory isNullOrNil not
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
			self critical: [ w factory reset ].
			self refreshSelectionModelIn: w ] ]
]

{ #category : 'building' }
GtkListViewAdapter >> refreshSelectionModelIn: gtkListView [
	
	self critical: [
		gtkListView selectionModel: self newSelectionModel ]
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

	((index < 1) or: [ self presenter items isEmpty ]) ifTrue: [ ^ self ].
	self innerWidgetDo: [ :w |
		w 
			scrollToPosition: index - 1 
			flags: GtkListScrollFlags GTK_LIST_SCROLL_FOCUS ]
]

{ #category : 'api - selection' }
GtkListViewAdapter >> selectedRowPresenter [
	"answers the selected presenter. 
	 This will just work if the presenters are model based presenter (so I can get them). "
	| item |

	self flag: #TODO. "Maybe I need to generalize this using a presenter property to 
	weak-keep the calling object?"

	item := self presenter selection selectedItem.
	item ifNil: [ ^ nil ].
	
	^ self innerWidget factory storedPresenters
		detect: [ :each | each model = item ]
		ifNone: [ nil ]
]

{ #category : 'private' }
GtkListViewAdapter >> setDeferredAction: aBlock [

	deferredAction := aBlock
]

{ #category : 'private - updating' }
GtkListViewAdapter >> updateSelectionFromPresenter [

	self withCycleDetectionOnBackendDo: [ 
		self isAlive ifFalse: [ ^ self ].	
		self selectionCompanion updateSelectionFromPresenter ]
]

{ #category : 'building' }
GtkListViewAdapter >> widgetClass [

	^ GtkListView
]
