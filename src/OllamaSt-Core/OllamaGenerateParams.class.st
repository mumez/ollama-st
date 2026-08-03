"
I hold parameters for an Ollama /api/generate request.

Responsibility:
- I collect the model name, optional system prompt, runner options, and stream flag.
- I serialize everything to a request body Dictionary via #asDictionary.

Collaborators:
- OllamaClient: creates and configures me via a builder block, then calls #asDictionary.
- OllamaOptions: optional runner options (temperature, seed, etc.).

Public API and Key Messages:
- #model: — set the model name.
- #system: — set an optional system prompt prepended to the generation.
- #optionsBy: aBlock — configure runner options via a builder block.
- #stream: true/false — enable streaming response (default: false).
- #isStreaming — true when stream: true has been set.
"
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
	^ stream ifNil: [ false ]
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
