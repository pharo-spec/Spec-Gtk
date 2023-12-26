"
A frame presenter to decorate a content presenter with a frame and an optional label.

**IMPORTANT:** For the time being, this component is just present with the Gtk backend.
"
Class {
	#name : 'SpFramePresenter',
	#superclass : 'SpAbstractWidgetPresenter',
	#instVars : [
		'#label => ObservableSlot',
		'#presenter => ObservableSlot'
	],
	#category : 'Spec-Gtk-Frame-Presenter',
	#package : 'Spec-Gtk-Frame',
	#tag : 'Presenter'
}

{ #category : 'specs' }
SpFramePresenter class >> adapterName [

	^ #FrameAdapter
]

{ #category : 'documentation' }
SpFramePresenter class >> documentExamplesProtocol [

	^ #example
]

{ #category : 'example' }
SpFramePresenter class >> example [
	
	^ self new 
		application: (SpApplication new useBackend: #Gtk);
		label: 'Test';
		presenter: (SpLabelPresenter new 
			label: 'Content';
			yourself);
		open
]

{ #category : 'api' }
SpFramePresenter >> label [
	^ label
]

{ #category : 'api' }
SpFramePresenter >> label: anObject [
	label := anObject
]

{ #category : 'api' }
SpFramePresenter >> presenter [

	^ presenter
]

{ #category : 'api' }
SpFramePresenter >> presenter: aPresenter [

	aPresenter owner: self.
	presenter := aPresenter
]

{ #category : 'api-events' }
SpFramePresenter >> whenLabelChangedDo: aBlock [
	
	self property: #label whenChangedDo: aBlock
]

{ #category : 'api-events' }
SpFramePresenter >> whenPresenterChangedDo: aBlock [
	
	self property: #presenter whenChangedDo: aBlock
]
