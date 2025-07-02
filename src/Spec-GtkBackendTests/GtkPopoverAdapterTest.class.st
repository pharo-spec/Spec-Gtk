Class {
	#name : 'GtkPopoverAdapterTest',
	#superclass : 'TestCase',
	#instVars : [
		'app'
	],
	#category : 'Spec-GtkBackendTests',
	#package : 'Spec-GtkBackendTests'
}

{ #category : 'tests' }
GtkPopoverAdapterTest >> testPopoverIsCorrectlyDestroyedWhenClose [
	| presenter app oldWindowSize oldDisposeSize engine popover |

	engine := GEngine ensureRunning.
	
	app := SpApplication new useBackend: #Gtk.
	presenter := SpLabelPresenter newApplication: app.
	presenter open.
	25 milliSeconds wait.

	oldWindowSize := engine windowRegistry size.
	oldDisposeSize := engine disposeRegistry size.
	
	popover := presenter newLabel asPopover.
	popover popup.
	popover presenter adapter widget autoReleaseWhenDisposedByGtk.
	25 milliSeconds wait.
	
	self assert: app windows size equals: 2.
	self assert: engine windowRegistry size equals: oldWindowSize + 1.
	self assert: engine disposeRegistry size equals: oldDisposeSize + 1.

	popover dismiss.
	popover := nil.
	3 timesRepeat: [ Smalltalk garbageCollect ].
	20 milliSeconds wait.

	self assert: app windows size equals: 1.
	self assert: engine windowRegistry size equals: oldWindowSize.
	self assert: engine disposeRegistry size equals: oldDisposeSize.	

	presenter window close.
	presenter := nil
]

{ #category : 'tests' }
GtkPopoverAdapterTest >> testPopoverWithListViewIsCorrectlyDestroyedWhenClose [
]
