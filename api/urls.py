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
    path('burn/', views.burn, name='burn'),
    path('get_burn/', views.get_burn, name='get_burn'),
    path('mint/', views.mint, name='mint'),
    path('get_mint/', views.get_mint, name='get_mint'),
    path('stake/', views.stake, name='stake'),
    path('get_stake/', views.get_stake, name='get_stake'),
    path('withdraw/', views.withdrawStakeAndRewards, name='withdraw'),
    path('get_withdraw/', views.get_withdraw, name='get_withdraw'),
    path('staked_balance/', views.stakedBalanceOf, name='staked_balance'),
    path('get_staked_balance/', views.get_stakedBalanceOf, name='get_staked_balance'),
    
]