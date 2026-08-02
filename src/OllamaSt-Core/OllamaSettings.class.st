Class {
	#name : 'OllamaSettings',
	#superclass : 'Object',
	#instVars : [
		'settingsDict'
	],
	#classInstVars : [
		'default'
	],
	#category : 'OllamaSt-Core',
	#package : 'OllamaSt-Core'
}

{ #category : 'instance creation' }
OllamaSettings class >> default [
	^ default ifNil: [ default := self new ]
]

{ #category : 'class initialization' }
OllamaSettings class >> initialize [
	default := nil
]

{ #category : 'actions-dictionary' }
OllamaSettings >> at: key ifAbsent: aBlock [
	^ self settingsDict at: key ifAbsent: aBlock
]

{ #category : 'actions-dictionary' }
OllamaSettings >> at: key ifAbsentPut: aBlock [
	^ self settingsDict at: key ifAbsentPut: aBlock
]

{ #category : 'actions-dictionary' }
OllamaSettings >> at: key put: value [
	^ self settingsDict at: key put: value
]

{ #category : 'defaults' }
OllamaSettings >> defaultHost [
	^ 'http://localhost:11434'
]

{ #category : 'accessing' }
OllamaSettings >> defaultModel [
	^ self at: #defaultModel ifAbsent: [ '' ]
]

{ #category : 'accessing' }
OllamaSettings >> defaultModel: aString [
	self at: #defaultModel put: aString
]

{ #category : 'accessing' }
OllamaSettings >> host [
	^ self at: #host ifAbsentPut: [ self defaultHost ]
]

{ #category : 'accessing' }
OllamaSettings >> host: aString [
	self at: #host put: aString
]

{ #category : 'defaults' }
OllamaSettings >> defaultTimeout [
	^ 120
]

{ #category : 'accessing' }
OllamaSettings >> timeout [
	^ self at: #timeout ifAbsentPut: [ self defaultTimeout ]
]

{ #category : 'accessing' }
OllamaSettings >> timeout: seconds [
	self at: #timeout put: seconds
]

{ #category : 'initialization' }
OllamaSettings >> initialize [
	settingsDict := nil
]

{ #category : 'accessing-private' }
OllamaSettings >> settingsDict [
	^ settingsDict ifNil: [ settingsDict := IdentityDictionary new ]
]
