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

{ #category : 'private' }
OllamaClient >> httpJsonPost: path body: aDictionary [
	| url cli |
	url := self settings host , path.
	cli := ZnClient new forJsonREST.
	cli post: url contents: aDictionary.
	cli isSuccess ifFalse: [ (OllamaError fromResponse: cli response) signal ].
	^ STON fromString: cli response entity string
]
