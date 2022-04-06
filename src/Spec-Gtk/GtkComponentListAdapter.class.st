Class {
	#name : #GtkComponentListAdapter,
	#superclass : #GtkAdapter,
	#traits : 'GtkTDisconnectSelectionEvents',
	#classTraits : 'GtkTDisconnectSelectionEvents classTrait',
	#instVars : [
		'innerWidget',
		'currentShownItems'
	],
	#classInstVars : [
		'gtkWidget',
		'realWidget'
	],
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #specs }
GtkComponentListAdapter class >> adaptingAliases [

	^ #(FastTableAdapter)
]

{ #category : #building }
GtkComponentListAdapter >> addKeyBindingsTo: gtkWidget [

	super addKeyBindingsTo: gtkWidget.
	self addContextMenuKeyBindings: gtkWidget
]

{ #category : #building }
GtkComponentListAdapter >> addModelTo: gtkListBox [

	gtkListBox canFocus: true.
	gtkListBox activateOnSingleClick: self presenter activatesOnSingleClick.

	self model selection isMultipleSelection 
		ifTrue: [ gtkListBox beMultipleSelectionMode ]
		ifFalse: [ gtkListBox beSingleSelectionMode ].

	self presenter whenPresentersChangedDo: [ :collection | 
		self updateWith: collection ].	
			
	self
		update: gtkListBox 
		with: self presenter presenters.
		
	self presenter selection isEmpty ifFalse: [ 
		self refreshWidgetSelectionOf: gtkListBox ].
	
	gtkListBox connectSelectedRowsChanged: [ 
		self backendUpdatingDo: [
			self presenter selection selectIndexes: self innerWidget selectedIndexes ] ].

	gtkListBox connectRowActivated: [ :row | 
		self doActivateRow: row ].
	
	self model contextMenu 
		ifNotNil: [ :menu | self addMenu: menu to: gtkListBox ]
]

{ #category : #private }
GtkComponentListAdapter >> disconnectSelectionEventsOf: aWidget during: aBlock [

	aWidget 
		blockCallbacks: #('row-selected' 'selected-rows-changed')
		during: aBlock
]

{ #category : #private }
GtkComponentListAdapter >> doActivateRow: rowHandle [
	| row |

	row := self innerWidget findChildByHandle: rowHandle.
	self presenter doActivateAtIndex: (self innerWidget children indexOf: row)
]

{ #category : #protocol }
GtkComponentListAdapter >> doTakeKeyboardFocus: gtkListBox [

	gtkListBox hasChildren ifFalse: [ ^ super doTakeKeyboardFocus: gtkListBox ].
	(gtkListBox selectedRow 
		ifNil: [ gtkListBox children first ])
		grabFocus
]

{ #category : #accessing }
GtkComponentListAdapter >> elementAt: index [
	| item |

	item := self innerWidgetDo: [ :w | 
		(w children 
			at: index 
			ifAbsent: [ nil ])
			ifNotNil: [ :aRow | aRow data ] ].
	^ item ifNil: [ self presenter items at: index ]
]

{ #category : #'private accessing' }
GtkComponentListAdapter >> innerWidget [

	^ widget child
]

{ #category : #testing }
GtkComponentListAdapter >> isNonEditableRow: aRow column: aColumn [ 
	"no rows are directly editable in a component list (they can be 
	 if defined like that in the inner presenters, but it is handled different)"
	^ true
]

{ #category : #testing }
GtkComponentListAdapter >> items [

	^ innerWidget items
]

{ #category : #updating }
GtkComponentListAdapter >> refreshList [
	
	self innerWidgetDo: [ :w |
		self 
			disconnectSelectionEventsOf: w
			during: [ self update: w with: self presenter items ] ]
]

{ #category : #factory }
GtkComponentListAdapter >> refreshWidgetSelection [

	self innerWidgetDo: [ :w |
		self refreshWidgetSelectionOf: w ]
]

{ #category : #private }
GtkComponentListAdapter >> refreshWidgetSelectionOf: gtkListBox [

	self 
		refreshWidgetSelectionOf: gtkListBox 
		indexes: self presenter selection selectedIndexes
]

{ #category : #private }
GtkComponentListAdapter >> refreshWidgetSelectionOf: gtkListBox indexes: aCollection [

	self 
		disconnectSelectionEventsOf: gtkListBox 
		during: [
			aCollection do: [ :rowIndex | 
				gtkListBox selectIndex: rowIndex ] ]
]

{ #category : #accessing }
GtkComponentListAdapter >> selectIndex: rowIndex [

	self innerWidgetDo: [ :w |
		rowIndex ~= 0 
			ifTrue: [ 
				w selectIndex: rowIndex.
				self flag: #TODO. "Not implemented directly in listbox, I need to do it by hand"
				"self scrollToSelectionIfNeeded: rowIndex" ]
			ifFalse: [ 
				w unselectAll ] ]
]

{ #category : #accessing }
GtkComponentListAdapter >> selectedIndexes [

	^ self innerWidget selectedIndexes
]

{ #category : #private }
GtkComponentListAdapter >> showMenu: aValuable event: event [

	self innerWidgetDo: [ :w |
		| row |
		row := w getRowAtY: event y asInteger.
		row ifNotNil: [ 
			w selectRow: row ].
		super showMenu: aValuable event: event ]
]

{ #category : #building }
GtkComponentListAdapter >> update: gtkWidget with: aCollection [

	"This is a workaround to prevent double geneation of list. If I am updating 
	 the same presenters I already have, I skip the process."
	currentShownItems = aCollection ifTrue: [ ^ self ].
	currentShownItems := aCollection.

	gtkWidget removeAll.
	aCollection do: [ :presenter |
		self flag: #TODO. "WARNING. Rebuild presenters may keep value holders in 
		weird status (also, it may prevent old adaptors to be collected, creating 
		a leak)."
		gtkWidget add: (presenter build asListBoxRow
			data: presenter;
			activatable: presenter isActivatable;
			selectable: presenter isSelectable;
			yourself) ].

	gtkWidget showAll.	

	self flag: #TODO. "Composed lists should be like this but they are crashing the image somehow.
	Since I do not have a lot of time now, I just comment it and keep the 'old' way (which will not 
	 work fine in all cases)"
	"oldWidgets := gtkWidget children collect: [ :each | 
		each child 
			objectRef; 
			yourself ].

	newRows := aCollection collect: [ :aPresenter | | childWidget |
		aPresenter adapter 
			ifNotNil: [ :anAdapter | 
				(oldWidgets includes: anAdapter widget) ifTrue: [ 
					childWidget := anAdapter widget ] ].
		childWidget ifNil: [ 
			childWidget := aPresenter buildWithSpec ].
		
		childWidget asListBoxRow
			data: aPresenter;
			activatable: aPresenter isActivatable;
			selectable: aPresenter isSelectable;
			yourself ].
	
	gtkWidget removeAll.
	gtkWidget addAll: newRows.
	oldWidgets do: [ :each | each objectUnref ].

	gtkWidget showAll"
]

{ #category : #building }
GtkComponentListAdapter >> updateWith: aCollection [

	self innerWidgetDo: [ :w |
		self update: w with: aCollection ]
]

{ #category : #building }
GtkComponentListAdapter >> widgetClass [
	
	^ GtkListBox
]

{ #category : #building }
GtkComponentListAdapter >> wrapWidget: gtkWidget [

	innerWidget := gtkWidget.
	^ self wrapWithScrollableWindow: gtkWidget
		
]
