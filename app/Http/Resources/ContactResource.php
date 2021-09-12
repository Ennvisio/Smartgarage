<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ContactResource extends JsonResource
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
            'name' => $this->name,
            'type' => $this->type,
            'email' => $this->email,
            'mobile' => $this->mobile,
            'address' => $this->address,
            'bank_name' => $this->bank_name,
            'account_no' => $this->account_no,
            'bkash_no' => $this->bkash_no,
            'created_at' => $this->created_at->format('Y-m-d'),
        ];
    }
}
