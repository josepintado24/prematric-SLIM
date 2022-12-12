<?php

namespace prematricula\App;

use Slim\Factory\AppFactory;

require __DIR__ . '/../../vendor/autoload.php';

$cont_aux = new \DI\Container;
AppFactory::setContainer($cont_aux);
$app = AppFactory::create();
$app->addErrorMiddleware(true, true, true);
$container =$app->getContainer();

require 'Routes.php';
require 'Config.php';
require 'Conexion.php';

$app->run();
