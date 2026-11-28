<?php

return [
    'routes' => [
        ['GET', 'decision', 'decision/MainDecisionController@index'],
        ['GET', 'decision/query/:queryIndex', 'decision/MainDecisionController@query'],
    ],
];