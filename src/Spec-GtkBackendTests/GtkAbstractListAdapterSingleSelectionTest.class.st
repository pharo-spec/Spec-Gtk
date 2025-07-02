Class {
	#name : 'GtkAbstractListAdapterSingleSelectionTest',
	#superclass : 'GtkAdapterTestCase',
	#category : 'Spec-GtkBackendTests',
	#package : 'Spec-GtkBackendTests'
}

{ #category : 'testing' }
GtkAbstractListAdapterSingleSelectionTest class >> isAbstract [

	^ self name = ##GtkAbstractListAdapterSingleSelectionTest
]

{ #category : 'running' }
GtkAbstractListAdapterSingleSelectionTest >> adapter [

	^ presenter adapter
]

{ #category : 'tests-model-to-widget' }
GtkAbstractListAdapterSingleSelectionTest >> testSelectManyIndexesKeepsLastSelectionInWidget [
	presenter selectIndex: 1.
	presenter selectIndex: 2.

	self assert: presenter adapter selectedIndexes equals: #(2)
]

{ #category : 'tests-model-to-widget' }
GtkAbstractListAdapterSingleSelectionTest >> testSelectPresenterIndexOutsideRangeUnsetsSelectedIndexInWidget [
	presenter selectIndex: 100.
	self assert: presenter adapter selectedIndexes isEmpty
]

{ #category : 'tests-model-to-widget' }
GtkAbstractListAdapterSingleSelectionTest >> testSelectPresenterIndexSetsSelectedIndexInWidget [
	presenter selectIndex: 1.
	self assert: (presenter adapter selectedIndexes includes: 1)
]

{ #category : 'tests-model-to-widget' }
GtkAbstractListAdapterSingleSelectionTest >> testSelectPresenterItemSetsSelectedIndexInWidget [
	presenter selectItem: 20.
	self assert: (presenter adapter selectedIndexes includes: 2)
]

{ #category : 'tests-widget-to-model' }
GtkAbstractListAdapterSingleSelectionTest >> testSelectWidgetIndexRaisesSelectionIndexChangeEventOnce [
	| counter |
	counter := 0.
	presenter selection
		whenChangedDo: [ :selection | counter := counter + 1 ].
		
	presenter adapter selectIndex: 2.
	self assert: counter equals: 1
]

{ #category : 'tests-widget-to-model' }
GtkAbstractListAdapterSingleSelectionTest >> testSelectWidgetIndexRaisesSelectionIndexChangeEventWithSelectedIndex [
	| selectedIndex |
	
	presenter selection
		whenChangedDo: [ :selection | selectedIndex := selection selectedIndex ].
	presenter adapter selection selectPath: {1}.
	self assert: selectedIndex equals: 1
]

{ #category : 'tests-widget-to-model' }
GtkAbstractListAdapterSingleSelectionTest >> testSubscribeToEventDoesNotRaiseEvent [

	presenter selection
		whenChangedDo: [ :selection | self fail ].
]

{ #category : 'tests-widget-to-model' }
GtkAbstractListAdapterSingleSelectionTest >> testUnselectAllInWidgetRaisesEmptySelectionChangeEvent [
	| gotSelection |
	
	presenter adapter selectIndex: 1.
	
	presenter selection
		whenChangedDo: [ :selection | gotSelection := selection ].
	presenter adapter unselectAll.
	self assert: gotSelection isEmpty
]

{ #category : 'tests-widget-to-model' }
GtkAbstractListAdapterSingleSelectionTest >> testUnselectAllInWidgetRaisesSelectionIndexChangeEventOnce [
	| counter |
	counter := 0.

	presenter adapter selectIndex: 1.

	presenter selection
		whenChangedDo: [ :selection | counter := counter + 1 ].

	presenter adapter unselectAll.

	self assert: counter equals: 1
]

{ #category : 'tests-model-to-widget' }
GtkAbstractListAdapterSingleSelectionTest >> testUnselectPresenterIndexUnselectsIndexInWidget [
	presenter
		selectIndex: 1;
		unselectIndex: 1.
	self assert: presenter adapter selectedIndexes isEmpty
]

{ #category : 'tests-model-to-widget' }
GtkAbstractListAdapterSingleSelectionTest >> testUnselectPresenterItemUnselectsIndexInWidget [
	presenter
		selectItem: 20;
		unselectItem: 20.
	self assert: presenter adapter selectedIndexes isEmpty
]

{ #category : 'tests-widget-to-model' }
GtkAbstractListAdapterSingleSelectionTest >> testUnselectUnselectedWidgetIndexRaisesSelectionIndexChangeEventOnce [
	| counter |
	counter := 0.

	presenter adapter selectIndex: 1.

	presenter selection
		whenChangedDo: [ :selection | counter := counter + 1 ].

	presenter adapter selection unselectAll.
	self assert: counter equals: 1
]

{ #category : 'tests-widget-to-model' }
GtkAbstractListAdapterSingleSelectionTest >> testUnselectUnselectedWidgetIndexRaisesSelectionIndexChangeEventWithSelectedIndex [
	| selectedIndex |

	presenter adapter selectIndex: 1.

	presenter selection
		whenChangedDo: [ :selection | selectedIndex := selection selectedIndex ].

	presenter adapter selection unselectAll.

	self assert: selectedIndex equals: 0
]

{ #category : 'tests-widget-to-model' }
GtkAbstractListAdapterSingleSelectionTest >> testUnselectWidgetIndexRaisesSelectionIndexChangeEventOnce [
	| counter |
	counter := 0.
	presenter adapter selectIndex: 1.

	presenter selection
		whenChangedDo: [ :selection | counter := counter + 1 ].

	presenter adapter selection unselectPath: #(1).
	self assert: counter equals: 1
]

{ #category : 'tests-widget-to-model' }
GtkAbstractListAdapterSingleSelectionTest >> testUnselectWidgetIndexRaisesSelectionIndexChangeEventWithSelectedIndex [
	| selectedIndex |
	presenter adapter selectIndex: 1.
	presenter selection
		whenChangedDo: [ :selection | selectedIndex := selection selectedIndex ].

	presenter adapter selection unselectPath: {1}.

	self assert: selectedIndex equals: 0
]

{ #category : 'running' }
GtkAbstractListAdapterSingleSelectionTest >> widget [

	^ self adapter widget
]
