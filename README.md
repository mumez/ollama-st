# OllamaSt

A Pharo Smalltalk client library for the [Ollama](https://ollama.com) API.

## Features

- **Embed** — generate text embeddings via `/api/embed`
- **Generate** — text generation via `/api/generate`
- **Chat** — *(planned)*
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

### Timeout

Generate requests can take time depending on the model. The default timeout is 120 seconds and can be adjusted:

```smalltalk
ollama settings timeout: 300.
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
