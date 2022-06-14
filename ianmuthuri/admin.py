
from django.contrib import admin
from .models import About, Tool, Certificate, Projects, Services, Blog,Visitors



# class PostAdmin(SummernoteModelAdmin):
#     ummernote_fields = ('content',)

# admin.site.register(Blog, PostAdmin)
admin.site.register(Tool)
admin.site.register(Certificate)
admin.site.register(Projects)
admin.site.register(Services)
admin.site.register(About)
admin.site.register(Blog)
admin.site.register(Visitors)
# Register your models here.
# class ProjectsAdmin(admin.ModelAdmin):
#     fields = ['title', 'description']
#     inlines = [LessonInline]

# admin.site.register(Projects, ProjectsAdmin)
