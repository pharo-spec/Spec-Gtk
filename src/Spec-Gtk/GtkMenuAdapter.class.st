Class {
	#name : #GtkMenuAdapter,
	#superclass : #GtkMenuBaseAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkMenuAdapter >> addModelTo: gtkWidget [

	self model menuGroups 
		do: [ :eachGroup | 
			eachGroup menuItems
				do: [ :each | gtkWidget add: each buildWithSpec ] ]
		separatedBy: [ 
			gtkWidget add: (GtkSeparatorMenuItem new
				show;
				yourself) ]	
]

{ #category : #accessing }
GtkMenuAdapter >> widgetClass [

	^ GtkMenu
]
