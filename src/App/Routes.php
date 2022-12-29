<?php


use Slim\Routing\RouteCollectorProxy;
use prematricula\Controller\{Curso};

$app->group('/curso', function (RouteCollectorProxy $curso) {
    $curso->get('/{indice}/{limite}', Curso::class . ":listar");
    $curso->get('/{id}', Curso::class . ":buscarCodigo");
    $curso->post('', Curso::class . ":crear");
    $curso->post('/filtrado/{indice}/{limite}', Curso::class . ":filtrar");
    $curso->put('/{id}', Curso::class . ":editar");
    $curso->delete('/{id}', Curso::class . ":eliminar");
});
