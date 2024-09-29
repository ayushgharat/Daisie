from flask import Flask, jsonify, request

app = Flask(__name__)

# Define an endpoint
@app.route('/api/hello', methods=['GET'])
def hello_world():
    return jsonify(message="Hello, World!")

# Another endpoint with a parameter
@app.route('/api/greet/<name>', methods=['GET'])
def greet(name):
    return jsonify(message=f"Hello, {name}!")

# POST endpoint example
@app.route('/api/data', methods=['POST'])
def receive_data():
    data = request.json
    return jsonify(received_data=data)

if __name__ == '__main__':
    app.run(debug=True)