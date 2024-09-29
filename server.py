from flask import Flask, jsonify, request
from data_trans import process_strokes_data
from flask_cors import CORS
import json
from model_retrieval_alzheimer import run_model

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

        # Initialize the variables to hold the desired result
        parkinson_object = None
        alzheimers_list = []

        # Iterate through the list of objects
        # for obj in data:
        #     if obj.get("questionNo") == 26:
        #         parkinson_object = obj
        #     else:
        #         alzheimers_list.append(obj)

        for i in range(0, len(json_data)):
            if json_data[i]["questionNo"] == 26:
                parkinson_object = json_data[i]
            else:
                alzheimers_list.append(json_data[i])

        print(parkinson_object)
        print(alzheimers_list)        

        # Process the strokes data using the function in app_logic.py
        final_df = process_strokes_data(json.dumps(alzheimers_list))
        response = run_model(final_df)
        print("Final Score")
        print(response)


        # Return the DataFrame as a CSV file
        if(int(response) == 0): 
            return jsonify({"result": "negative"})
        else:
            return jsonify({"result": "positive"})

    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)