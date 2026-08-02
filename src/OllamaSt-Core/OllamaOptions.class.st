Class {
	#name : 'OllamaOptions',
	#superclass : 'Object',
	#instVars : [
		'optionsDict'
	],
	#category : 'OllamaSt-Core',
	#package : 'OllamaSt-Core'
}

{ #category : 'instance creation' }
OllamaOptions class >> in: aBlock [
	| inst |
	inst := self new.
	aBlock value: inst.
	^ inst
]

{ #category : 'converting' }
OllamaOptions >> asDictionary [
	^ self optionsDict
]

{ #category : 'initialization' }
OllamaOptions >> initialize [
	optionsDict := Dictionary new
]

{ #category : 'accessing-private' }
OllamaOptions >> optionsDict [
	^ optionsDict
]

{ #category : 'accessing' }
OllamaOptions >> seed [
	^ self optionsDict at: 'seed' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
OllamaOptions >> seed: anInteger [
	self optionsDict at: 'seed' put: anInteger
]

{ #category : 'accessing' }
OllamaOptions >> temperature [
	^ self optionsDict at: 'temperature' ifAbsent: [ nil ]
]

{ #category : 'accessing' }
OllamaOptions >> temperature: aNumber [
	self optionsDict at: 'temperature' put: aNumber
]
