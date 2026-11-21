<?php

return [
    'routes' => [
        ['GET', 'docinfo', 'docinfo/MainDocinfoController@index'],
        ['GET', 'docinfo/query/:queryIndex', 'docinfo/MainDocinfoController@query'],
    ],
];