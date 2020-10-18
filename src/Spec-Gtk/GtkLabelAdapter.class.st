Class {
	#name : #GtkLabelAdapter,
	#superclass : #GtkMiscAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #accessing }
GtkLabelAdapter >> addModelTo: gtkWidget [
	
	super addModelTo: gtkWidget.
	
	gtkWidget label: self getText.
	self presenter whenLabelChangedDo: [
		self innerWidgetDo: [ :w | w label: self getText ] ].
]

{ #category : #accessing }
GtkLabelAdapter >> getText [

	^ self presenter label localizedForPresenter: self presenter
]

{ #category : #accessing }
GtkLabelAdapter >> label [

	^ self getText
]

{ #category : #factory }
GtkLabelAdapter >> newWidget [

	^ GtkLabel new
]
