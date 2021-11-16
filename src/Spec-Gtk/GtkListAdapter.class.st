Class {
	#name : #GtkListAdapter,
	#superclass : #GtkBaseListAdapter,
	#traits : 'GtkTTableAccessing - {#addColumns:to:}',
	#classTraits : 'GtkTTableAccessing classTrait',
	#instVars : [
		'listColumn'
	],
	#category : #'Spec-Gtk-Adapter-List'
}

{ #category : #specs }
GtkListAdapter class >> adaptingAliases [

	^ #(FastTableAdapter)
]

{ #category : #building }
GtkListAdapter >> addColumn: aTableColumn to: aGtkTreeView [ 
	| addColumnVisitor |
	
	addColumnVisitor := GtkTableColumnBuilder new
		model: self presenter;
		resizable: false;
		columns: { aTableColumn };
		view: aGtkTreeView;
		yourself.
		
	aTableColumn acceptColumnVisitor: addColumnVisitor
]

{ #category : #building }
GtkListAdapter >> addColumnsTo: gtkWidget [

	self error: 'Should not arrrive here. A list does not has columns'
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
GtkListAdapter >> listColumn [

	^ listColumn ifNil: [ listColumn := self newListColumn ]
]

{ #category : #factory }
GtkListAdapter >> newListColumn [
	| column |
		
	column := SpStringTableColumn
		title: self presenter headerTitle
		evaluated: self presenter display.	
	
	self presenter displayColor 
		ifNotNil: [ :aBlock | column displayColor: aBlock ].
	self presenter displayBold
		ifNotNil: [ :aBlock | column displayBold: aBlock ].
	self presenter displayItalic
		ifNotNil: [ :aBlock | column displayItalic: aBlock ].
	self presenter displayUnderline
		ifNotNil: [ :aBlock | column displayUnderline: aBlock ].
	self presenter displayBackgroundColor 
		ifNotNil: [ :aBlock | column displayBackgroundColor: aBlock ].

	self presenter displayIcon ifNotNil: [ :aBlock |
		column := SpCompositeTableColumn 
			with: (SpImageTableColumn evaluated: aBlock) beNotExpandable
			with: column ].

	^ column
]

{ #category : #private }
GtkListAdapter >> newTreeStoreOld [
	| store |

	store := GtkTreeDataStore new.
	store beList.
	
	self presenter hasIcons ifTrue: [ 
		store addColumn: (GtkTreeDataPixbufColumn evaluated: [ :item | 
			self presenter iconFor: item ]) ].
		
	store addColumn: (GtkTreeDataStringColumn evaluated: [ :item |
		(self presenter displayValueFor: item) asString ]).
	
	store roots: self presenter items.
	
	"configure drag&drop"
	store dragEnabled: self presenter dragEnabled.
	self presenter dropEnabled ifTrue: [ 
		store 
			dropEnabled: true;
			acceptDrop: self presenter acceptDrop ].	
	
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

	gtkList model: self newTreeStore.
	self addColumn: self listColumn to: gtkList.
	
]

{ #category : #private }
GtkListAdapter >> tableColumns [

	^ { self listColumn }
]

{ #category : #releasing }
GtkListAdapter >> unsubscribe [ 

	self widgetDo: [:w | w children first disconnect: #destroy ].
	 
	self presenter selection unsubscribeOuterContextReceiver: self.

	super unsubscribe.
]
