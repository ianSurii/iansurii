from django.urls import path, include
from . import views
from django.conf import settings
from django.conf.urls.static import static
from django.urls import include


urlpatterns = [
    # Create a path object defining the URL pattern to the index view
    path(route='', view=views.index, name='home'),


] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)\
    + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)\
    + static(settings.UPLOADS_URL, document_root=settings.UPLOADS_ROOT)
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL,
                          document_root=settings.MEDIA_ROOT)
