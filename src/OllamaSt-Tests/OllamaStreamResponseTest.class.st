Class {
	#name : 'OllamaStreamResponseTest',
	#superclass : 'TestCase',
	#category : 'OllamaSt-Tests',
	#package : 'OllamaSt-Tests'
}

{ #category : 'tests' }
OllamaStreamResponseTest >> testNextMessagesAndAtEnd [
	| ndjson response |
	ndjson := '{"response":"Hello"}' , String lf , '{"response":"World","done":true}' , String lf.
	response := OllamaStreamResponse on: ndjson readStream.
	self deny: response atEnd.
	self assert: (response nextMessages at: 'response') equals: 'Hello'.
	self deny: response atEnd.
	self assert: (response nextMessages at: 'response') equals: 'World'.
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
