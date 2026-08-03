Class {
	#name : 'OllamaGenerateParams',
	#superclass : 'Object',
	#instVars : [
		'model',
		'system',
		'ollamaOptions',
		'stream'
	],
	#category : 'OllamaSt-Core',
	#package : 'OllamaSt-Core'
}

{ #category : 'instance creation' }
OllamaGenerateParams class >> in: aBlock [
	| inst |
	inst := self new.
	aBlock value: inst.
	^ inst
]

{ #category : 'converting' }
OllamaGenerateParams >> asDictionary [
	| dict |
	dict := Dictionary new.
	dict at: 'model' put: (self model ifNil: [ '' ]).
	dict at: 'stream' put: self isStreaming.
	self system ifNotNil: [ :s | dict at: 'system' put: s ].
	self ollamaOptions ifNotNil: [ :opts |
		opts asDictionary ifNotEmpty: [ :optsDict | dict at: 'options' put: optsDict ] ].
	^ dict
]

{ #category : 'accessing' }
OllamaGenerateParams >> model [
	^ model
]

{ #category : 'accessing' }
OllamaGenerateParams >> model: aString [
	model := aString
]

{ #category : 'accessing-private' }
OllamaGenerateParams >> ollamaOptions [
	^ ollamaOptions
]

{ #category : 'accessing' }
OllamaGenerateParams >> optionsBy: aBlock [
	ollamaOptions := OllamaOptions in: aBlock
]

{ #category : 'accessing' }
OllamaGenerateParams >> stream [
	^ stream
]

{ #category : 'accessing' }
OllamaGenerateParams >> stream: aBoolean [
	stream := aBoolean
]

{ #category : 'accessing' }
OllamaGenerateParams >> system [
	^ system
]

{ #category : 'accessing' }
OllamaGenerateParams >> system: aString [
	system := aString
]

{ #category : 'testing' }
OllamaGenerateParams >> isStreaming [
	^ self stream = true
]
