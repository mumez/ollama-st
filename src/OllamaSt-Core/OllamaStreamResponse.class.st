"
I represent a streaming NDJSON response from the Ollama API. Chunks are returned as-is by #nextMessages/#do: — an Ollama error occurring mid-stream arrives as a plain chunk Dictionary with an 'error' key rather than being signaled as an exception. A malformed or truncated NDJSON line will raise a STON parse error out of #nextMessages/#do:.
"
Class {
	#name : 'OllamaStreamResponse',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'entity'
	],
	#category : 'OllamaSt-Core',
	#package : 'OllamaSt-Core'
}

{ #category : 'instance creation' }
OllamaStreamResponse class >> on: aStream [
	^ self new
		setStream: aStream;
		yourself
]

{ #category : 'instance creation' }
OllamaStreamResponse class >> on: aStream entity: aZnStreamingEntity [
	^ self new
		setStream: aStream entity: aZnStreamingEntity;
		yourself
]

{ #category : 'testing' }
OllamaStreamResponse >> atEnd [
	^ stream atEnd
]

{ #category : 'initialize-release' }
OllamaStreamResponse >> close [
	entity ifNotNil: [ entity close ]
]

{ #category : 'enumerating' }
OllamaStreamResponse >> do: aBlock [
	[ [ self atEnd ] whileFalse: [
		self nextMessages ifNotNil: [ :chunk | aBlock value: chunk ] ] ]
		ensure: [ self close ]
]

{ #category : 'accessing' }
OllamaStreamResponse >> nextMessages [
	| line |
	line := stream upTo: Character lf.
	^ line isEmpty ifTrue: [ nil ] ifFalse: [ STON fromString: line ]
]

{ #category : 'initialize-release' }
OllamaStreamResponse >> setStream: aStream [
	stream := aStream
]

{ #category : 'initialize-release' }
OllamaStreamResponse >> setStream: aStream entity: aZnStreamingEntity [
	stream := aStream.
	entity := aZnStreamingEntity
]
