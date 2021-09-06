<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class PurchaseResource extends JsonResource
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
        $data = [
            'id' => $this->id,
            'purchase_number' => $this->purchase_number,
            'owner' => $this->User->name,
            'contact_id' => $this->contact_id,
            'supplier_name' => $this->Supplier ? $this->Supplier->name : '',
            'purchase_status' => $this->purchase_status,
            'purchase_date' => $this->purchase_date,
            'total_purchase_quantity' => $this->total_purchase_quantity,
            'subtotal_cost' => $this->subtotal_cost,
            'total_cost' => round($this->total_cost, 2),
//            'paid_price' => $this->paid_amount,
            'paid_price' =>round($this->payments->sum('payment_amount'),2),
//            'due_amount' => $this->due_amount,
            'due_amount' => round($this->total_cost-$this->payments->sum('payment_amount'),2),
//            'payment_status' => $this->payment_status?$this->payment_status:"Due",
            'payment_status' => ucfirst($payment_status),
        ];

        if ($request->route()->parameters()) {
            $data['items'] = PurchaseItemsResource::collection($this->purchaseItems);
        }
        return $data;
    }
}

