#!/bin/bash
set -e

# Make sure the server is running
ollama serve &
sleep 3

# Models to process (base_model:new_model_name)
MODELS=(
  "llama3.1:7b llama3.1:7b-16k"
  "llama3.3:70b llama3.3:70b-16k"
  "deepseek-r1:32b deepseek-r1:32b-16k"
  "deepseek-r1:70b deepseek-r1:70b-16k"
  "gemma3:12b gemma3:12b-16k"
  "gemma3:27b gemma3:27b-16k"
  "qwen3:8b qwen3:8b-16k"
  "qwen3:32b qwen3:32b-16k"
  "mistral:7b mistral:7b-16k"
  "mixtral:8x7b mixtral:8x7b-16k"
)

for entry in "${MODELS[@]}"; do
  set -- $entry
  BASE="$1"
  TARGET="$2"

  echo "========================================"
  echo " Processing model: $BASE → $TARGET"
  echo "========================================"

  # 1. Pull the base model
  ollama pull "$BASE"

  # 2. Export its modelfile
  MODFILE="${BASE//[:]/_}.modelfile"
  ollama show "$BASE" --modelfile > "$MODFILE"

  # 3. Insert the context parameter (16384 tokens)
  sed -i '/^FROM /a PARAMETER num_ctx 16384' "$MODFILE"

  # 4. Create the extended-context model
  ollama create "$TARGET" --file "$MODFILE"
done

# Prevent background server from exiting early
wait
