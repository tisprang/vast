#!/bin/bash
set -e

# Make sure the server is running
ollama serve &
sleep 3

# 1. Pull base model
ollama pull llama3.3:70b
wait
