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
    public function todo($ind, $lim)
    {
        $con = $this->container->get('bd');
        $sql="call todosCursos(:ind, :lim)";
        $consulta=$con->prepare($sql);
        $consulta->binParam(':ind', $ind, PDO::PARAM_INT);
        $consulta->binParam(':lim', $lim, PDO::PARAM_INT);
        $consulta->execute();
        $datos=[];
        if($consulta->rowCount()>0){
            
        }

        return $query->fetchAll();


        //     $indice = ($pagina - 1) * $limite;
        //     $conexion = $this->container->get('bd');
        //     $sql = "CALL all$tabla(:indice, :limite)";
        //     $query = $conexion->prepare($sql);
        //     $query->bindParam(':indice', $indice, PDO::PARAM_INT);
        //     $query->bindParam(':limite', $limite, PDO::PARAM_INT);
        //     $query->execute();
        //     $datos = [];
        //     if ($query->rowCount() > 0) {
        //         $i = 0;
        //         while ($reg = $query->fetch(PDO::FETCH_ASSOC)) {
        //             $i++;
        //             foreach ($reg as $clave => $valor) {
        //                 $datos[$i][$clave] = $valor;
        //             }
        //         }
        //     }
        //     $query = null;
        //     $con = null;
        //     return $datos;
    }
    // public function busca($tabla, $codigo)
    // {
    //     $conexion = $this->container->get('bd');
    //     $sql = "call search$tabla(:codigo)";
    //     $query = $conexion->prepare($sql);
    //     $query->bindParam(':codigo', $codigo, PDO::PARAM_STR);
    //     $query->execute();
    //     $datos = $query->fetchAll();
    //     $query = null;
    //     $conexion = null;
    //     return $datos;
    // }
    // public function guarda($tabla, $datos, $id)
    // {
    //     // die(var_dump($this->generarParam($datos)));
    //     $params=$this->generarParam($datos);
    //     $conexion = $this->container->get('bd');
    //     $sql = $id != null ? "SELECT edit$tabla$params" : "SELECT new$tabla$params";
    //     // die($sql);
    //     $d=[];
    //     foreach ($datos as $campo =>$valor){
    //         $d[$campo]= filter_var($valor, FILTER_SANITIZE_STRING);
    //     }
    //     $query = $conexion->prepare($sql);
    //     // if ($id != null) {
    //     //     $query->bindParam(':id', $id, PDO::PARAM_INT);
    //     // }
    //     // $query->bindParam(':id_oficina', $datos->id_oficina, PDO::PARAM_INT);
    //     // $query->bindParam(':nombre', $datos->nombre, PDO::PARAM_STR);
    //     // $query->bindParam(':distrito', $datos->distrito, PDO::PARAM_STR);
    //     // $query->bindParam(':provincia', $datos->provincia, PDO::PARAM_STR);
    //     // $query->bindParam(':departamento', $datos->departamento, PDO::PARAM_STR);
    //     $query->execute($d);
    //     $datos = $query->fetch(PDO::FETCH_NUM);
    //     $query = null;
    //     $conexion = null;
    //     return $datos;
    // }
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
