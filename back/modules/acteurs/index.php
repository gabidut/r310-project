<?php

return [
    'routes' => [
        ['GET', 'acteurs', 'acteurs/MainActeursController@index'],
        ['GET', 'acteurs/query/:queryIndex', 'acteurs/MainActeursController@query'],
    ],
];