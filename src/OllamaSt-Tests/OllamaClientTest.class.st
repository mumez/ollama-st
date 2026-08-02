Class {
	#name : 'OllamaClientTest',
	#superclass : 'TestCase',
	#category : 'OllamaSt-Tests',
	#package : 'OllamaSt-Tests'
}

{ #category : 'accessing' }
OllamaClientTest >> defaultModel [
	^ 'qwen3-embedding:4b'
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
