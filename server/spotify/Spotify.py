from dotenv import load_dotenv
import os
import base64
import json
from pip._vendor.requests.api import post
import requests
import random
from typing_extensions import deprecated

from ml_agent.predict import SpotifyPredictor
from server.TrackModel import TrackModel


class Spotify:
    def __init__(self):
        load_dotenv()
        self.client_id = os.getenv('SPOTIFY_CLIENT_ID')
        self.client_secret = os.getenv('SPOTIFY_CLIENT_SECRET')

        if not self.client_id or not self.client_secret:
            print("Please set SPOTIFY_CLIENT_ID and SPOTIFY_CLIENT_SECRET in .env file.")
            return

    def connect(self):
        print("Connecting to Spotify...")
        auth_str = f"{self.client_id}:{self.client_secret}"
        auth_base64 = str(base64.b64encode(auth_str.encode('utf-8')), "utf-8")

        url = "https://accounts.spotify.com/api/token"
        headers = {
            "Authorization": f"Basic {auth_base64}",
            "Content-Type": "application/x-www-form-urlencoded"
        }
        data = {"grant_type": "client_credentials"}
        try:
            response = post(url, headers=headers, data=data)
        except Exception as e:
            print(f"Error trying to connect to Spotify: {e}")
            return

        json_response = json.loads(response.content)
        if json_response.get('error') is not None:
            print(f"Error connecting to Spotify: {json_response['error']}")
            return

        print("Connected to Spotify...")
        return json_response['access_token']


    def getTrack(self, token: str, playlist_id: str) -> list[TrackModel]:
        url = f"https://api.spotify.com/v1/playlists/{playlist_id}"
        headers = {"Authorization": f"Bearer {token}"}

        response = requests.get(url, headers=headers)
        print(f"Status Code: {response.status_code}")

        track_data = []
        if response.status_code == 200:
            playlist_data = response.json()
            index = 0
            for item in playlist_data["tracks"]["items"]:
                track = item["track"]
                images = track["album"]["images"]
                artist_names = ", ".join(artist['name'] for artist in track['artists'])

                track_data.append(TrackModel(index, track['id'],track['name'],
                    artist_names, images[1]['url'], images[2]['url'],
                    "",0,0))
                index += 1

        else:
            print(f"Error: {response.status_code}")
            print(response.json())

        return track_data

    @deprecated("This method is deprecated, use getTrackFeatures instead.")
    def getTrackFeatures_deprecated(self, token: str, track_data: list[TrackModel]) -> list[TrackModel]:
        url = "https://api.spotify.com/v1/audio-features/"
        headers = {"Authorization": f"Bearer {token}"}
        for track in track_data:
            response = requests.get(url + track.id, headers=headers)
            feature_data = response.json()
            track.energy = feature_data["energy"]
            track.valence = feature_data["valence"]
        return track_data

    def getTrackFeatures(self,track_data: list[TrackModel]) -> (list[TrackModel],list[(float,float)]):
        music_data = []
        for track in track_data:
            valence = round(random.uniform(0.0, 1.0), 2)
            energy = round(random.uniform(0.0, 1.0), 2)
            track.valence = valence
            track.energy = energy
            music_data.append((valence, energy))
        return track_data, music_data

    def resultPredict(self,music_data: list[(float, float)]) -> str:
        model_path = './ml_agent/spotify_stats_classifier.pth'
        config_path = './ml_agent/model_config.json'
        predictor = SpotifyPredictor(model_path, config_path)

        valence, energy = 0, 0
        for valence_data, energy_data in music_data:
            valence += valence_data
            energy += energy_data

        valence = valence/len(music_data)
        energy = energy/len(music_data)

        result = predictor.predict(valence,energy)
        return result

if __name__ == '__main__':
    spotify = Spotify()
    token = spotify.connect()
    track_data = spotify.getTrack(token, '4JxHVaS9NL1sBENQkGjXqp')

    spotify.getTrackFeatures(track_data)
    for track in track_data:
        print (track)

    _, music_data = spotify.getTrackFeatures(track_data)
    result = spotify.resultPredict(music_data)
    print(f"Predicted class: {result}")



