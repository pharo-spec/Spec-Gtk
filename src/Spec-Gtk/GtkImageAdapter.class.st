Class {
	#name : #GtkImageAdapter,
	#superclass : #GtkMiscAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #accessing }
GtkImageAdapter >> addModelTo: gtkImage [

	super addModelTo: gtkImage.
	
	self updateForm: self model image into: gtkImage.
	
	self model whenImageChangeDo: [ self updateForm: self model image into: gtkImage ].
]

{ #category : #accessing }
GtkImageAdapter >> image [
	
	^ self widget
]

{ #category : #building }
GtkImageAdapter >> newWidget [

	^ GtkImage newEmpty 
]

{ #category : #updating }
GtkImageAdapter >> updateForm: aForm into: aGtkImage [ 
		
	| pixbuf |
	
	aForm isNil ifTrue: [ aGtkImage clear. ^ self ].
	
	pixbuf := GdkPixbuf newForm: aForm.
	aGtkImage setFromGdkPixbuf: pixbuf.
]
