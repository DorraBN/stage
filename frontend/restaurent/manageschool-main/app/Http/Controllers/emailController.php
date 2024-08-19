<?php

namespace App\Http\Controllers;
use App\Mail\ContactMail;
use Illuminate\Support\Facades\Mail;
use Illuminate\Http\Request;

class emailController extends Controller
{
    //
    public function sendEmail(Request $request)
{
    $details = [
        'email' => $request->email,
        'subject' => $request->subject,
        'message' => $request->message,
    ];

    Mail::to('destinataire@example.com')->send(new ContactMail($details));

    return response()->json(['message' => 'Email envoyé avec succès !']);
}
}
