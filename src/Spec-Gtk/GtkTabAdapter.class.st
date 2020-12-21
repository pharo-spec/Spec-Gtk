Class {
	#name : #GtkTabAdapter,
	#superclass : #GtkLayoutAdapter,
	#instVars : [
		'lastPage'
	],
	#category : #'Spec-Gtk-Layout-Box'
}

{ #category : #private }
GtkTabAdapter >> addConstraints: constraints toChild: childWidget [
	"adds constraits by child."

	^ childWidget
]

{ #category : #private }
GtkTabAdapter >> applyLayout: aLayout [

	widget := GtkNotebook new.
	self connectToEvents: aLayout. 

	widget connectSwitchPage: [ :aPage | 
		lastPage ifNotNil: [
			aLayout announce: (SpTabUnselected newPresenter: lastPage) ].
		lastPage := aPage data.
		aLayout announce: (SpTabSelected newPresenter: aPage data) ].
	
	widget show
]

{ #category : #private }
GtkTabAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [
	| childWidget labelPresenter labelWidget page |

	labelPresenter := constraints label asPresenter.
	labelWidget := 	labelPresenter hasAdapter 
		ifTrue: [ labelPresenter adapter widget ]
		ifFalse: [ 
			labelPresenter 
				owner: aPresenter owner;
				buildWithSpec ].
		
	childWidget := aPresenter buildWithSpec: constraints spec.
	page := widget newPageLabel: labelWidget content: childWidget.
	page data: aPresenter.
	gtkWidget append: page.
	
	^ gtkWidget
]
