Class {
	#name : #GtkTabAdapter,
	#superclass : #GtkLayoutAdapter,
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
	widget show
]

{ #category : #private }
GtkTabAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [
	| childWidget labelPresenter labelWidget |

	labelPresenter := constraints label asPresenter.
	labelWidget := 	labelPresenter hasAdapter 
		ifTrue: [ labelPresenter adapter widget ]
		ifFalse: [ 
			labelPresenter 
				owner: aPresenter owner;
				buildWithSpec ].
		
	childWidget := aPresenter buildWithSpec: constraints spec.
	gtkWidget 
		append: childWidget 
		label: labelWidget.
			
	^ gtkWidget
]
