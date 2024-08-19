<?php

namespace App\Http\Controllers;


use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
class AuthController extends Controller
{
    /**
     * Handle user registration.
     *
     * @param  Request  $request
     * @return \Illuminate\Http\Response
     */
    public function register(Request $request)
    {
        try {
            $input = $request->all();
            $validator = Validator::make($input, [
                'name' => 'required',
                'email' => 'required|email|unique:users,email',
                'phone' => 'required',
                'password' => 'required|min:6',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => 'Validation Error',
                    'errors' => $validator->errors(),
                ], 422);
            }

            $input['password'] = Hash::make($request->password);
            $user = User::create($input);

          

            return response()->json([
                'status' => true,
                'message' => 'User registered successfully',
                'data' => [
                    'user' => $user,
                  
                    'token_type' => 'Bearer',
                ],
            ], 200);
        } catch (\Throwable $th) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to register user',
                'error' => $th->getMessage(),
            ], 500);
        }
    }
    public function login(Request $request)
    {
        try {
            $input = $request->only('email', 'password');
    
            $validator = Validator::make($input, [
                'email' => 'required|email',
                'password' => 'required',
            ]);
    
            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => 'Validation Error',
                    'errors' => $validator->errors(),
                ], 422);
            }
    
            if (!Auth::attempt($input)) {
                return response()->json([
                    'status' => false,
                    'message' => 'Unauthorized',
                ], 401);
            }
    
            $user = Auth::user();
    
            // Check if the logged in user's email is 'admin@gmail.com'
            if ($user->email === 'admin@gmail.com') {
            
    
                return response()->json([
                    'status' => true,
                    'message' => 'Logged in successfully',
                    'data' => [
                        'user' => $user,
                        
                        'token_type' => 'Bearer',
                    ],
                ], 200);
            } else {
               
                Auth::logout(); 
                return response()->json([
                    'status' => false,
                    'message' => 'Unauthorized: You are not an admin user.',
                ], 401);
            }
        } catch (\Throwable $th) {
            return response()->json([
                'status' => false,
                'message' => 'Failed to login user',
                'error' => $th->getMessage(),
            ], 500);
        }
    }

}
