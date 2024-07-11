<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// routes/api.php

Route::get('/sign', function () {
    return response()->json(['message' => 'This is the sign endpoint']);
});


Route::post('login', [AudthController::class, 'login']);
Route::post('register', [AudthController::class, 'register']);

