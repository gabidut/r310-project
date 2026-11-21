<?php

return [
    'routes' => [
        ['GET', 'vieetudiante', 'vieetudiante/MainVieetudianteController@index'],
        ['GET', 'vieetudiante/query/:queryIndex', 'vieetudiante/MainVieetudianteController@query'],
    ],
];