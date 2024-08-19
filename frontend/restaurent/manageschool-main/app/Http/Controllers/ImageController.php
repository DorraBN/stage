<?php
namespace App\Http\Controllers;

use App\Models\Image;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ImageController extends Controller
{
   
    public function index()
    {
        $response = response()->json([
            'message' => 'This is a CORS-enabled response',
        ]);
    
        $response->header('Access-Control-Allow-Origin', '*');
        $response->header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        $response->header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
        $images = Image::all();

        $response = response()->json([
            'data' => $images,
            'message' => 'Images retrieved successfully',
        ]);
        return $response;
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string',
            'image' => 'nullable|string', 
        ]);
        
        $image = new Image();
        $image->title = $request->input('title');
        
        if ($request->has('image')) {
            $imageData = $request->input('image');
            $imageData = str_replace('data:image/png;base64,', '', $imageData);
            $imageData = str_replace(' ', '+', $imageData);
            $fileName = 'image_' . time() . '.png';
            Storage::disk('public')->put($fileName, base64_decode($imageData));
            $url = Storage::url($fileName);
            $image->url = $url;
        } else {
            $image->url = null;
        }
        
        $image->save();
        
        return response()->json(['message' => 'Image saved successfully', 'data' => $image]);
    }
}
