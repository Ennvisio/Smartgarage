<?php

use App\Http\Controllers\CustomerController;
use App\Http\Controllers\ContactController;
use App\Http\Controllers\ProductsController;
use App\Http\Controllers\CollectionController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\SubCategoryController;
use App\Http\Controllers\UnitController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\SettingController;
use App\Http\Controllers\BrandController;
use App\Http\Controllers\PurchaseController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\RoleController;
use App\Http\Controllers\PermissionController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::group(
    [
        'middleware' => 'api',
        'namespace' => 'App\Http\Controllers',
        'prefix' => 'auth',
    ],
    function ($router) {
        Route::post('login', 'ApiAuthController@login');
        Route::post('signup', 'ApiAuthController@signup');
        Route::post('logout', 'ApiAuthController@logout');
        Route::get('userinfo', 'ApiAuthController@me');
        Route::get('refresh', 'ApiAuthController@refresh');
    }
);


Route::resource('product', ProductsController::class);
Route::post('product/search', [ProductsController::class, 'productSearch']);
Route::get('customer-search', [CustomerController::class, 'customerSearch']);
Route::post('contact-search', [ContactController::class, 'contactSearch']);

Route::resource('category', CategoryController::class);
Route::get('get-categories', [ProductsController::class, 'getAllCategories']);
Route::get('getAllBrands', [ProductsController::class, 'getAllBrands']);
Route::get('get-subcategories/{category}', [CategoryController::class, 'getSubcategories']);
Route::get('get-subunits/{unit}', [UnitController::class, 'getSubUnits']);
Route::get('get-clients', [ContactController::class, 'getClients']);
Route::get('get-suppliers', [ContactController::class, 'getSuppliers']);
Route::get('get-vehicles', [\App\Http\Controllers\InvoiceController::class, 'getVehicles']);
Route::post('get-invoice-details', [\App\Http\Controllers\InvoiceController::class, 'getInvoiceDetails']);


//Route::resource('client', ClientController::class);
Route::resource('customer', CustomerController::class);
Route::resource('contact', ContactController::class);
Route::resource('collection', CollectionController::class);


Route::get('customer-due', [CollectionController::class, 'customerDueMoney']);
Route::get('dashboard-data', [UserController::class, 'dashboardData']);


Route::group(
    [
        'middleware' => 'api',
        'namespace' => 'App\Http\Controllers',
        'prefix' => 'reports',
    ],
    function ($router) {
        Route::get('expense', 'ReportController@expenseReport');
        Route::get('collection', 'ReportController@collectionReport');
        Route::get('payment', 'ReportController@paymentReport');
        Route::get('sales', 'ReportController@salesReport');
    }
);

Route::patch('user/{id}', [UserController::class, 'update']);
Route::post('update-settings', [SettingController::class, 'updateSettings']);
Route::get('settings', [SettingController::class, 'index']);

Route::resource('brand', BrandController::class);

Route::resource('unit', UnitController::class);

Route::resource('purchase', PurchaseController::class);

Route::get('purchase-contacts', [PurchaseController::class, 'getContacts']);
Route::get('purchase-products/{name}', [PurchaseController::class, 'getProducts']);


Route::group(['middleware' => ['auth']], function () {
});

Route::resource('role', RoleController::class);
Route::post('role-has-permission/{id}', [RoleController::class, 'permissionList']);
Route::post('user-role/{id}', [RoleController::class, 'userRole']);
Route::resource('permission', PermissionController::class);

Route::resource('vehicle', \App\Http\Controllers\VehicleController::class);
Route::resource('vehicle-type', \App\Http\Controllers\VehicleTypeController::class);
Route::resource('vehicle-color', \App\Http\Controllers\ColorController::class);

Route::resource('service', \App\Http\Controllers\ServiceController::class);

Route::resource('purchase', PurchaseController::class);
Route::patch('purchase/addpayment/{id}', [PurchaseController::class, 'addPayment']);
Route::get('purchase-payment', [PurchaseController::class, 'viewPayment']);
Route::get('purchase-items', [PurchaseController::class, 'purchaseItemsList']);

Route::resource('invoice', \App\Http\Controllers\InvoiceController::class);
Route::get('get-brands', [BrandController::class, 'getBrands']);
Route::get('top-card-data', [\App\Http\Controllers\DashboardController::class, 'get_top_card_data']);
