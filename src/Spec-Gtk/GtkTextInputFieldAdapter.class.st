Class {
	#name : #GtkTextInputFieldAdapter,
	#superclass : #GtkAbstractTextAdapter,
	#pools : [
		'GdkKeyCodes'
	],
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkTextInputFieldAdapter >> addModelTo: gtkEntry [
	
	super addModelTo: gtkEntry.

	"sync presenter text and gtk"
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

{ #category : #'spec protocol' }
GtkTextInputFieldAdapter >> cursorPositionIndex: index [
	
	^ self innerWidgetDo: [ :w | w position: index ]
]

{ #category : #private }
GtkTextInputFieldAdapter >> getPlaceholderText [

	^ self presenter placeholder ifNotNil: [ :aString | aString localizedForPresenter: self presenter ]
]

{ #category : #'private - actions' }
GtkTextInputFieldAdapter >> installContextMenuOn: gtkEntry [
	
	(actionMap keys noneSatisfy: [ :each | each isVisible ]) ifTrue: [ ^ self ].
	gtkEntry extraMenu: (GtkActionMenuBuilder new visit: self presenter actionGroup)
]

{ #category : #'private - actions' }
GtkTextInputFieldAdapter >> installShortcutsOn: gtkEntry [
	| enter |
	
	super installShortcutsOn: gtkEntry.
	"GtkEntry implements the activation signal, which means if we have a CR shortcut 
	 defined (Pharo can do this time to time), it will not work, because it will send 
	 the signal instead. To fix this (since spec does not implement activation signal 
	 for input fields), I detect if I have defined it and if that's the case, I install 
	 the shortcut as a signal"
	enter := KeyboardKey enter asKeyCombination.
	actionMap keysDo: [ :each | 
		(each hasShortcutKey and: [ each shortcutKey  = enter ])
			ifTrue: [ 
				gtkEntry connectActivate: [ each execute ] ] ]
]

{ #category : #testing }
GtkTextInputFieldAdapter >> isPassword [
	
	^ widget isPassword 
]

{ #category : #accessing }
GtkTextInputFieldAdapter >> placeHolderText [
	
	^ widget placeHolderText 
]

{ #category : #selection }
GtkTextInputFieldAdapter >> selectAll [
	
	self innerWidgetDo: [ :w | w selectAll ]
]

{ #category : #private }
GtkTextInputFieldAdapter >> setEditable: aBoolean [ 

	self innerWidgetDo: [ :w | w editable: aBoolean ]
]

{ #category : #selection }
GtkTextInputFieldAdapter >> setSelectionFromModel: aSelection [
 
	self innerWidgetDo: [ :w | 
		w selectFrom: (aSelection first - 1) to: aSelection last ]
]

{ #category : #'spec protocol' }
GtkTextInputFieldAdapter >> takeKeyboardFocusWithoutSelecting [

	self innerWidgetDo: [ :w | w grabFocus ]
]

{ #category : #visiting }
GtkTextInputFieldAdapter >> text: aString [ 
	
	super text: aString.
	"Changing the text programatically does not throw an event"
	self model text: aString.
]

{ #category : #'private - updating' }
GtkTextInputFieldAdapter >> updatePresenterText: aString [

	self backendUpdatingDo: [ 
		self presenter text: aString ] 
]

{ #category : #private }
GtkTextInputFieldAdapter >> widgetClass [

	^ GtkEntry
]

{ #category : #building }
GtkTextInputFieldAdapter >> wrapWidget: gtkWidget [

	^ gtkWidget
]
