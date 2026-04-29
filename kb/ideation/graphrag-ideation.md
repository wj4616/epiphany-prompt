# GraphRAG for Ideation
**Domain:** ideation
**Type:** technique
**Relevance:** high
**Source:** Wave 1 — 04-llm-ideation.md

## Summary
GraphRAG for Ideation uses knowledge graph-augmented retrieval to expand the model's ideation space beyond its training distribution by injecting cross-domain conceptual connections. Standard dense RAG (embedding similarity retrieval) actually reduces idea diversity for ideation tasks — better retrieval returns more similar content, narrowing rather than broadening the generative space. GraphRAG escapes this paradox by organizing retrieved knowledge into relational graphs, enabling multi-hop traversal across connected concepts in different domains. Microsoft GraphRAG, LightRAG, and CogGRAG (mind-map tree-structured retrieval) are the primary implementations. Analogical Reasoning Amplification research demonstrated a 10x improvement in novel concept generation when human-guided analogies from distant domains were provided as context.

## Core Mechanism
GraphRAG constructs a knowledge graph from the source corpus, where nodes are entities and edges represent relationships (causal, compositional, analogical, taxonomic). At query time, instead of retrieving the top-K semantically similar chunks, the system traverses the graph from the query node through multi-hop paths, surfacing entities and relationships that are conceptually connected but semantically distant from the query. For ideation, the key traversal strategy is cross-domain path finding: retrieve paths of the form A→B→C where A is in the problem domain and C is in a structurally analogous but semantically distant domain. This provides the model with analogical inspiration from unexpected sources — the mechanism that underlies most breakthrough creative solutions. LightRAG uses dual-level indexing (local entity relationships and global document themes) to support both specific and abstract cross-domain queries. CogGRAG uses mind-map trees to structure retrieved knowledge hierarchically before injection.

## Application in Skill Context
In a prompt engineering skill, GraphRAG ideation is applied when the task requires non-obvious prompt structures or when standard prompt patterns are known to be insufficient. The technique injects cross-domain path contexts before the ideation prompt, framing them explicitly as analogical inspiration: "Here are structural patterns from [adjacent domain]: [GraphRAG-retrieved paths]. Apply these structural analogies to generate novel framings of the following prompt engineering problem." For prompt structure ideation specifically, the skill can maintain a small cross-domain analogy graph connecting prompt engineering concepts to structures from rhetoric, law, teaching, game design, and software architecture — domains with rich structural pattern libraries. The injection cost is additional context tokens, so paths should be filtered to 3–5 most structurally relevant traversals.

## Key Variants / Parameters
- **Microsoft GraphRAG**: community-detection-based graph construction; strong for large corpus global reasoning
- **LightRAG**: dual-level indexing (local + global); lower build cost, good for medium-scale KBs
- **CogGRAG**: mind-map tree structure; best for hierarchically organized domains
- **Path length**: 2–3 hops optimal for ideation; longer paths increase noise
- **Cross-domain framing**: explicit analogical framing in injection prompt is critical — without it, the model treats cross-domain content as noise rather than inspiration
- **Dense RAG baseline**: avoid for ideation tasks; use only when retrieval accuracy (not diversity) is the goal

## Related KB Entries
- [autotriz.md](autotriz.md)
- [creative-dc.md](creative-dc.md)
- [constraint-based-prompting.md](constraint-based-prompting.md)
- [persona-hub.md](persona-hub.md)
