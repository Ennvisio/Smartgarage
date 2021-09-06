<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class PurchaseReportResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param \Illuminate\Http\Request $request
     * @return array
     */
    public function toArray($request)
    {
        $payment_status='';
        if(count($this->payments)>0)
        {
            if($this->payments->sum('payment_amount')==$this->total_cost)
            {
                $payment_status='Paid';
            }
            else{
                $payment_status='Partial';
            }
        }else{
            $payment_status='Due';
        }
        return [
            'id' => $this->id,
            'purchase_number' => $this->purchase_number,
            'supplier_name' => $this->Supplier ? $this->Supplier->name : 'N\A',
            'purchase_date' => $this->purchase_date ? $this->purchase_date : 'N\A',
            'total_purchase_quantity' => $this->total_purchase_quantity ? $this->total_purchase_quantity : 'N\A',
            'total_cost' => round($this->total_cost, 2),
//            'payment_status' => $this->payment_status,
            'payment_status' => ucfirst($payment_status),
        ];
    }
}
