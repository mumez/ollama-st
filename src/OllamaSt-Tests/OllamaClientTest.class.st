Class {
	#name : 'OllamaClientTest',
	#superclass : 'TestCase',
	#category : 'OllamaSt-Tests',
	#package : 'OllamaSt-Tests'
}

{ #category : 'accessing' }
OllamaClientTest >> defaultEmbedModel [
	^ 'qwen3-embedding:4b'
]

{ #category : 'accessing' }
OllamaClientTest >> defaultGenerateModel [
	^ 'nemotron-3-nano:4b'
]

{ #category : 'accessing' }
OllamaClientTest >> defaultModel [
	^ self defaultEmbedModel
]

{ #category : 'tests' }
OllamaClientTest >> testEmbedWithModel [
	| result embeddings |
	result := OllamaClient new
		embed: 'The sky is blue because of Rayleigh scattering'
		model: self defaultModel.
	embeddings := result at: 'embeddings'.
	self assert: embeddings isNil not.
	self assert: embeddings first isNil not.
	self assert: embeddings first size > 0
]

{ #category : 'tests' }
OllamaClientTest >> testEmbedUsingBlock [
	| result embeddings |
	result := OllamaClient new
		embed: 'The sky is blue because of Rayleigh scattering'
		using: [ :params |
			params model: self defaultModel; dimensions: 128 ].
	embeddings := result at: 'embeddings'.
	self assert: embeddings isNil not.
	self assert: embeddings first size equals: 128
]

{ #category : 'tests' }
OllamaClientTest >> testEmbedWithDefaultModel [
	| client result |
	client := OllamaClient new.
	client model: self defaultModel.
	result := client embed: 'The sky is blue because of Rayleigh scattering'.
	self assert: (result at: 'model') equals: self defaultModel
]

{ #category : 'tests' }
OllamaClientTest >> testSettingsHost [
	| client |
	client := OllamaClient host: 'http://localhost:11434'.
	self assert: client settings host equals: 'http://localhost:11434'
]

{ #category : 'tests' }
OllamaClientTest >> testSettingsDefaultHost [
	| client |
	client := OllamaClient new.
	self assert: client settings host equals: 'http://localhost:11434'
]

{ #category : 'tests' }
OllamaClientTest >> testGenerateWithModel [
	| result |
	result := OllamaClient new
		generate: 'Why is the sky blue? Answer in one sentence.'
		model: self defaultGenerateModel.
	self assert: (result at: 'done').
	self assert: (result at: 'response') isNil not.
	self assert: (result at: 'response') isEmpty not
]

{ #category : 'tests' }
OllamaClientTest >> testGenerateWithDefaultModel [
	| client result |
	client := OllamaClient new.
	client model: self defaultGenerateModel.
	result := client generate: 'Say hello in one word.'.
	self assert: (result at: 'model') equals: self defaultGenerateModel
]

{ #category : 'tests' }
OllamaClientTest >> testGenerateUsingBlock [
	| result |
	result := OllamaClient new
		generate: 'Why is the sky blue? Answer in one sentence.'
		using: [ :params |
			params
				model: self defaultGenerateModel;
				system: 'You are a concise assistant.' ].
	self assert: (result at: 'done').
	self assert: (result at: 'response') isEmpty not
]

{ #category : 'tests' }
OllamaClientTest >> testGenerateUsingBlockWithStreaming [
	| response chunks |
	response := OllamaClient new
		generate: 'Why is the sky blue? Answer in one sentence.'
		using: [ :params |
			params
				model: self defaultGenerateModel;
				stream: true ].
	self assert: (response isKindOf: OllamaStreamResponse).
	chunks := OrderedCollection new.
	response do: [ :chunk | chunks add: chunk ].
	self assert: chunks isEmpty not.
	self assert: (chunks last at: 'done').
	self assert: (chunks anySatisfy: [ :c | (c at: 'response' ifAbsent: [ '' ]) isEmpty not ])
]

{ #category : 'tests' }
OllamaClientTest >> testChatWithModel [
	| result message |
	result := OllamaClient new
		chat: 'Why is the sky blue? Answer in one sentence.'
		model: self defaultGenerateModel.
	self assert: (result at: 'done').
	message := result at: 'message'.
	self assert: (message at: 'role') equals: 'assistant'.
	self assert: (message at: 'content') isEmpty not
]

{ #category : 'tests' }
OllamaClientTest >> testChatWithDefaultModel [
	| client result |
	client := OllamaClient new.
	client model: self defaultGenerateModel.
	result := client chat: 'Say hello in one word.'.
	self assert: (result at: 'model') equals: self defaultGenerateModel
]

{ #category : 'tests' }
OllamaClientTest >> testChatUsingBlock [
	| result message |
	result := OllamaClient new
		chat: 'Why is the sky blue? Answer in one sentence.'
		using: [ :params |
			params
				model: self defaultGenerateModel;
				systemMessage: 'You are a concise assistant.' ].
	self assert: (result at: 'done').
	message := result at: 'message'.
	self assert: (message at: 'content') isEmpty not
]

{ #category : 'tests' }
OllamaClientTest >> testTags [
	| result models |
	result := OllamaClient new tags.
	models := result at: 'models'.
	self assert: models isNil not.
	self assert: models isCollection
]

{ #category : 'tests' }
OllamaClientTest >> testPs [
	| result |
	result := OllamaClient new ps.
	self assert: (result includesKey: 'models')
]

{ #category : 'tests' }
OllamaClientTest >> testVersion [
	| version |
	version := OllamaClient new version.
	self assert: version isNil not.
	self assert: version isString
]

{ #category : 'tests' }
OllamaClientTest >> testChatWithMessages [
	| messages result message |
	messages := {
		OllamaMessage system: 'You are a concise assistant.'.
		OllamaMessage user: 'Why is the sky blue? Answer in one sentence.' }.
	result := OllamaClient new
		chatWith: messages
		model: self defaultGenerateModel.
	self assert: (result at: 'done').
	message := result at: 'message'.
	self assert: (message at: 'role') equals: 'assistant'
]

{ #category : 'tests' }
OllamaClientTest >> testChatWithMessagesStreaming [
	| response chunks messages |
	messages := {
		OllamaMessage system: 'You are a concise assistant.'.
		OllamaMessage user: 'Why is the sky blue? Answer in one sentence.' }.
	response := OllamaClient new
		chatWith: messages
		using: [ :params |
			params
				model: self defaultGenerateModel;
				stream: true ].
	self assert: (response isKindOf: OllamaStreamResponse).
	chunks := OrderedCollection new.
	response do: [ :chunk | chunks add: chunk ].
	self assert: chunks isEmpty not.
	self assert: (chunks last at: 'done').
	self assert: (chunks anySatisfy: [ :c |
		((c at: 'message' ifAbsent: [ Dictionary new ]) at: 'content' ifAbsent: [ '' ]) isEmpty not ])
]
