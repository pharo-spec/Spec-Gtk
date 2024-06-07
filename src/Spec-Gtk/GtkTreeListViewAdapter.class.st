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
	self presenter whenRootsChangedDo: [ 
		self updateRoots ].

	gtkListView connectRowActivated: [ :position |
		self presenter doActivateSelected ]
]

{ #category : 'accessing' }
GtkTreeListViewAdapter >> elementAt: index [
	| item |

	item := self innerWidgetDo: [ :w | w selectionModel model itemAt: index ].
	^ item ifNil: [ self presenter items at: index ]
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
			w selectionModel: self newSelectionModel.
			w factory reset ] ]
]

{ #category : 'building' }
GtkTreeListViewAdapter >> refreshSelectionModelIn: gtkListView [
	| selectionModel |
	
	selectionModel := self newSelectionModel.
	gtkListView selectionModel: selectionModel.
	"update store in factory"
	gtkListView factory store: selectionModel model store
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

{ #category : 'building' }
GtkTreeListViewAdapter >> widgetClass [

	^ GtkListView
]
