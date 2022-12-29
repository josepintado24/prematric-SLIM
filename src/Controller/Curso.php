<?php

namespace prematricula\Controller;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class Curso extends AccesoBD
{
    public function listar(Request $request, Response $response, $args)
    {
        $indice = $args['indice'];
        $limite = $args['limite'];
        $datos = $this->lista($indice, $limite);
        $status = sizeof($datos) > 0 ? 200 : 204;
        $response->getBody()->write(json_encode($datos));
        return $response->withHeader('Content-Type', 'aplication/json')->withStatus($status);
    }
    public function buscarCodigo(Request $request, Response $response, $args)
    {
        $codigo = $args['id'];
        $datos = $this->buscar($codigo);
        $response->getBody()->write(json_encode($datos));
        $status = sizeof($datos) > 0 ? 200 : 404;
        return $response->withHeader('Content-Type', 'aplication/json')->withStatus($status);
    }
    public function crear(Request $request, Response $response, $args)
    {
        $body = json_decode($request->getBody());
        $datos = $this->guardar($body);
        $status = $datos[0] > 0 ? 409 : 201;
        $response->getBody()->write(json_encode($datos));
        return $response->withHeader('Content-Type', 'aplication/json')->withStatus($status);
    }
    public function editar(Request $request, Response $response, $args)
    {
        $body = json_decode($request->getBody());
        $id = $args['id'];
        // Modificar 
        $datos = $this->guardar($body, $id);
        $status = $datos[0] > 0 ? 200 : 404;
        $response->getBody()->write(json_encode($datos));
        return $response->withHeader('Content-Type', 'aplication/json')->withStatus($status);
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
    public function eliminar(Request $request, Response $response, $args)
    {
        $id = $args['id'];
        // eliminar 
        $datos = $this->elimina($id);
        $status = $datos[0] > 0 ? 200 : 404;
        $response->getBody()->write(json_encode($datos));
        return $response->withHeader('Content-Type', 'aplication/json')->withStatus($status);
    }
}
