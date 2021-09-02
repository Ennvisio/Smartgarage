<?php

namespace App\Http\Controllers;

use App\Models\Contact;
use App\Models\Invoice;
use App\Models\Product;
use App\Models\Purchase;
use Carbon\Carbon;
use Illuminate\Http\Request;

class DashboardController extends Controller
{

    public function get_top_card_data()
    {
        $number_of_product = Product::active()->count();
        $number_of_invoice = Invoice::active()->whereDate('created_at', Carbon::today())->count();
        $number_of_purchase = Purchase::active()->whereDate('created_at', Carbon::today())->count();
        $number_of_clients = Contact::active('customer')->count();
        $recent_products = Product::with('category')->active()->latest()->take('5')->get();

        return response()->json(["number_of_product"=>$number_of_product, "number_of_invoice"=>$number_of_invoice, "number_of_purchase"=>$number_of_purchase, "number_of_clients"=>$number_of_clients, "recent_products"=> $recent_products]);
    }


}
