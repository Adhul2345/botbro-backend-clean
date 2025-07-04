#!/bin/bash

# Create project root
mkdir -p botbro-backend
cd botbro-backend || exit

# Create root files
touch app.py requirements.txt config.py

# Create folders and files
mkdir -p memory llm utils data

touch memory/chat_memory.py
touch llm/groq_llm.py
touch utils/formatter.py
touch data/memory.json

# Add default memory file content
echo "[]" > data/memory.json

echo "✅ BotBro backend structure created!"
tree .
