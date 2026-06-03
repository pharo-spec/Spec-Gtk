Class {
	#name : 'GtkActionWithReferenceMenuBuilder',
	#superclass : 'GtkActionMenuBuilder',
	#category : 'Spec-Gtk-Actions',
	#package : 'Spec-Gtk',
	#tag : 'Actions'
}

{ #category : 'private' }
GtkActionWithReferenceMenuBuilder >> appendCommand: aCommand [
	| item actionName widgetReference |
	
	actionName := self actionNameFor: aCommand.
	
	logger trace: widget.
	
	widgetReference := GVariant newUint64: (widget ifNotNil: [ widget getHandle asInteger] ifNil: [ 0 ]).
	item := GMenuItem new
		label: aCommand dynamicName; 
		action: actionName withTargetValue: widgetReference;
		yourself.
		
		menu appendItem: item
]
