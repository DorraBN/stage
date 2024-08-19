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
        Schema::table('reserves', function (Blueprint $table) {
            $table->string('status')->default('confirmed'); // Ajout de la colonne avec valeur par défaut
        });
    }

    public function down()
    {
        Schema::table('reserves', function (Blueprint $table) {
            $table->dropColumn('status'); // Suppression de la colonne en cas de rollback
        });
    }
};
