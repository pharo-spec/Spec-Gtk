Class {
	#name : 'GtkRadioButtonAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'emulating' }
GtkRadioButtonAdapter >> addAssociatedTo: gtkWidget [
	
	self presenter associatedRadioButtons ifEmpty: [ ^ self ].

	self presenter associatedRadioButtons do: [ :each |  
		each withAdapterDo: [ :anAdapter | 
			anAdapter widgetDo: [ :w | w group: gtkWidget ] ] ].

	self presenter isInitialStateSet ifFalse: [ 
		self widgetClass new 
			group: gtkWidget;
			beNotVisible;
			active: true ]
]

{ #category : 'emulating' }
GtkRadioButtonAdapter >> addModelTo: gtkWidget [
	
	super addModelTo: gtkWidget.

	self presenter hasLabel
	ifTrue: [ gtkWidget child: self newChildLabel ].

	self addAssociatedTo: gtkWidget.
	self presenter isInitialStateSet 
		ifTrue: [ gtkWidget active: self presenter state ].
	
	gtkWidget connectToggled: [ self presenter state: self state ].
	
	self model whenLabelChangedDo: [ self updateLabel ].
	self model whenChangedDo: [ gtkWidget active: self presenter state ]
]

{ #category : 'emulating' }
GtkRadioButtonAdapter >> clicked [


	self deprecated: #Gtk4
]

{ #category : 'private' }
GtkRadioButtonAdapter >> getLabelText [

	^ self presenter label ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : 'updating' }
GtkRadioButtonAdapter >> newChildLabel [

	^ ((GtkLabel newLabel: self getLabelText)
			wrap: true;
			yourself)
]

{ #category : 'accessing' }
GtkRadioButtonAdapter >> state [
	
	^ widget isActive
]

{ #category : 'updating' }
GtkRadioButtonAdapter >> updateLabel [

	self widgetDo: [ :w |
		w child: self newChildLabel ]
]

{ #category : 'factory' }
GtkRadioButtonAdapter >> widgetClass [

	^ GtkCheckButton
]
