from djongo import models


class Track(models.Model):
    id = models.IntegerField(primary_key=True)
    spotify_id = models.CharField(max_length=15)
    name = models.CharField(max_length=50)
    author = models.CharField(max_length=50)
    image300 = models.CharField(max_length=200)
    image64 = models.CharField(max_length=200)
    date = models.CharField(max_length=15)
    valence = models.FloatField()
    energy = models.FloatField()


class History(models.Model):
    id = models.IntegerField(primary_key=True)
    type = models.CharField(max_length=50)
    date = models.CharField(max_length=20)

class User(models.Model):
    id = models.IntegerField(primary_key=True)
    first_name = models.CharField(max_length=20)
    last_name = models.CharField(max_length=20)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=256)
    is_admin = models.BooleanField(default=False)
    tracks = models.ArrayField(
        model_container=Track,
        default=list
    )
    track_history = models.ArrayField(
        model_container=History,
        default=list
    )

    def delete(self, *args, **kwargs):
        self.tracks.clear()
        self.track_history.clear()
        super().delete(*args, **kwargs)

    def getNextId(self):
        last_id = User.objects.aggregate(models.Max('id'))['id__max']
        return (last_id or 0) + 1

    def check_password(self, password):
        return self.password == password

    def getNextTrackId(self):
        return max(track['id'] for track in self.tracks) + 1 if self.tracks else 1

    def getNextHistoryId(self):
        return max(history['id'] for history in self.track_history) + 1 if self.track_history else 1


