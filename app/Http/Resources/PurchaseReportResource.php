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
        return [
            'id' => $this->id,
            'purchase_number' => $this->purchase_number,
            'supplier_name' => $this->Supplier ? $this->Supplier->name : 'N\A',
            'purchase_date' => $this->purchase_date ? $this->purchase_date : 'N\A',
            'total_purchase_quantity' => $this->total_purchase_quantity ? $this->total_purchase_quantity : 'N\A',
            'total_cost' => round($this->total_cost, 2),
            'payment_status' => $this->payment_status,
        ];
    }
}
