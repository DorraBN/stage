<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\MenuController;
use App\Http\Controllers\TableController;
use App\Http\Controllers\ReserveController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\ImageController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\ReservationController;
use App\Http\Controllers\emailController;
Route::post('/send-email', [emailController::class, 'sendEmail']);

Route::post('/send-reservation-email', [ReservationController::class, 'sendReservationEmail']);
Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Authentication routes
Route::post('register', [AuthController::class, 'register']);
Route::post('login', [AuthController::class, 'login']);

// Menu routes
Route::get('menu', [MenuController::class, 'index']);
Route::get('menu/{id}', [MenuController::class, 'show']);
Route::post('menustore', [MenuController::class, 'store']);
Route::put('menuup/{id}', [MenuController::class, 'update']);
Route::delete('destroy/{id}', [MenuController::class, 'destroy']);
///table routes

Route::get('table', [TableController::class, 'index']);
Route::get('table/{id}', [TableController::class, 'show']);
Route::post('storeTable', [TableController::class, 'store']);
Route::put('update/{id}', [TableController::class, 'update']);
Route::delete('destroyTable/{id}', [TableController::class, 'destroy']);

///reservations routes

Route::post('reserves', [ReserveController::class, 'store']);
Route::get('reserves/{id}', [ReserveController::class, 'show']);
Route::get('showreserves', [ReserveController::class, 'index']);
Route::delete('deletereserves/{id}', [ReserveController::class, 'destroy']);
Route::post('/check-email', [ReserveController::class, 'checkEmail']);
Route::get('/reservations', [ReserveController::class, 'getReservationsByEmail']);
Route::put('updateReserve/{id}', [ReserveController::class, 'update']);
///products routes
Route::get('products', [ProductController::class, 'index']);
Route::get('productdetails/{id}', [ProductController::class, 'show']);
Route::post('/productss', [ProductController::class, 'store']);
Route::put('products/{id}', [ProductController::class, 'update']);
Route::delete('deleteproducts/{id}', [ProductController::class, 'destroy']);
///orders routes
Route::post('orders', [OrderController::class, 'store']);
Route::get('orderss', [OrderController::class, 'index']);
Route::put('ordersupdate/{id}', [OrderController::class, 'update']);

Route::delete('deleteOrder/{id}', [OrderController::class, 'destroy']);
Route::get('image/{id}', [ImageController::class, 'show']);
Route::post('/imageadd', [ImageController::class, 'store']);
Route::get('/images', [ImageController::class, 'index']);

// Post
Route::get('/postss', [PostController::class, 'index']); // all posts
Route::post('/posts', [PostController::class, 'store']); // create post
Route::get('/posts/{id}', [PostController::class, 'show']); // get single post
Route::put('/posts/{id}', [PostController::class, 'update']); // update post
Route::delete('/posts/{id}', [PostController::class, 'destroy']); // delete post
