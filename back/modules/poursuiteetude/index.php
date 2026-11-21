<?php

return [
    'routes' => [
        ['GET', 'apprentissage', 'apprentissage/MainApprentissageController@index'],
        ['GET', 'apprentissage/query/:queryIndex', 'apprentissage/MainApprentissageController@query'],
    ],
];