<?php

namespace App\Http\Controllers;

use App\Http\Resources\InsuranceResource;
use App\Models\Insurance;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
class InsuranceController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $record = $request->record;
        $keyword = $request->keyword;
        if ($record == 'all' || $request->per_page == -1) {
            $insurance= Insurance::active()->search($keyword)->get();
        } else {
            $insurance= Insurance::active()->search($keyword)->paginate($request->get('per_page', 10));
        }
        return InsuranceResource::collection($insurance);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $insurance = new Insurance();
        $insurance->company_name = $request->company_name;
        $insurance->product_id = $request->product_id;
        $insurance->owner_id = auth()->user()->id;
        $insurance->policy_number = $request->policy_number;
        $insurance->change_payable = $request->change_payable;
        $insurance->start_date = $request->start_date;
        $insurance->end_date = $request->end_date;
        $insurance->period = $request->period;
        $insurance->recurring_date = $request->recurring_date;
        if ($request->hasFile('policy_document')) {
            $imageName = time() . '.' . $request->policy_document->getClientOriginalExtension();
            $insurance->policy_document = "documents/policy_document/{$imageName}";
            $request->policy_document->move(public_path('documents/policy_document/'), $imageName);
        }
        $insurance->note = $request->note;
        $insurance->created_by = auth()->user()->id;
        $insurance->save();
        return response(new InsuranceResource($insurance), Response::HTTP_CREATED);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $insurance = Insurance::find($id);
        $insurance->delete();
        return response()->json(['success' => true, 'message' => 'Deleted successfully'], 204);
    }
}
