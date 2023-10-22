Class {
	#name : 'GtkProgressBarAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkProgressBarAdapter >> addModelTo: gtkWidget [

	gtkWidget showText.
	self updateState
]

{ #category : 'api' }
GtkProgressBarAdapter >> fixedValue: aNumber [

	self innerWidgetDo: [ :w | 
		w progress: aNumber asFloat ]
]

{ #category : 'api' }
GtkProgressBarAdapter >> indeterminateValue [

	self innerWidgetDo: [ :w | 
		w pulse ]
]

{ #category : 'api' }
GtkProgressBarAdapter >> updateState [

	self presenter state ifNil: [ ^ self ].
	
	self presenter state applyTo: self.
	self flag: #TODO. "This may be a problem now?"
	"GRunLoop current isInCallback 
		ifTrue: [ Gtk3PollingRunLoop new processEvents ]"
]

{ #category : 'building' }
GtkProgressBarAdapter >> widgetClass [

	^ GtkProgressBar
]
