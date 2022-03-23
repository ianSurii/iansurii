from datetime import date
import datetime
from distutils.command.upload import upload
from django.db import models



# Create your models here.

class Certificate(models.Model):
    id = models.IntegerField(auto_created=True, primary_key=True)
    title = models.CharField(max_length=200, default="title")
    issuer = models.CharField(max_length=300, default="issuer")
    dateissued = models.DateField(default=datetime.datetime.now)
    url = models.CharField(max_length=200)
    picture = models.CharField(max_length=200)


class Blog(models.Model):
    id = models.IntegerField(auto_created=True, primary_key=True)
    picture = models.FileField(upload_to="uploads/")
    title = models.CharField(max_length=9999999999999999, default="title")
    dateadded = models.DateField(default=datetime.datetime.now)
    # blogurl =models.DateField(default=datetime.datetime.now)
    introduction = models.CharField(max_length=2000, default="introduction")
    content = models.TextField(
        max_length=9999999999999999, default="https://medium.com/@ianmuthuri254/")
    url = models.TextField(
        max_length=300, default="https://medium.com/@ianmuthuri254/")


class About(models.Model):
    id = models.IntegerField(auto_created=True, primary_key=True)
    about = models.CharField(max_length=3000, default="title")


class Services(models.Model):
    id = models.IntegerField(auto_created=True, primary_key=True)
    title = models.CharField(max_length=200, default="title")
    portorolioPicture = models.FileField(upload_to="uploads/")


class Projects(models.Model):

    id = models.IntegerField(auto_created=True, primary_key=True)
    title = models.CharField(max_length=200, default="title")
    description = models.CharField(max_length=300, default="description")
    date = models.DateField(default=datetime.datetime.now)
    url = models.CharField(max_length=200)
    picture = models.FileField(upload_to="uploads/")
    role = models.CharField(max_length=200)


class Tool(models.Model):
    id = models.IntegerField(auto_created=True, primary_key=True)
    title = models.CharField(max_length=200, default="title")
    url = models.CharField(max_length=200)
    strength = models.IntegerField()
    picture = models.CharField(max_length=200)
