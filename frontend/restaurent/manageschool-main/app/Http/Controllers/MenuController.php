<?php

namespace App\Http\Controllers;

use App\Models\Menu;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class MenuController extends Controller
{
    public function index()
    {
        $menu = Menu::all();
        return response()->json($menu);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric',
            'category' => 'required|string',
            'image_url' => 'nullable|string',
            'available' => 'required|boolean',
        ]);

        $image_url = null;

        if ($request->has('image_url')) {
            $imageData = $request->input('image_url');
            $imageData = str_replace('data:image/png;base64,', '', $imageData);
            $imageData = str_replace(' ', '+', $imageData);
            $fileName = 'image_' . time() . '.png';
            Storage::disk('public')->put($fileName, base64_decode($imageData));
            $image_url = Storage::url($fileName);
        }

        $menu = Menu::create([
            'name' => $request->input('name'),
            'description' => $request->input('description'),
            'price' => $request->input('price'),
            'category' => $request->input('category'),
            'image_url' => $image_url,
            'available' => $request->input('available'),
        ]);

        return response()->json($menu, 200);
    }

    public function show($id)
    {
        return response()->json(Menu::find($id));
    }

    public function update(Request $request, $id)
    {
        $menu = Menu::findOrFail($id);
        $menu->update($request->all());
        return response()->json($menu, 200);
    }

    public function destroy($id)
    {
        Menu::findOrFail($id)->delete();
        return response()->json(null, 200);
    }
}
