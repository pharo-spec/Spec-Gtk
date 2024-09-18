Class {
	#name : 'GtkAbstractTextAdapter',
	#superclass : 'GtkAdapter',
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkAbstractTextAdapter >> addEditionContextMenuTo: menuPresenter [
	

	self presenter hasEditionContextMenu ifFalse: [ ^ self ].
	
	self presenter editionContextMenu menuGroups 
		do: [ :each | menuPresenter addMenuGroup: each ]
]

{ #category : 'building' }
GtkAbstractTextAdapter >> addModelTo: gtkWidget [

	super addModelTo: gtkWidget.
	self addTextTo: gtkWidget. 
	self presenter whenTextChangedDo: [ :text |
		self updateTextFromPresenter: text ]
]

{ #category : 'building' }
GtkAbstractTextAdapter >> addTextTo: gtkWidget [
	
	self model text ifNotNil: [ :text | 
		self setText: text to: gtkWidget ].

]

{ #category : 'building' }
GtkAbstractTextAdapter >> buildMenu: menuPresenterOrBlock [

	^ super buildMenu: menuPresenterOrBlock value
]

{ #category : 'undo-redo' }
GtkAbstractTextAdapter >> clearUndoManager [
	"do nothing, it does not has sense in gtk"
]

{ #category : 'spec protocol' }
GtkAbstractTextAdapter >> cursorPositionIndex [

	^ self innerWidgetDo: [ :w | w textBuffer cursorPosition ]
]

{ #category : 'testing' }
GtkAbstractTextAdapter >> hasActions [

	"it has at least one (the extra)"
	^ true
]

{ #category : 'spec protocol' }
GtkAbstractTextAdapter >> insert: aString at: positionIndex [

	self innerWidgetDo: [ :w |
		w textBuffer 
			insertText: aString 
			at: positionIndex ]
]

{ #category : 'building' }
GtkAbstractTextAdapter >> newActionManager [

	^ GtkAdapterActionTextManager on: self
]

{ #category : 'selection' }
GtkAbstractTextAdapter >> selectAll [
	
	self innerWidgetDo: [ :w | w textBuffer selectAll ]
]

{ #category : 'selection' }
GtkAbstractTextAdapter >> selectLine [

	self innerWidgetDo: [ :w | w textBuffer selectLineAtCursor ].
]

{ #category : 'selection' }
GtkAbstractTextAdapter >> selection [ 
	| selection |

	self innerWidgetDo: [ :w | 
		selection := w textBuffer selection. 
		selection ifNotNil: [ 
			selection := selection first + 1 to: selection last ] ].
	
	^ selection ifNil: [ 1 to: 0 ]
]

{ #category : 'emulating' }
GtkAbstractTextAdapter >> sendRightClickEvent [
	
	self innerWidget 
		withCallbacksOfType: GPopulatePopupCallback 
		do: [ :aCallback |
			aCallback valueWithArguments: {
				self innerWidget getHandle.
				GtkMenu new getHandle.
				ExternalAddress null } ]
]

{ #category : 'selection' }
GtkAbstractTextAdapter >> setSelectionFromModel: aSelection [
 
	self innerWidgetDo: [ :w | 
		w textBuffer 
			selectFrom: (aSelection first - 1)
			to: aSelection last ]
]

{ #category : 'accessing' }
GtkAbstractTextAdapter >> setText: aString to: gtkWidget [

	gtkWidget text: aString asString
]

{ #category : 'accessing' }
GtkAbstractTextAdapter >> text: aString [ 
	
	self setText: aString to: widget
]

{ #category : 'private - updating' }
GtkAbstractTextAdapter >> updateTextFromPresenter: aString [
	
	self backendDetectCyclesDo: [  
		self innerWidgetDo: [ :w | 
			self setText: aString to: w ] ]
]
