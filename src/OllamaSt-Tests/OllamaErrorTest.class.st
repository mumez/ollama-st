Class {
	#name : 'OllamaErrorTest',
	#superclass : 'TestCase',
	#category : 'OllamaSt-Tests',
	#package : 'OllamaSt-Tests'
}

{ #category : 'tests' }
OllamaErrorTest >> testMessageTextWithStringEntity [
	| response error |
	response := ZnResponse serverErrorWithEntity: (ZnEntity text: 'boom').
	error := OllamaError fromResponse: response.
	self assert: error messageText equals: 'HTTP 500: boom'
]

{ #category : 'tests' }
OllamaErrorTest >> testMessageTextWithStreamingEntity [
	| entity response error |
	entity := ZnStreamingEntity
		readFrom: 'boom' readStream
		usingType: ZnMimeType applicationJson
		andLength: 'boom' size.
	response := ZnResponse serverErrorWithEntity: entity.
	error := OllamaError fromResponse: response.
	self assert: error messageText equals: 'HTTP 500: boom'
]

{ #category : 'tests' }
OllamaErrorTest >> testMessageTextWithNilResponse [
	self assert: OllamaError new messageText equals: 'OllamaError'
]
