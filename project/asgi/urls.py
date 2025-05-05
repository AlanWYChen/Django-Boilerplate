from django.urls import path
from .views import async_hello

urlpatterns = [
    path('async-hello/', async_hello),
]