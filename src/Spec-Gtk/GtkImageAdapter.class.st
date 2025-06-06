Class {
	#name : 'GtkImageAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'accessing' }
GtkImageAdapter >> addModelTo: gtkImage [

	super addModelTo: gtkImage.
	
	self updateForm: self model image into: gtkImage.
	self model whenImageChangeDo: [ 
		self widgetDo: [ :w |
			self updateForm: self model image into: gtkImage ] ]
]

{ #category : 'accessing' }
GtkImageAdapter >> image [
	
	^ self widget
]

{ #category : 'building' }
GtkImageAdapter >> newWidget [

	^ GtkImage newEmpty 
]

{ #category : 'updating' }
GtkImageAdapter >> updateForm: aFormOrGdkPixbuf into: aGtkImage [
	| paintable |
	
	aFormOrGdkPixbuf ifNil: [ 
		aGtkImage clear. 
		^ self ].
	
	paintable := aFormOrGdkPixbuf asGdkPaintable.
	aFormOrGdkPixbuf isForm ifTrue: [ 
		| size |
		size := aFormOrGdkPixbuf width@aFormOrGdkPixbuf height.
		paintable 
			computeConcreteSize: size
			defaults: size ].
	aGtkImage setFromPaintable: paintable
]
