from flask import Flask, jsonify, request
from data_trans import process_strokes_data
from flask_cors import CORS
import json
from model_retrieval_alzheimer import run_model
from chatbot_logic import interact_with_user
from parkinson import park_model

app = Flask(__name__)
CORS(app)

# Define an endpoint
@app.route('/process', methods=['POST'])
def receive_data():
    
    try:
        # Get the JSON input
        json_data = request.json

        # Load the JSON data into a Python list
        # data = json.loads(json_data)

        # # Initialize the variables to hold the desired result
        # parkinson_object = None
        alzheimers_list = []

        # # Iterate through the list of objects
        # # for obj in data:
        # #     if obj.get("questionNo") == 26:
        # #         parkinson_object = obj
        # #     else:
        # #         alzheimers_list.append(obj)

        for i in range(0, len(json_data)):
            if json_data[i]['questionNo'] == '26':
                # parkinson_object = json_data[i]
                continue
            else:
                alzheimers_list.append(json_data[i])

        # print(parkinson_object)
        # print(alzheimers_list)        

        # Process the strokes data using the function in app_logic.py
        final_df = process_strokes_data(alzheimers_list)
        response = run_model(final_df)

        park_response = park_model(json_data)
        # park_response = None
        print(park_response)

        # Return the DataFrame as a CSV file
        if(int(response) == 0): 
            return jsonify({"alzheimer": "negative", "parkinson": park_response})
        else:
            return jsonify({"alzheimer": "positive", "parkinson": park_response})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Define the /chat endpoint
@app.route('/chat', methods=['POST'])
def chat():
    data = request.json

    print(data)
    
    # Extract necessary information from the request
    user_input = data.get('user_input')
    chat_history = data.get('chat_history', [])
    model_output_alz = data.get('model_output_alz')
    model_output_park = data.get('model_output_park')
    
    # Call the interact_with_user function with the inputs
    ai_response = interact_with_user(user_input, chat_history, model_output_alz, model_output_park)
    
    # Return the AI response
    return jsonify({'ai_response': ai_response})


if __name__ == '__main__':
    app.run(debug=True)