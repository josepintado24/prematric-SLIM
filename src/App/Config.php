<?php
$container->set('config_bd', function () {
    return (object)[
        "host" => "localhost",
        // "bd" => "lotizacion",
        "bd" => "prematricx",
        "usr" => "jlpintado",
        "pass" => "jlpintado",
        "charset" => "utf8"
    ];
});
