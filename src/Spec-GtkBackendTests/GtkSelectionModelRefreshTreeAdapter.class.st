Class {
	#name : 'GtkSelectionModelRefreshTreeAdapter',
	#superclass : 'GtkTreeListViewAdapter',
	#instVars : [
		'nextSelectionModel'
	],
	#category : 'Spec-GtkBackendTests',
	#package : 'Spec-GtkBackendTests'
}

{ #category : 'private' }
GtkSelectionModelRefreshTreeAdapter >> backendUpdatingDo: aBlock [

	^ aBlock value
]

{ #category : 'private' }
GtkSelectionModelRefreshTreeAdapter >> innerWidgetDo: aBlock [

	^ aBlock value: widget
]

{ #category : 'testing' }
GtkSelectionModelRefreshTreeAdapter >> isAlive [

	^ true
]

{ #category : 'private - factory' }
GtkSelectionModelRefreshTreeAdapter >> newSelectionModel [

	^ nextSelectionModel
]

{ #category : 'accessing' }
GtkSelectionModelRefreshTreeAdapter >> nextSelectionModel: aSelectionModel [

	nextSelectionModel := aSelectionModel
]

{ #category : 'accessing' }
GtkSelectionModelRefreshTreeAdapter >> widget: aWidget [

	widget := aWidget
]
