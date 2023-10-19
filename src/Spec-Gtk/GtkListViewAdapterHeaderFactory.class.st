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

{ #category : 'private' }
GtkListViewAdapterHeaderFactory class >> gtkNew [ 

	self ffiCall: #(#GtkListViewAdapterHeaderFactory *gtk_signal_list_item_factory_new())
]

{ #category : 'accessing' }
GtkListViewAdapterHeaderFactory >> bind: listItem to: anObject [
	| child |

	child := self presenterAtHandle: listItem child.
	child label: anObject asString
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

	child := presenter newLabel.
	child build.

	self storePresenter: child.

	listItem child: child adapter widget
]
