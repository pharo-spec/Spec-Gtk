Class {
	#name : 'GtkTreeColumnViewAdapter',
	#superclass : 'GtkBaseTreeListViewAdapter',
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'building' }
GtkTreeColumnViewAdapter >> addModelTo: gtkColumnView [
	super addModelTo: gtkColumnView.

	"gtkColumnView headerFactory: self newHeaderFactory."

	self presenter columns withIndexDo: [ :each :index |
		gtkColumnView appendColumn: (self newGtkColumnViewColumnFrom: each index: index) ].
	
	self refreshSelectionModelIn: gtkColumnView.
	gtkColumnView singleClickActivate: self presenter isActiveOnSingleClick.

	self presenter selection isEmpty 
		ifFalse: [ self setDeferredAction: [ self updateSelectionFromPresenter ] ].
	self presenter whenSelectionChangedDo: [ self updateSelectionFromPresenter ].
	self presenter whenIsResizableChangedDo: [ :aBoolean |
		self updateResizableColumnsTo: aBoolean ].
	self presenter whenRootsChangedDo: [ self updateRoots ].

	gtkColumnView connectRowActivated: [ :position |
		self runInSystem: [ self presenter doActivateSelected ] ]
]

{ #category : 'api' }
GtkTreeColumnViewAdapter >> alternateRowsColor [

	self innerWidgetDo: [ :w | 
		w showRowSeparators: true ]
]

{ #category : 'private' }
GtkTreeColumnViewAdapter >> configureScrolling [
	"
configureScrolling
	| vAlignment |

	vAlignment := self presenter verticalAlignment.
	vAlignment whenChangedDo: [ 
		self scrollToSelectionIfNeeded: vAlignment desiredVisibleRow ].
	self presenter whenDisplayDo: [
		self scrollToSelectionIfNeeded: vAlignment desiredVisibleRow ]	
	"
	self flag: #TODO. "see how this would work here"
]

{ #category : 'private - factory' }
GtkTreeColumnViewAdapter >> newColumnFactory: aColumn index: index [
	| factoryClass |
	
	factoryClass := index = 1
		ifTrue: [ GtkTreeColumnViewExpanderAdapterItemFactory ]
		ifFalse: [ GtkTreeColumnViewAdapterItemFactory ]. 

	^ factoryClass
		newPresenter: self presenter 
		column: aColumn
]

{ #category : 'private - factory' }
GtkTreeColumnViewAdapter >> newGtkColumnViewColumnFrom: aColumn index: index [

	^ GtkColumnViewColumn new
		title: aColumn title;
		factory: (self newColumnFactory: aColumn index: index);
		resizable: self presenter isResizable;
		expand: aColumn isExpandable;
		in: [ :this | 
			aColumn hasFixedWidth 
				ifTrue: [ this fixedWidth: aColumn width ] ];
		yourself
]

{ #category : 'private - factory' }
GtkTreeColumnViewAdapter >> newHeaderFactory [

	^ GtkColumnViewAdapterHeaderFactory newPresenter: self presenter
]

{ #category : 'building' }
GtkTreeColumnViewAdapter >> refreshSelectionModelIn: gtkColumnView [
	| selectionModel |

	selectionModel := self newSelectionModel.
	"update store in factory. This has to be BEFORE setting it to the list view 
	 because gtk will trigger an update *immediately*. and it needs to find the 
	 right contents when it looks for them. "
	gtkColumnView columns do: [ :each |
		each factory store: selectionModel model store ].
	gtkColumnView selectionModel: selectionModel 
]

{ #category : 'accessing' }
GtkTreeColumnViewAdapter >> scrollToSelection [
	"not needed, in gtk it will always scroll to selection"
]

{ #category : 'private' }
GtkTreeColumnViewAdapter >> scrollToSelectionIfNeeded: index [ 
	self flag: #TODO. "no sense here, but I need to refactory the presenter, I think"
]

{ #category : 'private - updating' }
GtkTreeColumnViewAdapter >> updateResizableColumnsTo: aBoolean [

	self innerWidgetDo: [ :w |
		w columns do: [ :each | each resizable: aBoolean ] ]
]

{ #category : 'building' }
GtkTreeColumnViewAdapter >> widgetClass [

	^ GtkColumnView
]
