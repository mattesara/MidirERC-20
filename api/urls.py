from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('get_supply/', views.get_supply, name='get_supply'),
    path('balance/', views.balance_view, name='balance'),
    path('get_balance/', views.get_balance, name='get_balance'),
    path('approve/', views.approve, name='approve'),
    path('get_approve/', views.get_approve, name='get_approve'),
    path('allowance/', views.allowance, name='allowance'),
    path('get_allowance/', views.get_allowance, name='get_allowance'),
    path('transferFrom/', views.transferFrom, name='transferFrom'),
    path('get_transferFrom/', views.get_transferFrom, name='get_transferFrom'),
    path('transfer/', views.transfer, name='transfer'),
    path('get_transfer/', views.get_transfer, name='get_transfer'),
]