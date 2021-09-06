<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Auth;

class Purchase extends Model
{
    use HasFactory;
    use SoftDeletes;

    protected $table = "purchases";

    protected $fillable = [
        'purchase_status',  'purchase_date', 'total_purchase_quantity', 'subtotal_cost', 'purchase_discount', 'purchase_tax', 'total_cost',  'note', 'deleted_at',
    ];

    public function purchaseItems()
    {
        return $this->hasMany(PurchaseItem::class);
    }

    public function Supplier()
    {
        return $this->belongsTo(Contact::class, 'contact_id');
    }
    public function User()
    {
        return $this->belongsTo(User::class, 'owner_id');
    }

    public function scopeActive($query)
    {
        return $query->where('owner_id', Auth::user()->id)->orderBy('created_at', 'desc');
    }
    public function payments()
    {
        return $this->morphMany(Payment::class, 'paymentable');
    }

}
