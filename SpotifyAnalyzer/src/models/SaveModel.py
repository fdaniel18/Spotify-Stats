import json
import os
import torch


def save_model(model, features, classes):
    # Define paths relative to the root of the project
    model_path = os.path.join(os.path.dirname(__file__), '../../model-savings/spotify_stats_classifier.pth')
    config_path = os.path.join(os.path.dirname(__file__), '../../model-savings/model_config.json')

    # Save model weights
    torch.save(model.state_dict(), model_path)

    # Save model configuration
    model_config = {
        'input_size': features,
        'num_classes': classes
    }

    with open(config_path, 'w') as config_file:
        json.dump(model_config, config_file)

    print(f"Model saved to {model_path}")
    print(f"Config saved to {config_path}")
