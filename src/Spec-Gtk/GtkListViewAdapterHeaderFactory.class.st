"
Header factory for to be used with `GtkListViewAdapter`
"
Class {
	#name : 'GtkListViewAdapterHeaderFactory',
	#superclass : 'GtkListViewAdapterBaseFactory',
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'accessing' }
GtkListViewAdapterHeaderFactory >> bind: listItem [

	self 
		bind: listItem 
		to: (self itemAt: (listItem start + 1))
]

{ #category : 'accessing' }
GtkListViewAdapterHeaderFactory >> bind: listItem to: anObject [
	"| child |

	child := self presenterAtHandle: listItem child.
	child label: anObject asString"
]

{ #category : 'private' }
GtkListViewAdapterHeaderFactory >> itemAt: aPosition [ 

	^ self presenter headerTitle
]

{ #category : 'private' }
GtkListViewAdapterHeaderFactory >> listItemClass [
	
	^ GtkListHeader
]

{ #category : 'accessing' }
GtkListViewAdapterHeaderFactory >> setup: listItem [
	| child |

	child := presenter newPresenter.
	child layout: SpBoxLayout newHorizontal.
	child addStyle: 'columnview-header'.

	presenter columns do: [ :each | 
		child layout add: (child newButton
			label: each title;
			yourself) ].
	
	"child := presenter newButton."
	child build.

	self storePresenter: child.

	listItem child: child adapter widget
]
