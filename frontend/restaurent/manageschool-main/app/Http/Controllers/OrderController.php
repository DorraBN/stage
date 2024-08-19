<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Order; 

class OrderController extends Controller
{
    //
    public function index()
    {
        $order = Order::all();
        return response()->json($order);
    }

    public function show($id)
    {
        $order = Order::find($id);

        if ($order) {
            return response()->json($order);
        } else {
            return response()->json(['message' => 'order not found'], 404);
        }
    }


    public function destroy($id)
    {
        $order = Order::findOrFail($id);
        $order->delete();

        return response()->json(null, 200);
 
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'customer_name' => 'required|string|max:255',
            'phone_number' => 'required|string|max:20',
            'delivery_address' => 'required|string|max:255',
            'payment_method' => 'required|string',
            'card_number' => 'nullable|string',
            'expiry_date' => 'nullable|string',
            'cvv' => 'nullable|string',
            'total_price' => 'required|numeric',
            'products' => 'required|array',
        ]);
    
  
        $order = new Order();
        $order->customer_name = $validated['customer_name'];
        $order->phone_number = $validated['phone_number'];
        $order->delivery_address = $validated['delivery_address'];
        $order->payment_method = $validated['payment_method'];
        $order->card_number = $validated['card_number'];
        $order->expiry_date = $validated['expiry_date'];
        $order->cvv = $validated['cvv'];
        $order->total_price = $validated['total_price'];
        $order->save();
    
        foreach ($validated['products'] as $product) {
            $orderProduct = new OrderProduct();
            $orderProduct->order_id = $order->id;
            $orderProduct->product_name = $product['name'];
            $orderProduct->quantity = $product['quantity'];
            $orderProduct->price = $product['price'];
            $orderProduct->save();
        }
    
        return response()->json(['message' => 'Order successfully placed'], 200);
    }
    
    public function update(Request $request, $id)
{
    
    $rules = [
        'customer_name' => 'nullable|string|max:255',
        'phone_number' => 'nullable|string|max:20',
        'delivery_address' => 'nullable|string|max:255',
        'payment_method' => 'nullable|string',
        'card_number' => 'nullable|string',
        'expiry_date' => 'nullable|string',
        'cvv' => 'nullable|string',
        'total_price' => 'nullable|numeric',
        'items' => 'nullable|array',
        'items.*.product_name' => 'nullable|string',
        'items.*.quantity' => 'nullable|integer',
        'items.*.price' => 'nullable|numeric',
           'is_confirmed' => 'nullable|boolean'
    ];

    
    $validatedData = $request->validate($rules);


    $order = Order::findOrFail($id);

  
    $orderData = array_filter([
        'customer_name' => $validatedData['customer_name'] ?? $order->customer_name,
        'phone_number' => $validatedData['phone_number'] ?? $order->phone_number,
        'delivery_address' => $validatedData['delivery_address'] ?? $order->delivery_address,
        'payment_method' => $validatedData['payment_method'] ?? $order->payment_method,
        'card_number' => $validatedData['card_number'] ?? $order->card_number,
        'expiry_date' => $validatedData['expiry_date'] ?? $order->expiry_date,
        'cvv' => $validatedData['cvv'] ?? $order->cvv,
        'total_price' => $validatedData['total_price'] ?? $order->total_price,
        
    ]);


    $order->update($orderData);

    
    if (isset($validatedData['items'])) {
   
        $order->items = json_encode($validatedData['items']);
    }

    $order->save();

    return response()->json($order, 200);
}


}
