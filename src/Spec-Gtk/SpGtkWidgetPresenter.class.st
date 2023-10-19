Class {
	#name : 'SpGtkWidgetPresenter',
	#superclass : 'SpAbstractWidgetPresenter',
	#instVars : [
		'widget'
	],
	#category : 'Spec-Gtk-Widgets',
	#package : 'Spec-Gtk',
	#tag : 'Widgets'
}

{ #category : 'specs' }
SpGtkWidgetPresenter class >> adapterName [

	^ #GtkWidgetAdapter
]

{ #category : 'documentation' }
SpGtkWidgetPresenter class >> documentFactoryMethodSelector [

	^ #newGtkWidget
]

{ #category : 'accessing' }
SpGtkWidgetPresenter >> widget [
	^ widget
]

{ #category : 'accessing' }
SpGtkWidgetPresenter >> widget: anObject [
	widget := anObject
]
