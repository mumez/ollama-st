# OllamaSt

A Pharo Smalltalk client library for the [Ollama](https://ollama.com) API.

## Features

- **Embed** — generate text embeddings via `/api/embed`
- **Generate** — *(planned)*
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
