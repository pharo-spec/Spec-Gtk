Class {
	#name : 'GtkTabAdapter',
	#superclass : 'GtkLayoutAdapter',
	#instVars : [
		'lastPage'
	],
	#category : 'Spec-Gtk-Layout-Box',
	#package : 'Spec-Gtk',
	#tag : 'Layout-Box'
}

{ #category : 'building' }
GtkTabAdapter >> adapterWasBuilt [

	layout children ifEmpty: [ ^ self ]. 
	lastPage := layout children at: layout initialPageIndex.
	layout initialPageIndex = 1 ifFalse: [ 
		self widgetDo: [ :w | 
			w currentPage: layout initialPageIndex ] ]
]

{ #category : 'private' }
GtkTabAdapter >> addConstraints: constraints toChild: childWidget [
	"adds constraits by child."

	^ childWidget
]

{ #category : 'private' }
GtkTabAdapter >> applyLayout: aLayout [

	widget := GtkNotebook new.
	widget beScrollable.
	
	self connectToEvents: aLayout.
	
	self flag: #WARNING. "switch page will be called a last time when releasing. 
	I have no way to fix this in an efficient way so users need to take this 
	into account (if they are using tab select/unselect events)" 
	widget connectSwitchPage: [ :aPage | 
		lastPage ifNotNil: [
			aLayout announce: (SpTabUnselected newPresenter: lastPage) ].
		lastPage := aPage data.
		aLayout announce: (SpTabSelected newPresenter: aPage data) ]
]

{ #category : 'private' }
GtkTabAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [

	| childWidget labelPresenter labelWidget page |
	labelPresenter := constraints label asPresenter.
	labelWidget := labelPresenter hasAdapter
		               ifTrue: [ labelPresenter adapter widget ]
		               ifFalse: [ 
			               labelPresenter
				               owner: aPresenter owner;
				               build ].

	childWidget := aPresenter buildWithSelector: constraints spec.
	page := widget newPageLabel: labelWidget content: childWidget.
	page data: aPresenter.
	gtkWidget append: page.

	^ gtkWidget
]

{ #category : 'removing' }
GtkTabAdapter >> remove: aPresenter [

	^ self widgetDo: [ :w |
		| widgetToRemove |
		widgetToRemove := aPresenter adapter widget.
		self ensureRetained: widgetToRemove.
		w remove: (w children detect: [ :each | each data = aPresenter ]) ]
]

{ #category : 'accessing' }
GtkTabAdapter >> selectIndex: index [

	lastPage := layout children at: index.
	self widgetDo: [ :w | 
		w currentPage: index - 1 ]
]
