<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Menu extends Model
{
    use HasFactory;

    protected $table = 'menu';
    protected $casts = [
        'available' => 'boolean',
    ];
    protected $fillable = [
        'name',
        'category',
        'description',
        'price',
        'available',
        'image_url',
    ];
}
