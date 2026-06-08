I have included 3 different implementations 

1) Manual Implementation (Try 1) - Without Langchain and Manual Splitting
2) Langchain FAISS (Try 2) - Implemented with Langchain-FAISS and Basic Recursive text splitter
3) Langchain Chroma (Final) - Implemented with Langchain-Chroma and Markdown Splitter with Recursive Text splitter

The vector.db is the pickled file for the manual implementation. The full project (With FAISS and Chroma db) are included and attached in the google drive link along with the demo image.
The first two implementations are only done with one reasearch paper 'attention is all you need' while the third (final) implementation is done with all the 7 research papers provided

In the third implementation, I have extracted all images and tables from the pdf, fed them into a different LLM and retireved the description in textfual format and replaced them in the original list of chunks. So it has a rough description of text and table data as well. Due to token and hardware contraints, a full fledged high quality implementation wasn't possible, but with a better model, the method might prove plausible.

Also in the final implementation, I've set the top_k value to 1 instead of 2 or 3, which has significantly affected answer quality due to hardware constraints. If this value is increased to 2 with a better condition, answer quality will be greater. 

The front end is developed with Flutter with a python backend 
