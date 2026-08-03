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
	^ self httpJsonPost: '/api/generate' body: body
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
	^ self httpJsonPost: '/api/chat' body: body
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
OllamaClient >> httpJsonGet: path [
	| url cli |
	url := self settings host , path.
	cli := ZnClient new
		timeout: self settings timeout;
		yourself.
	cli get: url.
	cli isSuccess ifFalse: [ (OllamaError fromResponse: cli response) signal ].
	^ STON fromString: cli response entity string
]

{ #category : 'private' }
OllamaClient >> httpJsonPost: path body: aDictionary [
	| url cli |
	url := self settings host , path.
	cli := ZnClient new
		forJsonREST;
		timeout: self settings timeout;
		yourself.
	cli post: url contents: aDictionary.
	cli isSuccess ifFalse: [ (OllamaError fromResponse: cli response) signal ].
	^ STON fromString: cli response entity string
]
