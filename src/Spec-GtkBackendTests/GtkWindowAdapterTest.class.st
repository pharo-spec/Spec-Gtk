Class {
	#name : 'GtkWindowAdapterTest',
	#superclass : 'TestCase',
	#instVars : [
		'app'
	],
	#category : 'Spec-GtkBackendTests',
	#package : 'Spec-GtkBackendTests'
}

{ #category : 'tests' }
GtkWindowAdapterTest >> testWindowIsCorrectlyDestroyedWhenClose [
	| presenter app oldWindowSize oldDisposeSize engine |

	engine := GEngine ensureRunning.
	oldWindowSize := engine windowRegistry size.
	oldDisposeSize := engine disposeRegistry size.
	
	app := SpApplication new useBackend: #Gtk.
	presenter := SpLabelPresenter newApplication: app.
	presenter open.
	25 milliSeconds wait.
	presenter adapter widget autoReleaseWhenDisposedByGtk.

	self denyEmpty: app windows.
	self assert: engine windowRegistry size equals: oldWindowSize + 1.
	self assert: engine disposeRegistry size equals: oldDisposeSize + 1.

	presenter window close.
	presenter := nil.
	
	3 timesRepeat: [ Smalltalk garbageCollect ].
	
	self assertEmpty: app windows.
	self assert: engine windowRegistry size equals: oldWindowSize.
	self assert: engine disposeRegistry size equals: oldDisposeSize
	
]

{ #category : 'tests' }
GtkWindowAdapterTest >> testWindowWithListViewIsCorrectlyDestroyedWhenClose [
	| presenter app oldWindowSize oldDisposeSize engine |

	engine := GEngine ensureRunning.
	oldWindowSize := engine windowRegistry size.
	oldDisposeSize := engine disposeRegistry size.
	
	app := SpApplication new useBackend: #Gtk.
	presenter := SpListViewPresenter newApplication: app.
	presenter items: Smalltalk allClassesAndTraits.
	presenter open.
	25 milliSeconds wait.

	self denyEmpty: app windows.
	self assert: engine windowRegistry size equals: oldWindowSize + 1.
	"list view is registering a factory to release when destroyed"
	self assert: engine disposeRegistry size equals: oldDisposeSize + 1.

	presenter window close.
	presenter := nil.
	
	3 timesRepeat: [ Smalltalk garbageCollect ].
	
	self assertEmpty: app windows.
	self assert: engine windowRegistry size equals: oldWindowSize.
	self assert: engine disposeRegistry size equals: oldDisposeSize
	
]
