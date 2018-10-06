Class {
	#name : #GtkApplication,
	#superclass : #Object,
	#traits : 'TGtkLibrary',
	#classTraits : 'TGtkLibrary classTrait',
	#instVars : [
		'runLoop'
	],
	#classVars : [
		'Current'
	],
	#pools : [
		'GtkTypes'
	],
	#category : 'Mars-Gtk-Base'
}

{ #category : #accessing }
GtkApplication class >> current [
	^ Current
]

{ #category : #'class initialization' }
GtkApplication class >> initialize [
	SessionManager default registerSystemClassNamed: self name
]

{ #category : #'system startup' }
GtkApplication class >> shutDown: quitting [
	"ensure Gtk is stop when shutting down"
	quitting ifFalse: [ ^ self ].
	Current ifNil: [ ^ self ].
	Current stop.
]

{ #category : #private }
GtkApplication >> initArgC: argc argV: argv [
	^ self ffiCall: #( void gtk_init ( ulong argc, ulong argv ) )
]

{ #category : #private }
GtkApplication >> initGtk3 [
	"Initialize Gtk3"
	self flag: #todo. "This is a temporal hack to ensure library is found (I need to review the VM)."
	"DynamicLoader loadLibrary: GtkLibrary uniqueInstance moduleName.  "
	self initArgC: 0 argV: 0
]

{ #category : #initialization }
GtkApplication >> initialize [
	super initialize.
	runLoop := GtkRunLoop current
]

{ #category : #testing }
GtkApplication >> isRunning [ 
	^ runLoop isRunning
]

{ #category : #running }
GtkApplication >> run [
	Current ifNotNil: [ Current stop ].
	Current := nil.
	self start.
	Current := self.
	
]

{ #category : #'private running' }
GtkApplication >> start [ 
	self isRunning ifTrue: [ self stop ].
	self initGtk3.
	runLoop start
]

{ #category : #'private running' }
GtkApplication >> stop [
	self isRunning ifFalse: [ ^ self ].
	runLoop stop
]

{ #category : #'as yet unclassified' }
GtkApplication >> suspendRunLoopWhile: aBlock [
	self stop.
	^ aBlock ensure: [ self start ]
]