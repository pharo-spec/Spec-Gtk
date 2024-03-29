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

{ #category : #api }
GtkProgressBarAdapter >> updateState [

	self presenter state ifNil: [ ^ self ].
	
	self presenter state applyTo: self.
	GRunLoop current isInCallback 
		ifTrue: [ GtkPollingRunLoop new processEvents ]
]

{ #category : #building }
GtkProgressBarAdapter >> widgetClass [

	^ GtkProgressBar
]
