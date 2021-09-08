<?php

namespace App\Http\Controllers;

use App\Http\Resources\CollectionResource;
use App\Http\Resources\ExpenseResource;
use App\Http\Resources\InvoiceReportResource;
use App\Http\Resources\OrderResource;
use App\Http\Resources\PaymentResource;
use App\Http\Resources\PurchaseReportResource;
use App\Models\Collection;
use App\Models\Expense;
use App\Models\Invoice;
use App\Models\Order;
use App\Models\OrderProduct;
use App\Models\Payment;
use App\Models\Purchase;
use Illuminate\Http\Request;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Symfony\Component\HttpFoundation\Response;

class ReportController extends Controller
{

    public function report_purchase(Request $request)
    {
        $purchase = Purchase::active()->get();
        return  PurchaseReportResource::collection($purchase);
    }
    public function report_invoice(Request $request)
    {
        $invoice = Invoice::active()->get();
        return  InvoiceReportResource::collection($invoice);
    }

    public function searchPurchase(Request $request)
    {
        $from_date = $request->date_range[0];
        $end_date = $request->date_range[1];
        $contact_id =$request->contact_id;

        $results="";
        if ($contact_id !== null)
        {
            $results=Purchase::active()->where('contact_id', $contact_id)->get();
        }
        if(($from_date && $end_date) != null) {
            $results=Purchase::active()->whereBetween('purchase_date', [$from_date, $end_date])->get();
        }
        else{
            $results="";
        }
        return  PurchaseReportResource::collection($results);
    }
    public function searchInvoice(Request $request)
    {
        $from_date = $request->date_range[0];
        $end_date = $request->date_range[1];
        $contact_id =$request->contact_id;
        $results="";
        if ($contact_id !== null)
        {
            $results=Invoice::active()->where('contact_id', $contact_id)->get();
        }
        if(($from_date && $end_date) != null) {
            $results=Invoice::active()->whereBetween('date', [$from_date, $end_date])->get();
        }
        else{
            $results="";
        }
        return  InvoiceReportResource::collection($results);
    }

}
