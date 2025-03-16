import pandas as pd


# 0: Sad, Calm
# 1: Sad, Energetic
# 2: Neutral, Calm
# 3: Neutral, Energetic
# 4: Happy, Calm
# 5: Happy, Energetic
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


data_file = pd.read_csv('data_set_average_music_annotation.csv')

data_file['valence'] = data_file['valence'] / 10
data_file['arousal'] = data_file['arousal'] / 10
data_file['output'] = data_file.apply(lambda row: classify_music(row['valence'], row['arousal']), axis=1)

data_file.to_csv('data-set-extended.csv', index=False)
print(data_file[['song_id', 'valence', 'arousal', 'output']])
