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
            'invoice_number' => $this->invoice_number,
            'client_name' => $this->client? $this->client->name : 'N\A',
            'date' => $this->date ? $this->date : 'N\A',
            'total_amount' => round($this->total_cost, 2),
//            'payment_status' => $this->payment_status,
            'payment_status' => ucfirst($payment_status),
        ];
    }
}
