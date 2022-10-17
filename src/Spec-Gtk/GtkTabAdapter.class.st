Class {
	#name : #GtkTabAdapter,
	#superclass : #GtkLayoutAdapter,
	#instVars : [
		'lastPage'
	],
	#category : #'Spec-Gtk-Layout-Box'
}

{ #category : #building }
GtkTabAdapter >> adapterWasBuilt [

	layout children ifEmpty: [ ^ self ]. 
	lastPage := layout children at: layout initialPageIndex.
	layout initialPageIndex = 1 ifFalse: [ 
		self widgetDo: [ :w | 
			w currentPage: layout initialPageIndex ] ]
]

{ #category : #private }
GtkTabAdapter >> addConstraints: constraints toChild: childWidget [
	"adds constraits by child."

	^ childWidget
]

{ #category : #private }
GtkTabAdapter >> applyLayout: aLayout [

	widget := GtkNotebook new.
	widget beScrollable.
	
	self connectToEvents: aLayout. 

	widget connectSwitchPage: [ :aPage | 
		lastPage ifNotNil: [
			aLayout announce: (SpTabUnselected newPresenter: lastPage) ].
		lastPage := aPage data.
		aLayout announce: (SpTabSelected newPresenter: aPage data) ]
]

{ #category : #private }
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

{ #category : #removing }
GtkTabAdapter >> remove: aPresenter [
	| widgetToRemove |
	
	widgetToRemove := aPresenter adapter widget.
	self ensureRetained: widgetToRemove.
	^ self widgetDo: [ :w | 
		w remove: (w children detect: [ :each | each data = aPresenter ]) ]
]

{ #category : #accessing }
GtkTabAdapter >> selectIndex: index [

	lastPage := layout children at: index.
	self widgetDo: [ :w | 
		w currentPage: index - 1 ]
]
