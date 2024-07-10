from flask import Flask, request, jsonify
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer # type: ignore
from sklearn.model_selection import train_test_split # type: ignore
from sklearn.naive_bayes import MultinomialNB # type: ignore
from sklearn.metrics import accuracy_score# type: ignore
import joblib # type: ignore
import random

app = Flask(__name__)

vectorizer = TfidfVectorizer()

@app.route('/train', methods=['GET'])
def train_model():
    df = pd.read_csv('user_queries.csv')
    X = vectorizer.fit_transform(df['question'])
    y = df['class']
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    model = MultinomialNB()
    model.fit(X_train, y_train)
    y_pred = model.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)
    joblib.dump(model, 'model.joblib')
    joblib.dump(vectorizer, 'vectorizer.joblib')
    return jsonify({'message': 'Model trained', 'accuracy': accuracy})

greetings = ['hi', 'hey', "what's up", "hello","hello there","hi there","hey there","hi!","hey!","hello!","hello there!","hi there!","hey there!","what's up","whats up"]
responses = [
    "Hi! What can I help you with?",
    "Hello there! How can I assist you today?",
    "Hey! Looking for some help?",
    "Hi! What questions do you have?",
    "Hello! How can I help you today?",
]

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    question = data['question'].lower()  # Convert to lowercase to handle case variations

    # Initialize response variables
    predicted_class = None
    max_probability = 0

    # Check if the question is a greeting
    if question in greetings:
        response_message = random.choice(responses)  # Select a random response
        return jsonify({'prediction': response_message})
    else:
        loaded_model = joblib.load('model.joblib')
        loaded_vectorizer = joblib.load('vectorizer.joblib')
        vectorized_question = loaded_vectorizer.transform([question])
        probabilities = loaded_model.predict_proba(vectorized_question)
        max_probability = max(probabilities[0])

        # Define a threshold for classification confidence
        confidence_threshold = 0.5  # Adjust based on your model and needs

        if max_probability < confidence_threshold:
            response_message = 'Ask questions related to your plant'
            return jsonify({'prediction': response_message})
        else:
            predicted_class = loaded_model.classes_[probabilities[0].argmax()]

    return jsonify({'prediction': predicted_class, 'confidence': max_probability,'status':200})


if __name__ == '__main__':
    app.run(debug=True)

# WAN: 10.136.61.223
# LAN: 192.168.0.1