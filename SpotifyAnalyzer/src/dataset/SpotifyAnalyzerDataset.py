from torch.utils.data import Dataset
import numpy as np
import torch

class SpotifyAnalyzerDataset(Dataset):
    def __init__(self, data_path, transform=None):
        data_set = np.loadtxt(data_path, delimiter=",", dtype=np.float32, skiprows=1)
        self.features = torch.from_numpy(data_set[:, 1:3])
        self.labels = torch.from_numpy(data_set[:, [3]])

    def __len__(self):
        return len(self.features)

    def __getitem__(self, index):
        return self.features[index], self.labels[index]

