from django.db import models
from djongo.models.fields import ObjectIdField

class Transaction(models.Model):
    id = ObjectIdField()
    tx_hash = models.CharField(max_length=66)
    sender = models.CharField(max_length=42)
    recipient = models.CharField(max_length=42)
    amount = models.DecimalField(max_digits=18, decimal_places=6)
    date = models.DateTimeField(auto_now_add=True)
