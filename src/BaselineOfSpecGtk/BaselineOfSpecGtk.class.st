Class {
	#name : #BaselineOfSpecGtk,
	#superclass : #BaselineOf,
	#category : #BaselineOfSpecGtk
}

{ #category : #baseline }
BaselineOfSpecGtk >> baseline: spec [
	<baseline>

	spec
		for: #common
		do: [ 
			self gtk: spec.
			self gtkCode: spec.
			self gtkMorphic: spec.
			self spec: spec.
			self specCode: spec.
			self specMorphic: spec.
			
			spec
				"spec"
				package: 'Spec-Gtk-Frame' with: [ spec requires: #('GtkCore' 'SpecCore' 'Spec-Gtk') ];
				package: 'Spec-Gtk-Keybindings' with: [ spec requires: #('GtkCore') ];
				package: 'Spec-Gtk' with: [ spec requires: #('GtkCore' 'Spec-Gtk-Keybindings') ];
				"spec-code"
				package: 'Spec-Gtk-Code' with: [ spec requires: #('SpecCode' 'GtkCode') ];
				package: 'Spec-Gtk-Pillar' with: [ spec requires: #('GtkCore') ];
				"morphic"
				package: 'Spec-Gtk-Morphic-Adapter' with: [ spec requires: #('GtkMorphic' 'Spec-Gtk') ];
				"testing"
				package: 'Spec-GtkBackendTests' with: [ spec requires: ('Spec-Gtk') ] ].
		
		spec group: 'Core' with: #('GtkCore' 'SpecCore' 'Spec-Gtk' 'Spec-Gtk-Frame' 'Spec-Gtk-Keybindings').
		spec group: 'Code' with: #('GtkCode' 'Spec-Gtk-Code').	
		spec group: 'Morphic' with: #('GtkMorphic' 'Spec-Gtk-Morphic-Adapter').
		spec group: 'Tests' with: #('Spec-GtkBackendTests').
		
		spec group: 'Base' with: #('Core' 'Code').
		
		spec group: 'default' with: #('Base' 'Tests' 'Morphic')
]

{ #category : #'external projects' }
BaselineOfSpecGtk >> gtk: spec [

	spec baseline: 'GtkCore' with: [ 
		spec 
			repository: 'github://pharo-spec/gtk-bindings';
			className: 'BaselineOfGtk';			
			loads: 'Core' ]
]

{ #category : #'external projects' }
BaselineOfSpecGtk >> gtkCode: spec [

	spec baseline: 'GtkCode' with: [ 
		spec 
			repository: 'github://pharo-spec/gtk-bindings';
			className: 'BaselineOfGtk';
			loads: 'Code' ]
]

{ #category : #'external projects' }
BaselineOfSpecGtk >> gtkMorphic: spec [

	spec baseline: 'GtkMorphic' with: [ 
		spec 
			repository: 'github://pharo-spec/gtk-bindings';
			className: 'BaselineOfGtk';
			loads: 'Morphic' ]
]

{ #category : #'external projects' }
BaselineOfSpecGtk >> spec: spec [

	spec baseline: 'SpecCore' with: [ 
		spec 
			repository: 'github://pharo-spec/Spec:Pharo10';
			loads: 'Core' ]
]

{ #category : #'external projects' }
BaselineOfSpecGtk >> specCode: spec [

	spec baseline: 'SpecCode' with: [ 
		spec 
			repository: 'github://pharo-spec/Spec:Pharo10';
			className: 'BaselineOfSpecCore';
			loads: 'Code' ]
]

{ #category : #'external projects' }
BaselineOfSpecGtk >> specMorphic: spec [

	spec baseline: 'SpecMorphic' with: [ 
		spec 
			repository: 'github://pharo-spec/Spec:Pharo10';
			className: 'BaselineOfSpec2' ]
]
