"
A presenter to show the `SpDropListPresenter` list item. 
It can show an icon or not.
"
Class {
	#name : 'SpDropListItemPresenter',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'iconPresenter',
		'labelPresenter'
	],
	#category : 'Spec-Gtk-Adapter-List',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-List'
}

{ #category : 'layout' }
SpDropListItemPresenter >> defaultLayout [

	^ self owner hasIcons
		ifTrue: [ self iconLayout ]
		ifFalse: [ self labelLayout ]
]

{ #category : 'layout' }
SpDropListItemPresenter >> iconLayout [

	^ SpBoxLayout newHorizontal
		spacing: 5;
		add: iconPresenter expand: false;
		add: labelPresenter;
		yourself
]

{ #category : 'initialization' }
SpDropListItemPresenter >> initializePresenters [

	iconPresenter := self newImage.
	labelPresenter := self newLabel
]

{ #category : 'layout' }
SpDropListItemPresenter >> labelLayout [

	^ SpBoxLayout newHorizontal
		add: labelPresenter;
		yourself
]

{ #category : 'initialization' }
SpDropListItemPresenter >> updatePresenter [

	self model ifNil: [ ^ self ].

	self owner hasIcons
		ifTrue: [ iconPresenter image: (self owner getIconFor: self model) ].
	labelPresenter label: (self owner displayForItem: self model)
]

{ #category : 'layout' }
SpDropListItemPresenter >> useIconLayout [

	self layout: self iconLayout
]

{ #category : 'layout' }
SpDropListItemPresenter >> useLabelLayout [

	self layout: self labelLayout
]
