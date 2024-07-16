Class {
	#name : 'GtkImageAdapter',
	#superclass : 'GtkMiscAdapter',
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
	
	aFormOrGdkPixbuf ifNil: [ 
		aGtkImage clear. 
		^ self ].
	
	aGtkImage setFromPaintable: aFormOrGdkPixbuf asGdkPaintable
]
