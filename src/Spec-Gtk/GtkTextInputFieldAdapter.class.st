Class {
	#name : 'GtkTextInputFieldAdapter',
	#superclass : 'GtkAbstractTextAdapter',
	#pools : [
		'GdkKeyCodes'
	],
	#category : 'Spec-Gtk-Adapter',
	#package : 'Spec-Gtk',
	#tag : 'Adapter'
}

{ #category : 'building' }
GtkTextInputFieldAdapter >> addModelTo: gtkEntry [
	
	super addModelTo: gtkEntry.

	gtkEntry connectChanged: [ 
		self updatePresenterText: gtkEntry text ].
	
	self presenter placeholder ifNotNil: [ :text | 
		gtkEntry placeHolderText: (text localizedForPresenter: self presenter) asString ].
	self presenter whenPlaceholderChangedDo: [ :text | 
		gtkEntry placeHolderText: (text localizedForPresenter: self presenter) asString ].
		
	gtkEntry maxLength: self model maxLength.
	self model whenMaxLengthChangedDo: [ gtkEntry maxLength: self presenter maxLength ].
	
	gtkEntry editable: self presenter isEditable.
	self presenter whenEditableChangedDo: [ :value | 
		self setEditable: value ].
	
	self presenter isPassword ifTrue: [ 
		gtkEntry bePassword.
		gtkEntry visibility: false. ].
	
	self presenter whenPasswordChangedDo: [ :isPassword | 
		isPassword
			ifFalse: [ gtkEntry beForAnyCharacter ]
			ifTrue: [ gtkEntry bePassword ].
		gtkEntry visibility: isPassword not ]
]

{ #category : 'accessing' }
GtkTextInputFieldAdapter >> cursorPositionIndex: index [
	
	^ self innerWidgetDo: [ :w | w position: index ]
]

{ #category : 'private' }
GtkTextInputFieldAdapter >> getPlaceholderText [

	^ self presenter placeholder ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : 'testing' }
GtkTextInputFieldAdapter >> isPassword [
	
	^ widget isPassword 
]

{ #category : 'accessing' }
GtkTextInputFieldAdapter >> placeHolderText [
	
	^ widget placeHolderText 
]

{ #category : 'selection' }
GtkTextInputFieldAdapter >> selectAll [
	
	self innerWidgetDo: [ :w | w selectAll ]
]

{ #category : 'private' }
GtkTextInputFieldAdapter >> setEditable: aBoolean [ 

	self innerWidgetDo: [ :w | w editable: aBoolean ]
]

{ #category : 'selection' }
GtkTextInputFieldAdapter >> setSelectionFromModel: aSelection [
 
	self innerWidgetDo: [ :w | 
		w selectFrom: (aSelection first - 1) to: aSelection last ]
]

{ #category : 'accessing' }
GtkTextInputFieldAdapter >> takeKeyboardFocusWithoutSelecting [

	self innerWidgetDo: [ :w | w grabFocusWithoutSelecting ]
]

{ #category : 'visiting' }
GtkTextInputFieldAdapter >> text: aString [ 
	
	super text: aString.
	"Changing the text programatically does not throw an event"
	self model text: aString.
]

{ #category : 'private - updating' }
GtkTextInputFieldAdapter >> updatePresenterText: aString [

	self backendUpdatingDo: [ 
		self presenter text: aString ] 
]

{ #category : 'private' }
GtkTextInputFieldAdapter >> widgetClass [

	^ GtkEntry
]

{ #category : 'building' }
GtkTextInputFieldAdapter >> wrapWidget: gtkWidget [

	^ gtkWidget
]
