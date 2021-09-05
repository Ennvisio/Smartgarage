<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Auth;

class Invoice extends Model
{
    use HasFactory;
    use SoftDeletes;

    protected $table = 'invoices';

    public function invoiceItems()
    {
        return $this->hasMany(InvoiceItem::class);
    }

    public function client()
    {
        return $this->belongsTo(Contact::class, 'contact_id', 'id');
    }

    public function scopeActive($query)
    {
        return $query->where('owner_id', Auth::user()->id)->orderBy('created_at', 'desc');
    }

}
