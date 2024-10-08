# Flask Server Setup

## Prerequisites

Before you begin, make sure you have the following installed on your system:

- **Python** (version 3.7 or higher): Download and install Python from [python.org](https://www.python.org/).
- **pip**: Python's package installer, which is typically included with Python. You can verify installation by running:
  ```bash
  pip --version
  ```

## Setup Instructions

### 1. Clone the repository

Clone the repository to your local machine:

```bash
git clone https://github.com/ayushgharat/Daisie.git
```

Navigate to the project directory:

```bash
cd daisie/backend
```

### 2. Set up a virtual environment (optional but recommended)

It’s a good practice to use a virtual environment to manage dependencies for your Python project. To create a virtual environment:

```bash
python3 -m venv venv
```

Activate the virtual environment:

- On macOS and Linux:
  ```bash
  source venv/bin/activate
  ```
- On Windows:
  ```bash
  venv\Scripts\activate
  ```

### 3. Install dependencies

Install the required Python packages using `pip`:

```bash
pip install -r requirements.txt
```

### 4. Run the Flask server

To run the Flask development server, use the following command:

```bash
export FLASK_APP=server.py
export FLASK_ENV=development  # This enables debug mode
flask run
```

On Windows, the `export` commands are different:

```bash
set FLASK_APP=server.py
set FLASK_ENV=development
flask run
```

The server should start on `http://127.0.0.1:5000/`.

### 5. Access the Flask server

Once the server is running, you can open your browser and navigate to:

```
http://127.0.0.1:5000/
```

This should display your Flask application.

## Deactivating the virtual environment

When you're done working on your project, you can deactivate the virtual environment by running:

```bash
deactivate
```

## Troubleshooting

- If you get a module not found error, ensure that all dependencies are installed by running:
  ```bash
  pip install -r requirements.txt
  ```
- If the Flask server doesn't start, make sure that the `FLASK_APP` environment variable is set to the correct file (e.g., `server.py`).
