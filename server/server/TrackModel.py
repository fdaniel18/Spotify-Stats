class TrackModel:
    def __init__(self, id, spotify_id, name, author, image300, image64, data, valence, energy):
        self.id = id
        self.spotify_id = spotify_id
        self.name = name
        self.author = author
        self.image300 = image300
        self.image64 = image64
        self.data = data
        self.valence = valence
        self.energy = energy

    def to_dict(self):
        return {
            "id": self.id,
            "spotify_id": self.spotify_id,
            "name": self.name,
            "author": self.author,
            "image300": self.image300,
            "image64": self.image64,
            "data": self.data,
            "valence": self.valence,
            "energy": self.energy,
        }

    def __str__(self):
        return str(self.to_dict())
