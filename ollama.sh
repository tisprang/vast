#!/bin/bash
ollama serve &
sleep 3
ollama pull llama3.1:8b
wait
