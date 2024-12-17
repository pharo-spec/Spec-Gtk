"
Gtk adapter for `SpDropDownPresenter`
"
Class {
	#name : 'GtkDropDownAdapter',
	#superclass : 'GtkAdapter',
	#instVars : [
		'deferredAction'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'building' }
GtkDropDownAdapter >> addModelTo: gtkDropDown [

	super addModelTo: gtkDropDown.
	
	gtkDropDown factory: self newItemFactory.
	gtkDropDown model: self newStore.
	gtkDropDown enableSearch: true.

	"the caller takes ownership of return vlue and it will free it when not using 
	 it anymore, that' s why we answer a pointer and not a char*."
	gtkDropDown expression: (GtkCClosureExpression 
		newType: GType G_TYPE_STRING 
		signature: #(void *(void *handle))
		block: [ :handle | self expressionFor: gtkDropDown atHandle: handle ]).
		
	self presenter selection isEmpty 
		ifFalse: [ self setDeferredAction: [ self updateSelectionFromPresenter ] ].
	self presenter selection 
		whenChangedDo: [ self updateSelectionFromPresenter ].
		
	gtkDropDown connectSelectedItem: [ 
		self updatePresenterSelectionFromGtk ]
]

{ #category : 'private' }
GtkDropDownAdapter >> doInitializationDeferredActions [

	deferredAction ifNil: [ ^ self ].
	deferredAction ensure: [ deferredAction := nil ]
]

{ #category : 'accessing' }
GtkDropDownAdapter >> elementAt: index [
	| item |

	item := self innerWidgetDo: [ :w | w model itemAt: index ].
	^ item ifNil: [ self presenter items at: index ]
]

{ #category : 'private' }
GtkDropDownAdapter >> expressionFor: gtkDropDown atHandle: handle [

	(gtkDropDown model itemAtHandle: handle) ifNotNil: [ :item |
		(self presenter display value: item) ifNotNil: [ :aString | 
			^ GLibLibrary uniqueInstance gstrdup: aString ] ].
	
	^ ExternalAddress null
]

{ #category : 'private - factory' }
GtkDropDownAdapter >> newItemFactory [

	^ GtkListViewAdapterItemFactory newPresenter: self presenter
]

{ #category : 'private - factory' }
GtkDropDownAdapter >> newStore [
	
	^ GtkListViewAdapterDataStore newPresenter: self presenter
]

{ #category : 'updating' }
GtkDropDownAdapter >> refreshList [

	self innerWidgetDo: [ :w |
		w factory reset.
		w model: self newStore ]
]

{ #category : 'accessing' }
GtkDropDownAdapter >> selectIndex: anIndex [

	self innerWidgetDo: [ :w | w select: anIndex - 1]
]

{ #category : 'private' }
GtkDropDownAdapter >> setDeferredAction: aBlock [

	deferredAction := aBlock
]

{ #category : 'private - updating' }
GtkDropDownAdapter >> updatePresenterSelectionFromGtk [
	
	self backendUpdatingDo: [
		| index |
		index := self innerWidgetDo: [ :w | w selected ].
		self presenter selection selectIndex: index + 1 ]
]

{ #category : 'private - updating' }
GtkDropDownAdapter >> updateSelectionFromPresenter [

	self backendDetectCyclesDo: [ 
		| index |
		index := self presenter selection selectedIndex - 1. 
		self innerWidgetDo: [ :w |
			index >= 0 
				ifTrue: [ 
					w selected = index 
						ifFalse: [ w select: index ] ]
				ifFalse: [ 
					w unselectAll ] ] ]
]

{ #category : 'building' }
GtkDropDownAdapter >> widgetClass [

	^ GtkDropDown
]
