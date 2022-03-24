from django.shortcuts import render


# Create your views here.
from django.http import HttpResponse
from datetime import date
from .models import Tool, Blog, Projects, Services, About


def index(request):
    # Create a simple html page as a string
    context = {}
    # If the request method is GET
    if request.method == 'GET':
        # Using the objects model manage to read all course list
        # and sort them by total_enrollment descending
        services = Services.objects.order_by('id')
        tools = Tool.objects.order_by('id')
        blog = Blog.objects.order_by('id')
        about = About.objects.order_by('id')
        project = Projects.objects.order_by('id')
        # Appen the course list as an entry of context dict
        context['services'] = services
        context['about'] = about
        context['tools'] = tools
        context['blog'] = blog
        # context['blog'] = blog
        context['project'] = project
        return render(request, 'ianmuthuri/index.html', context)
