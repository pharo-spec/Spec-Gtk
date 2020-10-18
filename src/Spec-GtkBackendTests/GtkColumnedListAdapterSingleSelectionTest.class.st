Class {
	#name : #GtkColumnedListAdapterSingleSelectionTest,
	#superclass : #GtkAbstractListAdapterSingleSelectionTest,
	#category : #'Spec-GtkBackendTests'
}

{ #category : #running }
GtkColumnedListAdapterSingleSelectionTest >> classToTest [
	^ SpTablePresenter
]

{ #category : #running }
GtkColumnedListAdapterSingleSelectionTest >> setUp [

	super setUp.

	window := presenter
		beSingleSelection;
		addColumn: (SpStringTableColumn evaluated: [:x | x asString ]);
		addColumn: (SpStringTableColumn evaluated: [:x | (x + 1) asString ]);
		items: #(10 20 30);
		openWithSpec.
]
