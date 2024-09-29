from flask import Flask, request, jsonify
import pandas as pd
import json
import numpy as np
import math

#Constants
paper_width_cm = 21.0  # A4 paper width in cm
paper_height_cm = 29.7  # A4 paper height in cm
cm_per_pixel = 0.01923  # Conversion factor from pixels to cm
daisy_per_cm_x = 885.8095238095239  # Conversion factor for X-axis in Daisy units
daisy_per_cm_y = 679.1919191919192  # Conversion factor for Y-axis in Daisy units

mean_variances_dict = {
    3:  [1775.3416245494254, 102412.18401303446],
    18: [1679.7060418034484, 148805.95699385056],
    23: [1650.2875518172414, 190038.41970936782],
    13: [1758.759194358046, 121422.69492727582],
    10: [1701.2060636959773, 144647.82238397127],
    14: [1697.1729586229883, 139250.74882390804],
    4:  [1918.5667057632181, 56071.349474156894],
    15: [1586.8975904017243, 213140.62265902295]
}

question_numbers = []
dfs = []
strokes_by_test = []

def process_strokes_data(json_data):
    global question_numbers, dfs, strokes_by_test
    question_numbers = []
    dfs = []
    strokes_by_test = []

    for test_index in range(len(json_data)):  
        question_no = int(json_data[test_index]['questionNo'])
        question_numbers.append(question_no)
        test_strokes = json_data[test_index]['strokes']
        strokes_by_test.append(test_strokes)
        df = json_to_dataframe(test_strokes)
        dfs.append(df)

    final_df = create_metrics_dataframe_for_all_tests(dfs, question_numbers)
    return final_df
        
def create_metrics_dataframe_for_all_tests(dfs, test_numbers):
    final_df = pd.DataFrame()
    for i in range(len(test_numbers)):
        metrics_df = get_on_paper_metrics_as_df(dfs[i], i, test_numbers[i])
        final_df = pd.concat([final_df, metrics_df], axis=1)
    return final_df

def get_on_paper_metrics_as_df(df, i, test_number):
    metrics_list = get_on_paper_metrics(df, i, test_number)
    
    metric_names = [
        'air_time', 'disp_index', 'gmrt_in_air', 'gmrt_on_paper', 'max_x_extension', 'max_y_extension',
        'mean_acc_in_air', 'mean_acc_on_paper', 'mean_gmrt', 'mean_jerk_in_air', 'mean_jerk_on_paper',
        'mean_speed_in_air', 'mean_speed_on_paper', 'num_of_pendown', 'paper_time', 
        'pressure_mean', 'pressure_var', 'total_time'
    ]
    
    metric_names_with_test = [f"{name}{test_number}" for name in metric_names]
    metrics_df = pd.DataFrame([metrics_list], columns=metric_names_with_test)
    return metrics_df

def get_on_paper_metrics(df, i, test_number):
    # Gathering metrics that are being calculated
    mean_speed_on_paper = calculate_mean_speed_df_daisy(df)
    mean_acc_on_paper = compute_time_weighted_mean_acceleration_daisy(df)
    gmrt_on_paper = compute_gmrt_daisy(df)
    
    # SWAPPING max X and Y extensions as per your request
    max_x_extension = compute_max_y_extension_daisy(df)
    max_y_extension = compute_max_x_extension_daisy(df)
    disp_index = calculate_dispersion_index(df)
    
    # Pendown (strokes data related)
    pendown = pendowns(strokes_by_test[i])  # Use index `i` to get corresponding strokes
    
    # Pressure data processing - using question_numbers[i] for mean_variances_dict
    pressure_mean = process_pressure_data(df, mean_variances_dict[question_numbers[i]][0], mean_variances_dict[question_numbers[i]][1])
    pressure_var = 0
    
    # Paper time, total time (you likely already have a function for this)
    total_time, air_time, paper_time = calculate_times(strokes_by_test[i])

    # Setting metrics that are currently placeholders
    air_time_metric = air_time
    mean_speed_in_air = 0  # Placeholder for mean speed in air
    mean_acc_in_air = 0  # Placeholder for mean acceleration in air
    mean_jerk_in_air = 0  # Placeholder for mean jerk in air
    mean_jerk_on_paper = 0  # Placeholder for mean jerk on paper
    gmrt_in_air = 0  # Placeholder for gmrt in air
    mean_gmrt = 0
    # Packing everything into the final output list
    result_list = [
        air_time_metric,          # air_time1
        disp_index,               # disp_index1
        gmrt_in_air,              # gmrt_in_air1
        gmrt_on_paper,            # gmrt_on_paper1
        max_x_extension,          # max_x_extension1
        max_y_extension,          # max_y_extension1
        mean_acc_in_air,          # mean_acc_in_air1
        mean_acc_on_paper,        # mean_acc_on_paper1
        mean_gmrt,                # mean_gmrt1
        mean_jerk_in_air,         # mean_jerk_in_air1
        mean_jerk_on_paper,       # mean_jerk_on_paper1
        mean_speed_in_air,        # mean_speed_in_air1
        mean_speed_on_paper,      # mean_speed_on_paper1
        pendown,                  # num_of_pendown1
        paper_time,               # paper_time1
        pressure_mean,            # pressure_mean1
        pressure_var,             # pressure_var1
        total_time                # total_time1
    ]
    
    return result_list

