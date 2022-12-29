<?php

namespace prematricula\Controller;

use Psr\Container\ContainerInterface;
use PDO;

class AccesoBD
{
    protected $container;
    public function __construct(ContainerInterface $c)
    {
        $this->container = $c;
    }
    // private function generarParam($d)
    // {
    //     $cad = "(";
    //     foreach ($d as $campo => $valor) {
    //         $cad.=":$campo,";
    //     }
    //     $cad=trim($cad,',');
    //     $cad.=");";
    //    return $cad;
    // }
    // public function todo($tabla, $pagina, $limite)
    public function lista($ind, $lim)
    {
        $con = $this->container->get('bd');
        $sql = "call all_curso(:ind, :lim)";
        $consulta = $con->prepare($sql);
        $consulta->bindParam(':ind', $ind, PDO::PARAM_INT);
        $consulta->bindParam(':lim', $lim, PDO::PARAM_INT);
        $consulta->execute();
        $datos = [];

        if ($consulta->rowCount() > 0) {
            $i = 0;
            while ($reg = $consulta->fetch(PDO::FETCH_ASSOC)) {

                $i++;
                foreach ($reg as $clave => $valor) {
                    $datos[$i][$clave] = $valor;
                }
            }
        }
        $consulta = null;
        $con = null;
        return $datos;
    }
    public function buscar($codigo)
    {
        $conexion = $this->container->get('bd');
        $sql = "call search_curso(:codigo)";
        $query = $conexion->prepare($sql);
        $query->bindParam(':codigo', $codigo, PDO::PARAM_STR);
        $query->execute();
        $datos = $query->fetchAll();
        $query = null;
        $conexion = null;
        return $datos;
    }
    public function guardar($datos, $id = null)
    {
        $conexion = $this->container->get('bd');
        $sql = $id !=null ? "select update_curso(:id, :nombre)" :"select new_curso(:id, :nombre)";
        $query= $conexion->prepare($sql);
        $query->bindParam(':id', $datos->id, PDO::PARAM_STR);
        $query->bindParam(':nombre', $datos->nombre, PDO::PARAM_STR);
        $query->execute();
        $datos=$query->fetch(PDO::FETCH_NUM);
        $query=null;
        $conexion=null;
        return $datos;

    }
    // public function elimina($tabla, $codigo)
    // {
    //     $conexion = $this->container->get('bd');
    //     $sql = "select delete$tabla(:codigo)";
    //     $query = $conexion->prepare($sql);
    //     $query->bindParam(':codigo', $codigo, PDO::PARAM_INT);
    //     $query->execute();
    //     $datos = $query->fetch(PDO::FETCH_NUM);
    //     $query = null;
    //     $conexion = null;
    //     return $datos;
    // }
    // public function filtra($tabla, $p, $pagina, $lim)
    // {
    //     $ind = ($pagina - 1) * $lim;
    //     $conexion = $this->container->get('bd');
    //     $cad = "";
    //     foreach ($p as $valor) {
    //         $cad .= "%$valor%&";
    //     }
    //     $query = $conexion->prepare("call filter$tabla(:cadena,:indice, :limite);");
    //     $query->bindParam(':cadena', $cad, PDO::PARAM_STR);
    //     $query->bindParam(':indice', $ind, PDO::PARAM_INT);
    //     $query->bindParam(':limite', $lim, PDO::PARAM_INT);
    //     $query->execute();
    //     $datos = $query->fetchAll();
    //     $query = null;
    //     $conexion = null;
    //     return $datos;
    // }
}
