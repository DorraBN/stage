<?php

namespace App\Http\Controllers;

use App\Models\Table;
use Illuminate\Http\Request;

class TableController extends Controller
{
    public function index()
    {
        $tables = Table::all();
        return response()->json($tables);
    }

    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'name' => 'required|string',
            'capacity' => 'required|integer',
            'position' => 'nullable|string',
            'availability' => 'required|boolean',
        ]);

        $table = Table::create($validatedData);

        return response()->json($table, 200);
    }

    public function show($id)
    {
        $table = Table::findOrFail($id);
        return response()->json($table);
    }

    public function update(Request $request, $id)
    {
        $table = Table::findOrFail($id); // Récupérer l'élément existant par son ID
        
        // Valider et mettre à jour les champs nécessaires
        $table->name = $request->input('name');
        $table->capacity = $request->input('capacity');
        $table->position = $request->input('position');
        $table->availability = $request->input('availability');
    
        $table->save(); // Sauvegarder les modifications
    
        return response()->json($table, 200); // Répondre avec l'élément mis à jour
    }

    public function destroy($id)
    {
        $table = Table::findOrFail($id);
        $table->delete();

        return response()->json(null, 200);
    }
}
