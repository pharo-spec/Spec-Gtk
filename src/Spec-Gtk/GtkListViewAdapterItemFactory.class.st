Class {
	#name : 'GtkListViewAdapterItemFactory',
	#superclass : 'GtkListViewAdapterBaseFactory',
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'accessing' }
GtkListViewAdapterItemFactory >> bind: listItem to: anObject [
	| child |

	child := self presenterAtHandle: listItem child.
	child ifNil: [ ^ self ].
	
	presenter bindAction
		value: child 
		value: anObject
]

{ #category : 'accessing' }
GtkListViewAdapterItemFactory >> setup: listItem [
	| child |

	child := presenter setupAction cull: presenter.
	child build.

	self storePresenter: child.

	listItem child: child adapter widget
]
