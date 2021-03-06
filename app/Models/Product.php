<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Auth;

class Product extends Model
{
    use HasFactory;
    use SoftDeletes;

    protected $table = "products";

    protected $fillable = [
        'name', 'type', 'brand_id', 'category_id', 'buying_price', 'selling_price', 'quantity', 'status', 'image', 'created_by', 'updated_by', 'deleted_at',
    ];

    public function category()
    {
        return $this->belongsTo(Category::class, 'category_id');
    }

    public function invoiceItems(){
        return $this->hasMany(InvoiceItem::class);
    }

    public function Unit()
    {
        return $this->belongsTo(Unit::class, 'unit_id');
    }
    public function scopeSearch($query, $keyword)
    {
        if ($keyword != null) {
            return $query->where('name', 'like', '%' . $keyword . '%');
        }
    }
    public function brand()
    {
        return $this->belongsTo(Brand::class, 'brand_id','id');
    }

    public function getImageAttribute($value)
    {
//        return asset('images/' . $value);
        return  $value?   asset('/' . $value) :"";
    }

    public function insurances()
    {
        return $this->hasMany(Insurance::class);
    }

    public function scopeActive($query)
    {
        return $query->where('owner_id',Auth::user()->id)->orderBy('created_at', 'desc');
    }

    public function media()
    {
        return $this->morphOne(File::class, 'fileable');
    }


    public static function createSingleProductVariation($product, $purchase_price, $sell_price, $tax)
    {
        $variation_data = [
            'name' => $product->name,
            'product_id' => $product->id,
            'sub_sku' => $product->sku,
            'purchase_price' => $purchase_price,
            'sell_price' => $sell_price,
            'tax' => $tax,
        ];
        ProductVariation::create($variation_data);
        return true;
    }

    public static function createVariableProductVariations($product, $product_variation)
    {
        $variation_data = [
            'name' => $product_variation['name'],
            'product_id' => $product->id,
            'sub_sku' => empty($product_variation['sub_sku']) ? self::generateSubSku($product) : $product_variation['sub_sku'],
            'purchase_price' => $product_variation['purchase_price'],
            'sell_price' => $product_variation['sell_price'],
            'tax' => $product_variation['tax']
        ];
        ProductVariation::create($variation_data);
        return true;
    }
}
