Class {
	#name : 'OllamaStreamResponse',
	#superclass : 'Object',
	#instVars : [
		'stream'
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

{ #category : 'testing' }
OllamaStreamResponse >> atEnd [
	^ stream atEnd
]

{ #category : 'enumerating' }
OllamaStreamResponse >> do: aBlock [
	[ self atEnd ] whileFalse: [
		self nextMessages ifNotNil: [ :chunk | aBlock value: chunk ] ]
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
