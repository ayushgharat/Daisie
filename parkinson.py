import matplotlib.pyplot as plt
import json
import cv2
import numpy as np
import pickle

def park_model(json_dat):
    json_data = json_dat
    for i in range(0,len(json_data)):
        if json_data[i]['questionNo'] == '26':
            break
    json_data = json_data[i]['strokes']
    # Function to plot the strokes
    fig, ax = plt.subplots(figsize=(10, 8))
    fig.patch.set_facecolor('white')  # Set figure background to white
    ax.set_facecolor('white')
    
        # Loop through each stroke and plot the points
    for stroke_index, stroke in enumerate(json_data):
        x_values = [point['x'] for point in stroke['points']]
        y_values = [point['y'] for point in stroke['points']]
    
            # Plot each stroke with a different color and label
        ax.plot(x_values, y_values, color = 'black', linewidth = 4)
    
        # Add labels and title
    plt.xlabel('X coordinates')
    plt.ylabel('Y coordinates')
    plt.gca().invert_yaxis()  # Invert Y-axis to match the screen-like coordinates
        
    plt.axis('off')
        
    plt.savefig('park_img.jpg', bbox_inches='tight', pad_inches=0,facecolor = 'white')
    
        # Show the plot
    plt.show()
    
    plt.close()
    
    labels = ['Healthy', 'Parkinson']
    image_healthy = cv2.imread('park_img.jpg')
#image_parkinson = cv2.imread('/content/Parkinsons_Disease_Detection_using_Parkinsons_Spiral_Drawing/dataset/test_image_parkinson.png')

    image_healthy = cv2.resize(image_healthy, (128, 128))
    image_healthy = cv2.cvtColor(image_healthy, cv2.COLOR_BGR2GRAY)
    image_healthy = np.array(image_healthy)
    image_healthy = np.expand_dims(image_healthy, axis=0)
    image_healthy = np.expand_dims(image_healthy, axis=-1)
    
    with open('parkinson_disease_detection.pkl', 'rb') as file:
                model = pickle.load(file)
    
    ypred_healthy = model.predict(image_healthy)
    
    if np.argmax(ypred_healthy[0], axis=0) == 0:
        return 'negative'
    else:
        return 'positive'