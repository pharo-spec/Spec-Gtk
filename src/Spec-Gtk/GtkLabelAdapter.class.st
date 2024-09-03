Class {
	#name : 'GtkLabelAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'accessing' }
GtkLabelAdapter >> addModelTo: gtkWidget [
	
	super addModelTo: gtkWidget.
	self setLabelTo: gtkWidget.
	self presenter whenLabelChangedDo: [
		self updateLabel ]
]

{ #category : 'accessing' }
GtkLabelAdapter >> applyDecorationsTo: aWidget label: aString [
	| attrs |
	
	attrs := PangoAttrList newUnowned.
	self presenter displayColor ifNotNil: [ :block |
		(block cull: aString) ifNotNil: [ :aColor |
			attrs add: (PangoAttribute newForegroundColor: aColor) ] ].
	self presenter displayBold ifNotNil: [ :block |
		(block cull: aString) ifTrue: [ 
			attrs add: PangoAttribute newBold ] ].
	self presenter displayItalic ifNotNil: [ :block |
		(block cull: aString) ifTrue: [ 
			attrs add: PangoAttribute newItalic ] ].
	self presenter displayUnderline ifNotNil: [ :block |
		(block cull: aString) ifTrue: [ 
			attrs add: PangoAttribute newUnderline ] ].
	self presenter displayBackgroundColor ifNotNil: [ :block |
		(block cull: aString) ifNotNil: [ :aColor |
		  	attrs add: (PangoAttribute newBackgroundColor: aColor) ] ].

	attrs isEmpty 
		ifFalse: [ aWidget attributes: attrs ].
	
	attrs unref
]

{ #category : 'accessing' }
GtkLabelAdapter >> beJustifyCenter [

	self widgetDo: [ :w | w beJustifyCenter ]
]

{ #category : 'accessing' }
GtkLabelAdapter >> beJustifyLeft [

	self widgetDo: [ :w | w beJustifyLeft ]
]

{ #category : 'accessing' }
GtkLabelAdapter >> beJustifyRight [

	self widgetDo: [ :w | w beJustifyRight ]
]

{ #category : 'accessing' }
GtkLabelAdapter >> beNotWrap [

	self widgetDo: [ :w | w wrap: false ]
]

{ #category : 'accessing' }
GtkLabelAdapter >> beWrap [

	self widgetDo: [ :w | w wrap: true ]
]

{ #category : 'accessing' }
GtkLabelAdapter >> getText [

	^ (self presenter label ifNil: ['']) 
		localizedForPresenter: self presenter
]

{ #category : 'testing' }
GtkLabelAdapter >> isWrap [

	^ self widgetDo: [ :w | w isWrap ]
]

{ #category : 'accessing' }
GtkLabelAdapter >> label [

	^ self getText
]

{ #category : 'factory' }
GtkLabelAdapter >> newWidget [

	^ GtkLabel new
]

{ #category : 'accessing' }
GtkLabelAdapter >> setLabelTo: gtkWidget [
	| label |
	
	label := self getText.
	gtkWidget label: label.
	self 
		applyDecorationsTo: gtkWidget 
		label: label
]

{ #category : 'private - updating' }
GtkLabelAdapter >> updateLabel [

	self innerWidgetDo: [ :w | 
		self setLabelTo: w ]
]
