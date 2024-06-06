Class {
	#name : 'GtkBaseTreeListViewAdapter',
	#superclass : 'GtkAdapter',
	#traits : 'GtkTHaveWrappingScrollBars',
	#classTraits : 'GtkTHaveWrappingScrollBars classTrait',
	#instVars : [
		'deferredAction',
		'selectionCompanion'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'private' }
GtkBaseTreeListViewAdapter >> doInitializationDeferredActions [

	deferredAction ifNil: [ ^ self ].
	deferredAction ensure: [ deferredAction := nil ]
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
	
	self notYetImplemented
]

{ #category : 'private - updating' }
GtkBaseTreeListViewAdapter >> updatePresenterSelection: position numItems: numItems [
	
	self backendUpdatingDo: [
		self selectionCompanion updateSelectionFromGtk ]
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
		| selection row  |
		selection :=  w selectionModel.
		row := GtkTreeListRow fromHandleUnreferenced: selection selectedItem getHandle.
		path := row withItemDo: [ :item |
			selection model store pathOfItem: item ] ].

	self presenter selection selectPath: path
]
