Class {
	#name : #GtkAdapterTestCase,
	#superclass : #SpBaseTest,
	#instVars : [
		'app'
	],
	#category : #'Spec-GtkBackendTests'
}

{ #category : #testing }
GtkAdapterTestCase class >> isAbstract [

	^ super isAbstract or: [ self = GtkAdapterTestCase ]
]

{ #category : #running }
GtkAdapterTestCase >> adapter [ 

	^ presenter adapter
]

{ #category : #running }
GtkAdapterTestCase >> initializeTestedInstance [
	super initializeTestedInstance.

	presenter application: app.
]

{ #category : #running }
GtkAdapterTestCase >> runCaseManaged [
	
	GtkApplication ensureRunning. 
	app := SpApplication new.
	app useBackend: #Gtk.
	
	[ super runCaseManaged  ] ensure: [ app:= nil ].
]
