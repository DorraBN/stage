<?php

namespace App\Http\Controllers;

namespace App\Http\Controllers;

use Symfony\Component\HttpFoundation\Response;

class FileController extends Controller
{
    public function serveImage($filename)
    {
        $path = storage_path('app/public/' . $filename);

        if (!file_exists($path)) {
            abort(404);
        }

        $file = file_get_contents($path);
        $response = new Response($file, 200);
        $response->headers->set('Content-Type', 'image/png');
        $response->headers->set('Access-Control-Allow-Origin', '*');

        return $response;
    }
}
