-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-04-2022 a las 15:57:52
-- Versión del servidor: 10.4.11-MariaDB
-- Versión de PHP: 7.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `lotizacion`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `allManzana` (IN `_indice` SMALLINT UNSIGNED, IN `_limite` SMALLINT UNSIGNED)  BEGIN
select * from manzanas where estado=1 ORDER by nombre LIMIT _indice, _limite ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allProyecto` (IN `_indice` SMALLINT UNSIGNED, IN `_limite` SMALLINT UNSIGNED)  BEGIN
select * from proyectos where estado=1 ORDER by nombre LIMIT _indice, _limite ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `filterProyecto` (`_parametros` VARCHAR(250), `_paginas` SMALLINT UNSIGNED, `_cantRegs` SMALLINT UNSIGNED)  BEGIN
	select * from proyectos where id like (select substring_index(_parametros, '&', 1)) and 
		nombre like (select substring_index((select substr( _parametros, locate('&', _parametros)+1)),'&', 1)) limit _paginas, _cantRegs;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchProyecto` (IN `_codigo` INT(11))  BEGIN
SELECT * FROM lotizacion.proyectos where id=_codigo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `todosProyecto` (IN `_indice` SMALLINT UNSIGNED, IN `_limite` SMALLINT UNSIGNED)  BEGIN
select * from proyectos where estado=1 ORDER by nombre LIMIT _indice, _limite ;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `deleteProyecto` (`_id` INT(5)) RETURNS INT(1) BEGIN
	declare _cant int;
    select count(id) into _cant from proyectos where id=_id && estado=1 ;
    if _cant >0 then
		update proyectos set
			estado =0,
			fecha_edit=null
		where id=_id;
	end if;
	RETURN _cant;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `editManzana` (`_id` INT(5), `_id_proyecto` INT(5), `_nombre` VARCHAR(200), `_etapa` INT(3), `_detalle` TEXT) RETURNS INT(1) BEGIN
	declare _cant int;
    declare _cantIgual int;
    declare _idExis int;
     set _idExis=0;
	SELECT count(id) into _cant from manzanas where id=_id;
    SELECT count(nombre) into _cantIgual from manzanas where nombre=_nombre;
    SELECT id into _idExis from manzanas where nombre=_nombre;
    if _cant >0 then
		if _cantIgual> 0 &&_idExis=_id then
			set _cant=2;
			update manzanas set
				id_proyecto =_id_proyecto,
				nombre=_nombre,
				etapa=_etapa,
				detalle=_detalle,
				fecha_edit=null
			where id=_id;
		end if;
        if _cantIgual<= 0 then
			set _cant=2;
			update manzanas set
				id_proyecto =_id_proyecto,
				nombre=_nombre,
				etapa=_etapa,
				detalle=_detalle,
				fecha_edit=null
			where id=_id;
		end if;
        
    end if;
	RETURN _cant;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `editProyecto` (`_id` INT, `_id_oficina` INT, `_nombre` VARCHAR(200), `_distrito` VARCHAR(200), `_provincia` VARCHAR(200), `_departamento` VARCHAR(200)) RETURNS INT(1) BEGIN
	declare _cant int;
    declare _cantIgual int;
	SELECT count(id) into _cant from proyectos where id=_id;
    SELECT count(nombre) into _cantIgual from proyectos where nombre=_nombre;
    if _cant >0 && _cantIgual<=0 then
		set _cant=2;
		update proyectos set
			id_oficina =_id_oficina,
            nombre=_nombre,
            distrito=_distrito,
            provincia=_provincia,
            departamento=_departamento,
			fecha_edit=null
		where id=_id;
	end if;
	RETURN _cant;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `newManzana` (`_id_proyecto` INT(5), `_nombre` VARCHAR(200), `_etapa` INT(3), `_detalle` TEXT) RETURNS INT(1) BEGIN
	declare _cant int;
	SELECT count(nombre) into _cant from manzanas where nombre=_nombre;
	if _cant<=0 then
		insert into manzanas (id_proyecto, nombre, etapa, detalle) values (_id_proyecto, _nombre, _etapa, _detalle);
	end if;
	
	RETURN _cant;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `newProyecto` (`_id_oficina` INT, `_nombre` VARCHAR(200), `_distrito` VARCHAR(200), `_provincia` VARCHAR(200), `_departamento` VARCHAR(200)) RETURNS INT(1) BEGIN
	declare _cant int;
	SELECT count(nombre) into _cant from proyectos where nombre=_nombre;
	if _cant<=0 then
		insert into proyectos (id_oficina , nombre, distrito, provincia, departamento) values (_id_oficina, _nombre , _distrito , _provincia , _departamento);
	end if;
	
	RETURN _cant;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asesor`
--

CREATE TABLE `asesor` (
  `id` int(4) NOT NULL,
  `nombre` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `apellido` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `celular` char(11) COLLATE utf8_unicode_ci NOT NULL,
  `telefono` char(11) COLLATE utf8_unicode_ci NOT NULL,
  `direccion` text COLLATE utf8_unicode_ci NOT NULL,
  `correo` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `dni` char(8) COLLATE utf8_unicode_ci NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `id_oficina` int(4) NOT NULL,
  `fecha_alta` timestamp NOT NULL DEFAULT current_timestamp(),
  `fehca_edit` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `campanias`
--

CREATE TABLE `campanias` (
  `id` int(4) NOT NULL,
  `id_proyecto` int(4) NOT NULL,
  `nombre` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8_unicode_ci NOT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `monto_o_porcentaje` bit(1) NOT NULL DEFAULT b'0',
  `descuento_monto` decimal(10,2) NOT NULL DEFAULT 0.00,
  `descuento_porcentaje` decimal(10,2) NOT NULL DEFAULT 0.00,
  `aforo` int(7) NOT NULL,
  `fecha_alta` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_edit` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `campanias`
