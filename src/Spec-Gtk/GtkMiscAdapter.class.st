Class {
	#name : #GtkMiscAdapter,
	#superclass : #GtkAdapter,
	#instVars : [
		'innerWidget'
	],
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #'private accessing' }
GtkMiscAdapter >> innerWidget [

	^ innerWidget ifNil: [ super innerWidget ]
]

{ #category : #'event installing' }
GtkMiscAdapter >> installEvent: anEvent [

	"If innerWidget is nil, it means component needs to be wrapped"
	(innerWidget isNil and: [ self presenter owner notNil ]) ifTrue: [
		self widgetDo: [ :w |
			innerWidget := w.
			self widget: (GtkEventBox newWidget: innerWidget) show.
			self presenter owner rebuildLayout ] ].
	super installEvent: anEvent
]

{ #category : #'private accessing' }
GtkMiscAdapter >> widget: aWidget [

	widget := aWidget
]

{ #category : #building }
GtkMiscAdapter >> wrapWidget: aWidget [
	| eventBox |

	self presenter hasEventHandler 
		ifFalse: [ ^ super wrapWidget: aWidget ].
		
	innerWidget := aWidget.
	eventBox := GtkEventBox newWidget: innerWidget.
	eventBox show.
	eventBox events: innerWidget events.
	innerWidget callbacks 
		do: [ :each | each connectTo: eventBox ].
		
	^ eventBox
]
