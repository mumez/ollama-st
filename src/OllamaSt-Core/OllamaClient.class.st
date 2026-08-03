"
I am the main entry point for communicating with a local Ollama server.

Responsibility:
- I send Embed, Generate, and Chat requests to the Ollama HTTP API.
- I maintain an OllamaSettings instance that holds the host URL, default model, and timeout.
- I dispatch both blocking (non-streaming) and streaming requests.

Collaborators:
- OllamaSettings: holds host, defaultModel, and timeout used by all requests.
- OllamaEmbedParams, OllamaGenerateParams, OllamaChatParams: parameter objects built via builder blocks and serialized to JSON request bodies.
- OllamaMessage: used to compose multi-turn chat conversations.
- OllamaStreamResponse: returned for streaming requests (stream: true).
- OllamaError: signaled on non-2xx HTTP responses.

Public API and Key Messages:
- #embed:model: — generate an embedding vector for a text string.
- #generate:model: — generate a text completion for a prompt.
- #chat:model: — send a single user message and receive a reply.
- #chatWith:model: — send a sequence of OllamaMessages for multi-turn chat.
- #embed:using:, #generate:using:, #chat:using:, #chatWith:using: — builder-block variants for advanced options (dimensions, system prompt, streaming, runner options).
- #tags — list locally available models.
- #ps — list currently running (loaded) models.
- #version — return the Ollama server version string.
- #model / #model: — get or set the default model on the receiver's settings.

Example:
  ollama := OllamaClient new.
  ollama model: 'nemotron-3-nano:4b'.
  result := ollama generate: 'Why is the sky blue?'.
  Transcript showCr: (result at: 'response').
"
Class {
	#name : 'OllamaClient',
	#superclass : 'Object',
	#instVars : [
		'settings'
	],
	#category : 'OllamaSt-Core',
	#package : 'OllamaSt-Core'
}

{ #category : 'instance creation' }
OllamaClient class >> host: aString [
	^ self new
		settings: (OllamaSettings new host: aString; yourself);
		yourself
]

{ #category : 'actions' }
OllamaClient >> generate: prompt [
	^ self generate: prompt using: [ :params | ]
]

{ #category : 'actions' }
OllamaClient >> generate: prompt model: modelName [
	^ self generate: prompt using: [ :params | params model: modelName ]
]

{ #category : 'actions' }
OllamaClient >> generate: prompt using: aBlock [
	| params body |
	params := OllamaGenerateParams new model: self settings defaultModel.
	aBlock value: params.
	body := params asDictionary.
	body at: 'prompt' put: prompt.
	^ params isStreaming
		ifTrue: [ self httpJsonPostStreaming: '/api/generate' body: body ]
		ifFalse: [ self httpJsonPost: '/api/generate' body: body ]
]

{ #category : 'actions' }
OllamaClient >> chat: text [
	^ self chat: text using: [ :params | ]
]

{ #category : 'actions' }
OllamaClient >> chat: text model: modelName [
	^ self chat: text using: [ :params | params model: modelName ]
]

{ #category : 'actions' }
OllamaClient >> chat: text using: aBlock [
	^ self chatWith: { OllamaMessage user: text } using: aBlock
]

{ #category : 'actions' }
OllamaClient >> chatWith: messages [
	^ self chatWith: messages using: [ :params | ]
]

{ #category : 'actions' }
OllamaClient >> chatWith: messages model: modelName [
	^ self chatWith: messages using: [ :params | params model: modelName ]
]

{ #category : 'actions' }
OllamaClient >> chatWith: messages using: aBlock [
	| params body |
	params := OllamaChatParams new
		model: self settings defaultModel;
		messages: messages;
		yourself.
	aBlock value: params.
	body := params asDictionary.
	^ params isStreaming
		ifTrue: [ self httpJsonPostStreaming: '/api/chat' body: body ]
		ifFalse: [ self httpJsonPost: '/api/chat' body: body ]
]

{ #category : 'actions' }
OllamaClient >> embed: text [
	^ self embed: text using: [ :params | ]
]

{ #category : 'actions' }
OllamaClient >> embed: text model: modelName [
	^ self embed: text using: [ :params | params model: modelName ]
]

{ #category : 'actions' }
OllamaClient >> embed: text using: aBlock [
	| params body |
	params := OllamaEmbedParams new model: self settings defaultModel.
	aBlock value: params.
	body := params asDictionary.
	body at: 'input' put: text.
	^ self httpJsonPost: '/api/embed' body: body
]

{ #category : 'accessing' }
OllamaClient >> model [
	^ self settings defaultModel
]

{ #category : 'accessing' }
OllamaClient >> model: aString [
	self settings defaultModel: aString
]

{ #category : 'accessing' }
OllamaClient >> settings [
	^ settings ifNil: [ settings := OllamaSettings new ]
]

{ #category : 'accessing' }
OllamaClient >> settings: anObject [
	settings := anObject
]

{ #category : 'actions' }
OllamaClient >> ps [
	^ self httpJsonGet: '/api/ps'
]

{ #category : 'actions' }
OllamaClient >> tags [
	^ self httpJsonGet: '/api/tags'
]

{ #category : 'actions' }
OllamaClient >> version [
	^ (self httpJsonGet: '/api/version') at: 'version'
]

{ #category : 'private' }
OllamaClient >> newHttpClient [
	^ ZnClient new
		timeout: self settings timeout;
		yourself
]

{ #category : 'private' }
OllamaClient >> httpJsonGet: path [
	| url cli |
	url := self settings host , path.
	cli := self newHttpClient.
	cli get: url.
	cli isSuccess ifFalse: [ (OllamaError fromResponse: cli response) signal ].
	^ STON fromString: cli response entity string
]

{ #category : 'private' }
OllamaClient >> httpJsonPost: path body: aDictionary [
	| url cli |
	url := self settings host , path.
	cli := self newHttpClient
		forJsonREST;
		yourself.
	cli post: url contents: aDictionary.
	cli isSuccess ifFalse: [ (OllamaError fromResponse: cli response) signal ].
	^ STON fromString: cli response entity string
]

{ #category : 'private' }
OllamaClient >> httpJsonPostStreaming: path body: aDictionary [
	| url cli |
	url := self settings host , path.
	cli := self newHttpClient
		contentWriter: [ :data | ZnEntity json: (ZnUtils defaultJSONWriter toString: data) ];
		streaming: true;
		yourself.
	cli post: url contents: aDictionary.
	cli isSuccess ifFalse: [ (OllamaError fromResponse: cli response) signal ].
	^ OllamaStreamResponse
		on: (ZnCharacterReadStream on: cli response entity stream)
		entity: cli response entity
]
