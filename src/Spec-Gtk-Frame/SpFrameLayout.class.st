"
A layout with maximally one child that adds a frame around its contnent with optional label
"
Class {
	#name : #SpFrameLayout,
	#superclass : #SpExecutableLayout,
	#instVars : [
		'label',
		'child'
	],
	#category : #'Spec-Gtk-Frame-Layout'
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
SpFrameLayout >> add: aNameOrPresenter [

	self child: aNameOrPresenter
]

{ #category : #adding }
SpFrameLayout >> add: aPresenter withConstraints: aBlock [
	
	super add: aPresenter withConstraints: aBlock.
	self announceChildAdded: aPresenter.
]

{ #category : #adding }
SpFrameLayout >> child: aNameOrPresenter [

	child ifNotNil: [ self remove: child ].
	child := aNameOrPresenter.
	self 
		add: aNameOrPresenter 
		withConstraints: [ :constraints | ].
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
SpFrameLayout >> label: aString [

	label := aString
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
