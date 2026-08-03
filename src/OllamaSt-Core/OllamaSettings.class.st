"
I hold configuration for an OllamaClient instance.

Responsibility:
- I store host URL, default model name, and HTTP timeout as named settings.
- I provide typed accessors with lazy-initialized defaults.
- I expose a class-side singleton via #default for shared configuration.

Collaborators:
- OllamaClient: holds me and reads host, defaultModel, and timeout for every request.

Public API and Key Messages:
- #host / #host: — Ollama server URL (default: 'http://localhost:11434').
- #defaultModel / #defaultModel: — model name used when no model is specified per request.
- #timeout / #timeout: — HTTP timeout in seconds (default: 120).

Internal Representation:
- settingsDict — IdentityDictionary keyed by symbols; backing store for all settings.
- default (class) — lazily initialized singleton instance.
"
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
