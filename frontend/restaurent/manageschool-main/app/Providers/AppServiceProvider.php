<?php

namespace App\Providers;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        //
        Validator::extend('time_format', function ($attribute, $value, $parameters, $validator) {
            // Custom logic to validate time format
            return preg_match('/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/', $value);
        });
    }
}
