Class {
	#name : 'GtkTreeListViewAdapter',
	#superclass : 'GtkListViewAdapter',
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'private - factory' }
GtkTreeListViewAdapter >> newItemFactory [

	^ GtkTreeListViewAdapterItemFactory newPresenter: self presenter
]

{ #category : 'private - factory' }
GtkTreeListViewAdapter >> newStore [
	| store |
	
	store := GtkTreeListViewAdapterDataStore newPresenter: self presenter.
	^ (GtkTreeListModel
		newRootModel: store 
		children: [ :itemHandle |
			store 
				itemAtHandle: itemHandle 
				children: self presenter children ])
]

{ #category : 'building' }
GtkTreeListViewAdapter >> refreshSelectionModelIn: gtkListView [
	| selectionModel |
	
	selectionModel := self newSelectionModel.
	gtkListView selectionModel: selectionModel.
	gtkListView factory store: selectionModel model store.
]
