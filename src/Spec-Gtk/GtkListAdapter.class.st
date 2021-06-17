Class {
	#name : #GtkListAdapter,
	#superclass : #GtkBaseListAdapter,
	#category : #'Spec-Gtk-Adapter-List'
}

{ #category : #specs }
GtkListAdapter class >> adaptingAliases [

	^ #(FastTableAdapter)
]

{ #category : #building }
GtkListAdapter >> addModelTo: gtkList [

	super addModelTo: gtkList.

	"Reset the model before destroying will prevent an annoying behaviour from GtkTreeView: 
	 it iterates the nodes when destroying the view (no idea why, probably to give you a 
	 chance to free what you put in user_data)"
	gtkList connectDestroy: [ 
		gtkList model roots: #() ].

	self presenter selection isMultipleSelection 
		ifTrue: [ gtkList beMultipleSelectionMode ]
		ifFalse: [ gtkList beSingleSelectionMode ].

	gtkList headersVisible: false.
	self setModelTo: gtkList.
	gtkList selection unselectAll.

	self presenter selection isEmpty 
		ifFalse: [ 
			self presenter selection selectedIndexes 
				do: [ :anIndex | gtkList selection selectPath: { anIndex } ]  ].
	
	self presenter selection whenChangedDo: [ 
		self presenter selection selectedIndexes 
			do: [ :anIndex | gtkList selection selectPath: { anIndex } ] ].
	
	gtkList connectRowActivated: [ :path | 
		self model doActivateAtIndex: path toArray first ].
	
	gtkList connectSelectionChanged: [ 
		self presenter selection selectIndexes: gtkList allSelected flattened ].
	
	self refreshWidgetHeaderTitleTo: gtkList
]

{ #category : #testing }
GtkListAdapter >> isShowColumnHeaders [
	
	^ self innerWidget isHeadersVisible
]

{ #category : #private }
GtkListAdapter >> newTreeStore [
	| store |

	store := GtkTreeDataStore new.
	store beList.
	
	self presenter hasIcons ifTrue: [ 
		store addColumn: (GtkTreeDataPixbufColumn evaluated: [ :item | 
			self presenter iconFor: item ]) ].
		
	store addColumn: (GtkTreeDataStringColumn evaluated: [ :item |
		(self presenter displayValueFor: item) asString ]).
	
	store roots: self presenter items.
	
	^ store
]

{ #category : #events }
GtkListAdapter >> refreshWidgetHeaderTitle [
	
	self innerWidgetDo: [ :w |
		self refreshWidgetHeaderTitleTo: w ]
]

{ #category : #events }
GtkListAdapter >> refreshWidgetHeaderTitleTo: gtkTreeView [
	
	self model headerTitle ifNotNil: [
		(gtkTreeView columns at: 1) title: self model headerTitle ].
	gtkTreeView headersVisible: self model headerTitle isNotNil
]

{ #category : #building }
GtkListAdapter >> setModelTo: gtkList [
	| columnIndex |

	columnIndex := 0.
	gtkList removeAllColumns.
	self presenter hasIcons ifTrue: [ 
		gtkList appendPixbufColumn: columnIndex.
		columnIndex := columnIndex + 1 ].
	gtkList appendTextColumn: columnIndex.
	gtkList model: self newTreeStore
]

{ #category : #releasing }
GtkListAdapter >> unsubscribe [ 

	self presenter selection unsubscribe: self.
	super unsubscribe.
]
