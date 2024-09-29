from flask import Flask, jsonify, request

app = Flask(__name__)

# Define an endpoint
@app.route('/process', methods=['POST'])
def receive_data():
    data = request.json
    print(data)
    return jsonify(message="Data Recieved")


if __name__ == '__main__':
    app.run(debug=True)