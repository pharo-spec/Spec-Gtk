"
Item factory to be used on `GtkDropListAdapter`.
It serves `SpDropListItemPresenter` instances.
"
Class {
	#name : 'GtkDropListAdapterItemFactory',
	#superclass : 'GtkListViewAdapterBaseFactory',
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'private' }
GtkDropListAdapterItemFactory class >> gtkNew [ 

	self ffiCall: #(GtkDropListAdapterItemFactory *gtk_signal_list_item_factory_new())
]

{ #category : 'accessing' }
GtkDropListAdapterItemFactory >> bind: listItem to: anObject [
	| child |

	child := self presenterAtHandle: listItem child.
	child model: anObject
]

{ #category : 'private' }
GtkDropListAdapterItemFactory >> getItems [

	^ self presenter getList
]

{ #category : 'accessing' }
GtkDropListAdapterItemFactory >> setup: listItem [
	| child |

	child := presenter instantiate: SpDropListItemPresenter.
	child build.

	self storePresenter: child.

	listItem child: child adapter widget
]
