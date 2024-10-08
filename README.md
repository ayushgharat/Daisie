# Hello Daisie

## 💡 Inspiration

The early detection of neurodegenerative diseases like Alzheimer’s and Parkinson’s is critical in managing and potentially slowing their progression. Handwriting is an under-explored diagnostic tool that can reveal key cognitive and motor changes. Inspired by the potential to use everyday tools like an iPad to track subtle handwriting patterns, we set out to build an accessible, AI-driven app that assists in early detection. By leveraging cutting-edge machine learning and natural language processing (NLP), we aim to provide a digital health solution that bridges technology and healthcare.

## ⚙️ What it does

Our app allows users to complete a series of cognitive and motor tasks using an iPad and an Apple Pencil. These tasks are based on well-researched benchmarks for detecting early signs of Alzheimer’s and Parkinson’s diseases. Once the user completes the tasks, the app processes the handwriting data through machine learning models trained on the DARWIN dataset to predict whether the user shows symptoms of Alzheimer’s or Parkinson’s.

After the prediction, an AI chatbot engages the user, asking additional targeted questions to refine the assessment based on their symptoms, medical history, and lifestyle. This interactive step allows for a more personalized assessment, enhancing the accuracy of the predictions by combining AI-driven analysis with user input.

## 🛠️ How we built it

- **Xcode** & **Swift**: The app was developed using `Xcode` with `Swift` as the core front-end language.

- **PencilKit for Data Collection**: `PencilKit` was used to collect stroke data such as speed, pressure, and tilt in real time. This raw data provided the basis for extracting features used to predict neurodegenerative conditions.

- **DARWIN Dataset & Paper Analysis**: We thoroughly studied the `DARWIN` dataset and the accompanying research paper by UCI to understand their data collection methodology and translate it to our app.

- **Data Preprocessing with Pandas & NumPy**: After collecting raw handwriting data, `Pandas` and `NumPy` were used to preprocess and extract key features, including on-paper metrics (speed, jerk, pendowns) and in-air hover metrics.

- **SciKit-Learn for Machine Learning Models**: We used `SciKit-Learn` to build 30 optimized models like `Random Forest`, `Decision Trees`, `Logistic Regression`, and `Convolutional Neural Networks`. These models were fine-tuned to predict early signs of Alzheimer’s and Parkinson’s based on handwriting features.

- **Handling Missing Features with Nearest Neighbors**: Features that were not directly extractable were estimated from the dataset using the `Nearest Neighbors` model. This allowed the test to emulate previously collected data and provide accurate results.

- **Flask Backend for API and Chatbot**: The backend, built with `Flask`, managed the prediction pipeline and chatbot interaction. It processed handwriting data, ran predictions, and communicated results to users in real-time.

- **LangChain & OpenAI for AI Chatbot**: After predictions, `LangChain` and `OpenAI`’s `GPT` were used to power a chatbot that asks follow-up questions based on model output. The chatbot provides a conversational layer to refine diagnosis based on user inputs.

- **Testing and Evaluation**: The model was rigorously tested with 100 epochs, and its performance was evaluated on both seen and unseen data. This comprehensive testing resulted in the reported accuracy, precision, recall, and F1 scores.

## ⛔ Challenges we ran into

- **Data Scaling**: One of the primary challenges was scaling the collected `Apple Pencil` data to match the `DARWIN` dataset. The scales and units for certain features, like stroke speed and jerk, needed precise alignment to ensure the iPad and DARWIN data worked together seamlessly in our models.

- **Apple PencilKit Stroke Data**: Working with `PencilKit` to capture accurate stroke data was challenging. The iPad's stroke data only provided a subset of the features we needed, particularly when compared to DARWIN's dataset, which included more detailed in-air movement metrics.

- **Learning Xcode**: For some team members, working with `Xcode` was a steep learning curve. Setting up the environment, learning `SwiftUI`, and integrating `PencilKit` took time and required troubleshooting various issues with iPad data collection.

- **Model Overfitting**: During model training, we initially faced overfitting, where our models performed well on training data but struggled on unseen test data. This required fine-tuning the model with additional regularization techniques and testing it rigorously.

- **Derived Features and Missing Hover Data**: We couldn't capture certain features from the iPad, like hover data or fine-grained pen tilt information, as these required specific hardware that wasn't available. We overcame this using a `Nearest Neighbors` model to estimate missing data based on similar features that were available.

## 🏆 Accomplishments that we're proud of

- **iPad Feature Extraction**: Successfully bridging the gap between the iPad's stroke data and the `DARWIN` dataset was a major achievement. We used techniques to map iPad handwriting data onto features that were previously only available from advanced lab equipment.

- **Selective Task Optimization**: Although the original research paper suggested 25 handwriting tasks, we identified the 8 most critical tasks that provided high accuracy through machine learning analysis, improving the model's efficiency while maintaining strong predictive performance.

- **Creating a Publicly Available Diagnostic Tool**: Developing a non-invasive tool for detecting Alzheimer's and Parkinson's, available to the public, is something we're proud of. Most diagnostic tools focus on memory tests or written questionnaires, but our tool includes handwriting analysis, which is a crucial indicator of motor function deterioration.

- **Optimizing Model Hyperparameters**: We achieved impressive model performance by carefully tuning hyperparameters such as learning rates, regularization values, and batch sizes to prevent overfitting and optimize accuracy on test data. F1 scores as high as 92% were achieved across all 20 models implemented.

- **Implementing Accurate Test Functionality**: We built various test functionalities, including accurate timing of tests, speech synthesis to guide users, and overlay drawing features for comparison. These allowed us to create a seamless experience for users taking cognitive assessments.


## 📝 What we learned

- **Apple PencilKit Mastery**: We became proficient in utilizing `Apple’s PencilKit` framework, successfully extracting detailed handwriting stroke data and turning it into critical diagnostic features.

- **Data Scaling Across Devices**: We learned how to scale and normalize data between `iPad`-generated features and the `DARWIN` dataset, ensuring compatibility and consistency across different devices.

- **Model Overfitting Prevention**: By applying advanced techniques and hyperparameter tuning, we effectively managed model overfitting, which significantly boosted the accuracy of our diagnostic predictions.

- **Clustering for Feature Extrapolation**: We developed and refined clustering techniques, specifically using `Nearest Neighbors` to estimate missing features like air movements (hover data) to bridge the gap between available and missing data from different devices.

- **Xcode and Swift UI Proficiency**: Building this app enhanced our skills in `Xcode` and `Swift UI`, allowing us to design and implement a user-friendly and efficient interface for test administration.

- **Research-Driven Development**: By integrating insights from the `DARWIN` dataset and research paper, we applied rigorous academic principles into a practical, user-friendly iPad app, successfully translating research into real-world diagnostics.


## ✈️ What's next for DAISIE

- **Use a Later iPad Version to Get Hover Data**: Future iterations of our app will incorporate newer iPad models capable of capturing hover data, allowing us to derive even more comprehensive features from `PencilKit`.

- **Make It Compatible for Other Tablets**: We plan to expand the app’s compatibility beyond `iPads` to other tablet devices, enabling broader accessibility and usage across different platforms.

- **Expand to More Neurological Diseases**: Our vision includes extending the app’s diagnostic capabilities to cover a wider range of neurodegenerative diseases, providing early detection tools for conditions beyond `Alzheimer’s` and `Parkinson’s`.

- **Refine Models for Enhanced Accuracy**: Continuous refinement of our clustering and machine learning models will be a priority, ensuring more accurate predictions and better generalization to real-world scenarios.
