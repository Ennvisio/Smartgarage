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
            'paid_price' => $this->paid_amount,
            'due_amount' => $this->due_amount,
            'payment_status' => $this->payment_status,
        ];

        if ($request->route()->parameters()) {
            $data['items'] = PurchaseItemsResource::collection($this->purchaseItems);
        }
        return $data;
    }
}

