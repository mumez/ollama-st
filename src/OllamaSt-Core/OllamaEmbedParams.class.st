"
I hold parameters for an Ollama /api/embed request.

Responsibility:
- I collect the model name, optional output dimensions, and runner options.
- I serialize everything to a request body Dictionary via #asDictionary.
- The input text itself is added by OllamaClient after the builder block runs.

Collaborators:
- OllamaClient: creates and configures me via a builder block, then merges 'input' into my dictionary.
- OllamaOptions: optional runner options (temperature, seed, etc.).

Public API and Key Messages:
- #model: — set the embedding model name.
- #dimensions: — request a specific output vector length (if supported by the model).
- #optionsBy: aBlock — configure runner options via a builder block.
"
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
