<?php

use Psr\Container\ContainerInterface;

$container->set('bd', function (ContainerInterface $c) {

    $conf = $c->get('config_bd');
    $opc = [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_OBJ
    ];

    $dns = "mysql:host=" . $conf->host . ";dbname=" . $conf->bd . ";charset=" . $conf->charset;
    try {
        $cone= new PDO($dns, $conf->usr, $conf->pass, $opc);
    } catch (\PDOException $e) {
        print "Error ".$e->getMessage().'<br>'; //Desarrollo
        // print "Error temporal"; //Produccion
        die();
    }
    return $cone;
});