def process_pressure_data(df, darwin_mean, darwin_variance):
    # Ensure the dataframe is sorted by time
    df = df.sort_index()

    # iPad pressure range
    ipad_min = 0
    ipad_max = 4.2

    # Calculate Darwin standard deviation from variance
    darwin_std = np.sqrt(darwin_variance)

    def normalize_ipad_data(pressure):
        return (pressure - ipad_min) / (ipad_max - ipad_min)

    def scale_to_darwin(normalized_pressure):
        return normalized_pressure * (darwin_std * 2) + (darwin_mean - darwin_std)

    # Apply normalization and scaling to the pressure column
    df['scaled_pressure'] = df['force'].apply(lambda x: scale_to_darwin(normalize_ipad_data(x)))

    # Calculate average pressure and variance in Darwin range
    average_pressure = df['scaled_pressure'].mean()
    variance_pressure = df['scaled_pressure'].var()

    #return average_pressure, variance_pressure
    return average_pressure

def pendowns(stroke_data):
    return len(stroke_data)

def calculate_times(stroke_data):
    total_time = 0
    total_air_time = 0
    
    # Get the first timestamp from the first stroke's first point
    start_time = stroke_data[0]['points'][0]['timestamp']
    #print(stroke_data[0]['points'][0])
    # Get the last timestamp from the last stroke's last point
    end_time = stroke_data[-1]['points'][-1]['timestamp']
    #print(stroke_data[-1]['points'][-1])
    # Calculate total time
    total_time = end_time

    total_air_time = start_time
    
    # Calculate air time by summing gaps between strokes
    for i in range(len(stroke_data) - 1):
        # End time of the current stroke
        current_stroke_end_time = stroke_data[i]['points'][-1]['timestamp']
        
        # Start time of the next stroke
        next_stroke_start_time = stroke_data[i + 1]['points'][0]['timestamp']
        
        # Air time between two strokes
        air_time = next_stroke_start_time - current_stroke_end_time
        
        # Add to total air time
        total_air_time += air_time


    total_paper_time = total_time - total_air_time
    
    return total_time, total_air_time, total_paper_time

def calculate_dispersion_index(df, box_size_daisy=3):
    # Convert paper size to Daisy units
    paper_width_daisy = paper_width_cm * daisy_per_cm_x
    paper_height_daisy = paper_height_cm * daisy_per_cm_y
    
    # Calculate total number of boxes (TB)
    num_boxes_x = int(paper_width_daisy / box_size_daisy)
    num_boxes_y = int(paper_height_daisy / box_size_daisy)
    total_boxes = num_boxes_x * num_boxes_y
    
    # Create a grid to track which boxes contain handwriting
    grid = np.zeros((num_boxes_x, num_boxes_y))
    
    # Loop through each point in the DataFrame and mark the corresponding box
    for i in range(len(df)):
        x_pixel = df.loc[i, 'x']
        y_pixel = df.loc[i, 'y']
        
        # Convert pixel coordinates to Daisy units
        x_daisy = x_pixel * cm_per_pixel * daisy_per_cm_x
        y_daisy = y_pixel * cm_per_pixel * daisy_per_cm_y
        
        # Determine which box the point falls into
        box_x = int(x_daisy / box_size_daisy)
        box_y = int(y_daisy / box_size_daisy)
        
        # Ensure the box is within bounds and mark it
        if 0 <= box_x < num_boxes_x and 0 <= box_y < num_boxes_y:
            grid[box_x, box_y] = 1  # Mark the box as containing handwriting
    
    # Count how many boxes contain handwriting (CB)
    boxes_with_handwriting = np.sum(grid)
    
    # Compute the Dispersion Index (DI)
    dispersion_index = boxes_with_handwriting / total_boxes
    
    return dispersion_index

