
from pathlib import Path

from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity


PROJECT_ROOT = Path(__file__).resolve().parent.parent
KNOWLEDGE_BASE = PROJECT_ROOT / "knowledge_base"

MODEL_NAME = "sentence-transformers/all-MiniLM-L6-v2"

print("Loading embedding model...")
model = SentenceTransformer(MODEL_NAME)


def load_documents():
    documents = []

    for file_path in KNOWLEDGE_BASE.glob("*.md"):
        text = file_path.read_text(encoding="utf-8")
        sections = text.split("\n## ")

        for index, section in enumerate(sections):
            section = section.strip()

            if section:
                documents.append({
                    "source": file_path.name,
                    "text": section if index == 0 else "## " + section,
                })

    return documents


documents = load_documents()

if not documents:
    raise RuntimeError(
        f"No Markdown documents found in {KNOWLEDGE_BASE}"
    )

document_embeddings = model.encode(
    [document["text"] for document in documents],
    normalize_embeddings=True,
)


def answer_from_knowledge_base(question, top_k=1):
    question_embedding = model.encode(
        [question],
        normalize_embeddings=True,
    )

    scores = cosine_similarity(
        question_embedding,
        document_embeddings,
    )[0]

    best_indices = scores.argsort()[::-1][:top_k]

    results = []

    for index in best_indices:
        document = documents[index]

        results.append(
            f"Source: {document['source']}\n"
            f"Similarity: {scores[index]:.3f}\n"
            f"{document['text']}"
        )

    return "\n\n---\n\n".join(results)


if __name__ == "__main__":
    question = input("Ask a question about QuickCommerce Analytics: ")
    print("\nRelevant information:\n")
    print(answer_from_knowledge_base(question))
