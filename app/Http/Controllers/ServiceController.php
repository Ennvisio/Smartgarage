<?php

namespace App\Http\Controllers;

use App\Http\Resources\ServiceResource;
use App\Models\Service;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Validator;
class ServiceController extends Controller
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
            $items = Service::active()->search($keyword)->get();
        } else {
            $items = Service::active()->search($keyword)->paginate($request->get('per_page', 10));
        }
        return ServiceResource::collection($items);
    }

    public function store(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'name' => 'required',
                'category_id' => 'required',
                'selling_price' => 'numeric',
            ]
        );
        if ($validator->fails()) {
            return response()->json(['success' => false, 'error' => $validator->errors()], 422);
        }

        $service = new Service();
        $service->owner_id = auth()->user()->id;

        $service->name  =$request->name;
        $service->category_id=$request->category_id;
        $service->selling_price=$request->selling_price;
        $service->status=$request->status;
        $service->description=$request->description;
        $service->save();

        return response(new ServiceResource($service), Response::HTTP_CREATED);
    }

    public function update(Request $request, $id)
    {
        $service = Service::findOrFail($id);
        if ($request->has('name')) {
            $service->name = $request->name;
        }
        if ($request->has('category_id')) {
            $service->category_id  = $request->category_id;
        }
        if ($request->has('selling_price')) {
            $service->selling_price = $request->selling_price;
        }
        if ($request->has('status')) {
            $service->status = $request->status;
        }
        if ($request->has('description')) {
            $service->description = $request->description;
        }

        $service->save();

        return response(new ServiceResource($service), Response::HTTP_OK);
    }

    public function destroy($id)
    {
        $service = Service::find($id);
        $service->delete();

        return response()->json(['success' => true, 'message' => 'Deleted successfully'], 204);
    }
}
