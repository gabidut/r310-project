<?php

return [
    'routes' => [
        ['GET', 'poursuiteetude', 'poursuiteetude/MainPoursuiteetudeController@index'],
        ['GET', 'poursuiteetude/query/:queryIndex', 'poursuiteetude/MainPoursuiteetudeController@query'],
    ],
];