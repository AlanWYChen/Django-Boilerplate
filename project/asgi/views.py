from django.shortcuts import render
from django.http import JsonResponse
import asyncio

async def async_hello(request):
    await asyncio.sleep(1)
    return JsonResponse({'message': 'Hello from async view!'})