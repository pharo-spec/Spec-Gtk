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
	
	self updateForm: self presenter image into: gtkImage.
	self model whenImageChangeDo: [ 
		self widgetDo: [ :w |
			self 
				updateForm: self presenter image 
				into: gtkImage ] ]
]

{ #category : 'private' }
GtkImageAdapter >> cachedPaintableForForm: aForm [

	^ aForm asGdkPaintableOnApplication: self presenter application
]

{ #category : 'accessing' }
GtkImageAdapter >> image [
	
	^ self widget
]

{ #category : 'building' }
GtkImageAdapter >> newWidget [

	^ self presenter isAutoScale 
		ifTrue: [ GtkPicture new ]
		ifFalse: [ GtkImage newEmpty ]
]

{ #category : 'private' }
GtkImageAdapter >> updateForm: aFormOrGdkPixbuf into: aGtkImageOrPicture [
	| paintable |

	aFormOrGdkPixbuf ifNil: [
		aGtkImageOrPicture clear.
		^ self ].

	paintable := aFormOrGdkPixbuf isForm
		ifTrue: [ self cachedPaintableForForm: aFormOrGdkPixbuf ]
		ifFalse: [ aFormOrGdkPixbuf asGdkPaintable ].

	self presenter isAutoScale
		ifTrue: [ aGtkImageOrPicture setPaintable: paintable ]
		ifFalse: [ aGtkImageOrPicture setFromPaintable: paintable ]
]
