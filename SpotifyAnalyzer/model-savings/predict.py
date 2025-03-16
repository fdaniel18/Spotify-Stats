import json
import torch
from src.models.SpotifyStatsClassifer import SpotifyStatsClassifier

class SpotifyPredictor:
    class_map = {
        0: "Sad, Calm",
        1: "Sad, Energetic",
        2: "Neutral, Calm",
        3: "Neutral, Energetic",
        4: "Happy, Calm",
        5: "Happy, Energetic"
    }

    def __init__(self, model_path, config_path):
        with open(config_path, 'r') as json_file:
            config = json.load(json_file)
        self.input_size = config.get("input_size")
        self.num_classes = config.get("num_classes")

        # Initialize model based on configuration
        self.model = SpotifyStatsClassifier(self.input_size, self.num_classes)
        self.model.load_state_dict(torch.load(model_path))
        self.model.eval()  # Set model to evaluation mode

    def predict(self, valence, arousal):
        input_data = torch.tensor([[valence, arousal]], dtype=torch.float32)
        with torch.no_grad():
            output = self.model(input_data)
            predicted_class = output.argmax(dim=1).item()  # Get the class with the highest probability
        return self.class_map[predicted_class]

if __name__ == "__main__":
    model_path = "spotify_stats_classifier.pth"
    config_path = "model_config.json"

    predictor = SpotifyPredictor(model_path, config_path)
    while 1:
        try:
            valence = float(input("Enter valence (e.g., 0.45): "))
            arousal = float(input("Enter arousal (e.g., 0.35): "))

            # Make prediction
            result = predictor.predict(valence, arousal)
            print(f"Predicted class: {result}")

        except ValueError:
            print("Please enter valid float values for valence and arousal.")