<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Auth;

class Insurance extends Model
{
    use HasFactory;
    use SoftDeletes;

    public function product()
    {
        return $this->belongsTo(Product::class);
    }
    public function scopeActive($query)
    {
        return $query->where('owner_id',Auth::user()->id)->orderBy('created_at', 'desc');
    }

}
