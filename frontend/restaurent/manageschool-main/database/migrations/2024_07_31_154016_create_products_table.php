<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateProductsTable extends Migration
{
    public function up()
    {
        if (!Schema::hasTable('products')) {
            Schema::create('products', function (Blueprint $table) {
                $table->id();
                $table->string('name');
                $table->text('description')->nullable();
                $table->decimal('price', 8, 2);
                $table->string('category');
                $table->string('image')->nullable();
                $table->boolean('is_available');
                $table->timestamps();
            });
        }
    }
    

    public function down()
    {
        Schema::dropIfExists('products');
    }
}