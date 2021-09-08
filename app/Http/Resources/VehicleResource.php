<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class VehicleResource extends JsonResource
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
            'contact' => $this->contact? $this->contact->name : '',
            'brand' => $this->brand? $this->brand->name : '',
            'brand_id' => $this->brand_id,
            'contact_id'=>$this->contact_id,
            'reg_no' => $this->reg_no,
            'chassis_no' => $this->chassis_no,
            'mileage' => $this->mileage,
            'model' => $this->model,
            'color' => $this->color? $this->color->name : '',
            'color_id' => $this->color_id,
            'type' => $this->vehicleType? $this->vehicleType->name : '',
            'type_id' => $this->type_id,
            'description' => $this->description,
        ];
    }
}
