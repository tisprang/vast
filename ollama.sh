#!/bin/bash
ollama serve &
sleep 3
ollama pull smollm2:135m
wait
