<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class InvoiceResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
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
        $data= [
            'id' => $this->id,
            'invoice_number' => $this->invoice_number,
            'contact_id' => $this->contact_id,
            'client_name' => $this->client? $this->client->name : null,
            'client_phone' => $this->client? $this->client->mobile : null,
            'date' => $this->date,
            'total_amount' => $this->total_cost,
            'paid_price' => round($this->payments->sum('payment_amount'),2),
            'discount' => $this->discount,
            'vat' => $this->vat,
            'status' => $this->payment_status,
            'due_amount' => round($this->total_cost-$this->payments->sum('payment_amount'),2),
//            'payment_status' => $this->payment_status?$this->payment_status:"Due",
            'payment_status' => ucfirst($payment_status),
        ];
        if ($request->route()->parameters()) {
            $data['items'] = InvoiceItemResource::collection($this->invoiceItems);
        }
        return $data;
    }
}
