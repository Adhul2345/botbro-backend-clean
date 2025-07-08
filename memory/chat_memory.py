import json
import os

class ChatMemory:
    def __init__(self, session_id="default", memory_dir="data"):
        self.session_id = session_id
        self.memory_dir = memory_dir
        self.memory_file = os.path.join(self.memory_dir, f"{self.session_id}.json")
        self.memory = []
        self.save_memory()
        self.load_memory()

    def add_message(self, role, content):
        # Convert 'bot' to 'assistant' for consistency
        if role == "bot":
            role = "assistant"
        self.memory.append({"role": role, "content": content})
        self.save_memory()

    def get_memory(self):
        return self.memory

    def get_messages(self):
        return self.memory

    def save_memory(self):
        os.makedirs(self.memory_dir, exist_ok=True)
        with open(self.memory_file, 'w') as f:
            json.dump(self.memory, f, indent=2)

    def load_memory(self):
        if os.path.exists(self.memory_file):
            with open(self.memory_file, 'r') as f:
                self.memory = json.load(f)

            # 🔥 Fix legacy 'bot' roles
            for message in self.memory:
                if message["role"] == "bot":
                    message["role"] = "assistant"
            self.save_memory()
        else:
            self.memory = []
