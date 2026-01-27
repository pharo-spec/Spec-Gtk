Class {
	#name : 'GtkBoxAdapter',
	#superclass : 'GtkLayoutAdapter',
	#category : 'Spec-Gtk-Layout-Box',
	#package : 'Spec-Gtk',
	#tag : 'Layout-Box'
}

{ #category : 'private' }
GtkBoxAdapter >> add: aPresenter constraints: constraints after: siblingWidget [
	"this is used while replacing, and is same as add:constraints: but with 
	 a sibling widget"

	aPresenter owner: self model. 
	self widgetDo: [ :gtkWidget | 
		| childWidget |
		
		childWidget := self 
			basicInsert: aPresenter
			constraints: constraints 
			to: gtkWidget
			after: siblingWidget.
		self addWidgetAlignment: constraints to: childWidget.
		"I'm keeping a reference to aPresenter into the built widget because in some cases 
		 it can be GC (in case of the on-the-fly creation, for example). 
		 Now this can be a real bad idea :)"
		childWidget data: aPresenter ]
]

{ #category : 'private' }
GtkBoxAdapter >> addConstraints: constraints toChild: childWidget [
	"adds constraits by child."

	layout direction 
		applyDirectionConstraintsTo: childWidget 
		constraints: constraints
		in: self.	

	constraints isExpand ifFalse: [
		| min |
		min := childWidget preferredSizeMinimum.
		constraints width ifNotNil: [ :w | 
			childWidget sizeRequest: w@min y ].
		constraints height ifNotNil: [ :h | 
			childWidget sizeRequest: min x@h ] ].

	^ childWidget
]

{ #category : 'accessing' }
GtkBoxAdapter >> addWidgetAlignment: constraints to: gtkWidget [

 	layout vAlign
		ifNotNil: [ :align | gtkWidget vAlign: align asGtkAlign ].
 	layout hAlign 
		ifNotNil: [ :align | gtkWidget hAlign: align asGtkAlign ]
]

{ #category : 'private' }
GtkBoxAdapter >> applyHorizontalConstraintsTo: aWidget constraints: constraints [
	
	constraints isPlacedAtStart 
		ifFalse: [ aWidget hAlignEnd ].
	aWidget hExpand: constraints isExpand
]

{ #category : 'private' }
GtkBoxAdapter >> applyLayout: aLayout [

	"build of widget was differed up to here (to know what is the direction)"
	widget := aLayout direction newWidgetOn: self.

	self connectToEvents: aLayout. 

	widget 
		homogeneous: aLayout isHomogeneous;
		spacing: aLayout spacing;
		margin: aLayout borderWidth
]

{ #category : 'private' }
GtkBoxAdapter >> applyVerticalConstraintsTo: aWidget constraints: constraints [
	
	constraints isPlacedAtStart 
		ifFalse: [ aWidget vAlignEnd ].
	aWidget vExpand: constraints isExpand
]

{ #category : 'private' }
GtkBoxAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [

	| childWidget |
	childWidget := aPresenter buildWithSelector: constraints spec.
	self addConstraints: constraints toChild: childWidget.
	self flag: #TODO. "constraints isPlacedAtStart does not has any meaning in gtk4" 
	gtkWidget append: childWidget.
	
	^ gtkWidget
]

{ #category : 'private' }
GtkBoxAdapter >> basicInsert: aPresenter constraints: constraints to: gtkWidget after: siblingWidget [

	| childWidget |
	childWidget := aPresenter buildWithSelector: constraints spec.
	self addConstraints: constraints toChild: childWidget.
	gtkWidget insert: childWidget after: siblingWidget.
	
	^ gtkWidget
]

{ #category : 'testing' }
GtkBoxAdapter >> childrenWidgets [
	
	^ self widget children
]

{ #category : 'factory' }
GtkBoxAdapter >> newHorizontal [

	^ GtkBox newHorizontal
]

{ #category : 'factory' }
GtkBoxAdapter >> newVertical [

	^ GtkBox newVertical
]

{ #category : 'accessing' }
GtkBoxAdapter >> replace: aPresenter with: otherPresenter withConstraints: constraints [
	| oldWidget siblingWidget |
	
	"preserve aPresenter widget (in case it will be used later)"
	oldWidget := aPresenter adapter widget. 
	oldWidget ensureObjectRefAndAutoRelease.
	siblingWidget := widget children before: oldWidget ifAbsent: [ nil ].	

	self remove: aPresenter.
	
	siblingWidget
		ifNotNil: [ 
			self 
				add: otherPresenter 
				constraints: constraints 
				after: siblingWidget ]
		ifNil: [
			self 
				add: otherPresenter
				constraints: constraints ] .
	
]

{ #category : 'updating' }
GtkBoxAdapter >> updateSpacing [

	self widgetDo: [ :w | w spacing: layout spacing ]
]
