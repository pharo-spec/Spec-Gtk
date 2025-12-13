"
A window adapter helper is here because windows in gtk can be of different classes. 
Most typical case is GtkWindow (simple gtk) and AdwWindow (adwaita).

In presence of adwaita package, we want to use it because it better integrated with the gnome system.
"
Class {
	#name : 'GtkWindowAdapterHelper',
	#superclass : 'Object',
	#traits : 'GtkTAdapterHelper',
	#classTraits : 'GtkTAdapterHelper classTrait',
	#category : 'Spec-Gtk-Adapter-Window',
	#package : 'Spec-Gtk',
	#tag : 'Adapter-Window'
}

{ #category : 'accessing' }
GtkWindowAdapterHelper >> add: aWidget toWindow: aWindow [

	aWindow child: aWidget
]

{ #category : 'accessing' }
GtkWindowAdapterHelper >> destroy: gtkWindow [

	gtkWindow isNullOrNil 
		ifFalse: [ gtkWindow destroy ]
]

{ #category : 'accessing' }
GtkWindowAdapterHelper >> setDecorated: aBoolean to: gtkWindow [

	gtkWindow decorated: aBoolean
]

{ #category : 'accessing' }
GtkWindowAdapterHelper >> widgetClass [

	^ GtkWindow
]
