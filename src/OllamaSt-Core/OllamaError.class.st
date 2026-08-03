Class {
	#name : 'OllamaError',
	#superclass : 'Error',
	#instVars : [
		'response'
	],
	#category : 'OllamaSt-Core',
	#package : 'OllamaSt-Core'
}

{ #category : 'instance creation' }
OllamaError class >> fromResponse: aResponse [
	^ self new
		response: aResponse;
		yourself
]

{ #category : 'accessing' }
OllamaError >> messageText [
	^ messageText ifNil: [
		response
			ifNil: [ 'OllamaError' ]
			ifNotNil: [ 'HTTP ' , response code printString , ': ' , response entity contents ] ]
]

{ #category : 'accessing' }
OllamaError >> response [
	^ response
]

{ #category : 'accessing' }
OllamaError >> response: anObject [
	response := anObject
]
