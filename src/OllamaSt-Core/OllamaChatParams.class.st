Class {
	#name : 'OllamaChatParams',
	#superclass : 'Object',
	#instVars : [
		'model',
		'messages',
		'ollamaOptions',
		'stream'
	],
	#category : 'OllamaSt-Core',
	#package : 'OllamaSt-Core'
}

{ #category : 'instance creation' }
OllamaChatParams class >> in: aBlock [
	| inst |
	inst := self new.
	aBlock value: inst.
	^ inst
]

{ #category : 'accessing' }
OllamaChatParams >> addMessage: anOllamaMessage [
	self messages add: anOllamaMessage
]

{ #category : 'converting' }
OllamaChatParams >> asDictionary [
	| dict |
	dict := Dictionary new.
	dict at: 'model' put: (self model ifNil: [ '' ]).
	dict at: 'stream' put: self isStreaming.
	dict at: 'messages' put: (self messages collect: [ :m | m asDictionary ]).
	self ollamaOptions ifNotNil: [ :opts |
		opts asDictionary ifNotEmpty: [ :optsDict | dict at: 'options' put: optsDict ] ].
	^ dict
]

{ #category : 'accessing' }
OllamaChatParams >> messages [
	^ messages ifNil: [ messages := OrderedCollection new ]
]

{ #category : 'accessing' }
OllamaChatParams >> messages: aCollection [
	messages := aCollection asOrderedCollection
]

{ #category : 'accessing' }
OllamaChatParams >> model [
	^ model
]

{ #category : 'accessing' }
OllamaChatParams >> model: aString [
	model := aString
]

{ #category : 'accessing-private' }
OllamaChatParams >> ollamaOptions [
	^ ollamaOptions
]

{ #category : 'accessing' }
OllamaChatParams >> optionsBy: aBlock [
	ollamaOptions := OllamaOptions in: aBlock
]

{ #category : 'accessing' }
OllamaChatParams >> systemMessage: aString [
	self messages addFirst: (OllamaMessage system: aString)
]

{ #category : 'accessing' }
OllamaChatParams >> stream [
	^ stream
]

{ #category : 'accessing' }
OllamaChatParams >> stream: aBoolean [
	stream := aBoolean
]

{ #category : 'testing' }
OllamaChatParams >> isStreaming [
	^ self stream = true
]
