Class {
	#name : 'GtkSwitchAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkSwitchAdapter >> addModelTo: gtkWidget [

	super addModelTo: gtkWidget.
	
	gtkWidget active: self presenter state.
	
	gtkWidget connectToggled: [
		self backendUpdatingDo: [ self updatePresenterState ] ].
	self presenter whenChangedDo: [
		self backendDetectCyclesDo: [ self updateState ] ]
]

{ #category : 'accessing' }
GtkSwitchAdapter >> state [
	
	^ widget isActive
]

{ #category : 'updating' }
GtkSwitchAdapter >> updatePresenterState [
	
	self presenter state: self state
]

{ #category : 'updating' }
GtkSwitchAdapter >> updateState [

	self widgetDo: [ :w | 
		self presenter state = w isActive
			ifFalse: [ w active: self presenter state ] ]
]

{ #category : 'factory' }
GtkSwitchAdapter >> widgetClass [

	^ GtkSwitch
]
