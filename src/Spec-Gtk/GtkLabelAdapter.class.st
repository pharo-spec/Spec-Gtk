Class {
	#name : #GtkLabelAdapter,
	#superclass : #GtkMiscAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #accessing }
GtkLabelAdapter >> addModelTo: gtkWidget [
	
	super addModelTo: gtkWidget.
	self setLabelTo: gtkWidget.
	self presenter whenLabelChangedDo: [
		self innerWidgetDo: [ :w | 
			self setLabelTo: w ] ].
]

{ #category : #accessing }
GtkLabelAdapter >> applyDecorationsTo: aWidget label: aString [
	| attrs empty |
	
	empty := true.
	attrs := PangoAttrList new. 
	self presenter displayColor ifNotNil: [ :block |
		(block cull: aString) ifNotNil: [ :aColor |
			empty := false.
			attrs add: (PangoAttribute newForegroundColor: aColor) ] ].
	self presenter displayBold ifNotNil: [ :block |
		(block cull: aString) ifTrue: [ 
			empty := false.
			attrs add: PangoAttribute newBold ] ].
	self presenter displayItalic ifNotNil: [ :block |
		(block cull: aString) ifTrue: [ 
			empty := false.
			attrs add: PangoAttribute newItalic ] ].
	self presenter displayUnderline ifNotNil: [ :block |
		(block cull: aString) ifTrue: [ 
			empty := false.
			attrs add: PangoAttribute newUnderline ] ].
	self presenter displayBackgroundColor ifNotNil: [ :block |
		(block cull: aString) ifNotNil: [ :aColor |
			empty := false.
		  	attrs add: (PangoAttribute newBackgroundColor: aColor) ] ].

	empty ifTrue: [ ^ self ].
	aWidget attributes: attrs
]

{ #category : #accessing }
GtkLabelAdapter >> getText [

	^ (self presenter label ifNil: ['']) 
		localizedForPresenter: self presenter
]

{ #category : #accessing }
GtkLabelAdapter >> label [

	^ self getText
]

{ #category : #factory }
GtkLabelAdapter >> newWidget [

	^ GtkLabel new
]

{ #category : #accessing }
GtkLabelAdapter >> setLabelTo: gtkWidget [
	| label |
	
	gtkWidget label: (label := self getText).
	self applyDecorationsTo: gtkWidget label: label. 

]
