"
Gtk adaptor for `SpListViewPresenter`.
"
Class {
	#name : #GtkListViewAdapter,
	#superclass : #GtkAdapter,
	#traits : 'GtkTHaveWrappingScrollBars',
	#classTraits : 'GtkTHaveWrappingScrollBars classTrait',
	#category : #'Spec-Gtk-Adapter-ListView'
}

{ #category : #building }
GtkListViewAdapter >> addModelTo: gtkListView [

	super addModelTo: gtkListView.
		
	gtkListView factory: self newItemFactory.
	gtkListView selectionModel: self newSelectionModel
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
	
	^ GtkSingleSelection newModel: self newStore
]

{ #category : #'private - factory' }
GtkListViewAdapter >> newStore [
	
	^ GtkListViewAdapterDataStore newPresenter: self presenter
]

{ #category : #updating }
GtkListViewAdapter >> refreshList [

	self innerWidgetDo: [ :w |
		w selectionModel: self newSelectionModel ]
]

{ #category : #accessing }
GtkListViewAdapter >> refreshWidgetSelection [

	self innerWidgetDo: [ :w |
		| rowIndex selection |
		rowIndex := self presenter selection selectedIndex.
		selection :=  w selectionModel selected + 1.
		selection = rowIndex ifTrue: [ ^ self ].
		rowIndex > 0
			ifTrue: [ w selectionModel select: rowIndex - 1 ]
			ifFalse: [ w selectionModel unselectAll ] ]
]

{ #category : #building }
GtkListViewAdapter >> widgetClass [

	^ GtkListView
]
