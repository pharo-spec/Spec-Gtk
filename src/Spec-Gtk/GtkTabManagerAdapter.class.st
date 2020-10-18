Class {
	#name : #GtkTabManagerAdapter,
	#superclass : #GtkAdapter,
	#category : #'Spec-Gtk-Adapter'
}

{ #category : #building }
GtkTabManagerAdapter >> addModelTo: gtkWidget [

	self model tabs do: [ :each |
		gtkWidget 
			append: each retrievingBlock value 
			label: (self buildLabelForTab: each) ]
]

{ #category : #building }
GtkTabManagerAdapter >> buildLabelForTab: aTabPresenter [
	| label |

	label := GtkLabel newLabel: aTabPresenter label asString.
	self flag: #TODO. "I'm not sure a notebook takes anything"
	"aTabPresenter icon ifNotNil: [ :icon |
		label := GtkBox newHorizontal
			packStart: (GtkImage newForm: icon);
			packEnd: label;
			yourself ]."

	^ label
]

{ #category : #building }
GtkTabManagerAdapter >> widgetClass [

	^ GtkNotebook
]
