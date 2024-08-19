<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;

class ReservationController extends Controller
{
    public function sendReservationEmail(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|email',
            'name' => 'required|string',
            'reservation_date' => 'required|date',
            'reservation_time' => 'required|string',
        ]);

        $email = $validated['email'];
        $name = $validated['name'];
        $reservationDate = $validated['reservation_date'];
        $reservationTime = $validated['reservation_time'];

        Mail::raw(
            "Dear $name,\n\nThis is a friendly reminder of your reservation on $reservationDate at $reservationTime.\n\nBest regards,\nRestaurant Team",
            function ($message) use ($email, $name) {
                $message->to($email, $name)
                        ->subject('Reminder: Reservation Details');
            }
        );

        return response()->json(['message' => 'Email sent successfully!']);
    }
}
