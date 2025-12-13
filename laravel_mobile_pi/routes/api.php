<?php

use App\Http\Controllers\MusicaController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;


//Route::get('usuarios', [UserController::class, 'mostrar']);

# rotas livres ===========================================
Route::post('registrar', [UserController::class, 'registrar']);
Route::post('login', [UserController::class, 'login']);
Route::get('capas/{nome}', [MusicaController::class, 'mostrarCapa']);
//Route::post('recuperar', [UserController::class, 'recuperar']);

# rotas protegidas ========================================
Route::group(['middleware' => 'auth:sanctum'], function() {

    Route::post('logout', [UserController::class, 'logout']);
    Route::get('perfil' , [UserController::class , 'perfil']);

    Route::get('musicas', [MusicaController::class, 'listar']);
    Route::post('musicas/add', [MusicaController::class, 'addstore']);
    Route::get('musicas/{nome}', [MusicaController::class, 'tocar']);
    // Route::get('musicas/categoria', [MusicaController::class, 'categoria']);
    // Route::get('musicas/artista', [MusicaController::class, 'artista']);
    // Route::get('musicas/titulo', [MusicaController::class, 'titulo']);
});
