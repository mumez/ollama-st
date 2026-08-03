Class {
	#name : 'OllamaMessage',
	#superclass : 'Object',
	#instVars : [
		'role',
		'content'
	],
	#category : 'OllamaSt-Core',
	#package : 'OllamaSt-Core'
}

{ #category : 'instance creation' }
OllamaMessage class >> assistant: content [
	^ self role: 'assistant' content: content
]

{ #category : 'instance creation' }
OllamaMessage class >> fromDictionary: aDictionary [
	^ self
		role: (aDictionary at: 'role')
		content: (aDictionary at: 'content')
]

{ #category : 'instance creation' }
OllamaMessage class >> role: aRole content: aContent [
	^ self new
		role: aRole;
		content: aContent;
		yourself
]

{ #category : 'instance creation' }
OllamaMessage class >> system: content [
	^ self role: 'system' content: content
]

{ #category : 'instance creation' }
OllamaMessage class >> user: content [
	^ self role: 'user' content: content
]

{ #category : 'converting' }
OllamaMessage >> asDictionary [
	^ Dictionary new
		at: 'role' put: self role;
		at: 'content' put: self content;
		yourself
]

{ #category : 'accessing' }
OllamaMessage >> content [
	^ content
]

{ #category : 'accessing' }
OllamaMessage >> content: aString [
	content := aString
]

{ #category : 'testing' }
OllamaMessage >> isAssistant [
	^ self role = 'assistant'
]

{ #category : 'testing' }
OllamaMessage >> isSystem [
	^ self role = 'system'
]

{ #category : 'testing' }
OllamaMessage >> isUser [
	^ self role = 'user'
]

{ #category : 'accessing' }
OllamaMessage >> role [
	^ role
]

{ #category : 'accessing' }
OllamaMessage >> role: aString [
	role := aString
]
