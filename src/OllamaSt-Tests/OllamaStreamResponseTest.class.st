Class {
	#name : 'OllamaStreamResponseTest',
	#superclass : 'TestCase',
	#category : 'OllamaSt-Tests',
	#package : 'OllamaSt-Tests'
}

{ #category : 'tests' }
OllamaStreamResponseTest >> testNextAndAtEnd [
	| ndjson response |
	ndjson := '{"response":"Hello"}' , String lf , '{"response":"World","done":true}' , String lf.
	response := OllamaStreamResponse on: ndjson readStream.
	self deny: response atEnd.
	self assert: (response next at: 'response') equals: 'Hello'.
	self deny: response atEnd.
	self assert: (response next at: 'response') equals: 'World'.
	self assert: response atEnd
]

{ #category : 'tests' }
OllamaStreamResponseTest >> testDoEnumeratesAllChunks [
	| ndjson response chunks |
	ndjson := '{"response":"Hello"}' , String lf , '{"response":"World","done":true}' , String lf.
	response := OllamaStreamResponse on: ndjson readStream.
	chunks := OrderedCollection new.
	response do: [ :chunk | chunks add: (chunk at: 'response') ].
	self assert: chunks asArray equals: #('Hello' 'World')
]

{ #category : 'tests' }
OllamaStreamResponseTest >> testDoOnEmptyStreamNeverInvokesBlock [
	| response invoked |
	response := OllamaStreamResponse on: '' readStream.
	invoked := false.
	response do: [ :chunk | invoked := true ].
	self deny: invoked
]

{ #category : 'tests' }
OllamaStreamResponseTest >> testNextReturnsNilForBlankLine [
	| ndjson response |
	ndjson := '{"response":"Hello"}' , String lf , String lf , '{"response":"World","done":true}' , String lf.
	response := OllamaStreamResponse on: ndjson readStream.
	self assert: (response next at: 'response') equals: 'Hello'.
	self assert: response next isNil.
	self assert: (response next at: 'response') equals: 'World'.
	self assert: response atEnd
]

{ #category : 'tests' }
OllamaStreamResponseTest >> testNextReadsLastLineWithoutTrailingNewline [
	| ndjson response |
	ndjson := '{"response":"Hello"}' , String lf , '{"response":"World","done":true}'.
	response := OllamaStreamResponse on: ndjson readStream.
	self assert: (response next at: 'response') equals: 'Hello'.
	self assert: (response next at: 'response') equals: 'World'.
	self assert: response atEnd
]
