<?php

namespace App\Http\Resources;

use App\Models\ProductVariation;
use App\Models\Purchase;
use Illuminate\Http\Resources\Json\JsonResource;

class PurchaseItemsResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param \Illuminate\Http\Request $request
     * @return array
     */
    public function toArray($request)
    {
        $purchase = Purchase::find($this->purchase_id);

        return [
            'purchase_id' => $this->purchase_id ? $this->purchase_id : 'N\A',
            'id' => $this->product_id,
            'name' => $this->product ? $this->product->name : '',
            'purchase_quantity' => $this->purchase_quantity ? $this->purchase_quantity : 'N/A',
            'price' => $this->purchase_price ? $this->purchase_price : 'N/A',
            'subtotal' => $this->total_price ? $this->total_price : 'N/A',
        ];
    }
}
