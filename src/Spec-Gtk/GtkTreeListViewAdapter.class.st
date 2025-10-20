Class {
	#name : 'GtkTreeListViewAdapter',
	#superclass : 'GtkBaseTreeListViewAdapter',
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'building' }
GtkTreeListViewAdapter >> addModelTo: gtkListView [

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
	self presenter whenSelectionChangedDo: [
		self updateSelectionFromPresenter ].
	self presenter whenRootsChangedDo: [ 
		self updateRoots ].

	gtkListView connectRowActivated: [ :position |
		self runInSystem: [ self presenter doActivateSelected ] ].

	logger trace: gtkListView getHandle message: 'tree'.
	logger trace: self presenter owner styles		
]

{ #category : 'api' }
GtkTreeListViewAdapter >> alternateRowsColor [

	self innerWidgetDo: [ :w | 
		w showSeparators: true ]
]

{ #category : 'accessing' }
GtkTreeListViewAdapter >> elementAt: index [
	| item |

	item := self innerWidgetDo: [ :w | w selectionModel model itemAt: index ].
	^ item ifNil: [ self presenter items at: index ]
]

{ #category : 'testing' }
GtkTreeListViewAdapter >> isAlive [
	
	^ self innerWidget factory isNullOrNil not
]

{ #category : 'private - factory' }
GtkTreeListViewAdapter >> newHeaderFactory [

	^ GtkListViewAdapterHeaderFactory newPresenter: self presenter
]

{ #category : 'private - factory' }
GtkTreeListViewAdapter >> newItemFactory [

	^ GtkTreeListViewAdapterItemFactory newPresenter: self presenter
]

{ #category : 'private - updating' }
GtkTreeListViewAdapter >> refreshList [

	self backendUpdatingDo: [
		self innerWidgetDo: [ :w |
			w selectionModel unselectAll.
			"IMPORTANT: Do not attempt to change the inner model of the selection model!
			 GTK will try to inform/notice the removal/addition of elements on it (and calling 
			 back a non existing anymore model reference objects), causing a crash."
			w factory reset.
			w selectionModel: self newSelectionModel ] ]
]

{ #category : 'building' }
GtkTreeListViewAdapter >> refreshSelectionModelIn: gtkListView [
	
	self critical: [
		| selectionModel |
		
		selectionModel := self newSelectionModel.	
		"update store in factory. This has to be BEFORE setting it to the list view 
		 because gtk will trigger an update *immediately*. and it needs to find the 
		 right contents when it looks for them. "
		gtkListView factory store: selectionModel model store.
		gtkListView selectionModel: selectionModel ]
]

{ #category : 'private - updating' }
GtkTreeListViewAdapter >> refreshWidgetSelection [

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

{ #category : 'accessing' }
GtkTreeListViewAdapter >> scrollToSelection [
	"not needed, in gtk it will always scroll to selection"
]

{ #category : 'api - selection' }
GtkTreeListViewAdapter >> selectedRowPresenter [
	"answers the selected presenter. 
	 This will just work if the presenters are model based presenter (so I can get them). "
	| item |

	self flag: #TODO. "Maybe I need to generalize this using a presenter property to 
	weak-keep the calling object?"

	item := self presenter selection selectedItem.
	item ifNil: [ ^ nil ].
	
	^ self innerWidget factory storedPresenters
		detect: [ :each | each isPresenter and: [ each model = item ] ]
		ifNone: [ nil ]
]

{ #category : 'building' }
GtkTreeListViewAdapter >> widgetClass [

	^ GtkListView
]
