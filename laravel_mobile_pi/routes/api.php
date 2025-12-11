<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;


//Route::get('usuarios', [UserController::class, 'mostrar']);

# rotas livres ===========================================
Route::post('registrar', [UserController::class, 'registrar']);
Route::post('login', [UserController::class, 'login']);
Route::post('recuperar', [UserController::class, 'recuperar']);


# rotas protegidas ========================================
Route::group(['middleware' => 'auth:sanctum'], function() {

    Route::post('logout', [UserController::class, 'logout']);
    Route::get('perfil' , [UserController::class , 'perfil']);
    
});
