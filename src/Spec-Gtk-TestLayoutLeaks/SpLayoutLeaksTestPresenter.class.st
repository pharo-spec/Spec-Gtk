Class {
	#name : #SpLayoutLeaksTestPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'layoutNumber',
		'button',
		'tree',
		'buttonBar',
		'checkBox',
		'componentList',
		'dropList',
		'label',
		'list',
		'menuBar',
		'numberInput',
		'progressBar',
		'radioButton',
		'richText',
		'searchInput',
		'statusBar',
		'table',
		'text',
		'textInput',
		'toggleButton',
		'treeTable',
		'treeTable2'
	],
	#category : #'Spec-Gtk-TestLayoutLeaks'
}

{ #category : #'instance creation' }
SpLayoutLeaksTestPresenter class >> leaksCheck [

	<sampleInstance>
	
	| win testPresenter oldAdapters result | 
	win := SpLayoutLeaksTestPresenter openGtk.
	testPresenter := win presenter.
	oldAdapters := testPresenter adapters.
	testPresenter swapLayouts.
	3 timesRepeat: [ Smalltalk garbageCollect ].
	result := oldAdapters allSatisfy: [ :e | e isNil ].
"	(ReferenceFinder findPathTo: oldAdapters last) inspect.
	"win close. 
	^ result.
]

{ #category : #'instance creation' }
SpLayoutLeaksTestPresenter class >> openGtk [

	<script>
	
	| p |  
	p := self newApplication: (SpApplication new useBackend: #Gtk).
	^ p openWithSpec.
]

{ #category : #'instance creation' }
SpLayoutLeaksTestPresenter class >> openMorphic [

	<script>
	
	| p |  
	p := self newApplication: (SpApplication new useBackend: #Morphic).
	^ p openWithSpec.
]

{ #category : #'instance creation' }
SpLayoutLeaksTestPresenter >> adapters [ 

	^ WeakArray withAll: { 
		button adapter. 
		buttonBar adapter.
		checkBox adapter.
		componentList adapter.
		dropList adapter.
		label adapter.
		list adapter.
		menuBar adapter.
		numberInput adapter.
		progressBar adapter.
		radioButton adapter.
"		richText adapter.
"		searchInput adapter.
		statusBar adapter.
		table adapter.
		text adapter.
		textInput adapter.
		toggleButton adapter.
		tree adapter.
		treeTable adapter.
		treeTable2 adapter.
	}
]

{ #category : #'instance creation' }
SpLayoutLeaksTestPresenter >> defaultLayout [ 

	^ SpBoxLayout newVertical
		add: (SpBoxLayout newVertical
			add: #button;
			add: #buttonBar;
			add: #checkBox;
			add: #dropList;
			add: #label;
			add: #list;
			add: #menuBar;
			add: #numberInput;
			add: #progressBar;
			add: #radioButton;
			add: #searchInput;
			add: #statusBar;
			add: #text;
			add: #textInput;
			add: #toggleButton;
			add: #table;
			add: #tree;
			add: #treeTable;
			add: #treeTable2;
			yourself)
		
]

{ #category : #'instance creation' }
SpLayoutLeaksTestPresenter >> emptyLayout [ 

	^ SpBoxLayout newVertical
]

{ #category : #'instance creation' }
SpLayoutLeaksTestPresenter >> gridLayout [ 

	^ SpBoxLayout newVertical
		add: (SpGridLayout new
			add: #button at: 1@1; 
			add: #buttonBar at: 2@1;
			add: #checkBox at: 3@1 ;
			add: #dropList at: 4@1 ;
			add: #label at: 1@2 ;
			add: #list at: 2@2 ;
			add: #menuBar at: 3@2 ;
			add: #numberInput at: 4@2 ;		
			add: #progressBar at: 1@3 ;
			add: #radioButton at: 2@3 ;
			add: #searchInput at: 3@3 ;
			add: #statusBar at: 4@3 ;
			add: #text at: 2@4 ;
			add: #textInput at: 3@4 ;
			add: #toggleButton at: 4@4 ;
			add: #table at: 1@4 ;
			add: #tree at: 1@5 ;
			add: #treeTable at: 2@5 ;
			add: #treeTable2 at: 1@6 ;
			yourself)
		
]

{ #category : #'instance creation' }
SpLayoutLeaksTestPresenter >> initializePresenters [ 

	layoutNumber := self layoutSelectors size.	
	
	button := self newButton label: 'select'.
	button action: [ ].

	buttonBar := self newButtonBar.
	
	checkBox := self newCheckBox label: 'test'.
	
	componentList := self newComponentList.
	
	dropList := self newDropList.
	
	label := self newLabel label: 'a label'.
	list := self newList.
	
	menuBar := self newMenuBar.
	numberInput := self newNumberInput.
	
	progressBar := self newProgressBar.
	radioButton := self newRadioButton.
"	richText := self newRichText.
"	
	searchInput := self newSearchInput.
	statusBar := self newStatusBar.
	table := self newTable.
	text := self newText.
	textInput := self newTextInput.
	toggleButton := self newToggleButton.
	
	tree := self newTree.
	tree 
		beMultipleSelection;
		roots: { 1. 2. 3 }.	
	
	treeTable := self newTreeTable.
	treeTable 
		beMultipleSelection;
		roots: { 1. 2. 3 }.
	treeTable selectItem: 1.

	treeTable2 := self newTreeTable.
	treeTable2 
		beSingleSelection;
		roots: { 1. 2. 3 }.
	treeTable2 selectItem: 1.
	
	self swapLayout.
	
]

{ #category : #'instance creation' }
SpLayoutLeaksTestPresenter >> layoutSelectors [ 

	^ #( defaultLayout gridLayout emptyLayout defaultLayout gridLayout )
	
]

{ #category : #'instance creation' }
SpLayoutLeaksTestPresenter >> swapLayout [ 

	| selectors l | 
	
	selectors := self layoutSelectors. 
	
	layoutNumber := (layoutNumber \\ selectors size) + 1.	
		l := self perform: (selectors at: layoutNumber).

	layout := l.

]

{ #category : #'instance creation' }
SpLayoutLeaksTestPresenter >> swapLayouts [ 

	10 timesRepeat: [
		self layoutSelectors size timesRepeat: [ 
			self swapLayout ]
	].
]
