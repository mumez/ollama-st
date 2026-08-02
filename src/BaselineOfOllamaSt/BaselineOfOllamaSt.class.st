Class {
	#name : 'BaselineOfOllamaSt',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfOllamaSt',
	#package : 'BaselineOfOllamaSt'
}

{ #category : 'baselines' }
BaselineOfOllamaSt >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec
			package: 'OllamaSt-Core';
			package: 'OllamaSt-Tests' with: [ spec requires: #('OllamaSt-Core') ].
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('OllamaSt-Core');
			group: 'Tests' with: #('OllamaSt-Tests');
			group: 'all' with: #('Core' 'Tests') ]
]
