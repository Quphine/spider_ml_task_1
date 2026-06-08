### RAG - Manual Implementation
This is my first attempt to completelty understand the RAG pipeline.  
In this project, I have implemented everything from scratch except for the LLM and the Embedding model  
> This was just an experiment, not the final version so I limited the number of injested pdfs to just 1

The following are the various features that I implemented manually:
- A chunking algorithm (Basic Recursive text splitter)
- vectorize function
- DB creation and storage as pickle file
- Cosine similariy search algorithm
- Context retrieval algorithm
