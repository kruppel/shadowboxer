# LangChain Python Development Skill

## Overview
Expert knowledge of LangChain Python framework for building LLM-powered applications, with strong bias towards v1 patterns for active development. Comprehensive understanding of both legacy and modern approaches, prioritizing v1 agent creation paradigms and LangGraph integration.

## LangChain v1 Core Changes

### New Agent Creation Paradigm
- `create_agent()` as the standard method for building agents
- Built on LangGraph for state management and persistence
- Middleware architecture for dynamic behavior control
- Conversation persistence and "time travel" capabilities

### Package Structure
- Core `langchain` package for essential agent building blocks
- `langchain_classic` for legacy v0.x functionality
- Streamlined imports and initialization patterns

### Key v1 Components
- **Agents**: Built with `create_agent()` and middleware
- **Content Blocks**: Unified content representation with `content_blocks` property
- **Structured Output**: Integrated in main agent loop with provider-side generation
- **Middleware**: PIIMiddleware, SummarizationMiddleware, HumanInTheLoopMiddleware
- **LangGraph Integration**: State management, streaming, persistence

### v1 Implementation Patterns
- Agent-first architecture over chain composition
- Middleware-based behavior modification
- Content blocks for unified output handling
- Async streaming with conversation state
- Structured output generation at provider level

## LangChain v1 Use Cases

### Modern Agent Creation
```python
from langchain import create_agent
from langchain.tools import Tool
from langchain.middleware import PIIMiddleware, SummarizationMiddleware

# v1 agent creation with middleware
def custom_tool_func(query: str) -> str:
    return f"Processed: {query}"

tools = [Tool(
    name="CustomTool",
    description="Processes queries",
    func=custom_tool_func
)]

# Create agent with middleware stack
agent = create_agent(
    model="gpt-4",
    tools=tools,
    middlewares=[
        PIIMiddleware(),
        SummarizationMiddleware(max_tokens=1000)
    ]
)

# Execute with conversation persistence
response = await agent.ainvoke(
    {"messages": [{"role": "user", "content": "Hello"}]},
    config={"configurable": {"thread_id": "conversation-1"}}
)
```

### Structured Output Generation
```python
from langchain import create_agent
from pydantic import BaseModel

class AnalysisResult(BaseModel):
    sentiment: str
    confidence: float
    key_topics: list[str]

# Agent with structured output
agent = create_agent(
    model="gpt-4",
    tools=[],
    structured_output=AnalysisResult
)

# Get structured response
result = await agent.ainvoke({"messages": messages})
analysis = result.content_blocks[0].parsed  # AnalysisResult object
```

### Content Blocks Usage
```python
# Access unified content representation
response = await agent.ainvoke({"messages": messages})

for block in response.content_blocks:
    if block.type == "text":
        print(f"Text: {block.text}")
    elif block.type == "tool_call":
        print(f"Tool: {block.name}, Args: {block.input}")
    elif block.type == "reasoning":
        print(f"Reasoning: {block.content}")
```

## LangChain v1 Best Practices

### Agent Architecture
- Use `create_agent()` as the primary building pattern
- Leverage middleware for cross-cutting concerns
- Design stateful conversations with thread management
- Implement proper tool composition and validation

### Middleware Usage
- Apply PIIMiddleware for sensitive data handling
- Use SummarizationMiddleware for long conversations
- Implement HumanInTheLoopMiddleware for approval workflows
- Create custom middleware for domain-specific logic

### Performance & Streaming
- Utilize async patterns with `ainvoke()` and `astream()`
- Implement conversation persistence with thread_id
- Stream responses for better user experience
- Cache expensive tool operations

### Security & Privacy
- Use PIIMiddleware to automatically redact sensitive information
- Validate all tool inputs and outputs
- Implement proper authentication for external tool access
- Use environment variables for API keys and configuration

## v1 Development Guidelines

### Project Structure
```
project/
├── src/
│   ├── agents/          # Agent creation and configuration
│   ├── middleware/      # Custom middleware implementations
│   ├── tools/           # Custom tool definitions
│   ├── schemas/         # Pydantic models for structured output
│   └── utils/           # Helper functions and utilities
├── configs/             # Configuration files
├── tests/              # Unit and integration tests
└── requirements.txt    # LangChain v1 dependencies
```

### Migration from v0.x
```python
# Update imports for legacy functionality
# OLD (v0.x):
# from langchain.chains import LLMChain

# NEW (v1):
from langchain_classic.chains import LLMChain  # Legacy chains
from langchain import create_agent              # New agent pattern
```

### Testing v1 Agents
- Test agent creation with different middleware combinations
- Mock tool calls and validate structured outputs
- Test conversation persistence and state management
- Validate content blocks parsing and handling

### Configuration with v1
```python
from pydantic import BaseModel
from langchain import create_agent

class AgentConfig(BaseModel):
    model_name: str = "gpt-4"
    max_tokens: int = 1000
    temperature: float = 0.1
    thread_id: str

# Configure agent with structured config
config = AgentConfig(thread_id="user-session-123")
agent = create_agent(
    model=config.model_name,
    temperature=config.temperature
)
```

## Troubleshooting

### Common Issues
- **Import errors**: Check LangChain version compatibility
- **API rate limits**: Implement exponential backoff
- **Memory issues**: Use streaming for large documents
- **Token limits**: Implement text splitting and chunking

### Debugging Tools
- Enable LangChain debugging: `langchain.debug = True`
- Use callbacks for tracing execution
- Log intermediate outputs in chains
- Monitor token usage and costs

## Integration Examples

### Vector Databases
- Pinecone for production scale
- Chroma for local development
- FAISS for in-memory operations
- Weaviate for semantic search

### LLM Providers
- Reference https://models.dev (cache/store in memory, refresh every week) for the latest model versions
- By default, use the latest Claude Sonnet model

## LangChain v1 Migration & Installation

### Installation
```bash
# Install LangChain v1
uv add langchain

# For legacy functionality
uv add langchain-classic

# Alternative: direct install
uv pip install langchain
uv pip install langchain-classic
```

### Key v1 Features
- `create_agent()` as the primary agent building method
- Middleware architecture for behavior control
- Content blocks for unified output representation
- Built-in structured output generation
- LangGraph integration for state management
- Conversation persistence and "time travel"
- Streaming support with async patterns

### Breaking Changes from v0.x
- Agent creation moved from `initialize_agent()` to `create_agent()`
- Legacy chains moved to `langchain_classic` package
- New middleware-based behavior modification
- Content representation changed to content blocks
- Structured output integrated into main loop

### Python-First Approach
This skill focuses exclusively on Python implementations:
- Server-side agent execution
- Python tool integration
- Async/await patterns for I/O
- Pydantic models for data validation
- No client-side or React considerations
