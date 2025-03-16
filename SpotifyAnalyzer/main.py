import sys
import torch
from torch.utils.data import DataLoader, random_split

import pandas
import numpy as np

from src.dataset.SpotifyAnalyzerDataset import SpotifyAnalyzerDataset
from src.models.SpotifyStatsClassifer import SpotifyStatsClassifier
from src.training.SpotifyTraining import SpotifyTraining
from src.models.SaveModel import save_model

if __name__ == '__main__':
    print('==============================================')
    print('============ SpotifyAnalyzer =================')
    print('System Version:', sys.version)
    print('PyTorch Version:', torch.__version__)
    print('Numpy Version:', np.__version__)
    print('Pandas version:', pandas.__version__)
    print('==============================================')

    path = 'data-set.csv'
    num_features = 2
    num_classes = 6
    epochs = 30

    data_set = SpotifyAnalyzerDataset(path)

    print('> Begin...')
    print(f'> Load the data from "{path}"...')
    print(f'> The lenght of the data set: {len(data_set)}')

    total_size = len(data_set)
    val_size = 1000
    train_size = total_size-1000
    #test_size = total_size - train_size - val_size  # ~10% for testing

    # Split the dataset
    train_data, val_data= random_split(data_set, [train_size, val_size])

    # Create DataLoaders for each split
    train_loader = DataLoader(train_data, batch_size=4, shuffle=True, num_workers=2)
    val_loader = DataLoader(val_data, batch_size=4, shuffle=False, num_workers=2)
    #test_loader = DataLoader(test_data, batch_size=4, shuffle=False, num_workers=2)

    print('> Load the model...')
    model = SpotifyStatsClassifier(input_size=num_features, num_classes=num_classes)
    yellow_color, reset_color = "\033[93m", "\033[0m"
    print(f"{yellow_color}{model}{reset_color}")

    print('> Start training...')
    trainer = SpotifyTraining(model, train_loader, val_loader, epochs)
    trainer.train()

    print('> Saving Model...')
    save_model(model, num_features, num_classes)
