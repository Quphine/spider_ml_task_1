# RAG - With Langchain and Chroma DB
## Overview
The following is the pipeline I have implemented in this project:
### Preprocessing and Chunking
- Using the pymupdf4llm module, I extracted all the elements in the pdf files in markdown syntax, and separated out image files and put them in
  another directory, (/process files/image_processing - in this repo)
- pymupdf4llm by default replaces all the images in the ouput with a specific marker ![]{}
- By using regex, these markers were identified and the images extracted earlier were passed onto a multimodal llm which inputs images and describes it
  textually. These textual descriptions were put in the place of the identified markers
- And therefore, I obtained the final markdown with images replaced with text and tables already in markdown format
- This markdown is split using MarkdownHeaderTextSplitter which chunks based on heading (to ensure coherence)
- To prevent huge chunks, I also added a recursive text splitter, to limit the size of each header chunk
- Also, metadata for each chunk is injected (source pdf, chunk no etc) by concatinating it with the chunk string to make it 'visible' for the LLM

### Embedding and Storing
- Due to token limitations, I used a basic Ollama embedding model run locally
- The chunks are vectorized and the chromaDB is built with indices and relevance trees being automatically generated
- This is stored inside /backend_py in this repo

### Retrieving Data and Output
- For the final retrieval, I used a simple Ollama LLM
- A prompt template was written
- When the user query is passed, its sent to the same embedding model that was used to create the chromaDB
- This embedding is is used to make a similarity search within the chromaDB, which returns the context
- Here due to harware contraints during experimentation, my top_k was set to 1 (Intially, but in the app its set to 2)
- The top k most relevant chunks are retreived.
- For the sake of information continuity, I also concatenated the preceeding and the succeeding chunks along with the retrieved chunk so that the model has a clearer context
- Again this might lead to context overload, but we may limit the max char length to a smaller value in the RecursiveTextSplitter
- This context is passed onto the prompt template and the response is generated.

### Frontend/Backend
-Frontend: Flutter (/frontend_flutter) in this repo  
-Backend: Python (/backend_py) in this repo
