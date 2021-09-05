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
    public function expenseReport(Request $request)
    {
        $start = $request->startDate;
        $end = $request->endDate;
        $category = $request->category;
        if (!empty($start) && !empty($end)) {
            $startdate = Carbon::parse($start);
            $enddate = Carbon::parse($end);
        } else {
            $startdate = Carbon::now()->subDays(30);
            $enddate = Carbon::now();
        }
        $expenses=Expense::whereBetween('created_at', [$startdate, $enddate]);
         if(!empty($category)){
            $expenses->where('exp_cat_id',$category);
        }
        return response(ExpenseResource ::collection($expenses->get()), Response::HTTP_OK);
    }


    public function collectionReport(Request $request)
    {
        $start = $request->startDate;
        $end = $request->endDate;
        if (!empty($start) && !empty($end)) {
            $startdate = Carbon::parse($start);
            $enddate = Carbon::parse($end);
        } else {
            $startdate = Carbon::now()->subDays(30);
            $enddate = Carbon::now();
        }
        return response(CollectionResource::collection(OrderProduct::whereBetween('created_at', [$startdate, $enddate])->get()), Response::HTTP_OK);
    }

    public function paymentReport(Request $request)
    {
        $start = $request->startDate;
        $end = $request->endDate;
        if (!empty($start) && !empty($end)) {
            $startdate = Carbon::parse($start);
            $enddate = Carbon::parse($end);
        } else {
            $startdate = Carbon::now()->subDays(30);
            $enddate = Carbon::now();
        }
        return response(PaymentResource ::collection(Order::whereBetween('created_at', [$startdate, $enddate])->get()), Response::HTTP_OK);
    }

    public function salesReport(Request $request)
    {
        $start = $request->startDate;
        $end = $request->endDate;
        if (!empty($start) && !empty($end)) {
            $startdate = Carbon::parse($start);
            $enddate = Carbon::parse($end);
        } else {
            $startdate = Carbon::today();
            $enddate = Carbon::tomorrow();
        }
        return response(OrderResource::collection(OrderProduct::whereBetween('created_at', [$startdate, $enddate])->get()), Response::HTTP_OK);

    }

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
        $results="";
        if(($from_date && $end_date) != null) {
            $results=Purchase::active()->whereBetween('purchase_date', [$from_date, $end_date])->get();
        }
        else{
            $results=Purchase::active()->get();
        }
        return  PurchaseReportResource::collection($results);
    }
    public function searchInvoice(Request $request)
    {
        $from_date = $request->date_range[0];
        $end_date = $request->date_range[1];
        $results="";
        if(($from_date && $end_date) != null) {
            $results=Invoice::active()->whereBetween('date', [$from_date, $end_date])->get();
        }
        else{
            $results=Invoice::active()->get();
        }
        return  InvoiceReportResource::collection($results);
    }

}
