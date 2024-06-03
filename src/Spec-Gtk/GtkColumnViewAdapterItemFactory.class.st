Class {
	#name : 'GtkColumnViewAdapterItemFactory',
	#superclass : 'GtkListViewAdapterBaseFactory',
	#instVars : [
		'column'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'instance creation' }
GtkColumnViewAdapterItemFactory class >> newPresenter: aPresenter column: aColumn [

	^ self new 
		presenter: aPresenter;
		column: aColumn;
		yourself
]

{ #category : 'accessing' }
GtkColumnViewAdapterItemFactory >> bind: listItem to: anObject [
	| child |

	child := self presenterAtHandle: listItem child.
	child ifNil: [ ^ self ].
	
	self column bindAction
		value: child 
		value: anObject
]

{ #category : 'accessing' }
GtkColumnViewAdapterItemFactory >> column [

	^ column
]

{ #category : 'accessing' }
GtkColumnViewAdapterItemFactory >> column: aColumn [

	column := aColumn
]

{ #category : 'accessing' }
GtkColumnViewAdapterItemFactory >> setup: listItem [
	| child |

	child := self column setupAction cull: presenter.
	child build.

	self storePresenter: child.

	listItem child: child adapter widget
]
