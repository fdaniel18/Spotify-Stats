import hashlib

import datetime
import json
import jwt
from rest_framework import viewsets, status
from rest_framework.exceptions import AuthenticationFailed
from rest_framework.response import Response
from rest_framework.views import APIView

from spotify.Spotify import Spotify
from .models import User
from .serializers import UserSerializer, UserUpdateSerializer


# ------------------- USER VIEWS -------------------

def secure(request):
    token = json.loads(request.body.decode("utf-8")).get('jwt')
    if not token:
        raise AuthenticationFailed('Unauthenticated!')
    try:
        payload = jwt.decode(token, 'secret', algorithms=['HS256'])
    except jwt.ExpiredSignatureError:
        raise AuthenticationFailed('Invalid token!')
    return payload


class UserViewSet(viewsets.ViewSet):
    def list(self, request):
        payload = secure(request)
        if not payload['is_admin']:
            return Response(status=status.HTTP_403_FORBIDDEN)
        users = User.objects.all()
        serializer = UserSerializer(users, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def create(self, request):
        payload = secure(request)
        if not payload['is_admin']:
            return Response(status=status.HTTP_403_FORBIDDEN)

        user = User.objects.filter(email=request.data['email']).first()
        if user:
            return Response({'message': 'User with this email already exists!'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            request.data['password'] = hashlib.sha256(request.data['password'].encode('utf-8')).hexdigest()
        except:
            print("Password field is empty")

        request.data['id'] = User().getNextId()
        serializer = UserSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)


    def retrieve(self, request, pk=None):
        payload = secure(request)
        if not payload['is_admin']:
            return Response(status=status.HTTP_403_FORBIDDEN)
        user = User.objects.get(id=pk)
        serializer = UserSerializer(user)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def update(self, request, pk=None):
        payload = secure(request)
        if not payload['is_admin']:
            return Response(status=status.HTTP_403_FORBIDDEN)
        user = User.objects.get(id=pk)
        serializer = UserUpdateSerializer(instance=user, data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_202_ACCEPTED)

    def current(self, request):
        payload = secure(request)
        user = User.objects.get(id=payload['id'])
        serializer = UserSerializer(user)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def destroy(self, request, pk=None):
        payload = secure(request)
        if not payload['is_admin']:
            return Response(status=status.HTTP_403_FORBIDDEN)
        user = User.objects.get(id=pk)
        user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class RegisterView(APIView):
    def post(self, request):
        user = User.objects.filter(email=request.data['email']).first()
        if user:
            return Response({'message': 'User with this email already exists!'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            request.data['password'] = hashlib.sha256(request.data['password'].encode('utf-8')).hexdigest()
        except:
            print("Password field is empty")

        request.data['id'] = User().getNextId()
        serializer = UserSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class LoginView(APIView):
    def post(self, request):
        email = request.data['email']
        password = hashlib.sha256(request.data['password'].encode('utf-8')).hexdigest()

        user = User.objects.filter(email=email).first()

        if user is None:
            raise AuthenticationFailed('User not found!')

        if not user.check_password(password):
            raise AuthenticationFailed('Incorrect password!')

        payload = {
            'id': user.id,
            'is_admin': user.is_admin,
            'exp': datetime.datetime.now(datetime.UTC) + datetime.timedelta(minutes=60),
            'iat': datetime.datetime.now(datetime.UTC),
        }

        token = jwt.encode(payload, 'secret', algorithm='HS256')

        response = Response()
        response.set_cookie(key='jwt', value=token, httponly=True)

        response.data = {'jwt': token}

        return response


class LogoutView(APIView):
    def post(self, request):
        secure(request)
        response = Response()
        response.delete_cookie('jwt')
        response.data = {'message': 'You have been logged out.'}

        return response


class SpotifyView(viewsets.ViewSet):
    # ALL POST
    def getCountry(self, request, id_country=None):
        secure(request)
        available_countries = {'RO': '7KHd1QmZFOsM61CxR9SYX4',
                               'UK': '2nnNV6SsMJziRmTypG2BIB',
                               'US': '6H1MbJejJOilQHmxt9aNjs',
                               'FR': '5wwah1dJWHHIzVmnQz1f38'}

        countries_from_abreviations = {'RO': 'Romania',
                                  'UK': 'United Kingdom',
                                  'US': 'United States',
                                  'FR': 'France'}
        spotify = Spotify()
        token = spotify.connect()

        if id_country in available_countries:
            track_data = spotify.getTrack(token, available_countries[id_country])
        else:
            print("Not an available country")
            return Response(status=status.HTTP_400_BAD_REQUEST)

        track_data, music_data = spotify.getTrackFeatures(track_data)
        result = spotify.resultPredict(music_data)
        track_data_dicts = [track.to_dict() for track in track_data]

        response = Response()
        response.data = {'country': f'{countries_from_abreviations[id_country]}?{id_country}',
                         'track_data': track_data_dicts,
                         'music_data': music_data,
                         'result': result}

        return response

    def getGlobal(self, request):
        secure(request)

        spotify = Spotify()
        token = spotify.connect()

        track_data = spotify.getTrack(token, '4JxHVaS9NL1sBENQkGjXqp')
        track_data, music_data = spotify.getTrackFeatures(track_data)
        result = spotify.resultPredict(music_data)
        track_data_dicts = [track.to_dict() for track in track_data]

        response = Response()
        response.data = {'track_data': track_data_dicts,
                         'music_data': music_data,
                         'result': result}

        return response

    def getUser(self, request, id_user=None):
        pass


class TrackViewSet(viewsets.ViewSet):
    def get_tracks(self, request):
        payload = secure(request)
        user = User.objects.get(id=payload['id'])
        tracks = user.tracks

        response = Response()
        response.data = {'tracks': tracks}

        return response

    def add_track(self, request):
        payload = secure(request)
        track = request.data['track']
        user = User.objects.get(id=payload['id'])
        track['id'] = User.getNextTrackId(user)
        user.tracks.append(track)
        user.save()

        return Response(status=status.HTTP_201_CREATED)

    def delete_track(self, request, id_track=None):
        payload = secure(request)
        user = User.objects.get(id=payload['id'])
        for track in user.tracks:
            if str(track['id']) == id_track:
                user.tracks.remove(track)
                user.save()

        return Response(status=status.HTTP_204_NO_CONTENT)


class HistoryViewSet(viewsets.ViewSet):
    def get_history(self, request):
        payload = secure(request)
        user = User.objects.get(id=payload['id'])
        history = user.track_history

        response = Response()
        response.data = {'history': history}

        return response

    def add_to_history(self, request):
        payload = secure(request)
        history = request.data['history']
        user = User.objects.get(id=payload['id'])
        history['id'] = User.getNextHistoryId(user)
        user.track_history.append(history)
        user.save()

        return Response(status=status.HTTP_201_CREATED)

    def delete_history(self, request, id_history=None):
        payload = secure(request)
        user = User.objects.get(id=payload['id'])
        for history in user.track_history:
            if str(history['id']) == id_history:
                user.track_history.remove(history)
                user.save()

        return Response(status=status.HTTP_204_NO_CONTENT)
