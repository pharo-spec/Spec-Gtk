Class {
	#name : 'GtkSearchInputFieldAdapter',
	#superclass : 'GtkAbstractTextAdapter',
	#pools : [
		'GdkKeyCodes'
	],
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkSearchInputFieldAdapter >> addModelTo: gtkEntry [
	
	super addModelTo: gtkEntry.

	gtkEntry connectSearchChanged: [ 
		self updatePresenterText: gtkEntry text ].
	
	"self presenter placeholder ifNotNil: [ :text | 
		gtkEntry placeHolderText: (text localizedForPresenter: self presenter) asString ].
	self presenter whenPlaceholderChangedDo: [ :text | 
		gtkEntry placeHolderText: (text localizedForPresenter: self presenter) asString ]."
		
	"gtkEntry maxLength: self model maxLength.
	self model whenMaxLengthChangedDo: [ gtkEntry maxLength: self presenter maxLength ]."
	
	gtkEntry editable: self presenter isEditable.
	self presenter whenEditableChangedDo: [ :value | 
		self setEditable: value ]
]

{ #category : 'accessing' }
GtkSearchInputFieldAdapter >> cursorPositionIndex: index [
	
	^ self innerWidgetDo: [ :w | w position: index ]
]

{ #category : 'private' }
GtkSearchInputFieldAdapter >> getPlaceholderText [

	^ self presenter placeholder ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : 'accessing' }
GtkSearchInputFieldAdapter >> placeHolderText [
	
	^ widget placeHolderText 
]

{ #category : 'selection' }
GtkSearchInputFieldAdapter >> selectAll [
	
	self innerWidgetDo: [ :w | w selectAll ]
]

{ #category : 'private' }
GtkSearchInputFieldAdapter >> setEditable: aBoolean [ 

	self innerWidgetDo: [ :w | w editable: aBoolean ]
]

{ #category : 'selection' }
GtkSearchInputFieldAdapter >> setSelectionFromModel: aSelection [
 
	self innerWidgetDo: [ :w | 
		w selectFrom: (aSelection first - 1) to: aSelection last ]
]

{ #category : 'accessing' }
GtkSearchInputFieldAdapter >> takeKeyboardFocusWithoutSelecting [

	self innerWidgetDo: [ :w | w grabFocusWithoutSelecting ]
]

{ #category : 'visiting' }
GtkSearchInputFieldAdapter >> text: aString [ 
	
	super text: aString.
	"Changing the text programatically does not throw an event"
	self model text: aString.
]

{ #category : 'private - updating' }
GtkSearchInputFieldAdapter >> updatePresenterText: aString [

	self runInSystem: [
		self backendUpdatingDo: [  
			self presenter text: aString ] ]
]

{ #category : 'private' }
GtkSearchInputFieldAdapter >> widgetClass [

	^ GtkSearchEntry
]

{ #category : 'building' }
GtkSearchInputFieldAdapter >> wrapWidget: gtkWidget [

	^ gtkWidget
]
