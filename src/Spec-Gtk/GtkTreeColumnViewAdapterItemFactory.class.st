Class {
	#name : 'GtkTreeColumnViewAdapterItemFactory',
	#superclass : 'GtkColumnViewAdapterItemFactory',
	#instVars : [
		'store'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'accessing' }
GtkTreeColumnViewAdapterItemFactory >> bind: listItem [
	| child row itemReference itemStore item |

	row := GtkTreeListRow fromHandleUnowned: listItem item getHandle.
	child := self presenterAtHandle: listItem child getHandle.
	child ifNil: [ ^ self ].
	
	itemReference := row item.
	itemStore := store storeAt: (itemReference dataAt: 'store').
	item := itemStore itemAtHandle: itemReference getHandle.
	itemReference objectUnref.
	storeModel ifTrue: [
		self storeModelPresenter: child model: item ].

	self column bindAction
		value: child 
		value: item
]

{ #category : 'accessing' }
GtkTreeColumnViewAdapterItemFactory >> bind: listItem to: anObject [
	
	self error: 'Should not arrive here'
]

{ #category : 'accessing' }
GtkTreeColumnViewAdapterItemFactory >> setup: listItem [
	| child |

	child := self column setupAction cull: presenter.
	child build.

	self storePresenter: child.
	listItem child: child adapter widget
]

{ #category : 'accessing' }
GtkTreeColumnViewAdapterItemFactory >> store: aRootStore [

	store := aRootStore.
	storedObjects removeAll
]

{ #category : 'accessing' }
GtkTreeColumnViewAdapterItemFactory >> unbind: listItem [
	"Releasing model of cell presenter on unbind because 
	 - it will not be show anymore, is wrong to think is already binded.
	 - models can have announcements related to the living row, and keeping them there can cause 
	   crashes (as the model send events to a potenatial inexistent row.
	 
	 This method is mirrored with GtkTreeListViewAdapterItemFactory>>unbind:
	 Any change here needs to be replicated there!"
	| expander cellPresenter |
	
	logger trace.
	
	expander := self presenterAtHandle: listItem child.
	"child will be a an expander as this is a single column tree, but I validate, just in case :P"
	expander class = GtkTreeExpander ifFalse: [ ^ self ].	
	
	cellPresenter := self presenterAtHandle: expander child getHandle.
	logger trace: cellPresenter.
	"I check for model as a guard, but all cells of listView components should understand it"
	(cellPresenter isNil or: [ (cellPresenter respondsTo: #model:) not])
		ifTrue: [ ^ self ].
	
	cellPresenter model: nil
]
