<?php

namespace App\Http\Controllers;

use App\Http\Resources\InvoiceResource;
use App\Models\Invoice;
use App\Models\InvoiceItem;
use App\Models\Product;
use App\Models\Service;
use App\Models\Vehicle;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class InvoiceController extends Controller
{
    public function __construct()
    {
        $this->middleware('jwt', ['except' => ['index']]);
    }

    public function index(Request $request)
    {
        $record = $request->record;
        $keyword = $request->keyword;
        if ($record == 'all' || $request->per_page == -1) {
            $invoices = Invoice::active()->search($keyword)->get();
        } else {
            $invoices = Invoice::active()->search($keyword)->paginate($request->get('per_page', 10));
        }
        return InvoiceResource::collection($invoices);
    }

    public function store(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'contact_id' => 'required',
            ]
        );

        if ($validator->fails()) {
            return response()->json(['success' => false, 'error' => $validator->errors()], 422);
        }
        DB::beginTransaction();
        try {
            $invoice = new Invoice();
            $invoice->invoice_number = (time() + rand(10, 1000));;
            $type = $request->type;
            $invoice->contact_id = $request->contact_id;
            $invoice->owner_id = auth()->user()->id;
            $invoice->paid_price = $request->paid_price;
            $invoice->date = date("Y-m-d", strtotime($request->date));
            $invoice->discount = $request->discount;
            $invoice->vat = $request->vat;
            $invoice->created_by = auth()->user()->id;
            $invoice->save();
            $item_subtotal_price = 0;
            $afterTax = 0;
            foreach ($request->invoice_items as $item) {
                $invoiceItem = new InvoiceItem();
                $invoiceItem->invoice_id = $invoice->id;
                $invoiceItem->vehicle_id = $request->vehicle_id;
                if ($item['category_type'] == "Product") {
                    $invoiceItem->product_id = $item['id'];
                    $invoiceItem->product_rate = $item['price'];
                    $invoiceItem->product_quantity = $item['invoice_quantity'];
                    $invoiceItem->total_price = $item['subtotal'];
                    // Subtracting quantity from products
                    $productID = $item['id'];
                    $invoice_quantity = $item['invoice_quantity'];
                    $product = Product::find($productID);
                    $old_quantity = $product->quantity;
                    if ($old_quantity >= $invoice_quantity) {
                        $product->quantity = $old_quantity - $invoice_quantity;
                        $product->save();
                    }
                    $invoiceItem->save();
                } else if ($item['category_type'] == "Service") {

                    $invoiceItem->service_id = $item['id'];
                    $invoiceItem->service_rate = $item['price'];
                    $invoiceItem->service_quantity = $item['invoice_quantity'];
                    $invoiceItem->total_price = $item['subtotal'];
                    $invoiceItem->save();
                }
                $item_subtotal_price += $invoiceItem->total_price;
            }
            if ($invoice->vat > 0) {
                $taxInPercentage = ($invoice->vat / 100);
                $afterTax = round($item_subtotal_price * $taxInPercentage);
            }
            $invoice->total_cost = ($item_subtotal_price + $afterTax) - $invoice->discount;
            $invoice->save();
            if ($request->paid_price != null) {
                $invoice->payments()->create([
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

        return response(new InvoiceResource($invoice), Response::HTTP_CREATED);
    }


    public function update(Request $request, $id)
    {
        DB::beginTransaction();
        try {
            $invoice = Invoice::findOrFail($id);
            if ($request->has('contact_id')) {
                $invoice->contact_id = $request->contact_id;
            }
            if ($request->has('paid_price')) {
                $invoice->paid_price = $request->paid_price;
            }
            if ($request->has('date')) {
                $invoice->date = date("Y-m-d", strtotime($request->date));
            }
            if ($request->has('discount')) {
                $invoice->discount = $request->discount;
            }
            if ($request->has('vat')) {
                $invoice->vat = $request->vat;
            }
            $invoice->save();

            $item_subtotal_price = 0;
            $afterTax = 0;
            foreach ($request->invoice_items as $item) {

                $product_id_exist = InvoiceItem::where('invoice_id', $invoice->id)->where('product_id', $item['id'])->first();
                $service_id_exist = InvoiceItem::where('invoice_id', $invoice->id)->where('service_id', $item['id'])->first();
                if ($product_id_exist || $service_id_exist) {
                    if ($item['category_type'] == "Product") {
                        $invoice_item_update_product = InvoiceItem::where('invoice_id', $invoice->id)->where('product_id', $item['id'])->first();

                        $invoice_item_update_product->product_id = $item['id'];
                        $invoice_item_update_product->product_rate = $item['price'];
                        $invoice_item_update_product->product_quantity = $item['invoice_quantity'];
                        $invoice_item_update_product->total_price = $item['subtotal'];
                        // Subtracting quantity from products
                        $productID = $item['id'];
                        $invoice_quantity = $item['invoice_quantity'];
                        $product = Product::find($productID);
                        $old_quantity = $product->quantity;
                        if ($old_quantity >= $invoice_quantity) {
                            $product->quantity = $old_quantity - $invoice_quantity;
                            $product->save();
                        }
                        $invoice_item_update_product->save();
                        $item_subtotal_price += $invoice_item_update_product->total_price;
                    } else if ($item['category_type'] == "Service") {

                        $invoice_item_update_service = InvoiceItem::where('invoice_id', $invoice->id)->where('service_id', $item['id'])->first();
                        $invoice_item_update_service->service_id = $item['id'];
                        $invoice_item_update_service->service_rate = $item['price'];
                        $invoice_item_update_service->service_quantity = $item['invoice_quantity'];
                        $invoice_item_update_service->total_price = $item['subtotal'];
                        $invoice_item_update_service->save();
                        $item_subtotal_price += $invoice_item_update_service->total_price;
                    }
                } else {
                    $invoiceItem = new InvoiceItem();
                    $invoiceItem->invoice_id = $invoice->id;

                    if ($request->has('vehicle_id')) {
                        $invoiceItem->vehicle_id = $request->vehicle_id;
                    }

                    if ($item['category_type'] == "Product") {
                        $invoiceItem->product_id = $item['id'];
                        $invoiceItem->product_rate = $item['price'];
                        $invoiceItem->product_quantity = $item['invoice_quantity'];
                        $invoiceItem->total_price = $item['subtotal'];

                        $productID = $item['id'];
                        $invoice_quantity = $item['invoice_quantity'];
                        $product = Product::find($productID);
                        $old_quantity = $product->quantity;
                        if ($old_quantity >= $invoice_quantity) {
                            $product->quantity = $old_quantity - $invoice_quantity;
                            $product->save();
                        }
                        $invoiceItem->save();
                    } else if ($item['category_type'] == "Service") {

                        $invoiceItem->service_id = $item['id'];
                        $invoiceItem->service_rate = $item['price'];
                        $invoiceItem->service_quantity = $item['invoice_quantity'];
                        $invoiceItem->total_price = $item['subtotal'];
                        $invoiceItem->save();
                    }
                    $item_subtotal_price += $invoiceItem->total_price;
                }
            }
            if ($invoice->vat > 0) {
                $taxInPercentage = ($invoice->vat / 100);

                $afterTax = round($item_subtotal_price * $taxInPercentage);
            }

            $invoice->total_cost = ($item_subtotal_price + $afterTax) - $invoice->discount;
            $invoice->save();
        } catch (\Exception $e) {
            DB::rollback();
            return response()->json(['success' => false, 'errmsg' => $e->getMessage()], 500);
        }
        DB::commit();
        return response(new InvoiceResource($invoice), Response::HTTP_CREATED);
    }


    public function destroy($id)
    {
        $invoice = Invoice::where('id', $id)->first();

        $invoice->delete();

        return response()->json(['success' => true, 'message' => 'Deleted successfully'], 204);
    }

    public function show(Invoice $invoice)
    {
        return new InvoiceResource($invoice);
    }

    public function getVehicles(Request $request)
    {
        $vehicles = Vehicle::where('owner_id', 1)->where('contact_id', $request->contact_id)->get();

        return response()->json($vehicles);
    }


    public function getInvoiceItems(Request $request)
    {
        if ($request->category_id === 1) {
            $items = Product::where('category_id', 1)->where('owner_id', auth()->user()->id)->get();
        } else {
            $items = Service::where('category_id', 2)->where('owner_id', auth()->user()->id)->get();
        }
        return response()->json($items);
    }

    public function getInvoiceDetails(Request $request)
    {
        $items = InvoiceItem::where('invoice_id', $request->id)->get();
        $lists = '';
        if (!empty($items)) {
            $lists = $items->map(function ($value) {
                return [
                    'id' => $value->id,
                    'vehicle_name' => $value->vehicle ? $value->vehicle->model : 'N/A',
                    'reg_no' => $value->vehicle ? $value->vehicle->reg_no : 'N/A',
                    'chassis_no' => $value->vehicle ? $value->vehicle->chassis_no : 'N/A',
                    'item_name' => $value->product ? $value->product->name : $value->service->name,
                    'item_quantity' => $value->product_quantity ? $value->product_quantity : $value->service_quantity,
                    'item_price' => $value->product_rate ? $value->product_rate : $value->service_rate,
                    'total_price' => $value->total_price ? $value->total_price : 'N/A',
                ];
            });
        }
        return response()->json($lists);
    }
    //For payment
    public function addPayment(Request $request, $id)
    {
        $invoice = Invoice::findOrFail($id);
        $previousPayment = $invoice->payments->sum('payment_amount');
        if ($invoice->total_cost >= ($previousPayment + $request->payment_amount)) {
            $newPayment = $invoice->payments()->create([
                'payment_amount' => $request->payment_amount,
                'payment_method' => $request->payment_method,
                'card_no' => $request->card_no,
                'bank_name'=>$request->bank_name,
                'account_no'=>$request->account_no,
                'payment_date' => date("Y-m-d", strtotime($request->payment_date ? $request->payment_date : now()))
            ]);
            $invoice->payment_status = "Due";
            if ($invoice->total_cost == ($previousPayment + $request->payment_amount)) {
                $invoice->payment_status = "Paid";
            }
            $invoice->save();
            return response(new InvoiceResource($invoice), Response::HTTP_OK);
        } elseif ($invoice->total_cost < ($previousPayment + $request->payment_amount)) {
            return response()->json(['success' => false, 'message' => 'You can not pay more than the original amount!'], 400);
        }
    }


}
