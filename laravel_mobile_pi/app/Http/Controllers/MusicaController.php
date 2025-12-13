<?php

namespace App\Http\Controllers;

use App\Models\Musica;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;

class MusicaController extends Controller
{
    public function listar(){
        return Musica::all();
    }

    public function tocar($nome){
        $caminho = storage_path("app/public/musicas/$nome");
        //dd();
        if(!file_exists($caminho)){
            return response()->json(
                ['erro' => 'função tocar no Controller musicas nao achou o arquivo'], 404
            );
        }

        return response()->file($caminho);
    }
    
    public function mostrarCapa($nome){
        $caminho = storage_path("app/capas/$nome");

        if (!file_exists($caminho)) {
            return response()->json([
                'erro' => 'Arquivo não encontrado (file_exists)',
                'caminho_testado' => $caminho
            ], 404);
        }

        return response()->file($caminho);
    }

    public function addstore(Request $request){

        //dd("ENTROU AQUI");

        $request->validate([
            'titulo'    => 'required|string',
            'artista'   => 'required|string',
            'categoria' => 'required|string',
            'arquivo'   => 'required|string',
            'capa'      => 'string'
        ]);


        Musica::create([
            'titulo'    => $request->titulo,
            'artista'   => $request->artista,
            'categoria' => $request->categoria,
            'arquivo'    => $request->arquivo,
            'capa'      => $request->capa
        ]);

        return response()->json([
            'message' => 'Música cadastrada!'
        ]);
    }
}
