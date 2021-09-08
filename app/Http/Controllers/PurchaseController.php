<?php

namespace App\Http\Controllers;

use App\Helpers\Helper;
use App\Http\Resources\PurchaseItemsResource;
use App\Http\Resources\PurchaseResource;
use App\Models\BusinessLocation;
use App\Models\LocationProductStock;
use App\Models\Product;
use Illuminate\Http\Request;
use App\Models\Purchase;
use App\Models\PurchaseItem;
use App\Models\PurchasePayment;
use App\Models\User;
use App\Models\Contact;

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;

class PurchaseController extends Controller
{
    public function __construct()
    {
        $this->middleware('jwt', ['except' => ['index']]);
    }

    public function index()
    {
        $purchase = Purchase::active()->paginate(10);
        return  PurchaseResource::collection($purchase);
    }

    public function getSuppliers()
    {
        $suppliers = Contact::where('owner_id', 1)->where('type', 'supplier')->get();
        return response()->json($suppliers);
    }
    public function store(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'contact_id' => 'required',
                'purchase_date' => 'required',
                'purchase_status' => 'required',
            ]
        );

        if ($validator->fails()) {
            return response()->json(['success' => false, 'error' => $validator->errors()], 422);
        }
        DB::beginTransaction();
        try {
            $purchase = new Purchase();
            $purchase->owner_id = auth()->user()->id;
            $purchase->purchase_number = (time() + rand(10, 1000));;
            $purchase->contact_id = $request->contact_id;
            $purchase->purchase_status = $request->purchase_status;
            $purchase->purchase_date = date("Y-m-d", strtotime($request->purchase_date));
            $purchase->purchase_discount = $request->purchase_discount;
            $purchase->purchase_tax = $request->purchase_tax;
            $purchase->note = $request->details;
            $purchase->created_by = auth()->user()->id;
            $purchase->updated_by = auth()->user()->id;
            $purchase->save();
            $item_purchase_quantity = 0;
            $item_subtotal_price = 0;
            $afterTax = 0;
            foreach (json_decode($request->purchase_items,true) as $item) {
                $purchase_item = PurchaseItem::savePurchaseItem($purchase->id, $item);
                $productID = $item['id'];
                $purchase_quantity = $item['purchase_quantity'];
                $product = Product::find($productID);
                $old_quantity = $product->quantity;
                if ( $purchase->purchase_status == "Received" && $purchase_quantity >0) {
                    $product->quantity = $purchase_quantity + $old_quantity;
                    $product->save();
                }
                $item_purchase_quantity += $purchase_item->purchase_quantity;
                $item_subtotal_price += $purchase_item->total_price;
            }

            $purchase->total_purchase_quantity = $item_purchase_quantity;
            $purchase->subtotal_cost = $item_subtotal_price;
            if ($purchase->purchase_tax > 0) {
                $taxInPercentage = ($purchase->purchase_tax / 100);
                $afterTax = round($item_subtotal_price * $taxInPercentage);
            }

            $purchase->total_cost = ($item_subtotal_price + $afterTax) - $purchase->purchase_discount;
            $purchase->save();

            if ($request->paid_price != null) {
                $purchase->payments()->create([
                    'payment_amount' => $request->paid_price,
                    'payment_method' => $request->payment_method,
                    'payment_date' => date("Y-m-d", strtotime($request->payment_date ? $request->payment_date : now())),
                    'payment_details' => $request->payment_details,
                ]);
            }

        } catch (\Exception $e) {
            DB::rollback();
            return response()->json(['success' => false, 'errmsg' => $e->getMessage()], 500);
        }
        DB::commit();

        return response(new PurchaseResource($purchase), Response::HTTP_CREATED);
    }

    public function show(Purchase $purchase)
    {
        return new PurchaseResource($purchase);
    }
    public function update(Request $request, $id)
    {
        DB::beginTransaction();
        try {
            $purchase = Purchase::findOrFail($id);

            if ($request->has('contact_id')) {
                $purchase->contact_id = $request->contact_id;
            }
            if ($request->has('purchase_status')) {
                $purchase->purchase_status = $request->purchase_status;
            }
            if ($request->has('purchase_date')) {
                $purchase->purchase_date = date("Y-m-d", strtotime($request->purchase_date));
            }
            if ($request->has('purchase_discount')) {
                $purchase->purchase_discount = $request->purchase_discount;
            }
            if ($request->has('purchase_tax')) {
                $purchase->purchase_tax = $request->purchase_tax;
            }
            $purchase->updated_by = auth()->user()->id;
            $purchase->save();
            $item_purchase_quantity = 0;
            $item_subtotal_price = 0;
            $afterTax = 0;
            if ($request->has('purchase_items')) {
                foreach (json_decode($request->purchase_items,true) as $item) {
                    $existing_purchased_items = PurchaseItem::where('purchase_id', $purchase->id)->where('product_id', $item['id'])->first();
                    if ($existing_purchased_items) {
                        $purchase_item_update = PurchaseItem::find($existing_purchased_items->id);
                        $purchase_item_update->purchase_id = $purchase->id;
                        $purchase_item_update->product_id = $item['id'];
                        $purchase_item_update->purchase_quantity = $item['purchase_quantity'];
                        $purchase_item_update->purchase_price = $item['price'];
                        $purchase_item_update->total_price = $item['purchase_quantity'] * $item['price'];
                        $purchase_item_update->save();
                        $productID = $item['id'];
                        $purchase_quantity = $item['purchase_quantity'];
                        $product = Product::find($productID);
                        $old_quantity = $product->quantity;
                        if ( $purchase->purchase_status == "Received" && $purchase_quantity >0) {
                            $product->quantity = $purchase_quantity + $old_quantity;
                            $product->save();
                        }
                        $item_purchase_quantity += $purchase_item_update->purchase_quantity;
                        $item_subtotal_price += $purchase_item_update->total_price;
                    } else {
                        $purchase_item = PurchaseItem::savePurchaseItem($purchase->id, $item);
                        $productID = $item['id'];
                        $purchase_quantity = $item['purchase_quantity'];
                        $product = Product::find($productID);
                        $old_quantity = $product->quantity;
                        if ( $purchase->purchase_status == "Received" && $purchase_quantity >0) {
                            $product->quantity = $purchase_quantity + $old_quantity;
                            $product->save();
                        }
                        $item_purchase_quantity += $purchase_item->purchase_quantity;
                        $item_subtotal_price += $purchase_item->total_price;
                    }
                }
            }
            if ($purchase->purchase_tax > 0) {
                $taxInPercentage = ($purchase->purchase_tax / 100);
                $afterTax = round($item_subtotal_price * $taxInPercentage);
            }
            $purchase->total_purchase_quantity = $item_purchase_quantity;
            $purchase->total_cost = ($item_subtotal_price + $afterTax) - $purchase->purchase_discount;
            $purchase->total_cost = $item_subtotal_price;
            $purchase->save();
            DB::commit();
        } catch (\Exception $e) {
            DB::rollback();
            return response()->json(['success' => false, 'errmsg' => $e->getMessage()], 500);
        }
        return response(new PurchaseResource($purchase), Response::HTTP_CREATED);
    }

    public function destroy($id)
    {
        $purchase = Purchase::where('id', $id)->first();
        $purchase->delete();
        return response()->json(['success' => true, 'message' => 'Deleted successfully'], 204);
    }

    //For payment
    public function addPayment(Request $request, $id)
    {
        $purchase = Purchase::findOrFail($id);
        $previousPayment = $purchase->payments->sum('payment_amount');
        if ($purchase->total_cost >= ($previousPayment + $request->payment_amount)) {
            $newPayment = $purchase->payments()->create([
                'payment_amount' => $request->payment_amount,
                'payment_method' => $request->payment_method,
                'card_no' => $request->card_no,
                'bank_name'=>$request->bank_name,
                'account_no'=>$request->account_no,
                'payment_date' => date("Y-m-d", strtotime($request->payment_date ? $request->payment_date : now()))
            ]);

            $purchase->payment_status = "Due";
            if ($purchase->total_cost == ($previousPayment + $request->payment_amount)) {
                $purchase->payment_status = "Paid";
            }
            $purchase->save();
            return response(new PurchaseResource($purchase), Response::HTTP_OK);
        } elseif ($purchase->total_cost < ($previousPayment + $request->payment_amount)) {
            return response()->json(['success' => false, 'message' => 'You can not pay more than the original amount!'], 400);
        }
    }


    public function purchaseItemsList(Request $request)
    {
        $purchaseid = $request->purchase_id;
        $purchase = Purchase::findOrFail($purchaseid);
        $all_items = $purchase->purchaseItems;
        return response(PurchaseItemsResource::collection($all_items), Response::HTTP_OK);
    }

    public function getContacts()
    {
        $contacts = Contact::get();
        return \response()->json($contacts);
    }

    public function getBusinessLocations()
    {
        $locations = BusinessLocation::get();
        return \response()->json($locations);
    }

    public function getProducts(Request $request)
    {
        $name = $request->name;
        $products = Products::where('name', 'LIKE', "%$name%")->get();
        return \response()->json($products);
    }


}
