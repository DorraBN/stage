<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Reserve;

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Reserve;

class ReserveController extends Controller
{
    public function index()
    {
        return response()->json(Reserve::all());
    }
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'required|string|max:255',
            'email' => 'required|string|email|max:255',
            'person' => 'required|string|max:255',
            'reservation_date' => 'required|date',
            'time' => 'required|string|max:255',
            'message' => 'nullable|string',
            'status' => 'Confirmed|string',
        ]);

        $reserve = Reserve::create($request->all());

        return response()->json($reserve, 200);
    }
    public function show($id)
    {
        $reserve = Reserve::findOrFail($id);
        return response()->json($reserve);
    }
    public function destroy($id)
    {
        $reserve = Reserve::findOrFail($id);
        $reserve->delete();

        return response()->json(null, 200);
 
    }
    public function checkEmail(Request $request)
    {
        $email = $request->input('email');
        $exists = Reserve::where('email', $email)->exists();

        return response()->json(['exists' => $exists]);
    }

    public function getReservationsByEmail(Request $request)
    {
        $email = $request->query('email');

        if (!$email) {
            return response()->json(['error' => 'Email is required'], 400);
        }

        $reservations = Reserve::where('email', $email)->get();

        if ($reservations->isEmpty()) {
            return response()->json(['message' => 'No reservations found'], 404);
        }

        return response()->json($reservations);
    }



public function update(Request $request, $id)
{
    $reserve = Reserve::findOrFail($id); 

    $reserve->name = $request->input('name');
    $reserve->phone = $request->input('phone');
    $reserve->email = $request->input('email');
    $reserve->person = $request->input('person');
    $reserve->person = $request->input('person');
    $reserve->reservation_date = $request->input('reservation_date');
    $reserve->time = $request->input('time');
    $reserve->message = $request->input('message');
    $reserve->status = $request->input('status');

    $reserve->save();

    return response()->json($resere, 200); 
}


}
