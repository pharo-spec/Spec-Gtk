"
Gtk adapter for `SpDropDownPresenter`
"
Class {
	#name : #GtkDropDownAdapter,
	#superclass : #GtkAdapter,
	#instVars : [
		'deferredAction',
		'selectionCompanion'
	],
	#category : #'Spec-Gtk-Adapter-ListView'
}

{ #category : #building }
GtkDropDownAdapter >> addModelTo: gtkDropDown [

	super addModelTo: gtkDropDown.
	
	gtkDropDown listFactory: self newItemFactory.
	gtkDropDown model: self newStore.
	gtkDropDown expression: (GtkCClosureExpression newStringCallback: [ :handle |
		(gtkDropDown model itemAtHandle: handle) 
			ifNotNil: [ :item | self presenter display value: item ] ])
]

{ #category : #private }
GtkDropDownAdapter >> doInitializationDeferredActions [

	deferredAction ifNil: [ ^ self ].
	deferredAction ensure: [ deferredAction := nil ]
]

{ #category : #accessing }
GtkDropDownAdapter >> elementAt: index [
	| item |

	item := self innerWidgetDo: [ :w | w selectionModel model itemAt: index ].
	^ item ifNil: [ self presenter items at: index ]
]

{ #category : #'private - factory' }
GtkDropDownAdapter >> newItemFactory [
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
GtkDropDownAdapter >> newStore [
	
	"^ GtkListViewAdapterDataStore newPresenter: self presenter"
	^ GListReferenceStore new
		items: self presenter items;
		yourself
]

{ #category : #updating }
GtkDropDownAdapter >> refreshList [

	self innerWidgetDo: [ :w |
		w model: self newStore ]
]

{ #category : #private }
GtkDropDownAdapter >> scrollToSelectionIfNeeded: index [

	self innerWidgetDo: [ :w |
		w scrollToPosition: index ]
]

{ #category : #private }
GtkDropDownAdapter >> selectionCompanion [

	^ selectionCompanion ifNil: [ 
		selectionCompanion := self presenter selectionMode gtkAdapterCompanion on: self ]
]

{ #category : #private }
GtkDropDownAdapter >> setDeferredAction: aBlock [

	deferredAction := aBlock
]

{ #category : #'private - updating' }
GtkDropDownAdapter >> updatePresenterSelection: position numItems: numItems [
	
	self backendUpdatingDo: [		
		| index |
		"Do not use the position received because is information about the change not 
	 	indicating the real selected index"	
		index := self widgetDo: [ :w | w selected ].
		self presenter selection selectIndex: index ]
]

{ #category : #'private - updating' }
GtkDropDownAdapter >> updateSelectionFromPresenter [

	self backendDetectCyclesDo: [ 
		self widgetDo: [ :w |
			w selected: self presenter selectedIndex ] ]
]

{ #category : #building }
GtkDropDownAdapter >> widgetClass [

	^ GtkDropDown
]
