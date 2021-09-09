<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class InsuranceResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'owner_id ' => $this->owner_id ,
            'company_name' => $this->company_name,
            'product' => $this->product ? $this->product->name : '',
            'product_id ' => $this->product_id  ? $this->product_id  : '',
            'policy_number' => $this->policy_number,
            'change_payable' => $this->change_payable,
            'start_date' => $this->start_date,
            'end_date' => $this->end_date,
            'period' => $this->period,
            'recurring_date' => $this->recurring_date,
            'policy_document' => $this->policy_document,
            'note' => $this->note,
        ];
    }
}
