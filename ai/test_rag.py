
from rag_pipeline import answer_from_knowledge_base

questions = [
    "How is on-time delivery rate calculated?",
    "How many orders were cancelled?",
    "What are the limitations of this dataset?",
    "What is the proposed operational experiment?",
]

for question in questions:
    print("\n" + "=" * 60)
    print("QUESTION:", question)
    print("=" * 60)
    print(answer_from_knowledge_base(question))
