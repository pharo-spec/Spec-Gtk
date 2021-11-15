"
A layout with maximally one child that adds a frame around its contnent with optional label
"
Class {
	#name : #SpFrameLayout,
	#superclass : #SpExecutableLayout,
	#instVars : [
		'label'
	],
	#category : #'Spec-Gtk-Frame-Support'
}

{ #category : #'instance creation' }
SpFrameLayout class >> newFrame [

	^ self new
]

{ #category : #'instance creation' }
SpFrameLayout class >> newLabel: aLabel [ 

	^ self new label: aLabel
]

{ #category : #private }
SpFrameLayout >> adapterName [

	^ #FrameLayoutAdapter
]

{ #category : #adding }
SpFrameLayout >> add: aName [

	self 
		add: aName 
		withConstraints: [ :constraints | ]
]

{ #category : #adding }
SpFrameLayout >> add: aName expand: shouldExpand [

	^ self 
		add: aName 
		withConstraints: [ :constraints | 
			constraints expand: shouldExpand ]
]

{ #category : #adding }
SpFrameLayout >> add: aName expand: shouldExpand fill: shouldFill padding: aNumber [
"
aName 		- the presenter to be added to box
expand 	- true if the new child is to be given extra space allocated to box . 
			  The extra space will be divided evenly between all children that use this option
fill 		- true if space given to child by the expand option is actually allocated to child , 
			  rather than just padding it. This parameter has no effect if expand is set to false. 
padding 	- extra space in pixels to put between this child and its neighbors, over and above 
			  the global amount specified by “spacing” property. If child is a widget at one of 
			  the reference ends of box , then padding pixels are also put between child and the
			  reference edge of box"

	self 
		add: aName 
		withConstraints: [ :constraints |
			constraints 
				expand: shouldExpand;
				fill: shouldFill; 
				padding: aNumber ]
]

{ #category : #adding }
SpFrameLayout >> add: aPresenter height: anInteger [ 
	self add: aPresenter withConstraints: [:constraints | constraints height: anInteger ].
]

{ #category : #adding }
SpFrameLayout >> add: aPresenter width: anInteger [
	self
		add: aPresenter
		withConstraints: [ :constraints | constraints width: anInteger ].
]

{ #category : #adding }
SpFrameLayout >> add: aPresenter withConstraints: aBlock [
	
	super add: aPresenter withConstraints: aBlock.
	self announceChildAdded: aPresenter.
]

{ #category : #adding }
SpFrameLayout >> addLast: aName [

	self 
		addLast: aName 
		withConstraints: [ :constraints | ]
]

{ #category : #adding }
SpFrameLayout >> addLast: aName expand: shouldExpand [

	self 
		addLast: aName 
		withConstraints: [ :constraints | 
			constraints expand: shouldExpand ]
]

{ #category : #adding }
SpFrameLayout >> addLast: aName expand: shouldExpand fill: shouldFill padding: aNumber [

	self 
		addLast: aName 
		withConstraints: [ :constraints |
			constraints 
				expand: shouldExpand;
				fill: shouldFill; 
				padding: aNumber ]
]

{ #category : #adding }
SpFrameLayout >> addLast: aName withConstraints: aBlock [

	self 
		add: aName 
		withConstraints: [ :constraints |
			constraints bePlacedAtEnd.
			aBlock value: constraints ]
]

{ #category : #private }
SpFrameLayout >> constraintsClass [

	^ SpFrameConstraints
]

{ #category : #initialization }
SpFrameLayout >> initialize [

	super initialize.

]

{ #category : #accessing }
SpFrameLayout >> label [
	^ label
]

{ #category : #accessing }
SpFrameLayout >> label: anObject [
	label := anObject
]

{ #category : #removing }
SpFrameLayout >> removeAll [

	children removeAll.
	adapter ifNotNil: [ :anAdapter | 
		anAdapter unsubscribe.
		anAdapter removeAll ]
]

{ #category : #replacing }
SpFrameLayout >> replace: aPresenter with: otherPresenter [
	"Replace aPresenter with otherPresenter. 
	 Original constraints will be preserved."
	
	self 
		replace: aPresenter 
		with: otherPresenter
		withConstraints: (self constraintsFor: aPresenter)
]

{ #category : #replacing }
SpFrameLayout >> replace: aPresenter with: otherPresenter withConstraints: constraints [
	"Replace aPresenter with otherPresenter"
	
	children
		replaceKey: aPresenter
		with: otherPresenter.

	self withAdapterDo: [ :anAdapter |
		anAdapter 
			replace: aPresenter 
			with: otherPresenter
			withConstraints: constraints ]
]
