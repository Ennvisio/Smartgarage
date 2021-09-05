<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class InvoiceReportResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'invoice_number' => $this->invoice_number,
            'client_name' => $this->client? $this->client->name : 'N\A',
            'date' => $this->date ? $this->date : 'N\A',
            'total_amount' => round($this->total_cost, 2),
            'payment_status' => $this->payment_status,
        ];
    }
}
