<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;
    protected $fillable = [
        'customer_name', 'phone_number', 'delivery_address', 'payment_method',
        'card_number', 'expiry_date', 'cvv', 'total_price', 'items', 'is_confirmed'
    ];

    protected $casts = [
        'items' => 'array', // Assure que les items sont traités comme un tableau
    ];
}
