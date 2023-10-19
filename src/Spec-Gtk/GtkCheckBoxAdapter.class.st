Class {
	#name : 'GtkCheckBoxAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkCheckBoxAdapter >> addModelTo: gtkWidget [

	super addModelTo: gtkWidget.
	
	gtkWidget label: self getLabelText.
	gtkWidget active: self presenter state.
	
	gtkWidget connectToggled: [
		self backendUpdatingDo: [ self updatePresenterState ] ].
	self presenter whenChangedDo: [
		self backendDetectCyclesDo: [ self updateState ] ].
	
	self presenter whenLabelChangedDo: [ self updateLabel ]
]

{ #category : 'emulating' }
GtkCheckBoxAdapter >> clicked [


	self deprecated: #Gtk4
]

{ #category : 'private' }
GtkCheckBoxAdapter >> getLabelText [

	^ self presenter label ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : 'accessing' }
GtkCheckBoxAdapter >> state [
	
	^ widget isActive
]

{ #category : 'updating' }
GtkCheckBoxAdapter >> updateLabel [

	self widgetDo: [ :w |
		w label: self getLabelText ]
]

{ #category : 'updating' }
GtkCheckBoxAdapter >> updatePresenterState [
	
	self presenter state: self state
]

{ #category : 'updating' }
GtkCheckBoxAdapter >> updateState [

	self widgetDo: [ :w | 
		self presenter state = w isActive
			ifFalse: [ w active: self presenter state ] ]
]

{ #category : 'factory' }
GtkCheckBoxAdapter >> widgetClass [

	^ GtkCheckButton
]
