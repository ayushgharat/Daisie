from flask import Flask, jsonify, request
from data_trans import process_strokes_data
from flask_cors import CORS

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

        # Return the DataFrame as a CSV file
        """response = make_response(final_df.to_csv(index=False))
        response.headers["Content-Disposition"] = "attachment; filename=metrics.csv"
        response.headers["Content-Type"] = "text/csv"
        return response"""
        return jsonify({"message": "This is a success!"})

    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)