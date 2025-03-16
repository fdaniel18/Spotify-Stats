import pandas as pd
import numpy as np

def classify_music(valence, arousal):
    mood_code = 3 if valence >= 0.55 else 2 if valence >= 0.4 else 1
    energy_code = 1 if arousal >= 0.5 else 0

    if mood_code == 1:
        class_index = 0 if energy_code == 0 else 1
    elif mood_code == 2:
        class_index = 2 if energy_code == 0 else 3
    else:
        class_index = 4 if energy_code == 0 else 5

    return class_index

data_file = pd.read_csv('data-set.csv')
num_entries = 100
random_data = {
    'song_id': range(data_file['song_id'].max() + 1, data_file['song_id'].max() + 1 + num_entries),  # Incremental song_ids
    'valence': np.random.uniform(0, 0.4, num_entries),  # Random valence between 0 and 1
    'arousal': np.random.uniform(0.5, 1, num_entries)   # Random arousal between 0 and 1
}

new_data = pd.DataFrame(random_data)
new_data['output'] = new_data.apply(lambda row: classify_music(row['valence'], row['arousal']), axis=1)
combined_data = pd.concat([data_file, new_data], ignore_index=True)

combined_data.to_csv('data-set-extended.csv', index=False)

print(combined_data[['song_id', 'valence', 'arousal', 'output']].head(10))  # Print the last 10 entries for verification
