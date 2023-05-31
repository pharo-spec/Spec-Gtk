Class {
	#name : #GtkAdapterMultiSelection,
	#superclass : #GtkAdapterSelection,
	#instVars : [
		'oldIndexes'
	],
	#category : #'Spec-Gtk-Adapter-ListView'
}

{ #category : #'instance creation' }
GtkAdapterMultiSelection >> newModel: aModel [ 

	^ GtkMultiSelection newModel: aModel
]

{ #category : #'private - updating' }
GtkAdapterMultiSelection >> updatePresenterSelection: position numItems: numItems [
	| indexes |
	
	indexes := self adapter innerWidgetDo: [ :w | w selectionModel allSelected ].
	self presenter selection selectIndexes: indexes
]

{ #category : #updating }
GtkAdapterMultiSelection >> updateSelectionFromPresenter [
	| rowIndexes newIndexes removedIndexes |

	oldIndexes ifNil: [ oldIndexes := #() ].
	rowIndexes := self presenter selection selectedIndexes.
	removedIndexes := oldIndexes \ rowIndexes.
	newIndexes := rowIndexes \ oldIndexes.
	oldIndexes := rowIndexes.
	
	self adapter innerWidgetDo: [ :w |
		removedIndexes do: [ :index | w selectionModel unselectItem: index ].
		newIndexes do: [ :index | w selectionModel selectItem: index unselectRest: false ].
		rowIndexes ifNotEmpty: [ 
			self adapter scrollToSelectionIfNeeded: rowIndexes first ] ]
]
