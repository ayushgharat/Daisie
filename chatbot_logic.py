import os
from dotenv import load_dotenv
from langchain_community.chat_models import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from langchain.chains import LLMChain

# Load environment variables
load_dotenv()

# Access API keys
openai_key = os.getenv('OPENAI_API_KEY')
langsmith_api = os.getenv('LANGCHAIN_API_KEY')

# Set API keys for environment
os.environ['OPENAI_API_KEY'] = openai_key
os.environ["LANGCHAIN_TRACING_V2"] = "true"
os.environ["LANGCHAIN_ENDPOINT"] = "https://api.langchain.plus"
os.environ["LANGCHAIN_API_KEY"] = langsmith_api

# Initialize LLM model
llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)

# Load context files
with open('alzheimer_context.txt', 'r') as file:
    alzheimer_context = file.read()

with open('alzheimer_testing.txt', 'r') as file:
    alzheimer_testing = file.read()

with open('research_paper.txt', 'r') as file:
    research_paper = file.read()

with open('app_model_description.txt', 'r') as file:
    app_model_description = file.read()

# Function to create chat history string
def create_prompt(chat_history):
    chat_history_str = "\n".join([f"{key}: {value}" for entry in chat_history for key, value in entry.items()])
    return chat_history_str

# Build the prompt with all the context and instructions
def build_prompt(chat_history, model_output_alz, model_output_park):
    chat_history_str = create_prompt(chat_history)
    
    prompt = f"""
    Context for the Chatbot you are designed to serve as:
    Our app is designed to help detect early signs of Alzheimer’s disease through handwriting analysis. 
    Users complete a series of 8 tasks on an iPad, which assess various cognitive and motor functions like writing, copying, and memory recall.
    These tasks are based on research from the DARWIN dataset, which has been shown to reveal early indicators of Alzheimer’s.
    After completing the tasks, the app processes the data through a machine learning model to generate a prediction on whether the user may be showing signs of Alzheimer's.
    Once the model provides its result, you (the chatbot) will interact with the user by asking a few additional lifestyle and health-related questions to further refine the assessment.

    Your task is to:
    1. Ask a few targeted questions (up to 5).
    2. Review the chat history each time to see how many questions have been asked.
    3. If fewer than 5 questions have been asked, ask another question based on the categories:
       - Clarifying symptoms (e.g., memory loss, confusion)
       - Medical history (family history, head trauma)
       - Lifestyle and cognitive engagement (mental activities, social interaction)
       - Medication and general health (medications, mood changes)
       - Daily functioning (managing tasks, decision-making)
    4. If 5 questions have been asked, provide a final recommendation starting with: "Thanks for taking the test and answering my questions." And in this final recommendation, mention Parkinson. We have a Parkinson test too at the end, and that result is shared with you.

    Below you are also given further information about Alzheimer's to help you out, the research paper the model is based on, the model's result (which is very important), and more detail on our app:

    General Alzheimer's information: {alzheimer_context}
    Alzheimer's testing information: {alzheimer_testing}
    Research Paper Details: {research_paper}
    Our app details: {app_model_description}

    Alzheimer's Model Result: {model_output_alz}
    Parkinson's Model Result: {model_output_park}

    Chat History:
    {chat_history_str}
    """
    return prompt

# LLM Chain for interacting with the chatbot
def interact_with_user(user_input, chat_history, model_output_alz, model_output_park):
    # Add user input to chat history
    chat_history.append({"Human": user_input})

    # Create prompt including the chat history and model outputs
    prompt = build_prompt(chat_history, model_output_alz, model_output_park)

    # Initialize LLM Chain
    template = ChatPromptTemplate.from_template(prompt)
    # chain_qa = LLMChain(llm=llm, prompt=template, output_key="answer")
    chain_qa = prompt | llm

    # Get the LLM response
    result = chain_qa.invoke({"input": user_input})
    
    # Add AI response to chat history
    chat_history.append({"AI": result["answer"]})
    
    return result["answer"]
