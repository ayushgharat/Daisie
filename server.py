from flask import Flask, jsonify, request
from data_trans import process_strokes_data
from flask_cors import CORS
from model_retrieval_alzheimer import run_model

app = Flask(__name__)
CORS(app)

# Define an endpoint
@app.route('/process', methods=['POST'])
def receive_data():
    
    try:
        # Get the JSON input
        data = request.json
        # Process the strokes data using the function in app_logic.py
        final_df = process_strokes_data(data)
        response = run_model(final_df)
        print(response)


        # Return the DataFrame as a CSV file
        if(response == 0.0): 
            return jsonify({"result": "negative"})
        else:
            return jsonify({"result": "positive"})

    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)