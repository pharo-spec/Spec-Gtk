Class {
	#name : 'GtkBaseListViewAdapter',
	#superclass : 'GtkAdapter',
	#traits : 'GtkTHaveWrappingScrollBars',
	#classTraits : 'GtkTHaveWrappingScrollBars classTrait',
	#instVars : [
		'mutex',
		'deferredAction',
		'selectionCompanion'
	],
	#pools : [
		'GtkListScrollFlags'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'building' }
GtkBaseListViewAdapter >> addModelTo: gtkWidget [

	super addModelTo: gtkWidget.
		
	gtkWidget connectRealize: [
		 self addSpecialActions.
		"I want this just once"
		gtkWidget disconnect: 'realize' ]
]

{ #category : 'building' }
GtkBaseListViewAdapter >> addSpecialActions [

	self presenter allWindowLike do: [ :each |
		each withAdapterDo: [ :anAdapter |
			anAdapter addSpecialActionsToListWidget: self ] ]
]

{ #category : 'private' }
GtkBaseListViewAdapter >> critical: aBlock [ 

	^ self mutex critical: aBlock
]

{ #category : 'testing' }
GtkBaseListViewAdapter >> isAlive [

	^ self subclassResponsibility
]

{ #category : 'private' }
GtkBaseListViewAdapter >> mutex [

	^ mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'private' }
GtkBaseListViewAdapter >> selectionCompanion [

	^ selectionCompanion ifNil: [ 
		selectionCompanion := self presenter selectionMode gtkAdapterCompanion on: self ]
]

{ #category : 'private - updating' }
GtkBaseListViewAdapter >> updateMultiSelectionFromGtk [
	| indexes |
	
	indexes := self innerWidgetDo: [ :w | w selectionModel allSelected ].
	self runInSystem: [ 
		self critical: [ self presenter selection selectIndexes: indexes ] ]
]

{ #category : 'private - updating' }
GtkBaseListViewAdapter >> updateMultiSelectionFromPresenter: pathsArray [
	| rowIndexes newIndexes removedIndexes oldIndexes |

	self isBackendUpdating ifTrue: [ ^ self ].

	oldIndexes := pathsArray ifNil: [ #(  ) ].
	rowIndexes := self presenter selection selectedIndexes.
	rowIndexes ifEmpty: [
		self innerWidgetDo: [ :w | w selectionModel unselectAll ].
		^ rowIndexes ].

	removedIndexes := oldIndexes \ rowIndexes.
	newIndexes := rowIndexes \ oldIndexes.

	self innerWidgetDo: [ :w |
		self withCycleDetectionOnBackendDo: [ 
			removedIndexes do: [ :index |
				w selectionModel unselectItem: index ].
			newIndexes do: [ :index |
				w selectionModel selectItem: index unselectRest: false ] ] ].
	
	^ newIndexes
]

{ #category : 'private - updating' }
GtkBaseListViewAdapter >> updatePresenterSelection: position numItems: numItems [
	
	self backendUpdatingDo: [
		self critical: [
			self selectionCompanion updateSelectionFromGtk ] ]
]

{ #category : 'private - updating' }
GtkBaseListViewAdapter >> updateSingleSelectionFromGtk [
	| index |

	"Do not use the position received because is information about the change not 
	 indicating the real selected index"	
	index := self innerWidgetDo: [ :w | w selectionModel selected ].
	self runInSystem: [
		self backendUpdatingDo: [
			self critical: [
				self presenter selection selectIndex: index ] ] ]
]

{ #category : 'private - updating' }
GtkBaseListViewAdapter >> updateSingleSelectionFromPresenter: oldIndex [
	| index |

	self isBackendUpdating ifTrue: [ ^ self ].

	index := self presenter selection selectedIndex. 
	oldIndex = index ifFalse: [
		self innerWidgetDo: [ :w |
			self withCycleDetectionOnBackendDo: [  
				index > 0 
					ifTrue: [ 
						"w selectionModel selectItem: index unselectRest: true."
						w 
							scrollToPosition: index - 1
							flags: GTK_LIST_SCROLL_FOCUS | GTK_LIST_SCROLL_SELECT ]
					ifFalse: [ 
						"w selectionModel unselectAll" ] ] ] ].

	^ index
]
