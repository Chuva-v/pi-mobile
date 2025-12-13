<?php

use App\Http\Controllers\MusicaController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('musicas/{nome}', [MusicaController::class, 'tocar']);
