"
I add the ""sortable columns"" trait to adapters who can use it (tables, trees, etc.)
"
Trait {
	#name : 'GtkTSortableColumns',
	#instVars : [
		'currentSortingColumnIndex'
	],
	#category : 'Spec-Gtk-Adapter-Table',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Table'
}

{ #category : 'private' }
GtkTSortableColumns >> addSortableColumnsTo: gtkTreeView [

	self columns withIndexDo: [ :each :index |
		each isSortable ifTrue: [ 
			self 
				makeSortableColumn: (gtkTreeView columns at: index) 
				model: each ] ]
]

{ #category : 'private accessing' }
GtkTSortableColumns >> columns [ 

	^ self required
]

{ #category : 'private' }
GtkTSortableColumns >> makeSortableColumn: gtkColumn model: aTableColumn [
	| id |

	id := self columns indexOf: aTableColumn.
	gtkColumn
		beClickable;
		disconnect: GClickedCallback signalName;
		connectClicked: [ self toggleSort: gtkColumn model: aTableColumn ]
]

{ #category : 'private' }
GtkTSortableColumns >> toggleSort: gtkColumn model: aTableColumn [
	| sortFunction wasVisible columnIndex |

	columnIndex := self columns indexOf: aTableColumn.
	currentSortingColumnIndex ifNotNil: [ :index |
		index = columnIndex ifFalse: [ 
			(self innerWidget columns at: index) hideSortIndicator ] ].

	wasVisible := gtkColumn isSortIndicatorVisible.
	wasVisible ifFalse: [ gtkColumn showSortIndicator ].
		
	sortFunction := (wasVisible not or: [ gtkColumn sortOrder == GtkSortType GTK_SORT_DESCENDING ])
		ifTrue: [  
			gtkColumn beSortAscending.
			aTableColumn sortFunction ]
		ifFalse: [ 
			gtkColumn beSortDescending.
			aTableColumn sortFunction reversed ].

	currentSortingColumnIndex := columnIndex.
	self innerWidget model sortWith: sortFunction
]
