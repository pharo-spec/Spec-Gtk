"
Item factory for to be used with `GtkListViewAdapter`
"
Class {
	#name : #GtkListViewAdapterItemFactory,
	#superclass : #GtkListViewAdapterBaseFactory,
	#category : #'Spec-Gtk-Adapter-ListView'
}

{ #category : #private }
GtkListViewAdapterItemFactory class >> gtkNew [ 

	self ffiCall: #(#GtkListViewAdapterItemFactory *gtk_signal_list_item_factory_new())
]

{ #category : #accessing }
GtkListViewAdapterItemFactory >> bind: listItem to: anObject [
	| child |

	child := self presenterAtHandle: listItem child.
	presenter bindAction
		value: child 
		value: anObject
]

{ #category : #accessing }
GtkListViewAdapterItemFactory >> setup: listItem [
	| child |

	child := presenter setupAction cull: presenter.
	child build.

	self storePresenter: child.

	listItem child: child adapter widget
]
