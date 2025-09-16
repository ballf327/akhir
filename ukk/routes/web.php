<?php

use App\Http\Controllers\AuthController;
use Illuminate\Support\Facades\Route;

Route::get('/register', [AuthController::class, 'showRegister'])->name('register');
Route::post('/register', [AuthController::class, 'register']);

Route::get('/', [AuthController::class, 'showLogin'])->name('login');
Route::post('/', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

// Dashboard masing-masing role
Route::middleware(['auth', 'role:admin'])->get('/admin/dashboard', function () {
    return "Selamat datang Admin!";
})->name('admin.dashboard');

Route::middleware(['auth', 'role:petugas'])->get('/petugas/dashboard', function () {
    return "Selamat datang Petugas!";
})->name('petugas.dashboard');

Route::middleware(['auth', 'role:user'])->get('/user/dashboard', function () {
    return "Selamat datang User!";
})->name('user.dashboard');
