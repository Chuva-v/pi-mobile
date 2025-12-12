<?php

namespace App\Http\Controllers;

use App\Models\Musica;
use Illuminate\Http\Request;

class MusicaController extends Controller
{
    public function listar(){
        return Musica::all();
    }

    public function tocar($nome){
        $caminho = storage_path("app/musicas/".$nome);

        if(!file_exists($caminho)){
            return response()->json(
                ['erro' => 'arquivo nao encontrado'], 404
            );
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
