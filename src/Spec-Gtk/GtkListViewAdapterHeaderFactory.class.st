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

{ #category : 'as yet unclassified' }
GtkListViewAdapterHeaderFactory >> bind: listItem to: anObject [
	| child |

	child := self presenterAtHandle: listItem child.
	child label: anObject asString
]

{ #category : 'private' }
GtkListViewAdapterHeaderFactory >> itemAt: aPosition [ 

	^ self presenter headerTitle
]

{ #category : 'as yet unclassified' }
GtkListViewAdapterHeaderFactory >> listItemClass [
	
	^ GtkListHeader
]

{ #category : 'as yet unclassified' }
GtkListViewAdapterHeaderFactory >> setup: listItem [
	| child |

	child := presenter newLabel.
	child build.

	self storePresenter: child.

	listItem child: child adapter widget
]
