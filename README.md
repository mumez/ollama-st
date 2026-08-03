# OllamaSt

A Pharo Smalltalk client library for the [Ollama](https://ollama.com) API.

## Features

- **Embed** — generate text embeddings via `/api/embed`
- **Generate** — text generation via `/api/generate`, including streaming
- **Chat** — multi-turn conversation via `/api/chat`, including streaming
- **Tags** — list locally available models via `/api/tags`
- **PS** — list running models via `/api/ps`
- **Version** — server version via `/api/version`
- No external dependencies — uses Zinc HTTP and STON bundled with Pharo

## Requirements

- Pharo 13 or later
- A running Ollama instance (default: `http://localhost:11434`)

## Installation

Load via Metacello:

```smalltalk
Metacello new
    repository: 'github://mumez/ollama-st/src';
    baseline: 'OllamaSt';
    load.
```

## Usage

### Basic setup

```smalltalk
"Default host (http://localhost:11434)"
ollama := OllamaClient new.

"Explicit host"
ollama := OllamaClient host: 'http://localhost:11434'.

"Access settings"
ollama settings host.  "=> 'http://localhost:11434'"
```

### Embed

```smalltalk
"Embed with explicit model"
ollama embed: 'The sky is blue because of Rayleigh scattering'
       model: 'qwen3-embedding:4b'.

"Set a default model once, then omit it"
ollama model: 'qwen3-embedding:4b'.
ollama embed: 'The sky is blue because of Rayleigh scattering'.

"Full options via builder block"
ollama
    embed: 'The sky is blue because of Rayleigh scattering'
    using: [ :params |
        params
            model: 'qwen3-embedding:4b';
            dimensions: 128;
            optionsBy: [ :opts | opts temperature: 0.5 ] ].
```

The response is a `Dictionary` matching the Ollama API JSON response:

```smalltalk
result := ollama embed: 'Hello' model: 'qwen3-embedding:4b'.
result at: 'embeddings'.   "=> Array of embedding vectors"
result at: 'model'.        "=> 'qwen3-embedding:4b'"
```

### Generate

```smalltalk
"Generate with explicit model"
ollama generate: 'Why is the sky blue? Answer in one sentence.'
        model: 'nemotron-3-nano:4b'.

"Set a default model once, then omit it"
ollama model: 'nemotron-3-nano:4b'.
ollama generate: 'Why is the sky blue? Answer in one sentence.'.

"With system prompt and options via builder block"
ollama
    generate: 'Why is the sky blue? Answer in one sentence.'
    using: [ :params |
        params
            model: 'nemotron-3-nano:4b';
            system: 'You are a concise assistant.';
            optionsBy: [ :opts | opts temperature: 0.7 ] ].
```

The response is a `Dictionary` matching the Ollama API JSON response:

```smalltalk
result := ollama generate: 'Why is the sky blue?' model: 'nemotron-3-nano:4b'.
result at: 'response'.   "=> generated text string"
result at: 'done'.       "=> true"
result at: 'model'.      "=> 'nemotron-3-nano:4b'"
```

### Streaming

Both `generate` and `chat` support streaming responses. Set `stream: true` in the builder block; the method then returns an `OllamaStreamResponse` instead of a `Dictionary`. Enumerate all chunks with `do:`; it closes the response automatically, including when the block exits early or raises an error.

```smalltalk
"Generate streaming — enumerate with do:"
response := ollama
    generate: 'Why is the sky blue? Answer in one sentence.'
    using: [ :params | params model: 'nemotron-3-nano:4b'; stream: true ].
response do: [ :chunk | Transcript show: (chunk at: 'response') ].
```

```smalltalk
"Generate streaming — manual pull loop for finer control"
response := ollama
    generate: 'Why is the sky blue? Answer in one sentence.'
    using: [ :params | params model: 'nemotron-3-nano:4b'; stream: true ].
[
    [ response atEnd ] whileFalse: [
        Transcript show: ((response nextMessages ifNil: [ Dictionary new ]) at: 'response' ifAbsent: [ '' ]) ]
] ensure: [ response close ].
```

```smalltalk
"Chat streaming"
| messages chatResponse |
messages := {
    OllamaMessage system: 'You are a concise assistant.'.
    OllamaMessage user: 'Why is the sky blue?' }.
chatResponse := ollama
    chatWith: messages
    using: [ :params | params model: 'nemotron-3-nano:4b'; stream: true ].
chatResponse do: [ :chunk | Transcript show: ((chunk at: 'message') at: 'content'); flush ].
```

### Timeout

Generate requests can take time depending on the model. The default timeout is 120 seconds and can be adjusted:

```smalltalk
ollama settings timeout: 300.
```

### Chat

```smalltalk
"Single user message with explicit model"
ollama chat: 'Why is the sky blue? Answer in one sentence.'
       model: 'nemotron-3-nano:4b'.

"Set a default model once, then omit it"
ollama model: 'nemotron-3-nano:4b'.
ollama chat: 'Why is the sky blue? Answer in one sentence.'.

"With system message via builder block"
ollama
    chat: 'Why is the sky blue? Answer in one sentence.'
    using: [ :params |
        params
            model: 'nemotron-3-nano:4b';
            systemMessage: 'You are a concise assistant.';
            optionsBy: [ :opts | opts temperature: 0.7 ] ].

"Multi-turn conversation with OllamaMessage"
| messages |
messages := {
    OllamaMessage system: 'You are a concise assistant.'.
    OllamaMessage user: 'Why is the sky blue?'.
    OllamaMessage assistant: 'Because of Rayleigh scattering.'.
    OllamaMessage user: 'Can you elaborate in one sentence?' }.
ollama chatWith: messages model: 'nemotron-3-nano:4b'.
```

The response is a `Dictionary` matching the Ollama API JSON response:

```smalltalk
result := ollama chat: 'Why is the sky blue?' model: 'nemotron-3-nano:4b'.
result at: 'done'.                          "=> true"
(result at: 'message') at: 'role'.          "=> 'assistant'"
(result at: 'message') at: 'content'.       "=> generated reply string"
```

### Tags, PS, Version

```smalltalk
"List all locally available models"
ollama tags.
"=> Dictionary with 'models' key containing an Array of model info Dictionaries"

"List currently running (loaded) models"
ollama ps.
"=> Dictionary with 'models' key"

"Get the Ollama server version"
ollama version.
"=> '0.9.6' (String)"
```

## Development

The project follows the Tonel file format and the standard Pharo development workflow.

```
src/
├── BaselineOfOllamaSt/
├── OllamaSt-Core/
└── OllamaSt-Tests/
```

Run the test suite:

```smalltalk
OllamaClientTest suite run.
```

## License

MIT
