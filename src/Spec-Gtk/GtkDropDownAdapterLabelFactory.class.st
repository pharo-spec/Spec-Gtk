"
A factory used to provide labels to GtkDropDownAdapter.
This is the element that will be shown in the selected part.
"
Class {
	#name : 'GtkDropDownAdapterLabelFactory',
	#superclass : 'GtkListViewAdapterBaseFactory',
	#instVars : [
		'setupAction',
		'bindAction'
	],
	#category : 'Spec-Gtk-Adapter-ListView',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-ListView'
}

{ #category : 'accessing' }
GtkDropDownAdapterLabelFactory >> bind: listItem to: anObject [
	| child |

	child := self presenterAtHandle: listItem child.
	child ifNil: [ ^ self ].
	
	self bindAction
		value: child 
		value: anObject
]

{ #category : 'accessing' }
GtkDropDownAdapterLabelFactory >> bindAction [

	^ bindAction ifNil: [ 
		bindAction := [ :aPresenter :anObject | 
			aPresenter label: (anObject
				ifNotNil: [ (self presenter display value: anObject) ]
				ifNil: [ '(None)' ]) ] ]
]

{ #category : 'accessing' }
GtkDropDownAdapterLabelFactory >> setup: listItem [
	| child |

	child := self setupAction cull: presenter.
	child build.

	self storePresenter: child.

	listItem child: child adapter widget
]

{ #category : 'accessing' }
GtkDropDownAdapterLabelFactory >> setupAction [

	^ setupAction ifNil: [ setupAction := [ :aPresenter | aPresenter newLabel ] ]
]
