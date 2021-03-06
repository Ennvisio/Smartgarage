<?php

namespace App\Http\Controllers;

use App\Models\Client;
use App\Models\Collection;
use App\Models\Customer;
use App\Models\Payment;
use App\Models\Product;
use App\Models\Setting;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

use App\Http\Controllers\Controller;
use Spatie\Permission\Models\Role;
use Hash;
use Illuminate\Support\Arr;

class UserController extends Controller
{
    public function index()
    {
        $users = User::paginate(5);
        return view('users.index', compact('users'));
    }

    public function create()
    {
        return view('users.create');
    }

    public function store(Request $request)
    {
        $this->validate($request, [
            'business_name' => 'required|string',
            'first_name' => 'required',
            'last_name' => 'required',
            'username' => 'required',
            'email' => 'required|email|unique:users,email',
            // 'password' => 'required|same:confirm-password',
            'password' => 'required',
            'roles' => 'required',
        ]);
        $user = User::create($request->only('name', 'username', 'email')
            + [
                'password' => bcrypt($request->input('password')),
            ]);
        $user->assignRole($request->input('roles'));
    }

    public function show(User $user)
    {

        return view('users.show', compact('user'));
    }

    public function dashboardData(Request $request)
    {
        if ($request->reportfor == 'weekly') {
            $startDate = Carbon::now()->startOfWeek(Carbon::SATURDAY);
            $endDate =  Carbon::now()->endOfWeek(Carbon::THURSDAY);
        } elseif ($request->reportfor == 'monthly') {
            $startDate = new Carbon('first day of this month');
            $endDate = new Carbon('last day of this month');
        } elseif ($request->reportfor == 'daily') {
            $startDate = Carbon::today();
            $endDate = Carbon::tomorrow();
        } else {
            $startDate = Carbon::now()->startOfYear();
            $endDate = Carbon::now()->endOfYear();
        }
        $lastestPayment = Payment::leftjoin('banks', 'banks.id', '=', 'payments.bank_id')->select('select_mode', 'banks.name as bank_name', 'payments.created_at', 'payment_amount')->orderBY('payments.id', 'desc')->take(4)->get();

        $totalCollection = Collection::whereBetween('created_at', [$startDate, $endDate])->sum('amount');
        $countClient = Client::all()->count();
        $countCustomer = Customer::all()->count();

        $regular_customers = Customer::join('order_products', 'customers.id', '=', 'order_products.customer_id')
            ->selectRaw('customers.*, COALESCE(sum(order_products.quantity),0) total_purchse, sum(order_products.total) as total_amount')
            ->where('customers.delete_status', 1)
            ->groupBy('customers.id')
            ->orderBy('total_purchse', 'desc')
            ->take(4)
            ->get();

        $popular_fish = Product::join('order_products', 'products.id', '=', 'order_products.product_id')
            ->selectRaw("products.*, sum(order_products.total) as total_amount")
            ->where('products.delete_status', 1)
            ->groupBy('products.id')
            ->orderBy('total_amount', 'desc')
            ->take(4)
            ->get();
        $commissions = Setting::select('arot_commission', 'bazar_commission')->first();

        $data = array(
            'totalcollection' => strval($totalCollection),
            'totalclient' => strval($countClient),
            'totalcustomer' => strval($countCustomer),
            'regular_customers' => $regular_customers,
            'popular_fish' => $popular_fish,
            'latest_payment' => $lastestPayment,
            'commissions' => $commissions
        );

        return response()->json(['success' => true, 'data' => $data], 200);
    }

    public function update(Request $request, $id)
    {
        $user = User::findOrFail($id);
        if ($request->has('first_name')) {
            $user->first_name = $request->first_name;
        }
        if ($request->has('last_name')) {
            $user->last_name = $request->last_name;
        }
        if ($request->has('username')) {
            $user->username = $request->username;
        }
        if ($request->has('email')) {
            $user->email = $request->email;
        }

        $user->save();
        return response()->json(['success' => true, 'message' => 'Updated successfully'], 200);
    }
    public function changePassword(Request $request)
    {
        $this->validate($request, [
            'new_password' => 'required|min:4'
        ]);
        $user = User::findOrFail(auth()->user()->id);
        if ($request->has('new_password')) {
            $user->password = bcrypt($request->new_password);
            $user->update();
            return response()->json(['message' => "password updated successfully"]);
        } else {
            return response()->json(['success' => false], 500);
        }
    }
}
