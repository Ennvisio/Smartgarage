<?php

namespace App\Http\Controllers;

use App\Http\Resources\BrandResource;
use Illuminate\Http\Request;
use App\Models\Brand;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;

class BrandController extends Controller
{
    public function __construct()
    {
        $this->middleware('jwt', ['except' => ['index']]);
    }

    public function index(Request $request)
    {
        $record = $request->record;
        $keyword = $request->keyword;
        if ($record == 'all' || $request->per_page == -1) {
            $items = Brand::active()->search($keyword)->get();
        } else {
            $items = Brand::active()->search($keyword)->paginate($request->get('per_page', 10));
        }
        return BrandResource::collection($items);
    }

    public function store(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'name' => 'required',
            ]
        );
        if ($validator->fails()) {
            return response()->json(['success' => false, 'error' => $validator->errors()], 422);
        }
        $brand = new Brand();
        $brand->owner_id = auth()->user()->id;
        $brand->name = $request->name;
        $brand->description = $request->description;
        $brand->save();
        return response(new BrandResource($brand), Response::HTTP_CREATED);
    }

    public function update(Request $request, $id)
    {
        $brand = Brand::findOrFail($id);
        if ($request->has('name')) {
            $brand->name = $request->name;
        }
        if ($request->has('description')) {
            $brand->description = $request->description;
        }
        $brand->save();
        return response(new BrandResource($brand), Response::HTTP_OK);
    }

    public function destroy($id)
    {
        $brand = Brand::where('id', $id)->first();
        $brand->delete();
        return response()->json(['success' => true, 'message' => 'Deleted successfully'], 204);
    }

    public function getBrands()
    {
        $brands = Brand::Active()->get();
        return response()->json($brands);
    }
}
