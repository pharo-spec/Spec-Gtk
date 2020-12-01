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
GtkMenuAdapter >> openAt: aPosition [

	self presenter application registerWindow: self presenter.
	"I need to execute this outside this current render cycle, because otherwise the 
	 gtk render loop assumes the action is over and it disposes the menu, that's the 
	 reason of the schedule"
	[  
		150 milliseconds wait.  
		self widgetDo: [ :w |
			w connectHide: [ self presenter application unregisterWindow: self presenter ].
			w showAll.
			w popupAtPointer: (GdkEventButton newButtonRelease
				window: self presenter window adapter widget gdkWindow; 
				device: GdkDisplay default defaultSeat pointer;
				time: Time millisecondClockValue;
				x: aPosition x asFloat;
				y: aPosition y asFloat;
				yourself) ] 
	] schedule
]

{ #category : #accessing }
GtkMenuAdapter >> openAtPointer [

	self openAt: GdkDisplay default defaultSeat pointer position
]

{ #category : #accessing }
GtkMenuAdapter >> widgetClass [

	^ GtkMenu
]
