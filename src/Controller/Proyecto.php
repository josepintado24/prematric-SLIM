<?php

namespace App\Controller;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class Proyecto extends AccesoBD
{
    private  $tabla='Proyecto';
    public function ConsultarTodos(Request $request, Response $response, $args)
    {
        $indice = $args['indice'];
        $limite = $args['limite'];
        $datos = $this->todo($this->tabla,$indice, $limite);
        $staus = sizeof($datos) > 0 ? 200 : 204;
        $response->getBody()->write(json_encode($datos));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($staus);
    }
    public function BuscarCodigo(Request $request, Response $response, $args)
    {
        $codigo = $args['codigo'];
        $datos = $this->busca($this->tabla,$codigo);
        $staus = sizeof($datos) > 0 ? 200 : 404;
        $response->getBody()->write(json_encode($datos));
        return $response->withHeader('Content-Type', 'application/json')->withStatus($staus);
    }
    public function filtrar(Request $request, Response $response, $args)
    {

        $indice = $args['indice'];
        $limite = $args['limite'];
        $valores= explode('&', $args['valores']);
        unset($valores[sizeof($valores)-1]);
        // die(var_dump($valores));
        $datos = $this->filtra($this->tabla,$valores, $indice, $limite);
        // $staus = sizeof($datos) > 0 ? 200 : 404;
        $response->getBody()->write(json_encode($datos));
        return $response->withHeader('Content-Type', 'application/json')->withStatus(200);
    }
    public function Crear(Request $request, Response $response, $args)
    {
        $body = json_decode($request->getBody());
        $datos=$this->guarda($this->tabla,$body, null);
        $status = $datos[0]>0 ? 409 : 201;
        $response->getBody()->write(json_encode($datos));
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus($status);
    }
    public function Editar(Request $request, Response $response, $args)
    {
        $id = $args['codigo'];
        $body = json_decode($request->getBody());
        $datos=$this->guarda($this->tabla,$body, $id);
        $status = $datos[0]==2 ? 201 : 404;
        $response->getBody()->write(json_encode($datos));
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus($status);
    }
    public function Eliminar(Request $request, Response $response, $args)
    {

        $id = $args['codigo'];
        $datos=$this->elimina($this->tabla,$id);
        $status = $datos[0]>0 ? 200 : 404;
        $response->getBody()->write(json_encode($datos));
        return $response
            ->withHeader('Content-Type', 'application/json')
            ->withStatus($status);
    }
}
