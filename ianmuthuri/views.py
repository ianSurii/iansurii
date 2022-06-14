from django.shortcuts import render


# Create your views here.
from django.http import HttpResponse
from datetime import date,datetime
from .models import Tool, Blog, Projects, Services, About,Visitors
import socket
import urllib
import json
from urllib import *
from django.core import serializers



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
       
        host_name = socket.gethostname() 
        host_ip = socket.gethostbyname(host_name) 
        serviceurl = 'http://www.geoplugin.net/json.gp?ip='+host_ip

        print('Retrieving', serviceurl)
        uh = urllib.request.urlopen(serviceurl)
        data = uh.read().decode()
        print('Retrieved', len(data), 'characters')
        js = json.loads(data)
        print(data) 
        # //log data to file

    #       ip_address = models.CharField(max_length=20)
    # date = models.DateField(default=date.today)
    # time = models.TimeField(default=datetime.datetime.now)
    # country = models.CharField(max_length=20)
    # city = models.CharField(max_length=20)
    # region = models.CharField(max_length=20)
    # region_code = models.CharField(max_length=20)
    # region_name = models.CharField(max_length=20)
    # area_code = models.CharField(max_length=20)
    # dma_code = models.CharField(max_length=20)
    # country_code = models.CharField(max_length=20)
    # country_name = models.CharField(max_length=20)
    # in_eu = models.CharField(max_length=20)
    # eu_vat_rate = models.CharField(max_length=20)
    # continent_code = models.CharField(max_length=20)
    # continent_name = models.CharField(max_length=20)
    # latitude = models.CharField(max_length=20)
    # longitude = models.CharField(max_length=20)
    # location_accuracy_radius = models.CharField(max_length=20)
    # timezone = models.CharField(max_length=20)
    # currency_code = models.CharField(max_length=20)
    # currency_symbol = models.CharField(max_length=20)
    # currency_symbol_utf8 = models.CharField(max_length=20)
    # currency_converter = models.CharField(max_length=20)

    # add the model visitorTracker
    # {"geoplugin_request": "192.168.76.1", "geoplugin_status": 404,
    #  "geoplugin_delay": "1ms", 
    #  "geoplugin_credit": "Some of the returned data includes GeoLite data created by MaxMind, available from <a href='http://www.maxmind.com'>http://www.maxmind.com</a>.", "geoplugin_city": null, "geoplugin_region": null, "geoplugin_regionCode": null, "geoplugin_regionName": null, "geoplugin_areaCode": null, "geoplugin_dmaCode": null, "geoplugin_countryCode": null, "geoplugin_countryName": null, "geoplugin_inEU": 0, "geoplugin_euVATrate": false, "geoplugin_continentCode": null, "geoplugin_continentName": null, "geoplugin_latitude": null, "geoplugin_longitude": null, "geoplugin_locationAccuracyRadius": null, "geoplugin_timezone": null, "geoplugin_currencyCode": null, "geoplugin_currencySymbol": null, "geoplugin_currencySymbol_UTF8": "", "geoplugin_currencyConverter": 0}
        
        ip_address=js['geoplugin_request'],
        # today=date.today(),
        # time=datetime.now(),
        # check if the country is null
        if js['geoplugin_countryName'] is None:
            country = 'Unknown'
        else:
            country = js['geoplugin_countryName']
        # check if the city is null
        if js['geoplugin_city'] is None:
            city = 'Unknown'
        else:
            city = js['geoplugin_city']
        # check if the region is null
        if js['geoplugin_region'] is None:
            region = 'Unknown'
        else:
            region = js['geoplugin_region']
        # check if the region code is null
        if js['geoplugin_regionCode'] is None:
            region_code = 'Unknown'
        else:
            region_code = js['geoplugin_regionCode']

       

        # check if the region name is null
        if js['geoplugin_regionName'] is None:
            region_name = 'Unknown'
        else:
            region_name = js['geoplugin_regionName']
        # check if the country code is null
        if js['geoplugin_countryCode'] is None:
            
            country_code = 'Unknown'
        else:
            country_code = js['geoplugin_countryCode']
        # check if the continent name is null
        if js['geoplugin_continentName'] is None:
            continent_name = 'Unknown'
        else:
            continent_name = js['geoplugin_continentName']
        # check if the tatitude  is null
        if js['geoplugin_latitude'] is None:
            latitude = 'Unknown'
        else:
            latitude = js['geoplugin_latitude']
        # check if the longitude is null
        if js['geoplugin_longitude'] is None:
            longitude = 'Unknown'
        else:
            longitude = js['geoplugin_longitude']
        
        Visitors.objects.create(

            ip_address=ip_address,
            # date=today,
            # time=time,
            country=country,
            city=city,
            region=region,
            region_code=region_code,
            region_name=region_name,
            country_code=country_code,
            continent_name=continent_name,
            latitude=latitude,
            longitude=longitude,
                                )
        # Create a new form instance and populate it with data from the request (binding):
        

                                
        # return the html page
        with open('geoplugin.json', 'w') as f:
            json.dump(js, f)
        
       
        return render(request, 'ianmuthuri/index.html', context)

# visitors views 
def visitorTracker(request):
    # Create a simple html page as a string
    context = {}
    json_serializer = serializers.get_serializer("json")()
    # If the request method is GET
    if request.method == 'GET':
        # //get the visitor information from the database
        visitors = Visitors.objects.order_by('date')
        if(visitors.count() > 10):
            context['visitors'] = visitors[:10]
        else:
            context['visitors'] = visitors
            context['visitors_serialized'] = json_serializer.serialize(visitors)
        visitors_serialize = json_serializer.serialize(Visitors.objects.all().order_by('date'), ensure_ascii=False)
        # Appen the course list as an entry of context dict
        # context['visitors'] = visitors
        return render(request, 'ianmuthuri/visitors.html', context)

