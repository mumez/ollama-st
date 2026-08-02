Class {
	#name : 'OllamaEmbedParams',
	#superclass : 'Object',
	#instVars : [
		'model',
		'dimensions',
		'ollamaOptions'
	],
	#category : 'OllamaSt-Core',
	#package : 'OllamaSt-Core'
}

{ #category : 'instance creation' }
OllamaEmbedParams class >> in: aBlock [
	| inst |
	inst := self new.
	aBlock value: inst.
	^ inst
]

{ #category : 'converting' }
OllamaEmbedParams >> asDictionary [
	| dict |
	dict := Dictionary new.
	dict at: 'model' put: (self model ifNil: [ '' ]).
	self dimensions ifNotNil: [ :d | dict at: 'dimensions' put: d ].
	self ollamaOptions ifNotNil: [ :opts |
		opts asDictionary ifNotEmpty: [ :optsDict | dict at: 'options' put: optsDict ] ].
	^ dict
]

{ #category : 'accessing' }
OllamaEmbedParams >> dimensions [
	^ dimensions
]

{ #category : 'accessing' }
OllamaEmbedParams >> dimensions: anInteger [
	dimensions := anInteger
]

{ #category : 'accessing' }
OllamaEmbedParams >> model [
	^ model
]

{ #category : 'accessing' }
OllamaEmbedParams >> model: aString [
	model := aString
]

{ #category : 'accessing-private' }
OllamaEmbedParams >> ollamaOptions [
	^ ollamaOptions
]

{ #category : 'accessing' }
OllamaEmbedParams >> optionsBy: aBlock [
	ollamaOptions := OllamaOptions in: aBlock
]
