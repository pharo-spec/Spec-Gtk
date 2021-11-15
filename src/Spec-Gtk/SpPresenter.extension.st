Extension { #name : #SpPresenter }

{ #category : #'*Spec-Gtk' }
SpPresenter >> isActivatable [
	"When being included as part of a *class:SpComponentListPresenter*, presenters can define 
	 whether they are activatable or not (default: ==true==)."

	^ true
]

{ #category : #'*Spec-Gtk' }
SpPresenter >> isSelectable [
	"When being included as part of a *class:SpComponentListPresenter*, presenters can define 
	 whether they are selectable or not (default: ==true==)."

	^ true
]
