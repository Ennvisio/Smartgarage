<?php

namespace App\Http\Controllers;

use App\Http\Resources\ContactResource;
use Illuminate\Http\Request;
use App\Models\Contact;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;

class ContactController extends Controller
{
    public function __construct()
    {
        $this->middleware('jwt', ['except' => ['index']]);
    }

    public function index(Request $request)
    {
        $type = $request->type;
        $record = $request->record;
        $keyword = $request->keyword;
        if ($record == 'all' || $request->per_page == -1) {
            $contacts = Contact::active($type)->search($keyword)->get();
        } else {
            $contacts = Contact::active($type)->search($keyword)->paginate($request->get('per_page', 10));
        }
        return  ContactResource::collection($contacts);
    }

    public function store(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'type' => 'required',
                'name' => 'required',
                'email' => 'required',
                'address' => 'required',
                'mobile' => 'required',
            ]
        );
        if ($validator->fails()) {
            return response()->json(['success' => false, 'error' => $validator->errors()], 422);
        }

        $contact = new Contact();
        $contact->owner_id = auth()->user()->id;
        $contact->name = $request->name;
        $contact->type = $request->type;
        $contact->email = $request->email;
        $contact->address = $request->address;
        $contact->mobile = $request->mobile;
        $contact->mobile = $request->mobile;
        $contact->bank_name = $request->bank_name;
        $contact->account_no = $request->account_no;
        $contact->bkash_no = $request->bkash_no;
        $contact->created_by = auth()->user()->id;
        $contact->save();

        return response(new ContactResource($contact), Response::HTTP_CREATED);
    }

    public function update(Request $request, $id)
    {
        $contact = Contact::findOrFail($id);

        if ($request->has('name')) {
            $contact->name = $request->name;
        }
        if ($request->has('type')) {
            $contact->type = $request->type;
        }
        if ($request->has('email')) {
            $contact->email = $request->email;
        }
        if ($request->has('address')) {
            $contact->address = $request->address;
        }
        if ($request->has('mobile')) {
            $contact->mobile = $request->mobile;
        }
        if ($request->has('bank_name')) {
            $contact->bank_name = $request->bank_name;
        }
        if ($request->has('account_no')) {
            $contact->account_no = $request->account_no;
        }
        if ($request->has('bkash_no')) {
            $contact->bkash_no = $request->bkash_no;
        }

        $contact->save();

        return response(new ContactResource($contact), Response::HTTP_OK);
    }

    public function destroy($id)
    {
        $contact = Contact::where('id', $id)->first();

        $contact->delete();

        return response()->json(['success' => true, 'message' => 'Deleted successfully'], 204);
    }

    public function contactSearch(Request $request)
    {
//        $business_id = auth()->user()->business_id;
        $owner_id = auth()->user()->id;
        $type = $request->type;
        $name = $request->name;
        if ($type == "customer") {
            $type = "customer";
            $contact = Contact::where('type', 'LIKE', "%$type%")->where('name', 'LIKE', "%$name%")->where('owner_id', 'LIKE', "%$owner_id%")->get();
        } elseif ($type == "supplier") {
            $type = "supplier";
            $contact = Contact::where('type', 'LIKE', "%$type%")->where('name', 'LIKE', "%$name%")->where('owner_id', 'LIKE', "%$owner_id%")->get();
        }


        if (count($contact) > 0) {
            return response(ContactResource::collection($contact), Response::HTTP_OK);
        } else {
            return response()->json(['success' => true, 'message' => 'Contact not found'], 200);
        }
    }

    public function getClients()
    {
        $contacts = Contact::where('owner_id',1)->where('type','customer')->get();
        return response()->json($contacts);
    }

    public function getSuppliers()
    {
        $contacts = Contact::where('owner_id',1)->where('type','supplier')->get();
        return response()->json($contacts);
    }
}
