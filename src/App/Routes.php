<?php


use Slim\Routing\RouteCollectorProxy;
use prematricula\Controller\{Curso};

$app->group('/curso', function (RouteCollectorProxy $curso) {
    $curso->get('/{indice}/{limite}', Curso::class . ":consultarTodos");
    $curso->get('/{codigo}', Curso::class . ":buscarCodigo");
    $curso->post('/', Curso::class . ":crear");
    $curso->post('/filtrado/{indice}/{limite}', Curso::class . ":filtrar");
    $curso->put('/{codigo}', Curso::class . ":editar");
    $curso->delete('/{codigo}', Curso::class . ":eliminar");
});
