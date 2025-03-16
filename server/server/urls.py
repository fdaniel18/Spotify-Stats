"""
URL configuration for server project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.urls import path
from users.views import UserViewSet, RegisterView, LoginView, LogoutView, SpotifyView, TrackViewSet, HistoryViewSet

urlpatterns = [
    # User routes
    path("users", UserViewSet.as_view({
        "post": "list"
    })),
    path("user/create", UserViewSet.as_view({
        "post": "create"
    })),
    path("user/current", UserViewSet.as_view({
        "post": "current"
    })),
    path("user/<str:pk>", UserViewSet.as_view({
        "get": "retrieve",
        "put": "update",
        "delete": "destroy"
    })),
    path("register", RegisterView.as_view()),
    path("login", LoginView.as_view()),
    path("logout", LogoutView.as_view()),

    # Spotify routes
    path("spotify/country/<str:id_country>", SpotifyView.as_view({
        "post": "getCountry"
    })),
    path("spotify/global", SpotifyView.as_view({
        "post": "getGlobal"
    })),

    # Track routes
    path('user/track/get', TrackViewSet.as_view({
        "post": "get_tracks"
    })),
    path('user/track/add', TrackViewSet.as_view({
        "post": "add_track"
    })),
    path('user/track/delete/<str:id_track>', TrackViewSet.as_view({
        "delete": "delete_track"
    })),

    # History routes
    path('user/history/get', HistoryViewSet.as_view({
        "post": "get_history"
    })),
    path('user/history/add', HistoryViewSet.as_view({
        "post": "add_to_history"
    })),
    path('user/history/delete/<str:id_history>', HistoryViewSet.as_view({
        "delete": "delete_history"
    })),


]