def compute_max_y_extension_daisy(df):
    if 'y' not in df.columns:
        raise ValueError("The DataFrame does not contain a 'y' column.")
    
    # Get the maximum and minimum y-coordinates in pixels
    max_y_pixels = df['y'].max()
    min_y_pixels = df['y'].min()
    
    # Convert pixel values to centimeters
    max_y_cm = max_y_pixels * cm_per_pixel
    min_y_cm = min_y_pixels * cm_per_pixel
    
    # Convert centimeters to daisy units (using Y-axis Daisy conversion)
    max_y_daisy = max_y_cm * daisy_per_cm_y
    min_y_daisy = min_y_cm * daisy_per_cm_y
    
    # Calculate the max Y extension in Daisy units
    max_y_extension_daisy = max_y_daisy - min_y_daisy
    
    return max_y_extension_daisy

def compute_max_x_extension_daisy(df):
    if 'x' not in df.columns:
        raise ValueError("The DataFrame does not contain an 'x' column.")
    
    # Get the maximum and minimum x-coordinates in pixels
    max_x_pixels = df['x'].max()
    min_x_pixels = df['x'].min()
    
    # Convert pixel values to centimeters
    max_x_cm = max_x_pixels * cm_per_pixel
    min_x_cm = min_x_pixels * cm_per_pixel
    
    # Convert centimeters to daisy units (using X-axis Daisy conversion)
    max_x_daisy = max_x_cm * daisy_per_cm_x
    min_x_daisy = min_x_cm * daisy_per_cm_x
    
    # Calculate the max X extension in Daisy units
    max_x_extension_daisy = max_x_daisy - min_x_daisy
    
    return max_x_extension_daisy

# used by gmrt daisy
def calculate_distance_daisy(x, y, origin=(0, 0)):
    # Calculate the individual X and Y distances in pixels
    dx_pixels = x - origin[0]
    dy_pixels = y - origin[1]
    
    # Convert pixel distances to centimeters
    dx_cm = dx_pixels * cm_per_pixel
    dy_cm = dy_pixels * cm_per_pixel
    
    # Convert centimeter distances to daisy units
    dx_daisy = dx_cm * daisy_per_cm_x
    dy_daisy = dy_cm * daisy_per_cm_y
    
    # Calculate Euclidean distance in daisy units
    distance_daisy = np.sqrt(dx_daisy**2 + dy_daisy**2)
    
    return distance_daisy

def compute_gmrt_daisy(df, d=10, origin=(0, 0)):
    n = len(df)
    
    if n <= d:
        raise ValueError("Number of points must be greater than the displacement 'd'")
    
    total_difference = 0  
    count = 0  
    
    for i in range(d, n):
        x_i, y_i = df.loc[i, 'x'], df.loc[i, 'y']
        x_prev, y_prev = df.loc[i - d + 1, 'x'], df.loc[i - d + 1, 'y']
        
        # Calculate the distance from the origin in daisy units for both points
        r_i_daisy = calculate_distance_daisy(x_i, y_i)
        r_prev_daisy = calculate_distance_daisy(x_prev, y_prev)
        
        # Compute the absolute difference between distances in daisy units
        difference = abs(r_i_daisy - r_prev_daisy)
        
        # Add the difference to the total
        total_difference += difference
        count += 1
    
    # Compute the average GMRT by dividing the cumulative difference by (n - d)
    gmrt_daisy = total_difference / count
    return gmrt_daisy

