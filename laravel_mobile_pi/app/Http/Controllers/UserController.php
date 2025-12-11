<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{

    public function mostrar(){
        return User::all();
    }


    public function registrar(Request $request){

        # validação 
        $request->validate([
            'name'     => 'required|max:200',
            'email'    => 'required|email|max:200|unique:users',
            'password' => 'required|min:3'
        ]);

        # criar usuario
        $user = User::create([
            'name'    => $request->name,
            'email'   => $request->email,
            'password'=> Hash::make($request->password)
        ]);

        return response()->json([
            'message' => 'Usuário criado com sucesso!',
            # retorna todas as informacoes do usuario
            'user' => $user
        ], 200);
        
    }


    public function login(Request $request){

        # validar
        $request->validate([
            'email'    => 'required|email|max:200',
            'password' => 'required'
        ]);

        # $user recebe o primeiro usuario que tiver o email igual ao do request
        $user = User::where('email', $request->email)->first();

        # se usuario nao existir ou senha errada
        if(!$user || !Hash::check($request->password, $user->password)){
            return response()->json([
                'message' => 'Credenciais incorretas'
            ], 401);
        }
        # else

        #apaga o token que existia e gera outro
        $user->tokens()->delete();

        # criamos o token
        $token = $user->createToken($request->email)->plainTextToken;

        return response()->json([
            'message' => 'Login realizado com sucesso!',
            'token'   => $token,
            'user'    => $user,
            'request' => $request->all()
        ]);

    }


    public function logout(Request $request){

        $user = $request->user();
        $user->tokens()->delete();

        return response()->json([
            'status'  => 'ok',
        ], 200);

    }


    // public function recuperar(Request $request){

    //     $request->validare([
    //         'email' => 'required|email|max:200'
    //     ]);
    // }

        public function perfil(Request $request){
            return $request->user();
        }
}

