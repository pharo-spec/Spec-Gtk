Class {
	#name : #GtkMillerAdapter,
	#superclass : #GtkLayoutAdapter,
	#instVars : [
		'innerWidget',
		'lastExtent',
		'lastPageSize',
		'realised',
		'keepShowingPage',
		'firstShowingWidget'
	],
	#category : #'Spec-Gtk-Layout-Box'
}

{ #category : #api }
GtkMillerAdapter >> add: aPresenter [

	self add: aPresenter constraints: SpLayoutConstraints new
]

{ #category : #private }
GtkMillerAdapter >> add: aPresenter constraints: constraints [
	
	aPresenter owner: self model. 
	self widgetDo: [ :w |
		| childWidget |
		
		childWidget := self 
			basicAdd: aPresenter
			constraints: constraints 
			to: innerWidget.
		"I'm keeping a reference to aPresenter into the built widget because in some cases 
		 it can be GC (in case of the on-the-fly creation, for example). 
		 Now this can be a real bad idea :)"
		childWidget data: aPresenter.
		self recalculatePages.
		self scrollToShowLastPage ]
]

{ #category : #private }
GtkMillerAdapter >> addConstraints: constraints toChild: childWidget [
	"adds constraits by child."
	
	^ childWidget
]

{ #category : #private }
GtkMillerAdapter >> applyLayout: aLayout [
	"build of widget was differed up to here (to know what is the direction)"

	innerWidget := layout direction newWidgetOn: self.
	innerWidget connectRealize: [
		realised := true.
		self scrollToShowLastPage ].

	innerWidget
		homogeneous: true;
		spacing: aLayout spacing;
		margin: aLayout borderWidth;
		beVisible.

	widget := GtkScrolledWindow newWidget: innerWidget.
	widget connectSizeAllocate: [ :aRect | self widgetResized ].

	self toggleVisible: self presenter isVisible.
	self presenter whenVisibleChangedDo: [
		self toggleVisible: self presenter isVisible ].

	self presenter hasHorizontalScrollBar
		ifTrue: [ self enableHScrollBar ]
		ifFalse: [ self disableHScrollBar ].
	self presenter whenHorizontalScrollBarChangedDo: [ :show |
		show
			ifTrue: [ self enableHScrollBar ]
			ifFalse: [ self disableHScrollBar ] ]
]

{ #category : #private }
GtkMillerAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [
	| childWidget |

	childWidget := aPresenter buildWithSelector: constraints spec.
	self addConstraints: constraints toChild: childWidget.
		
	gtkWidget 
		packStart: childWidget
		expand: true
		fill: true
		padding: 0.
			
	^ gtkWidget
]

{ #category : #private }
GtkMillerAdapter >> childrenWidgets [
	
	^ innerWidget children
]

{ #category : #private }
GtkMillerAdapter >> disableHScrollBar [

	keepShowingPage := true.
	self widgetDo: [ :w | w hScrollBar beNotVisible ]
]

{ #category : #private }
GtkMillerAdapter >> doScrollToShow: aWidget [
	| pos |

	pos := aWidget 
		translateCoordinates: 0@0 
		to: innerWidget.
	pos = (-1@ -1) ifTrue: [ 
		"reschedule to be sure is executed"
		^ self scrollToShow: aWidget ].
	
	self widget hAdjustment value: pos x asFloat.
	self widget vAdjustment value: pos y asFloat
]

{ #category : #private }
GtkMillerAdapter >> enableHScrollBar [

	keepShowingPage := true.
	self widgetDo: [ :w | w hScrollBar show ]
]

{ #category : #initialization }
GtkMillerAdapter >> initialize [

	super initialize.
	realised := false
]

{ #category : #'private accessing' }
GtkMillerAdapter >> innerWidget [

	^ innerWidget
]

{ #category : #factory }
GtkMillerAdapter >> newHorizontal [

	^ GtkBox newHorizontal
]

{ #category : #factory }
GtkMillerAdapter >> newVertical [

	^ GtkBox newVertical
]

{ #category : #private }
GtkMillerAdapter >> recalculatePageHeights [
	| newHeight widgets height |

	height := self widget height.
	widgets := self childrenWidgets.
	newHeight := widgets size = 1
		ifTrue: [ height ]
		ifFalse: [ height / (layout visiblePages min: widgets size) - (layout spacing / (layout visiblePages min: widgets size)) ].
		
	"since the container box is homogeneous, I just need to change the size of 
	 first element to get all the rest to follow"
	widgets first sizeRequest: (widgets first preferredSizeMinimum x)@newHeight
]

{ #category : #private }
GtkMillerAdapter >> recalculatePageWidths [
	| newWidth widgets width |

	width := self widget width.
	widgets := self childrenWidgets.
	newWidth := widgets size = 1
		ifTrue: [ width ]
		ifFalse: [ width / (layout visiblePages min: widgets size) - (layout spacing / (layout visiblePages min: widgets size)) ].
	
	"since the container box is homogeneous, I just need to change the size of 
	 first element to get all the rest to follow"
	widgets first sizeRequest: newWidth asInteger @ (widgets first preferredSizeMinimum y asInteger).
	
]

{ #category : #private }
GtkMillerAdapter >> recalculatePages [

	self widget ifNil: [ ^ self ].
	self childrenWidgets ifEmpty: [ ^ self ].
	((lastExtent = self widget size) 
		and: [ lastPageSize = self childrenWidgets size ]) 
		ifTrue: [ ^ self ].

	[ layout direction recalculatePages: self ]
	ensure: [ 
		lastExtent := self widget size.
		lastPageSize := self childrenWidgets size ]
]

{ #category : #api }
GtkMillerAdapter >> remove: aPresenter [
	| childWidget |

	self innerWidgetDo: [ :w |
		childWidget := aPresenter adapter widget.
		(w children includes: childWidget) ifTrue: [  
			w remove: childWidget.
			self recalculatePages.
			self scrollToShowLastPage ] ]
]

{ #category : #private }
GtkMillerAdapter >> scrollToShow: aWidget [

	realised ifFalse: [ ^ self ].
	innerWidget children ifEmpty: [ ^ self ].
	innerWidget children size = 1 ifTrue: [ ^ self ].

	self flag: #HACK. "This is needed because once added a children, the children will 
	not have immediately a real position, so we cannot scroll. 
	Positions and sizes in Gtk3 are calculated in the redrawing loop, to prevent multiple 
	sizing at once. We need to wait until this happens so the scrolling has sense."
	[
		15 milliSecond wait.
		[ self doScrollToShow: aWidget ]
		on: Error do: [ :e | 
			"do not lost the error if any, but do not stop because of it"
			e emit. 
			e messageText crTrace ]
	] asTask schedule: TKTNewProcessTaskRunner new
]

{ #category : #private }
GtkMillerAdapter >> scrollToShowLastPage [

	realised ifFalse: [ ^ self ].
	innerWidget children ifEmpty: [ ^ self ].
	innerWidget children size = 1 ifTrue: [ ^ self ].

	self scrollToShow: innerWidget children last
]

{ #category : #api }
GtkMillerAdapter >> selectPage: aNumber [
	| child |

	child := innerWidget children at: (aNumber max: 1).
	keepShowingPage 
		ifTrue: [ firstShowingWidget := child ].
	self widgetDo: [ :w | self scrollToShow: child ]
]

{ #category : #private }
GtkMillerAdapter >> toggleVisible: isVisible [

	isVisible 
		ifTrue: [ widget beVisible ] 
		ifFalse: [ widget beNotVisible ]
]

{ #category : #private }
GtkMillerAdapter >> widgetResized [

	self recalculatePages.
	(keepShowingPage and: [ firstShowingWidget notNil ])
		ifTrue: [ self scrollToShow: firstShowingWidget ]
]
