#!/bin/bash
set -e

# Make sure the server is running
ollama serve &
sleep 3

# 1. Pull base model
ollama pull llama3.1:8b

# 2. Export modelfile
ollama show llama3.1:8b --modelfile > myllama.modelfile

# 3. Insert PARAMETER line at the top OR after FROM <model>
# Insert after FROM line, which is safest:
sed -i '/^FROM /a PARAMETER num_ctx 131072' myllama.modelfile

# 4. Create the new extended context model
ollama create llama3.1:8b-128k --file myllama.modelfile

# Prevent background server from exiting early
wait
