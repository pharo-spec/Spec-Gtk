Class {
	#name : #GtkLayoutAdapter,
	#superclass : #GtkAdapter,
	#instVars : [
		'layout',
		'changeLayoutSubscription',
		'subscribedLayout'
	],
	#category : #'Spec-Gtk-Layout-Base'
}

{ #category : #testing }
GtkLayoutAdapter class >> isAbstract [ 

	^ super isAbstract 
		or: [ self = GtkLayoutAdapter ]
]

{ #category : #building }
GtkLayoutAdapter >> adapterWasBuilt [
	"hook to add after-build opeations (for example, initial status, etc.)"
]

{ #category : #accessing }
GtkLayoutAdapter >> add: aPresenter constraints: constraints [

	aPresenter owner: self model. 
	self widgetDo: [ :gtkWidget | | childWidget |
		childWidget := self 
			basicAdd: aPresenter
			constraints: constraints 
			to: gtkWidget.
		self addWidgetAlignment: constraints to: childWidget.
		"I'm keeping a reference to aPresenter into the built widget because in some cases 
		 it can be GC (in case of the on-the-fly creation, for example). 
		 Now this can be a real bad idea :)"
		childWidget data: aPresenter ]
]

{ #category : #accessing }
GtkLayoutAdapter >> addWidgetAlignment: constraints to: gtkWidget [

 	"for the moment, just Box Layout implements alignment. 
	 keep this empty but ready for the future :)"
]

{ #category : #private }
GtkLayoutAdapter >> applyLayout: aLayout [

	self subclassResponsibility
]

{ #category : #private }
GtkLayoutAdapter >> applyStyle: aWidget [

	self presenter styles do: [ :each | 
		aWidget addClass: each ]
]

{ #category : #private }
GtkLayoutAdapter >> applyVisibility [ 
	
	self presenter isVisible 
		ifTrue: [ widget show ] 
		ifFalse: [ widget hide ]
]

{ #category : #private }
GtkLayoutAdapter >> applyVisibility: gtkWidget [

	self presenter isVisible
		ifTrue: [ gtkWidget show ]
		ifFalse: [ gtkWidget hide ].
	self presenter whenVisibleChangedDo: [ :aValuable | 
		self updateVisibility: aValuable value ]
]

{ #category : #private }
GtkLayoutAdapter >> basicAdd: aPresenter constraints: constraints to: aPanel [ 

	self subclassResponsibility
]

{ #category : #building }
GtkLayoutAdapter >> build [
	
	^ self widget
]

{ #category : #building }
GtkLayoutAdapter >> buildWidget [
	"We defer this until layout: (because then I will know what I have to create)"
	
	^ nil
]

{ #category : #building }
GtkLayoutAdapter >> buildWithLayout: aSpecLayout [
	"This provides some polymorphism with regular presenters to allow composition of layouts."
	
	^ self widget
]

{ #category : #building }
GtkLayoutAdapter >> buildWithSelector: aSelector [
 
	^ self build
]

{ #category : #building }
GtkLayoutAdapter >> buildWithSpec [
	"This provides some polymorphism with regular presenters to allow composition of layouts."

	self 
		deprecated: 'Please use #build instead' 
		transformWith:  '`@receiver buildWithSpec' 
						-> '`@receiver build'. 
		
	^ self build
]

{ #category : #building }
GtkLayoutAdapter >> buildWithSpec: aSpec [
	"This provides some polymorphism with regular presenters to allow composition of layouts."

	self
		deprecated: 'Please use #buildWithLayout: instead'
		transformWith: '`@receiver buildWithSpec: `@arg'
			-> '`@receiver buildWithLayout: `@arg'.

	^ self buildWithLayout: aSpec
]

{ #category : #private }
GtkLayoutAdapter >> cleanupAfterReplacing [ 
	
	widget children do: [ :aChild |
		aChild cleanupAfterReplacing ].
	widget := nil.
]

{ #category : #private }
GtkLayoutAdapter >> connectToEvents: aLayout [

	self presenter whenVisibleChangedDo: [ 	
		self applyVisibility ].
		
	aLayout whenChildrenAddedDo: [ :ann |
		self 
			add: ann child
			constraints: (aLayout constraintsFor: ann child) ].	
			
	aLayout whenChildrenRemovedDo: [ :ann |
		self remove: ann child ].
	
	subscribedLayout := aLayout.
]

{ #category : #private }
GtkLayoutAdapter >> deferredLayout: aLayout [

	layout := aLayout.
	self applyLayout: aLayout.
	self applyVisibility: widget.
	self applyStyle: widget.
	self addKeyBindingsTo: widget.
	self addEventsTo: widget
]

{ #category : #private }
GtkLayoutAdapter >> ensureAllChildrenAreRetained [
	
	self widget children do: [ :each |
		self ensureRetained: each ]
]

{ #category : #private }
GtkLayoutAdapter >> ensureRetained: aWidget [
	"When removing a widget from a container, GTK3 will decrement the reference count, 
	 maybe causing a GC of the widget removed. Since we don't know what will happen with this 
	 widget after removal (maybe is kept for later), we increment the reference count and 
	 we mark the object for autoRelease (ensuring it *will* be collected when no references 
	 in the image remains)"

	aWidget ensureObjectRefAndAutoRelease
]

{ #category : #testing }
GtkLayoutAdapter >> isSpLayout [

	^ true
]

{ #category : #accessing }
GtkLayoutAdapter >> layout [

	^ layout
]

{ #category : #protocol }
GtkLayoutAdapter >> layout: aLayout [

	GRunLoop defer: [
		self deferredLayout: aLayout ]
]

{ #category : #private }
GtkLayoutAdapter >> rebuild [ 
	| oldChildren |

	oldChildren := widget children.
	"keep old"
	oldChildren do: [ :each | each objectRef ].
	"hide"
	widget hide.
	"remove all"
	widget removeAll.
	"re-add all"
	layout children do: [ :each |
		each isSymbol 
			ifTrue: [ 
				self add: (self model perform: each) adapter constraints: (layout constraintsFor: each) ]
			ifFalse: [ 
				self add: each forGtkLayoutRebuild constraints: (layout constraintsFor: each) ]].
	"show"
	widget show.
	"now dispose"
	oldChildren do: [ :each | each objectUnref ].
]

{ #category : #removing }
GtkLayoutAdapter >> remove: aPresenter [
	| widgetToRemove |
	
	widgetToRemove := aPresenter adapter widget.
	self ensureRetained: widgetToRemove.
	^ self widgetDo: [ :w | 
		w remove: widgetToRemove ]
]

{ #category : #'accessing children' }
GtkLayoutAdapter >> removeAll [

	self widgetDo: [ :w | 
		self ensureAllChildrenAreRetained.
		w removeAll ]
]

{ #category : #protocol }
GtkLayoutAdapter >> removeSubWidgets [

	self widgetDo: [ :w |
		w removeAll ]
]

{ #category : #accessing }
GtkLayoutAdapter >> replaceLayoutWith: aLayout [

	GRunLoop defer: [ 
		| oldAdapter |
		oldAdapter := self presenter adapter.
		self presenter adapter: (aLayout
			buildAdapterFor: self presenter
			bindings: self presenter application adapterBindings).
		oldAdapter cleanupAfterReplacing.
		self presenter owner adapter rebuild ]
]

{ #category : #protocol }
GtkLayoutAdapter >> takeKeyboardFocus [
	| presenters |

	presenters := self presenter presentersInFocusOrder.
	presenters ifNil: [ ^ self ]. 
		
	presenters 
		detect: [ :each | each canTakeKeyboardFocus ]
		ifFound: [ :aPresenter | aPresenter takeKeyboardFocus ]
]

{ #category : #releasing }
GtkLayoutAdapter >> unsubscribe [ 
	
	self unsubscribed ifTrue: [ ^ self ].
	
	unsubscribed := true.
	
	subscribedLayout ifNotNil: [ 
		subscribedLayout unsubscribe ].
	
	(self presenter observablePropertyNamed: #visible) unsubscribe: self.
	
	"we must not nil the widget for layout adapters. That's why we do not call the superclass implementation"
	super unsubscribe.
]

{ #category : #releasing }
GtkLayoutAdapter >> unsubscribed [ 

	^ unsubscribed ifNil: [ unsubscribed := false ]
]

{ #category : #protocol }
GtkLayoutAdapter >> updateBorderWidth [

	self widgetDo: [ :w | w borderWidth: layout borderWidth ]
]
