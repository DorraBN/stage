<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->string('customer_name');
            $table->string('phone_number');
            $table->string('delivery_address');
            $table->string('payment_method'); // Carte de crédit ou Paiement à la livraison
            $table->string('card_number')->nullable(); // Détails de la carte de crédit
            $table->string('expiry_date')->nullable(); // Détails de la carte de crédit
            $table->string('cvv')->nullable(); // Détails de la carte de crédit
            $table->decimal('total_price', 10, 2);
            $table->json('items'); // Liste des produits sélectionnés
            $table->boolean('is_confirmed')->default(false); // État de la commande
            $table->timestamps();
        });
    }
    

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('orders');
    }
};
