Class {
	#name : 'GtkMillerAdapter',
	#superclass : 'GtkLayoutAdapter',
	#instVars : [
		'innerWidget',
		'lastExtent',
		'lastPageSize',
		'realised',
		'keepShowingPage',
		'firstShowingWidget',
		'horizontalAdjustment',
		'visibleStart',
		'visibleCount',
		'columnWidth',
		'isUpdatingScroll'
	],
	#category : 'Spec-Gtk-Layout-Box',
	#package : 'Spec-Gtk',
	#tag : 'Layout-Box'
}

{ #category : 'api' }
GtkMillerAdapter >> add: aPresenter [

	self add: aPresenter constraints: SpLayoutConstraints new
]

{ #category : 'private' }
GtkMillerAdapter >> add: aPresenter constraints: constraints [

	aPresenter owner: self model.
	self innerWidgetDo: [ :gtkWidget |
		| childWidget |
		childWidget := self 
			basicAdd: aPresenter 
			constraints: constraints 
			to: gtkWidget.
		childWidget data: aPresenter.
		self recalculatePages.
		self scrollToShowLastPage ]
]

{ #category : 'private' }
GtkMillerAdapter >> addConstraints: constraints toChild: childWidget [
	"adds constraits by child."
	
	^ childWidget
]

{ #category : 'private' }
GtkMillerAdapter >> applyLayout: aLayout [

	innerWidget := GtkBox newHorizontal.
	innerWidget connectRealize: [
			realised := true.
			self updateViewportGeometryWhenAllocatedDo: [ self scrollToShowLastPage ] ].

	innerWidget
		homogeneous: false;
		spacing: aLayout spacing;
		margin: aLayout borderWidth;
		hExpand: false;
		beVisible.

	widget := GtkScrolledWindow newWidget: innerWidget.
	widget
		policyHScrollbar: GtkPolicyType GTK_POLICY_NEVER vScrollbar: GtkPolicyType GTK_POLICY_NEVER;
		overlayScrolling: true.
	horizontalAdjustment := widget hAdjustment.
	visibleCount := self initialVisibleCount.
	visibleStart := 0.
	widget connectNotifyProperty: 'width' do: [ :parameterSpec | self viewportWidthChanged ].
	aLayout whenVisiblePagesChangedDo: [ self visiblePagesChanged ].

	self toggleVisible: self presenter isVisible.
	self presenter whenVisibleChangedDo: [ self toggleVisible: self presenter isVisible ].

	self hideHorizontalScrollBar.
	self presenter whenHorizontalScrollBarChangedDo: [ :show | self hideHorizontalScrollBar ]
]

{ #category : 'private' }
GtkMillerAdapter >> basicAdd: aPresenter constraints: constraints to: gtkWidget [
	| childWidget |
	
	childWidget := aPresenter buildWithSelector: constraints spec.
	self addConstraints: constraints toChild: childWidget.
	self configureColumnWidget: childWidget.
	gtkWidget append: childWidget.
	
	^ childWidget
]

{ #category : 'private' }
GtkMillerAdapter >> childrenWidgets [

	^ innerWidget 
		ifNotNil: [ innerWidget children ]
		ifNil: [ #() ]
]

{ #category : 'private' }
GtkMillerAdapter >> clampVisibleStart [

	visibleStart := (self visibleStart min: self maximumStart) max: 0
]

{ #category : 'accessing' }
GtkMillerAdapter >> columnSpacing [

	layout ifNil: [ ^ 0 ].
	^ layout spacing
]

{ #category : 'accessing' }
GtkMillerAdapter >> columnStep [

	^ self columnWidth + self columnSpacing
]

{ #category : 'accessing' }
GtkMillerAdapter >> columnWidth [

	^ columnWidth ifNil: [ columnWidth := self defaultColumnWidth ]
]

{ #category : 'private' }
GtkMillerAdapter >> columnWidthForViewportWidth: aNumber [

	| availableWidth spacingWidth visiblePanelCount |
	visiblePanelCount := self preferredVisibleCount max: 1.
	spacingWidth := self columnSpacing * (visiblePanelCount - 1 max: 0).
	availableWidth := aNumber - spacingWidth max: visiblePanelCount.

	^ (availableWidth / visiblePanelCount) floor max: 1
]

{ #category : 'private' }
GtkMillerAdapter >> configureColumnWidget: childWidget [

	childWidget
		sizeRequestWidth: self columnWidth height: -1;
		vExpand: true;
		hExpand: false;
		addClass: 'miller-column'.
	^ childWidget
]

{ #category : 'private' }
GtkMillerAdapter >> configureColumnWidgets [

	self childrenWidgets do: [ :each | self configureColumnWidget: each ]
]

{ #category : 'defaults' }
GtkMillerAdapter >> defaultColumnWidth [

	^ 260
]

{ #category : 'private' }
GtkMillerAdapter >> disableHScrollBar [

	keepShowingPage := true.
	self hideHorizontalScrollBar
]

{ #category : 'private' }
GtkMillerAdapter >> doScrollToShow: aWidget [

	self scrollToShow: aWidget
]

{ #category : 'private' }
GtkMillerAdapter >> enableHScrollBar [

	keepShowingPage := false.
	self hideHorizontalScrollBar
]

{ #category : 'private' }
GtkMillerAdapter >> ensureAllColumnWidgetsAreRetained [

	self childrenWidgets do: [ :each | self ensureRetained: each ]
]

{ #category : 'private' }
GtkMillerAdapter >> firstVisibleWidget [

	^ self childrenWidgets at: self visibleStart + 1 ifAbsent: [ nil ]
]

{ #category : 'private' }
GtkMillerAdapter >> hideHorizontalScrollBar [

	self widgetDo: [ :w | w hScrollBar beNotVisible ]
]

{ #category : 'accessing' }
GtkMillerAdapter >> horizontalAdjustment [

	^ horizontalAdjustment ifNil: [ 
		widget 
			ifNotNil: [ horizontalAdjustment := widget hAdjustment ]
			ifNil: [ nil ]  ]
]

{ #category : 'private' }
GtkMillerAdapter >> initialVisibleCount [

	layout ifNil: [ ^ 1 ].
	^ layout visiblePages max: 1
]

{ #category : 'initialization' }
GtkMillerAdapter >> initialize [

	super initialize.
	realised := false.
	keepShowingPage := false.
	visibleStart := 0.
	visibleCount := 1.
	columnWidth := self defaultColumnWidth.
	isUpdatingScroll := false
]

{ #category : 'private accessing' }
GtkMillerAdapter >> innerWidget [

	^ innerWidget
]

{ #category : 'private' }
GtkMillerAdapter >> maximumStart [

	^ self childrenWidgets size - self visibleCount max: 0
]

{ #category : 'factory' }
GtkMillerAdapter >> newHorizontal [

	^ GtkBox newHorizontal
]

{ #category : 'factory' }
GtkMillerAdapter >> newVertical [

	^ GtkBox newVertical
]

{ #category : 'private' }
GtkMillerAdapter >> preferredVisibleCount [
	| childCount layoutCount |
	
	layoutCount := self initialVisibleCount.
	childCount := self childrenWidgets size.
	
	childCount = 0 ifTrue: [ ^ layoutCount ].
	^ (layoutCount min: childCount) max: 1
]

{ #category : 'private' }
GtkMillerAdapter >> recalculateColumnWidthFromViewport [

	| width |
	self widget ifNil: [ ^ self ].
	width := self widget width.
	width <= 0 ifTrue: [ ^ self ].
	columnWidth := self columnWidthForViewportWidth: width
]

{ #category : 'private' }
GtkMillerAdapter >> recalculatePageHeights [

	self recalculatePages
]

{ #category : 'private' }
GtkMillerAdapter >> recalculatePageWidths [

	self recalculatePages
]

{ #category : 'private' }
GtkMillerAdapter >> recalculatePages [

	self widget ifNil: [ ^ self ].
	self updateViewportGeometryWhenAllocatedDo: [ ]
]

{ #category : 'api' }
GtkMillerAdapter >> remove: aPresenter [
	| childWidget |
	
	aPresenter adapter ifNil: [ ^ self ].
	
	childWidget := aPresenter adapter widget.
	self innerWidgetDo: [ :gtkWidget |
		(gtkWidget children includes: childWidget) ifTrue: [
			self ensureRetained: childWidget.
			gtkWidget remove: childWidget.
			self clampVisibleStart.
			self snapToVisibleStart ] ]
]

{ #category : 'accessing children' }
GtkMillerAdapter >> removeAll [

	self innerWidgetDo: [ :gtkWidget |
		self ensureAllColumnWidgetsAreRetained.
		gtkWidget removeAll.
		visibleStart := 0.
		self snapToVisibleStart ]
]

{ #category : 'paginator' }
GtkMillerAdapter >> scrollByDeltaPercent: percent [
	| deltaPixels newStart |
	
	self widget ifNil: [ ^ self ].
	
	deltaPixels := self widget width * (percent / 100).
	newStart := (self visibleStart * self columnStep + deltaPixels / self columnStep) rounded.
	visibleStart := newStart.
	self clampVisibleStart.
	self snapToVisibleStart
]

{ #category : 'private' }
GtkMillerAdapter >> scrollToShow: aWidget [
	| index |
	
	index := self childrenWidgets indexOf: aWidget.
	index = 0 ifTrue: [ ^ self ].
	self selectPage: index
]

{ #category : 'private' }
GtkMillerAdapter >> scrollToShowLastPage [

	self childrenWidgets ifEmpty: [ ^ self ].
	visibleStart := self maximumStart.
	self snapToVisibleStart
]

{ #category : 'api' }
GtkMillerAdapter >> selectPage: aNumber [

	visibleStart := (aNumber max: 1) - 1.
	self clampVisibleStart.
	keepShowingPage ifTrue: [ firstShowingWidget := self firstVisibleWidget ].
	self snapToVisibleStart
]

{ #category : 'private' }
GtkMillerAdapter >> snapToVisibleStart [
	| adjustment targetX |
	
	adjustment := self horizontalAdjustment.
	adjustment ifNil: [ ^ self ].
	
	targetX := self visibleStart * self columnStep.
	isUpdatingScroll := true.
	[ adjustment value: targetX asFloat ] 
	ensure: [ 
		isUpdatingScroll := false ]
]

{ #category : 'private' }
GtkMillerAdapter >> toggleVisible: isVisible [

	isVisible 
		ifTrue: [ widget beVisible ] 
		ifFalse: [ widget beNotVisible ]
]

{ #category : 'private' }
GtkMillerAdapter >> updateViewportGeometry [

	self updateVisibleCount.
	self recalculateColumnWidthFromViewport.
	self configureColumnWidgets.
	self clampVisibleStart.
	self snapToVisibleStart
]

{ #category : 'private' }
GtkMillerAdapter >> updateViewportGeometryWhenAllocatedDo: aBlock [

	| gtkWidget |
	gtkWidget := self widget ifNil: [ ^ self ].
	self updateVisibleCount.
	self clampVisibleStart.
	gtkWidget width > 0 ifTrue: [
			self updateViewportGeometry.
			^ aBlock value ].
	gtkWidget addOneShotTickCallback: [
			gtkWidget width > 0 ifTrue: [
					self updateViewportGeometry.
					aBlock value ] ]
]

{ #category : 'private' }
GtkMillerAdapter >> updateVisibleCount [

	visibleCount := self preferredVisibleCount
]

{ #category : 'private' }
GtkMillerAdapter >> viewportWidthChanged [

	self updateViewportGeometryWhenAllocatedDo: [ ]
]

{ #category : 'accessing' }
GtkMillerAdapter >> visibleCount [

	^ visibleCount ifNil: [ visibleCount := self initialVisibleCount ]
]

{ #category : 'private' }
GtkMillerAdapter >> visiblePagesChanged [

	self updateViewportGeometryWhenAllocatedDo: [ ]
]

{ #category : 'accessing' }
GtkMillerAdapter >> visibleStart [

	^ visibleStart ifNil: [ visibleStart := 0 ]
]

{ #category : 'private' }
GtkMillerAdapter >> widgetResized [

	self viewportWidthChanged.
	(keepShowingPage and: [ firstShowingWidget notNil ]) 
		ifTrue: [ self scrollToShow: firstShowingWidget ]
]
