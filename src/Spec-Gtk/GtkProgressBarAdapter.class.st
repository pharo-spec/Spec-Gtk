Class {
	#name : #GtkProgressBarAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkProgressBarAdapter >> addModelTo: gtkWidget [

	gtkWidget showText.
	self updateState
]

{ #category : #api }
GtkProgressBarAdapter >> fixedValue: aNumber [

	self innerWidgetDo: [ :w | 
		w progress: aNumber asFloat ]
]

{ #category : #api }
GtkProgressBarAdapter >> indeterminateValue [

	self innerWidgetDo: [ :w | 
		w pulse ]
]

{ #category : #building }
GtkProgressBarAdapter >> updateProgressValueTo: value [

	value crTrace.
	"self innerWidgetDo: [ :w |
		self backendDetectCyclesDo: [ 
			w  ] ]"
]

{ #category : #api }
GtkProgressBarAdapter >> updateState [

	self presenter state ifNotNil: [ :state | state applyTo: self ]
]

{ #category : #building }
GtkProgressBarAdapter >> widgetClass [

	^ GtkProgressBar
]
