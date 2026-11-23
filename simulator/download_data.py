from datasets import load_dataset
import json

sst = load_dataset("stanfordnlp/sst2", split="train")

with open("corpus.jsonl", "w", encoding="utf-8") as f:
  for row in sst:
    # Format into payload shape
    f.write(json.dumps({"text": row["sentence"]}) + "\n")
