<?php

namespace App\Http\Controllers;

use App\Http\Resources\VehicleResource;
use App\Models\Vehicle;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Validator;

class VehicleController extends Controller
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
            $vehicles = Vehicle::active()->search($keyword)->get();
        } else {
            $vehicles = Vehicle::active()->search($keyword)->paginate($request->get('per_page', 10));
        }
        return VehicleResource::collection($vehicles);
    }

    public function store(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'model' => 'required',
                'reg_no' => 'required|unique:vehicles',
                'chassis_no' => 'required|unique:vehicles',
                'mileage' => 'required'
            ]
        );
        if ($validator->fails()) {
            return response()->json(['success' => false, 'error' => $validator->errors()], 422);
        }

        $vehicle = new Vehicle();

        $vehicle->owner_id = auth()->user()->id;
        $vehicle->contact_id = $request->contact_id;
        $vehicle->brand_id = $request->brand_id;
        $vehicle->model = $request->model;
        $vehicle->reg_no = $request->reg_no;
        $vehicle->chassis_no = $request->chassis_no;
        $vehicle->mileage = $request->mileage;
        $vehicle->color_id = $request->color_id;
        $vehicle->type_id = $request->type_id;
        $vehicle->description = $request->description;
        $vehicle->save();
        return response(new VehicleResource($vehicle), Response::HTTP_CREATED);
    }

    public function update(Request $request, $id)
    {
        $vehicle = Vehicle::findOrFail($id);
        $validator = Validator::make(
            $request->all(),
            [
                'reg_no' => "unique:vehicles,reg_no,$vehicle->id,id",
                'chassis_no' => "unique:vehicles,chassis_no,$vehicle->id,id",
            ]
        );
        if ($validator->fails()) {
            return response()->json(['success' => false, 'error' => $validator->errors()], 422);
        }
        if ($request->has('owner_id')) {
            $vehicle->owner_id = $request->owner_id;
        }
        if ($request->has('contact_id')) {
            $vehicle->contact_id = $request->contact_id;
        }
        if ($request->has('brand_id')) {
            $vehicle->brand_id = $request->brand_id;
        }
        if ($request->has('brand_name')) {
            $vehicle->brand_name = $request->brand_name;
        }
        if ($request->has('model')) {
            $vehicle->model = $request->model;
        }
        if ($request->has('reg_no')) {
            $vehicle->reg_no = $request->reg_no;
        }
        if ($request->has('chassis_no')) {
            $vehicle->chassis_no = $request->chassis_no;
        }
        if ($request->has('mileage')) {
            $vehicle->mileage = $request->mileage;
        }
        if ($request->has('color_id')) {
            $vehicle->color_id = $request->color_id;
        }
        if ($request->has('type_id')) {
            $vehicle->type_id = $request->type_id;
        }
        if ($request->has('description')) {
            $vehicle->description = $request->description;
        }
        $vehicle->save();
        return response(new VehicleResource($vehicle), Response::HTTP_OK);
    }

    public function edit($id)
    {
        $vehicle = Vehicle::findOrFail($id);
        return new VehicleResource($vehicle);
    }

    public function destroy($id)
    {
        $vehicle = Vehicle::find($id);
        $vehicle->delete();
        return response()->json(['success' => true, 'message' => 'Deleted successfully'], 204);
    }
}
