from flask import Flask, request, jsonify, Response
from flask_cors import CORS
from google import genai
from langchain_ollama import OllamaEmbeddings
from langchain_chroma import Chroma
import pickle

app = Flask(__name__)
CORS(app)

client = genai.Client(api_key='AIzaSyBd6kcJdGpr-wFBlFm_XflPkpklSOgWeGU')

persist_dir = './chroma_db'

with open('chunks.dat', 'rb') as file:
    chunks = pickle.load(file)

vector_store = Chroma(
    embedding_function=OllamaEmbeddings(model='qwen3-embedding:4b', keep_alive=0),
    persist_directory=persist_dir
)

def prompt(query: str):
    context_ls = vector_store.similarity_search(
        query=query,
        k=1
    )
    
    txt = ''
    for i in context_ls:
        i.id = None
        index = chunks.index(i)
        txt += chunks[index-1].page_content + '\n' + chunks[index].page_content + '\n' + chunks[index+1].page_content + '\n'
        
    prm = f'''
    You are a helpful assistant. Don't hallucinate. 
    This is the question: {query}
 
    Answer the question with the given context using clear Markdown structural formatting (like bolding, lists, and headers where appropriate). Use double newlines between paragraphs.

    Context:
    {txt}

    Please stick to the information given in the context, do not deviate or change.
    '''
    
    response_stream = client.models.generate_content_stream(
        model='gemini-2.5-flash',
        contents=prm
    )
    
    for chunk in response_stream:
        if chunk.text:
            # Safely swap raw newline characters out for an explicit text token flag 
            # so the SSE network stream layer never swallows them.
            safe_text = chunk.text.replace('\n', '[NEWLINE]')
            yield f'data: {safe_text}\n\n'


@app.route('/api/query/', methods=['POST'])
def handle_query():
    data = request.json
    user_query = data.get('query', '')

    if not user_query:
        return jsonify({'error': 'No Query provided'}), 400
    
    response = prompt(user_query)
    return Response(response, mimetype='text/event-stream')

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000, debug=True)