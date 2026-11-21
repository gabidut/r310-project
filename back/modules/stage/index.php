<?php

return [
    'routes' => [
        ['GET', 'stage', 'stage/MainStageontroller@index'],
        ['GET', 'stage/query/:queryIndex', 'stage/MainStageController@query'],
    ],
];