<?php

namespace controllers;

use core\Controller;
use core\Resource;
use models\EcoleSup;
use models\Inclus;
use models\Personne;
use resources\AuthResource;
use resources\MeResource;

/**
 * Contrôleur de la route /
 *
 * @author  gabidut
 * @version 1.0
 *
 */
class RootController extends Controller
{

    /**
     * Route initiale
     *
     * @return void
     */
    public function index(): void
    {
        header('Content-Type: application/json');
        echo json_encode([
            'message' => 'It Works.',
        ]);
    }

}