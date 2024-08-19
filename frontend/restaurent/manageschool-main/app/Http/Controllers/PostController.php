<?php
namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'body' => 'required|string',
            'user_id' => 'required|integer',
            'image' => 'nullable|url', // Vérification que c'est bien un URL
        ]);

        $post = Post::create([
            'body' => $request->input('body'),
            'user_id' => $request->input('user_id'),
            'image' => $request->input('image'), // Sauvegarde de l'URL de l'image
        ]);

        return response()->json($post, 200);
    }

    public function index()
    {
        $post = Post::all();
        return response()->json($post);
    }
}