def compute_time_weighted_mean_acceleration_daisy(df):
    total_weighted_acceleration = 0  # Sum of (acceleration * time interval)
    total_time_intervals = 0          # Sum of time intervals

    for i in range(1, len(df)):
        # Get current and previous points
        x1, y1, t1 = df.loc[i-1, 'x'], df.loc[i-1, 'y'], df.loc[i-1, 'timestamp']
        x2, y2, t2 = df.loc[i, 'x'], df.loc[i, 'y'], df.loc[i, 'timestamp']

        dt = t2 - t1
        if dt <= 0:  # Skip if time difference is zero or negative
            continue

        # Calculate pixel distance between current and previous points
        dx_pixels = x2 - x1
        dy_pixels = y2 - y1

        # Convert pixel distances to centimeters
        dx_cm = dx_pixels * cm_per_pixel
        dy_cm = dy_pixels * cm_per_pixel

        # Convert distances from cm to "daisy" units for X and Y separately
        dx_daisy = dx_cm * daisy_per_cm_x
        dy_daisy = dy_cm * daisy_per_cm_y

        # Calculate distance in "daisy" units
        distance_daisy = math.sqrt(dx_daisy**2 + dy_daisy**2)

        # Calculate current speed in "daisy/s"
        current_speed_daisy = distance_daisy / dt

        if i > 1:
            # Get the point before the previous one
            x0, y0, t0 = df.loc[i-2, 'x'], df.loc[i-2, 'y'], df.loc[i-2, 'timestamp']
            dx_prev_pixels = x1 - x0
            dy_prev_pixels = y1 - y0
            dt_prev = t1 - t0

            if dt_prev > 0:  # Ensure previous time difference is reasonable
                # Convert previous pixel distances to cm
                dx_prev_cm = dx_prev_pixels * cm_per_pixel
                dy_prev_cm = dy_prev_pixels * cm_per_pixel

                # Convert previous cm distances to "daisy" units
                dx_prev_daisy = dx_prev_cm * daisy_per_cm_x
                dy_prev_daisy = dy_prev_cm * daisy_per_cm_y

                # Calculate previous distance in "daisy" units
                previous_distance_daisy = math.sqrt(dx_prev_daisy**2 + dy_prev_daisy**2)

                # Calculate previous speed in "daisy/s"
                previous_speed_daisy = previous_distance_daisy / dt_prev

                # Calculate instantaneous acceleration in "daisy/s²"
                acceleration_daisy = (current_speed_daisy - previous_speed_daisy) / dt

                # Add weighted acceleration (acceleration * time interval)
                total_weighted_acceleration += acceleration_daisy * dt
                total_time_intervals += dt

    # Calculate time-weighted mean acceleration in "daisy/s²"
    if total_time_intervals > 0:
        mean_acceleration_daisy = total_weighted_acceleration / total_time_intervals
    else:
        mean_acceleration_daisy = 0

    return abs(mean_acceleration_daisy) / 1000

def calculate_mean_speed_df_daisy(df):
    total_distance_daisy = 0
    total_time_sec = 0

    for i in range(1, len(df)):
        x1, y1, t1 = df.loc[i-1, 'x'], df.loc[i-1, 'y'], df.loc[i-1, 'timestamp']
        x2, y2, t2 = df.loc[i, 'x'], df.loc[i, 'y'], df.loc[i, 'timestamp']

        dx_pixels = x2 - x1
        dy_pixels = y2 - y1
        dt = t2 - t1

        if dt <= 0:
            continue  # Skip if time difference is zero or negative

        # Convert pixel distances to cm
        dx_cm = dx_pixels * cm_per_pixel
        dy_cm = dy_pixels * cm_per_pixel

        # Convert cm to "daisy" units (using different scaling for x and y axes)
        dx_daisy = dx_cm * daisy_per_cm_x
        dy_daisy = dy_cm * daisy_per_cm_y

        # Calculate the total distance in "daisy" units
        distance_daisy = math.sqrt(dx_daisy**2 + dy_daisy**2)
        total_distance_daisy += distance_daisy
        total_time_sec += dt

        # Debug: print intermediate distance and time values
        #print(f"Segment Distance {i} (daisy): {distance_daisy}, Time (s): {dt}")

    # Debug: print total time and total distance
    #print(f"Total Distance (daisy): {total_distance_daisy}, Total Time (s): {total_time_sec}")

    # Calculate the mean speed in daisy/s
    if total_time_sec > 0:
        mean_speed_daisy_per_sec = total_distance_daisy / total_time_sec  # Speed in daisy/second
    else:
        mean_speed_daisy_per_sec = 0

    return mean_speed_daisy_per_sec / 1000

def json_to_dataframe(stroke_data):
    data = []
    for stroke in stroke_data:
        for point in stroke['points']:
            data.append([point['timestamp'], point['x'], point['y'], point.get('force', None)])  # Use .get() to avoid errors if 'force' is missing
    df = pd.DataFrame(data, columns=['timestamp', 'x', 'y', 'force'])
    return df