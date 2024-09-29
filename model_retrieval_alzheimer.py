import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import f1_score
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
import pickle
import os
import getpass

def run_model(myframe):

    num_tests = 25
    cols_per_test = 18

    df = pd.read_csv("data.csv")
    df = df.drop("ID", axis=1)

    df["class"] = df["class"].replace({'P': 1, 'H': 0})

    tot = 0
    tests = [3,4,10,13,14,15,18,23]
    model_sequence = [
        'RF', 'LR', 'LR', 'RF', 'RF', 'RF', 'LR', 'LDA', 'RF', 'RF', 'GNB', 'LR', 
        'RF', 'RF', 'RF', 'RF', 'RF', 'RF', 'RF', 'RF', 'RF', 'RF', 'LR', 'LR', 'RF'
    ]


    df1 = pd.DataFrame()
    df2 = myframe
    desktop_dir = 'models/'
    for i in range(1,26):
        if i in tests:
            df1['air_time'+str(i)] = df2['air_time'+str(i)]
            df1['disp_index'+str(i)] = df2['disp_index'+str(i)]
            df1['gmrt_in_air'+str(i)] = df2['gmrt_in_air'+str(i)]
            df1['gmrt_on_paper'+str(i)] = df2['gmrt_on_paper'+str(i)]
            df1['max_x_extension'+str(i)] = df2['max_x_extension'+str(i)]
            df1['max_y_extension'+str(i)] = df2['max_y_extension'+str(i)]
            df1['mean_acc_in_air'+str(i)] = df2['mean_acc_in_air'+str(i)]
            df1['mean_acc_on_paper'+str(i)] = df2['mean_acc_on_paper'+str(i)]
            df1['mean_gmrt'+str(i)] =  df2['mean_gmrt'+str(i)]
            df1['mean_jerk_in_air'+str(i)] = df2['mean_jerk_in_air'+str(i)]
            df1['mean_jerk_on_paper'+str(i)] = df2['mean_jerk_on_paper'+str(i)]
            df1['mean_speed_in_air'+str(i)] = df2['mean_speed_in_air'+str(i)]
            df1['mean_speed_on_paper'+str(i)] = df2['mean_speed_on_paper'+str(i)]
            df1['num_of_pendown'+str(i)] = df2['num_of_pendown'+str(i)]
            df1['paper_time'+str(i)] = df2['paper_time'+str(i)]
            df1['pressure_mean'+str(i)] = df2['pressure_mean'+str(i)]
            df1['pressure_var'+str(i)] = df2['pressure_var'+str(i)]
            df1['total_time'+str(i)] = df2['total_time'+str(i)]
        else:
            df1['air_time'+str(i)] = 0
            df1['disp_index'+str(i)] = 0
            df1['gmrt_in_air'+str(i)] = 0
            df1['gmrt_on_paper'+str(i)] = 0
            df1['max_x_extension'+str(i)] = 0
            df1['max_y_extension'+str(i)] = 0
            df1['mean_acc_in_air'+str(i)] = 0
            df1['mean_acc_on_paper'+str(i)] = 0
            df1['mean_gmrt'+str(i)] = 0
            df1['mean_jerk_in_air'+str(i)] = 0
            df1['mean_jerk_on_paper'+str(i)] = 0
            df1['mean_speed_in_air'+str(i)] = 0
            df1['mean_speed_on_paper'+str(i)] = 0
            df1['num_of_pendown'+str(i)] = 0
            df1['paper_time'+str(i)] = 0
            df1['pressure_mean'+str(i)] = 0
            df1['pressure_var'+str(i)] = 0
            df1['total_time'+str(i)] = 0

    for i in range(1,3):
        df1['air_time'+str(i)] = 0
        df1['disp_index'+str(i)] = 0
        df1['gmrt_in_air'+str(i)] = 0
        df1['gmrt_on_paper'+str(i)] = 0
        df1['max_x_extension'+str(i)] = 0
        df1['max_y_extension'+str(i)] = 0
        df1['mean_acc_in_air'+str(i)] = 0
        df1['mean_acc_on_paper'+str(i)] = 0
        df1['mean_gmrt'+str(i)] = 0
        df1['mean_jerk_in_air'+str(i)] = 0
        df1['mean_jerk_on_paper'+str(i)] = 0
        df1['mean_speed_in_air'+str(i)] = 0
        df1['mean_speed_on_paper'+str(i)] = 0
        df1['num_of_pendown'+str(i)] = 0
        df1['paper_time'+str(i)] = 0
        df1['pressure_mean'+str(i)] = 0
        df1['pressure_var'+str(i)] = 0
        df1['total_time'+str(i)] = 0
        
    for i in tests:
        model_filename = f'model_test_{i}_KNN.pkl'
        model_filepath = os.path.join(desktop_dir, model_filename)
        with open(model_filepath, 'rb') as file:
            loaded_model = pickle.load(file)
        tester1 = df1.iloc[:, (i-1) * cols_per_test:(i) * cols_per_test].values.reshape(1,-1)
        distance, index = loaded_model.kneighbors(tester1)
        true_val = df.iloc[[index[0][0]]]
        df1['gmrt_in_air'+str(i)] = true_val['gmrt_in_air'+str(i)].values[0]
        df1['mean_acc_in_air'+str(i)] = true_val['mean_acc_in_air'+str(i)].values[0]
        df1['mean_gmrt'+str(i)] = true_val['mean_gmrt'+str(i)].values[0]
        df1['mean_jerk_in_air'+str(i)] = true_val['mean_jerk_in_air'+str(i)].values[0]
        df1['mean_jerk_on_paper'+str(i)] = true_val['mean_jerk_on_paper'+str(i)].values[0]
        df1['mean_speed_in_air'+str(i)] = true_val['mean_speed_in_air'+str(i)].values[0]
        df1['pressure_var'+str(i)] = true_val['pressure_var'+str(i)].values[0]
        
        true_val.to_csv('tester.csv', index=False)
    df1.to_csv('updated_final_row_tests.csv', index=False)
        
    tests = [2,3,9,12,13,14,17,22]
    for j in range (1):
        
        tester = df1.loc[0]
        
        tester_pred = []
        
        for i in range(25):
            if i not in tests:
                tester_pred.append(0)
                continue
            tester_features = tester.iloc[i * cols_per_test:(i + 1) * cols_per_test].values.reshape(1, -1)
        
            model_filename = f'model_test_{i+1}_{model_sequence[i]}.pkl'
            model_filepath = os.path.join(desktop_dir, model_filename)
            with open(model_filepath, 'rb') as file:
                loaded_model = pickle.load(file)
            # Predict using the trained pipeline for the current test
            tester_prediction = loaded_model.predict(tester_features)
            tester_pred.append(tester_prediction[0])
            #print(f"Prediction for 'tester' on Test {i+1}: {tester_prediction[0]}")
        
        combined_predictions = np.round((tester_pred[2]+tester_pred[19]+tester_pred[18]+tester_pred[12]+tester_pred[9]+tester_pred[3]+tester_pred[14]+tester_pred[13])/8)
        return combined_predictions
        if combined_predictions == 0:
            tot += 1    # true_val.to_csv('/Users/aditya/Downloads/tester.csv', index=False)
