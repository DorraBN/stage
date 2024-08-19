<?php


namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reserve extends Model
{
    use HasFactory;
    protected $table = 'reserves';
    protected $fillable = [
        'name', 'phone', 'email', 'person', 'reservation_date', 'time', 'message',
    ];
}
