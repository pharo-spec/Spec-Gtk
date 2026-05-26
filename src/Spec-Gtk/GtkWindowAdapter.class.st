Class {
	#name : 'GtkWindowAdapter',
	#superclass : 'GtkBaseWindowAdapter',
	#category : 'Spec-Gtk-Adapter-Window',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Window'
}

{ #category : 'accessing' }
GtkWindowAdapter >> addWindowControl: aPresenter [
	
	self innerWidgetDo: [ :w |
		self addWindowControl: aPresenter build in: w ]
]

{ #category : 'private' }
GtkWindowAdapter >> addWindowControl: gtkWidget in: gtkWindow [

	adapterHelper addWindowControl: gtkWidget in: gtkWindow
]

{ #category : 'private - actions' }
GtkWindowAdapter >> newActionManager [

	^ adapterHelper newActionManager
]
