"
adapter to handle simple selections (maps a presenter selection with a gtk selection) 
"
Class {
	#name : #GtkAdapterSingleSelection,
	#superclass : #GtkAdapterSelection,
	#category : #'Spec-Gtk-Adapter-ListView'
}

{ #category : #'instance creation' }
GtkAdapterSingleSelection >> newModel: aModel [ 

	^ (GtkSingleSelection newModel: aModel)
		autoSelect: false;
		yourself
]

{ #category : #'private - updating' }
GtkAdapterSingleSelection >> updatePresenterSelection: position numItems: numItems [
	| index |

	"Do not use the position received because is information about the change not 
	 indicating the real selected index"	
	index := self adapter innerWidgetDo: [ :w | w selectionModel selected ].
	self presenter selection selectIndex: index
]

{ #category : #updating }
GtkAdapterSingleSelection >> updateSelectionFromPresenter [
	| index |

	index := self presenter selection selectedIndex. 
	self adapter innerWidgetDo: [ :w |
		index > 0 
			ifTrue: [ 
				w selectionModel selectItem: index unselectRest: true ]
			ifFalse: [ 
				w selectionModel unselectAll ] ]
]
