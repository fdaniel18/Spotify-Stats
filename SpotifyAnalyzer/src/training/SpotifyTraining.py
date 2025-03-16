import torch
from torch import nn
from tqdm import tqdm
import matplotlib.pyplot as plt


class SpotifyTraining:
    learning_rate = 0.001

    def __init__(self, model, train_loader, val_loader, epochs):
        self.model = model
        self.train_loader = train_loader
        self.val_loader = val_loader
        self.epochs = epochs

    def train(self):
        device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
        if device.type != "cuda":
            raise Exception("The model can only be trained on GPU, make sure you can run on a GPU")

        train_losses, val_losses = [], []

        criterion = nn.CrossEntropyLoss()
        optimizer = torch.optim.Adam(self.model.parameters(), lr=self.learning_rate)

        self.model.to(device)

        #Training phase
        for epoch in range(self.epochs):
            self.model.train()
            running_loss = 0.0
            for features, labels in tqdm(self.train_loader, desc="Training Loop"):
                features, labels = features[0].unsqueeze(0), labels[0].long()
                features, labels = features.to(device), labels.to(device)
                optimizer.zero_grad()
                outputs = self.model(features)

                loss = criterion(outputs, labels)
                loss.backward()
                optimizer.step()
                running_loss += loss.item() * features.size(0)

            train_loss = running_loss / len(self.train_loader.dataset)
            train_losses.append(train_loss)

            #Validation phase
            self.model.eval()
            running_loss = 0.0
            with torch.no_grad():
                for features, labels in tqdm(self.val_loader, desc="Validation Loop"):
                    features, labels = features[0].unsqueeze(0), labels[0].long()
                    features, labels = features.to(device), labels.to(device)

                    outputs = self.model(features)
                    loss = criterion(outputs, labels)
                    running_loss += loss.item() * features.size(0)
            val_loss = running_loss / len(self.val_loader)
            val_losses.append(val_loss)

            #Epoch stats
            print(f'\nEpoch [{epoch + 1}/{self.epochs}], Train Loss: {train_loss:.3f}, Validation Loss: {val_loss:.3f}\n')

        plt.plot(train_losses, label="Training Loss")
        plt.plot(val_losses, label="Validation Loss")
        plt.legend()
        plt.title('Loss vs Epochs')
        plt.show()


