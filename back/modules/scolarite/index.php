<?php

return [
    'routes' => [
        ['GET', 'scolarite', 'scolarite/MainScolariteController@index'],
        ['GET', 'scolarite/query/:queryIndex', 'scolarite/MainScolariteController@query'],
    ],
];