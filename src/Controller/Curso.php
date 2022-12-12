<?php

namespace prematricula\Controller;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class Curso extends AccesoBD
{
    public function consultarTodos(Request $request, Response $response, $args)
    {
        $indice = $args['indice'];
        $limite = $args['limite'];
        $datos = $this->todo($indice, $limite);
        $response->getBody()->write(json_encode($datos));
        return $response;
    }
    public function buscarCodigo(Request $request, Response $response, $args)
    {
        $codigo = $args['codigo'];
        $response->getBody()->write("$codigo");
        return $response;
    }
    public function crear(Request $request, Response $response, $args)
    {
        $body = json_decode($request->getBody());
        $body->estado = "Guardado";
        $response->getBody()->write(json_encode($body));
        return $response->withHeader('Content-Type', 'aplication/json')->withStatus(201);
    }
    public function filtrar(Request $request, Response $response, $args)
    {
        $indice = $args['indice'];
        $limite = $args['limite'];
        $body = json_decode($request->getBody());
        $datos[0]['codigo'] = "BC2CCC";
        $datos[0]['nombre'] = "Intro";
        $datos[1]['codigo'] = "BC2CCC";
        $datos[1]['nombre'] = "Java";
        $datos['estado'] = "Encontrado";
        $response->getBody()->write(json_encode($datos));
        return $response->withHeader('Content-Type', 'aplication/json')->withStatus(203);
    }
    public function editar(Request $request, Response $response, $args)
    {
        $codigo = $args['codigo'];
        $body = json_decode($request->getBody());
        $response->getBody()->write(json_encode($body));
        return $response->withHeader('Content-Type', 'aplication/json')->withStatus(203);
    }
    public function eliminar(Request $request, Response $response, $args)
    {
        $codigo = $args['codigo'];
        $response->getBody()->write("$codigo  Eliminado de forma correcta");
        return $response->withHeader('Content-Type', 'aplication/json')->withStatus(203);
    }
}