--

INSERT INTO `campanias` (`id`, `id_proyecto`, `nombre`, `descripcion`, `fecha_inicio`, `fecha_fin`, `monto_o_porcentaje`, `descuento_monto`, `descuento_porcentaje`, `aforo`, `fecha_alta`, `fecha_edit`) VALUES
(1, 1, 'Día de la Madre', 'Descuento por día de la madre', '2022-04-07 23:10:45', '2022-04-09 23:10:45', b'0', '100.00', '0.00', 50, '2022-04-07 04:13:38', '2022-04-07 04:13:38');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lotes`
--

CREATE TABLE `lotes` (
  `id` int(7) NOT NULL,
  `id_manzana` int(4) NOT NULL,
  `nombre` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `precio_especial` decimal(10,2) NOT NULL,
  `largo` decimal(10,2) NOT NULL,
  `ancho` decimal(10,2) NOT NULL,
  `fecha_alta` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_edit` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `lotes`
--

INSERT INTO `lotes` (`id`, `id_manzana`, `nombre`, `precio`, `precio_especial`, `largo`, `ancho`, `fecha_alta`, `fecha_edit`) VALUES
(1, 1, 'b2', '2000.00', '1800.00', '1.00', '1.00', '2022-04-07 04:01:35', '2022-04-07 04:01:35'),
(2, 1, 'b2', '2000.00', '1800.00', '1.00', '1.00', '2022-04-07 04:02:13', '2022-04-07 04:02:13'),
(3, 1, 'b4', '1800.00', '1500.00', '1.00', '1.00', '2022-04-07 04:05:25', '2022-04-07 04:05:25'),
(4, 1, 'B6', '1500.00', '1000.00', '5.50', '6.60', '2022-04-07 04:07:11', '2022-04-07 04:07:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manzanas`
--

CREATE TABLE `manzanas` (
  `id` int(5) NOT NULL,
  `id_proyecto` int(5) NOT NULL,
  `nombre` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `etapa` int(3) NOT NULL,
  `detalle` text COLLATE utf8_unicode_ci NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1,
  `fecha_alta` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_edit` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `manzanas`
--

INSERT INTO `manzanas` (`id`, `id_proyecto`, `nombre`, `etapa`, `detalle`, `estado`, `fecha_alta`, `fecha_edit`) VALUES
(1, 18, 'B4x', 4, 'OGO Q vSbeMsdddgp', 1, '2022-04-18 02:47:44', '2022-04-18 13:46:13'),
(3, 37, 'L7', 3, 'MLQ U A7V5xvRQ', 1, '2022-04-18 02:48:13', '2022-04-18 02:48:13'),
(4, 16, 'Z0', 2, 'KJO W LMqVPLL7', 1, '2022-04-18 02:48:13', '2022-04-18 02:48:13'),
(5, 6, 'Z3', 2, 'UKC T 61xzbeB9', 1, '2022-04-18 02:48:13', '2022-04-18 02:48:13'),
(7, 6, 'B5', 0, 'WKI S WR3VYNg8', 1, '2022-04-18 02:49:04', '2022-04-18 02:49:04'),
(8, 12, 'P0', 0, 'ENQ Y rAqtUcmT', 1, '2022-04-18 02:49:04', '2022-04-18 02:49:04'),
(9, 40, 'F7', 0, 'SDA L Kf1JmVqQ', 1, '2022-04-18 02:49:04', '2022-04-18 02:49:04'),
(27, 39, 'K9', 1, 'BWY X YaToSkhe', 1, '2022-04-18 02:49:35', '2022-04-18 02:49:35'),
(28, 38, 'F0', 3, 'HVS A oRg5XBR8', 1, '2022-04-18 02:49:42', '2022-04-18 02:49:42'),
(29, 53, 'C8', 4, 'LBO C H39oVTav', 1, '2022-04-18 02:49:42', '2022-04-18 02:49:42'),
(30, 53, 'Q5', 1, 'ALF Q iGpwnCcs', 1, '2022-04-18 02:49:42', '2022-04-18 02:49:42'),
(31, 31, 'W7', 3, 'PGH Y pbL0JChY', 1, '2022-04-18 02:49:42', '2022-04-18 02:49:42'),
(32, 6, 'W3', 6, 'RSG U 8EXjclGC', 1, '2022-04-18 02:49:42', '2022-04-18 02:49:42'),
(33, 48, 'Y7', 3, 'IAV J ycPcWATe', 1, '2022-04-18 02:49:42', '2022-04-18 02:49:42'),
(34, 20, 'W0', 10, 'CXT G FZrp9BIj', 1, '2022-04-18 02:49:42', '2022-04-18 02:49:42'),
(44, 8, 'S9', 1, 'HWC Y By8cp6cX', 1, '2022-04-18 02:50:48', '2022-04-18 02:50:48'),
(45, 43, 'X5', 4, 'CTR W xkwwg0lW', 1, '2022-04-18 02:50:53', '2022-04-18 02:50:53'),
(46, 6, 'N7', 9, 'XSJ L WoGt9Aef', 1, '2022-04-18 02:50:53', '2022-04-18 02:50:53'),
(47, 13, 'S4', 1, 'LLD K jbb5MfWT', 1, '2022-04-18 02:50:57', '2022-04-18 02:50:57'),
(48, 21, 'K5', 1, 'ETV C kvCKjA0h', 1, '2022-04-18 02:51:01', '2022-04-18 02:51:01'),
(49, 18, 'A6', 4, 'OGO Q vSbeMsgp', 1, '2022-04-18 02:51:05', '2022-04-18 02:51:05'),
(51, 16, 'S1', 4, 'HLX C u1uu1bNc', 1, '2022-04-18 02:51:12', '2022-04-18 02:51:12'),
(52, 32, 'H9', 5, 'UVJ N c0l9Dabu', 1, '2022-04-18 02:51:15', '2022-04-18 02:51:15'),
(53, 43, 'E0', 3, 'GDC I bxkhytJ2', 1, '2022-04-18 02:51:19', '2022-04-18 02:51:19'),
(54, 53, 'V4', 8, 'ZWN E olCbEQWy', 1, '2022-04-18 02:51:24', '2022-04-18 02:51:24'),
(55, 19, 'I7', 8, 'DHP C tIXk1Gbo', 1, '2022-04-18 02:51:27', '2022-04-18 02:51:27'),
(58, 29, 'G9', 1, 'IWS I 7D1uZLxO', 1, '2022-04-18 02:51:51', '2022-04-18 02:51:51'),
(59, 31, 'H5', 8, 'ZQZ W 852Yo4Xh', 1, '2022-04-18 02:51:51', '2022-04-18 02:51:51'),
(60, 6, 'G8', 2, 'JRH X pCuEUvmA', 1, '2022-04-18 02:51:51', '2022-04-18 02:51:51'),
(61, 53, 'C7', 2, 'YDA F t8dxPPEv', 1, '2022-04-18 02:51:51', '2022-04-18 02:51:51'),
(63, 9, 'O9', 1, 'UGY W tbPhN4AS', 1, '2022-04-18 02:52:13', '2022-04-18 02:52:13'),
(65, 37, 'X2', 10, 'RGP X D99X3uAD', 1, '2022-04-18 02:52:19', '2022-04-18 02:52:19'),
(66, 37, 'X8', 5, 'UTQ F g1uAFh9R', 1, '2022-04-18 02:52:19', '2022-04-18 02:52:19'),
(67, 11, 'G5', 5, 'IJQ A GZ9b3QYk', 1, '2022-04-18 02:52:19', '2022-04-18 02:52:19'),
(68, 29, 'B7', 9, 'DDY I IE0Hpr9f', 1, '2022-04-18 02:52:19', '2022-04-18 02:52:19'),
(69, 12, 'K0', 6, 'MRT C AJpLCyqE', 1, '2022-04-18 02:52:19', '2022-04-18 02:52:19'),
(71, 22, 'C1', 8, 'QYW C NEnxpQHv', 1, '2022-04-18 02:52:30', '2022-04-18 02:52:30'),
(73, 8, 'T8', 4, 'RVH I VwlBSkLg', 1, '2022-04-18 02:52:39', '2022-04-18 02:52:39'),
(74, 20, 'U9', 3, 'XFV N vHGyiHK3', 1, '2022-04-18 02:52:39', '2022-04-18 02:52:39'),
(77, 44, 'R1', 8, 'IQM O yB5TSgpT', 1, '2022-04-18 02:52:53', '2022-04-18 02:52:53'),
(78, 40, 'D4', 1, 'HXQ H HgxbhCXx', 1, '2022-04-18 02:52:53', '2022-04-18 02:52:53'),
(80, 39, 'T0', 8, 'MMN G xWAmUQum', 1, '2022-04-18 02:53:01', '2022-04-18 02:53:01'),
(81, 18, 'A62', 4, 'OGO Q vSbeMsgp', 1, '2022-04-18 03:14:59', '2022-04-18 03:14:59'),
(82, 18, 'A63', 4, 'OGO Q vSbeMsdddgp', 1, '2022-04-18 03:49:08', '2022-04-18 03:49:08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `oficina`
--

CREATE TABLE `oficina` (
  `id` int(5) NOT NULL,
  `nombre` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `detalle` text COLLATE utf8_unicode_ci NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `oficina`
--

INSERT INTO `oficina` (`id`, `nombre`, `detalle`, `estado`) VALUES
(1, 'Oficina 0001', 'sdfvkcdshklfdjsklf', 1),
(2, 'Oficina 2', 'fsfssdfdsf', 1),
(3, 'eu', 'etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut', 1),
(4, 'ultrices', 'orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat', 1),
(5, 'platea', 'faucibus orci luctus et ultrices posuere cubilia curae donec pharetra', 1),
(6, 'eros', 'non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem', 1),
(7, 'dapibus', 'felis donec semper sapien a libero nam dui proin leo odio porttitor', 1),
(8, 'lorem', 'curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at', 1),
(9, 'primis', 'ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque', 1),
(10, 'aliquam', 'molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec', 1),
(11, 'congue', 'pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero', 1),
(12, 'mattis', 'posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum', 1),
(13, 'pede', 'lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis', 1),
(14, 'ultrices', 'at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat', 1),
(15, 'sapien', 'phasellus sit amet erat nulla tempus vivamus in felis eu', 1),
(16, 'ut', 'nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia', 1),
(17, 'blandit', 'lorem ipsum dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum', 1),
(18, 'amet', 'rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat', 1),
(19, 'nullam', 'vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet', 1),
(20, 'nec', 'magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus', 1),
(21, 'tellus', 'fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis', 1),
(22, 'odio', 'vestibulum proin eu mi nulla ac enim in tempor turpis nec', 1),
(23, 'cursus', 'ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien', 1),
(24, 'consequat', 'ut odio cras mi pede malesuada in imperdiet et commodo', 1),
(25, 'risus', 'vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus', 1),
(26, 'quis', 'pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim', 1),
(27, 'cras', 'ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor', 1),
(28, 'augue', 'viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui', 1),
(29, 'lacus', 'nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea', 1),
(30, 'odio', 'adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit', 1),
(31, 'pretium', 'libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu', 1),
(32, 'blandit', 'in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur', 1),
(33, 'ac', 'phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac', 1),
(34, 'iaculis', 'in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas', 1),
(35, 'pellentesque', 'nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at', 1),
(36, 'morbi', 'lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante', 1),
(37, 'congue', 'a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem', 1),
(38, 'venenatis', 'id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat', 1),
(39, 'viverra', 'non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum', 1),
(40, 'sapien', 'amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere', 1),
(41, 'suscipit', 'odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel', 1),
(42, 'ipsum', 'justo in blandit ultrices enim lorem ipsum dolor sit amet', 1),
(43, 'at', 'pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id', 1),
(44, 'sit', 'purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor', 1),
(45, 'pede', 'in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed', 1),
(46, 'ut', 'nunc vestibulum ante ipsum primis in faucibus orci luctus et', 1),
(47, 'maecenas', 'aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum', 1),
(48, 'diam', 'lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non', 1),
(49, 'sed', 'morbi non quam nec dui luctus rutrum nulla tellus in', 1),
(50, 'praesent', 'quam suspendisse potenti nullam porttitor lacus at turpis donec posuere', 1),
(51, 'accumsan', 'in leo maecenas pulvinar lobortis est phasellus sit amet erat', 1),
(52, 'in', 'condimentum curabitur in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt', 1),
(53, 'tristique', 'felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan', 1),
(54, 'suspendisse', 'nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci', 1),
(55, 'eleifend', 'metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget', 1),
(56, 'diam', 'nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia', 1),
(57, 'convallis', 'ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin', 1),
(58, 'elementum', 'non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus', 1),
(59, 'pede', 'posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar', 1),
(60, 'vehicula', 'porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat', 1),
(61, 'mattis', 'fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a', 1),
(62, 'odio', 'felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat', 1),
(63, 'ornare', 'feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in', 1),
(64, 'quam', 'vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat', 1),
(65, 'arcu', 'ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus', 1),
(66, 'consequat', 'cras mi pede malesuada in imperdiet et commodo vulputate justo', 1),
(67, 'nec', 'vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus', 1),
(68, 'pretium', 'dui vel nisl duis ac nibh fusce lacus purus aliquet', 1),
(69, 'sed', 'orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae', 1),
(70, 'consequat', 'ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam tristique tortor eu pede', 1),
(71, 'orci', 'volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus', 1),
(72, 'at', 'tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa', 1),
(73, 'ac', 'congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo', 1),
(74, 'vestibulum', 'pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in', 1),
(75, 'iaculis', 'leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis', 1),
(76, 'velit', 'platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer', 1),
(77, 'ultrices', 'varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et', 1),
(78, 'pretium', 'malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim', 1),
(79, 'nulla', 'donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat', 1),
(80, 'ac', 'tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium', 1),
(81, 'pede', 'luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at', 1),
(82, 'in', 'augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum', 1),
(83, 'mollis', 'sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed', 1),
(84, 'fermentum', 'pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit', 1),
(85, 'posuere', 'et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci', 1),
(86, 'semper', 'ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam', 1),
(87, 'lacinia', 'at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non', 1),
(88, 'consectetuer', 'nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non', 1),
(89, 'aliquet', 'proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante', 1),
(90, 'dui', 'lorem id ligula suspendisse ornare consequat lectus in est risus auctor', 1),
(91, 'nisi', 'justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem', 1),
(92, 'eget', 'augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo', 1),
(93, 'interdum', 'mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue', 1),
(94, 'ipsum', 'justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in', 1),
(95, 'erat', 'cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna', 1),
(96, 'vestibulum', 'dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac', 1),
(97, 'nulla', 'vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat', 1),
(98, 'leo', 'bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem', 1),
(99, 'platea', 'in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis', 1),
(100, 'at', 'habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis', 1),
(101, 'in', 'sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus', 1),
(102, 'ut', 'vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod', 1),
(103, 'id', 'sit amet cursus id turpis integer aliquet massa id lobortis convallis', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyectos`
--

CREATE TABLE `proyectos` (
  `id` int(5) NOT NULL,
  `id_oficina` int(5) NOT NULL,
  `nombre` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `distrito` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `provincia` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `departamento` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1,
  `fecha_alta` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_edit` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `proyectos`
--

INSERT INTO `proyectos` (`id`, `id_oficina`, `nombre`, `distrito`, `provincia`, `departamento`, `estado`, `fecha_alta`, `fecha_edit`) VALUES
(1, 3, '33333', '33333', '33333', '33333', 0, '2022-04-14 04:42:33', '2022-04-17 18:39:05'),
(2, 30, 'RHINOSSS', 'SJL', 'Lima', 'Lima', 0, '2022-04-14 05:02:04', '2022-04-17 18:39:14'),
(3, 1, 'ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam', 'eget congue eget semper rutrum nulla nunc', 'sagittis sapien cum sociis natoque', 'ante ipsum primis in faucibus orci luctus et', 0, '2022-04-14 04:42:33', '2022-04-16 23:57:18'),
(4, 1, 'cras non', 'ac est lacinia', 'ut nulla sed', 'amet sem', 0, '2022-04-14 04:42:33', '2022-04-16 23:58:02'),
(5, 2, 'lacus morbi', 'justo etiam pretium', 'auctor sed', 'nulla facilisi', 0, '2022-04-14 04:42:33', '2022-04-17 14:04:13'),
(6, 3, 'habitasse platea', 'a feugiat', 'dictumst etiam', 'sapien cum', 0, '2022-04-14 04:42:33', '2022-04-17 18:38:42'),
(7, 4, 'et ultrices', 'justo in blandit', 'ac neque', 'mauris non ligula', 0, '2022-04-14 04:42:33', '2022-04-17 18:44:50'),
(8, 5, 'sapien in', 'leo maecenas', 'morbi ut odio', 'at ipsum', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(9, 6, 'quam sollicitudin', 'mauris ullamcorper purus', 'eu interdum', 'vel est donec', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(10, 7, 'varius integer', 'lobortis convallis', 'vulputate elementum nullam', 'eros suspendisse accumsan', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(11, 8, 'nunc rhoncus', 'vel ipsum', 'sollicitudin vitae consectetuer', 'vitae nisi nam', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(12, 9, 'eu interdum', 'nulla ac', 'tortor quis turpis', 'vestibulum ac est', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(13, 10, 'at dolor', 'ante nulla', 'in faucibus orci', 'at diam', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(14, 11, 'justo aliquamddd', 'mauris enim', 'ultricies eu', 'iaculis congue vivamus', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(15, 12, 'tincidunt eu', 'pede lobortis ligula', 'pede venenatis', 'vitae quam', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(16, 13, 'euismod scelerisque', 'ullamcorper purus sit', 'elementum eu interdum', 'orci luctus', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(17, 14, 'sit amet', 'felis fusce', 'viverra dapibus nulla', 'ipsum primis in', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(18, 15, 'sed justo', 'diam erat', 'non interdum in', 'donec quis', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(19, 16, 'odio curabitur', 'iaculis diam erat', 'enim blandit mi', 'nibh fusce', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(20, 17, 'aenean sit', 'purus aliquet at', 'lacinia erat', 'porttitor lorem', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(21, 18, 'ac enim', 'eleifend luctus ultricies', 'pulvinar nulla', 'mauris morbi', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(22, 19, 'maecenas rhoncus', 'ante ipsum', 'aenean sit', 'bibendum felis sed', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(23, 20, 'scelerisque mauris', 'quam nec', 'metus sapien', 'a ipsum integer', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(24, 21, 'ridiculus mus', 'sit amet erat', 'sapien varius', 'lacus at velit', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(25, 22, 'donec pharetra', 'vulputate vitae nisl', 'amet sem', 'mi in porttitor', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(26, 23, 'phasellus id', 'risus dapibus augue', 'interdum eu', 'mattis nibh ligula', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(27, 24, 'turpis adipiscing', 'sed accumsan felis', 'magna bibendum imperdiet', 'volutpat dui', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(29, 26, 'sollicitudin ut', 'suspendisse potenti nullam', 'mi sit amet', 'donec ut', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(31, 28, 'luctus et', 'aliquet at feugiat', 'nullam porttitor lacus', 'curabitur convallis', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(32, 29, 'sociis natoque', 'mattis pulvinar nulla', 'semper porta', 'ipsum praesent', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(33, 30, 'cursus urna', 'odio porttitor id', 'vestibulum ante', 'posuere cubilia', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(34, 31, 'eu mi', 'proin eu', 'vulputate ut ultrices', 'fermentum donec ut', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(35, 32, 'nulla facilisi', 'ultricies eu nibh', 'placerat praesent blandit', 'consectetuer adipiscing elit', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(36, 33, 'proin at', 'volutpat erat', 'quam sapien', 'parturient montes nascetur', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(37, 34, 'justo aliquam', 'vestibulum sit amet', 'tempus vivamus', 'ante ipsum', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(38, 35, 'cras in', 'sociis natoque', 'vestibulum ac', 'parturient montes nascetur', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(39, 36, 'lectus in', 'dapibus dolor', 'duis bibendum felis', 'interdum mauris', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(40, 37, 'in faucibus', 'nulla suspendisse potenti', 'odio donec vitae', 'ac tellus', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(41, 38, 'leo odio', 'non sodales', 'cubilia curae donec', 'lacus morbi', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(42, 39, 'nulla sed', 'orci mauris', 'augue vestibulum', 'amet sapien dignissim', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(43, 40, 'consequat metus', 'lorem ipsum', 'ut erat id', 'sed augue', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(44, 41, 'semper sapien', 'in felis', 'magna vulputate', 'eu tincidunt', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(45, 42, 'et magnis', 'quam nec', 'vestibulum rutrum', 'quis tortor id', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(46, 43, 'nisi at', 'morbi non lectus', 'dolor morbi', 'felis sed lacus', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(47, 44, 'ut odio', 'lobortis ligula sit', 'erat quisque erat', 'ipsum praesent', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(48, 45, 'nulla dapibus', 'gravida nisi at', 'sodales scelerisque mauris', 'amet erat', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(49, 46, 'vel ipsum', 'eget rutrum at', 'iaculis justo in', 'lacus at', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(50, 47, 'vitae nisl', 'nec molestie', 'pede morbi', 'pretium nisl', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(51, 48, 'primis in', 'eget tincidunt eget', 'tortor quis turpis', 'arcu adipiscing', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(52, 49, 'sem sed', 'sapien arcu', 'faucibus accumsan', 'eget elit', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(53, 50, 'dignissim vestibulum', 'rhoncus aliquet', 'cursus id', 'eleifend donec', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(60, 30, 'Lidera', 'Lidera', 'Lidera', 'Lidera', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(61, 30, 'qqqqq', 'Lidera', 'Lidera', 'Lidera', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(62, 30, 'aaaaa', 'Lidera', 'Lidera', 'Lidera', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(63, 30, 'zzzzzzzzzzzzzzz', 'Lidera', 'Lidera', 'Lidera', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(64, 30, 'zzzzzzzzzzzzzzzzzz', 'Lidera', 'Lidera', 'Lidera', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(65, 30, 'ccccc', 'Lidera', 'Lidera', 'Lidera', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(66, 30, 'vvvvvv', 'Lidera', 'Lidera', 'Lidera', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(67, 30, 'bbbbbb', 'Lidera', 'Lidera', 'Lidera', 1, '2022-04-14 04:42:33', '2022-04-14 04:07:56'),
(68, 30, 'sssssss', 'Lidera', 'Lidera', 'Lidera', 1, '2000-01-01 05:00:00', '2000-01-01 05:00:00'),
(69, 30, 'Del', 'SJL', 'Lima', 'Lima', 1, '2022-04-14 05:10:14', '2022-04-18 01:14:10'),
(70, 30, 'Rhinos', 'SJL', 'Lima', 'Lima', 1, '2022-04-17 13:09:21', '2022-04-17 13:09:21'),
(71, 30, 'Rechuchanboys', 'SJL', 'Lima', 'Lima', 1, '2022-04-17 18:34:40', '2022-04-17 18:34:40'),
(72, 30, 'Rechuchanboysvxxxx', 'SJL', 'Lima', 'Lima', 1, '2022-04-18 01:08:56', '2022-04-18 01:08:56'),
(73, 30, 'Delas', 'SJL', 'Lima', 'Lima', 1, '2022-04-18 02:56:23', '2022-04-18 04:05:25');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `asesor`
--
ALTER TABLE `asesor`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_asesor_oficina` (`id_oficina`);

--
-- Indices de la tabla `campanias`
--
ALTER TABLE `campanias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_campania_x_proyecto` (`id_proyecto`);

--
-- Indices de la tabla `lotes`
--
ALTER TABLE `lotes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_manzana_x_lotes` (`id_manzana`);

--
-- Indices de la tabla `manzanas`
--
ALTER TABLE `manzanas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD KEY `fx_manzana_proyecto` (`id_proyecto`);

--
-- Indices de la tabla `oficina`
--
ALTER TABLE `oficina`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `proyectos`
--
ALTER TABLE `proyectos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD KEY `fk_proyecto` (`id_oficina`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `asesor`
--
ALTER TABLE `asesor`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `campanias`
--
ALTER TABLE `campanias`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `lotes`
--
ALTER TABLE `lotes`
  MODIFY `id` int(7) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `manzanas`
--
ALTER TABLE `manzanas`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT de la tabla `oficina`
--
ALTER TABLE `oficina`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;

--
-- AUTO_INCREMENT de la tabla `proyectos`
--
ALTER TABLE `proyectos`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `asesor`
--
ALTER TABLE `asesor`
  ADD CONSTRAINT `fk_asesor_oficina` FOREIGN KEY (`id_oficina`) REFERENCES `oficina` (`id`);

--
-- Filtros para la tabla `campanias`
--
ALTER TABLE `campanias`
  ADD CONSTRAINT `fk_campania_x_proyecto` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id`);

--
-- Filtros para la tabla `lotes`
--
ALTER TABLE `lotes`
  ADD CONSTRAINT `fk_manzana_x_lotes` FOREIGN KEY (`id_manzana`) REFERENCES `manzanas` (`id`);

--
-- Filtros para la tabla `manzanas`
--
ALTER TABLE `manzanas`
  ADD CONSTRAINT `fx_manzana_proyecto` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id`);

--
-- Filtros para la tabla `proyectos`
--
ALTER TABLE `proyectos`
  ADD CONSTRAINT `fk_proyecto` FOREIGN KEY (`id_oficina`) REFERENCES `oficina` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
