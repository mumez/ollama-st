"
I hold parameters for an Ollama /api/chat request.

Responsibility:
- I collect the model name, a list of OllamaMessages, runner options, and stream flag.
- I serialize everything to a request body Dictionary via #asDictionary.
- I provide a convenience method #systemMessage: to prepend a system message without constructing an OllamaMessage directly.

Collaborators:
- OllamaClient: creates and configures me via a builder block, then calls #asDictionary.
- OllamaMessage: elements of my messages collection.
- OllamaOptions: optional runner options (temperature, seed, etc.).

Public API and Key Messages:
- #model: — set the model name.
- #messages: — set the full messages collection (Array or OrderedCollection of OllamaMessage).
- #addMessage: — append a single OllamaMessage.
- #systemMessage: — prepend a system-role OllamaMessage at the front of the list.
- #optionsBy: aBlock — configure runner options via a builder block.
- #stream: true/false — enable streaming response (default: false).
- #isStreaming — true when stream: true has been set.
"
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
OllamaChatParams >> stream [
	^ stream ifNil: [ false ]
]

{ #category : 'accessing' }
OllamaChatParams >> stream: aBoolean [
	stream := aBoolean
]

{ #category : 'accessing' }
OllamaChatParams >> systemMessage: aString [
	self messages addFirst: (OllamaMessage system: aString)
]

{ #category : 'testing' }
OllamaChatParams >> isStreaming [
	^ self stream = true
]
