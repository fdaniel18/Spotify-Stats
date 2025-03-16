from torch import nn

class SpotifyStatsClassifier(nn.Module):
    def __init__(self, input_size, num_classes):
        super(SpotifyStatsClassifier, self).__init__()

        # Define the layers
        self.fc1 = nn.Linear(input_size, 32)
        self.fc2 = nn.Linear(32, 16)
        self.fc3 = nn.Linear(16, num_classes)

        # Activation function
        self.relu = nn.ReLU()
        self.softmax = nn.Softmax(dim=1)  # Softmax for the output layer

    def forward(self, x):
        x = self.relu(self.fc1(x))
        x = self.relu(self.fc2(x))
        output = self.softmax(self.fc3(x))
        return output
