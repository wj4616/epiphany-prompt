# Soft Prompt Tuning
**Domain:** enhancement
**Type:** technique
**Relevance:** medium
**Source:** Wave 1 — soft-prompt-tuning

## Summary
Soft Prompt Tuning (Lester et al., 2021) prepends learnable continuous embedding vectors — soft prompts — to the model input and optimizes them via gradient descent while keeping all model weights frozen. Only 0.01%–0.1% of model parameters are trained. Variants extend this by placing trainable prefixes at every transformer layer (Prefix Tuning), adding residual connections (Residual Prompt Tuning), decomposing embeddings for efficiency (DePT), and routing through multiple soft prompts via MoE (Sparse Mixture-of-Prompts). The key advantage over discrete prompts is that gradient optimization can encode task-specific information that human-readable text cannot express; the key limitation is that soft prompts are model-specific and not interpretable.

## Core Mechanism
A soft prompt is a sequence of L learnable embedding vectors (typically L=10–100) concatenated to the beginning of the tokenized input embeddings. During training, gradient descent updates only these vectors, minimizing task loss. The frozen model's attention layers can attend to soft prompt positions, allowing the soft tokens to act as latent conditioning signals. Prefix Tuning (Li & Liang, 2021) extends the soft prompt to every transformer layer — each layer receives its own trainable prefix key-value pairs — giving stronger conditioning at the cost of more trainable parameters (0.1%–1%). P-Tuning targets encoder-based models; P-Tuning v2 extends prefix tuning across all layers for NLU tasks. Residual Prompt Tuning adds residual connections between the input embedding and the soft prompt, improving gradient flow. DePT (Decomposed Prompt Tuning) factorizes the soft prompt embedding matrix for parameter efficiency. Sparse Mixture-of-Prompts maintains multiple soft prompt candidates with an MoE router selecting among them per input, enabling specialization across input types.

## Application in Skill Context
Soft prompt tuning is not directly applicable to prompt engineering skills that operate via API (since API access provides no gradient access). Its relevance to skill design is indirect: understanding that gradient-optimized prompts can outperform human-crafted prompts for specific tasks informs when to escalate from manual prompt engineering to fine-tuning approaches. For the epiphany-prompt skill, the practical implication is recognizing the ceiling of discrete prompt optimization: if manual and APO-based improvement reaches a plateau, soft prompt tuning via fine-tuning API (when available) is the next escalation step. The non-transferability limitation is a key design constraint — any soft-tuned prompts built for one model version cannot be reused when the model is updated, requiring re-optimization. Skill documentation should flag this limitation explicitly when recommending soft prompting as an enhancement path.

## Key Variants / Parameters
- **Prompt length L**: 10 (minimal, fast training) to 100 (stronger conditioning, more parameters)
- **Placement**: input-only (standard soft prompt) vs. all-layer (Prefix Tuning, stronger but costlier)
- **Parameterization**: dense matrix (standard) vs. decomposed (DePT, more efficient) vs. residual (better gradient flow)
- **Multi-prompt routing**: single soft prompt vs. Sparse Mixture-of-Prompts with MoE router
- **Base model architecture**: encoder-only (P-Tuning), decoder-only (standard soft prompt), encoder-decoder (Prefix Tuning)

## Related KB Entries
- enhancement/automatic-prompt-optimization.md
- synthesis/mixture-of-experts.md
