"
Gtk adaptor for `SpListViewPresenter`.
"
Class {
	#name : 'GtkColumnViewAdapter',
	#superclass : 'GtkBaseListViewAdapter',
	#classTraits : 'GtkTHaveWrappingScrollBars classTrait',
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'building' }
GtkColumnViewAdapter >> addModelTo: gtkColumnView [

	super addModelTo: gtkColumnView.

	gtkColumnView headerFactory: self newHeaderFactory.

	self presenter columns do: [ :each |
		gtkColumnView appendColumn: (self newGtkColumnViewColumnFrom: each) ].
	
	self refreshSelectionModelIn: gtkColumnView.
	gtkColumnView singleClickActivate: self presenter isActiveOnSingleClick.

	self presenter selection isEmpty 
		ifFalse: [ self setDeferredAction: [ self updateSelectionFromPresenter ] ].
	self presenter selection 
		whenChangedDo: [ self updateSelectionFromPresenter ].
	self presenter whenIsResizableChangedDo: [ :aBoolean |
		self updateResizableColumnsTo: aBoolean ].

	gtkColumnView connectRowActivated: [ :position |
		self presenter doActivateAtIndex: position + 1 ].
	
	self configureScrolling
]

{ #category : 'api' }
GtkColumnViewAdapter >> alternateRowsColor [

	self innerWidgetDo: [ :w | 
		w showRowSeparators: true ]
]

{ #category : 'building' }
GtkColumnViewAdapter >> configureScrolling [
	| vAlignment |

	vAlignment := self presenter verticalAlignment.
	vAlignment whenChangedDo: [ 
		self scrollToSelectionIfNeeded: vAlignment desiredVisibleRow ].
	self presenter whenDisplayDo: [
		self scrollToSelectionIfNeeded: vAlignment desiredVisibleRow ]
]

{ #category : 'private' }
GtkColumnViewAdapter >> doInitializationDeferredActions [

	deferredAction ifNil: [ ^ self ].
	deferredAction ensure: [ deferredAction := nil ]
]

{ #category : 'accessing' }
GtkColumnViewAdapter >> elementAt: index [
	| item |

	item := self innerWidgetDo: [ :w | w selectionModel model itemAt: index ].
	^ item ifNil: [ self presenter items at: index ]
]

{ #category : 'private - factory' }
GtkColumnViewAdapter >> newColumnFactory: aColumn [

	^ GtkColumnViewAdapterItemFactory 
		newPresenter: self presenter 
		column: aColumn
]

{ #category : 'private - factory' }
GtkColumnViewAdapter >> newGtkColumnViewColumnFrom: aColumn [

	^ GtkColumnViewColumn new
		title: aColumn title;
		factory: (self newColumnFactory: aColumn);
		resizable: self presenter isResizable;
		expand: aColumn isExpand;
		in: [ :this | 
			aColumn hasFixedWidth 
				ifTrue: [ this fixedWidth: aColumn width ] ];
		yourself
]

{ #category : 'private - factory' }
GtkColumnViewAdapter >> newHeaderFactory [

	^ GtkColumnViewAdapterHeaderFactory newPresenter: self presenter
]

{ #category : 'private - factory' }
GtkColumnViewAdapter >> newSelectionModel [
	| selectionModel |

	selectionModel := self selectionCompanion newModel: self newStore.
	selectionModel connectSelectionChanged: [ :position :numItems |
		self updatePresenterSelection: position numItems: numItems ].
	
	^ selectionModel
]

{ #category : 'private - factory' }
GtkColumnViewAdapter >> newStore [
	
	^ GtkListViewAdapterDataStore newPresenter: self presenter
]

{ #category : 'private - updating' }
GtkColumnViewAdapter >> refreshList [

	self backendUpdatingDo: [
		self innerWidgetDo: [ :w |
			"IMPORTANT: Do not attempt to change the inner model of the selection model!
			 GTK will try to inform/notice the removal/addition of elements on it (and calling 
			 back a non existing anymore model reference objects), causing a crash."
			
			"refresh items in factory (so they are not out of sync)"
			w columns do: [ :each |
				each factory items: self presenter items ].
			"now change the model"
			self refreshSelectionModelIn: w ] ]
]

{ #category : 'building' }
GtkColumnViewAdapter >> refreshSelectionModelIn: gtkColumnView [
	
	gtkColumnView selectionModel: self newSelectionModel
]

{ #category : 'private - updating' }
GtkColumnViewAdapter >> refreshWidgetSelection [

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
GtkColumnViewAdapter >> scrollToSelectionIfNeeded: index [

	self innerWidgetDo: [ :w |
		w scrollToPosition: index ]
]

{ #category : 'private' }
GtkColumnViewAdapter >> setDeferredAction: aBlock [

	deferredAction := aBlock
]

{ #category : 'private - updating' }
GtkColumnViewAdapter >> updateResizableColumnsTo: aBoolean [

	self innerWidgetDo: [ :w |
		w columns do: [ :each | each resizable: aBoolean ] ]
]

{ #category : 'private - updating' }
GtkColumnViewAdapter >> updateSelectionFromPresenter [

	self backendDetectCyclesDo: [ 
		self selectionCompanion updateSelectionFromPresenter ]
]

{ #category : 'building' }
GtkColumnViewAdapter >> widgetClass [

	^ GtkColumnView
]
