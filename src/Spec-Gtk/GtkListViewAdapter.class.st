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
	| factory store selectionModel |

	super addModelTo: gtkListView.

	store := GtkListViewAdapterDataStore newPresenter: self presenter.
	
	factory := GtkListViewAdapterItemFactory newPresenter: self presenter.
	factory connectSetup: [ :listItem | 
		factory setup: listItem ].
	factory connectBind: [ :listItem |
		factory 
			bind: listItem
			to: (store items at: (listItem position + 1)) ].
		
	selectionModel := GtkSingleSelection newModel: store.
	
	gtkListView factory: factory.
	gtkListView model: selectionModel
]

{ #category : #building }
GtkListViewAdapter >> widgetClass [

	^ GtkListView
]
