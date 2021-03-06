<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PurchaseItem extends Model
{
    use HasFactory;

    protected $table = "purchase_items";

    protected $fillable = [
        'purchase_id',  'product_id', 'product_variation_id', 'purchase_quantity', 'purchase_price', 'total_price'
    ];

    public static function savePurchaseItem($purchase_id, $store_items)
    {
        $pi = PurchaseItem::create([
            'purchase_id' => $purchase_id,
            'product_id' => $store_items['id'],
            'purchase_quantity' => $store_items['purchase_quantity'],
//            'purchase_price' => $store_items['purchase_price'],
            'purchase_price' => $store_items['price'],
            'total_price' => $store_items['subtotal']
        ]);

        return $pi;
    }


    public function purchase()
    {
        return $this->belongsTo(Purchase::class);
    }

    public function product()
    {
//        return $this->belongsTo(Products::class,'product_id');
        return $this->belongsTo(Product::class,'product_id');
    }

    // public function productVariation()
    // {
    //     return $this->belongsTo(ProductVariation::class,'product_variation_id');
    // }

    // public function SalePurchaseReturn()
    // {
    //     return $this->belongsTo(SalePurchaseReturn::class);
    // }
}
