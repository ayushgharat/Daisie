from flask import Flask, jsonify, request

app = Flask(__name__)

# Define an endpoint
@app.route('/process', methods=['POST'])
def receive_data():
    data = request.json

    # Initialize the objects
    parkinson = None
    remaining_questions = []

    # Iterate through the data to separate the objects
    for item in data:
        if item.get("questionNo") == "26":
            parkinson = item
        else:
            remaining_questions.append(item)

    
    return jsonify(message="Data Recieved")


if __name__ == '__main__':
    app.run(debug=True)