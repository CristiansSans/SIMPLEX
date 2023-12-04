-- phpMyAdmin SQL Dump
-- version 4.9.7
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 07-04-2022 a las 13:06:43
-- Versión del servidor: 10.2.43-MariaDB-cll-lve
-- Versión de PHP: 7.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `simplex1_testenv`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_agenciaaduana_listar` ()  BEGIN
select
`tb_agenciaaduana`.`ada_ncorr` id,
null idparent,
`tb_agenciaaduana`.`ada_vnombre` description
from `tb_agenciaaduana`
order by `tb_agenciaaduana`.`ada_vnombre` asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_autenticacion_obtener` (IN `tslogin` VARCHAR(50), IN `tsclave` VARCHAR(50))  begin
            select  usua_ncorr, 
                    rol_ncorr, 
                    usua_vlogin,      
                    usua_vnombre,
		    usua_vapellido1,
                    usua_vapellido2,
                    usua_vmail,
                    usua_vclave
            from    tg_usuario
            where   usua_vlogin = tslogin
            and usua_vclave = tsclave;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_camionesempresa_listar` (`codempresa` INT)  BEGIN
    select  cam_ncorr, cam_vpatente, cam_vmarca, cam_vmodelo
    from    tg_camion cam
    where   emp_ncorr = codempresa
    order by cam.cam_vpatente asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_camiones_listar` (`codEmpresaTransporte` INT)  BEGIN
   DECLARE lnExisteCamion INT;
   IF codEmpresaTransporte = 0 THEN
        SELECT  0 ORDEN,cam_ncorr id, emp_ncorr idparent, cam_vpatente description
        FROM    tg_camion  
        ORDER BY ORDEN ASC, description ASC;
   ELSE
        SELECT  COUNT(*)
        INTO    lnExisteCamion
        FROM    tg_camion
        WHERE   emp_ncorr = codEmpresaTransporte;
        IF lnExisteCamion > 0 THEN
            SELECT  0 ORDEN,cam_ncorr id, emp_ncorr idparent, cam_vpatente description
            FROM    tg_camion
            WHERE   emp_ncorr = codEmpresaTransporte
            UNION
            SELECT  1 orden,0 id, null idparent,'--- OTRAS PATENTES ---' description
            UNION
            SELECT  2 ORDEN, cam_ncorr id, emp_ncorr idparent, CONCAT('-  ',cam_vpatente) description
            FROM    tg_camion
            WHERE   emp_ncorr !=codEmpresaTransporte OR emp_ncorr IS NULL
            ORDER BY ORDEN ASC, description ASC;
        ELSE
            SELECT  0 ORDEN,cam_ncorr id, emp_ncorr idparent, cam_vpatente description
            FROM    tg_camion  
            ORDER BY ORDEN ASC, description ASC;
        END IF;
   END IF;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_camion_eliminar` (`idcamion` INT)  BEGIN
    declare lnStatus int;    
    DECLARE CONTINUE HANDLER FOR 1451 set lnStatus = 1451;    
    delete from tg_camion where  cam_ncorr = idcamion;
    if lnStatus = 1451 then
        select 0,'La tarifa no puede ser eliminada ya que hay registros asociados';
    else
        select 1,'-';
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_camion_ingresar` (`codcamion` INT, `patente` VARCHAR(20), `marca` VARCHAR(20), `modelo` VARCHAR(20), `codempresa` INT)  BEGIN
    if codcamion = 0 then
        select if(max(cam_ncorr) is null,1,max(cam_ncorr)+1)
        into   codcamion
        from   tg_camion;
        insert into tg_camion (CAM_NCORR, CAM_VPATENTE, EMP_NCORR, CAM_VMARCA, CAM_VMODELO)
        values (codcamion, patente, codempresa,marca, modelo);
    else
        update  tg_camion
        set     cam_vpatente = patente, emp_ncorr = codempresa, cam_vmarca = marca, cam_vmodelo = modelo
        where   cam_ncorr = codcamion;
    end if;
    select 1,'-';
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_cargalibre_importar` (IN `codOrden` INT, IN `codUM` INT, IN `cantidad` INT, IN `observaciones` VARCHAR(500), IN `booking` VARCHAR(100), IN `operacion` VARCHAR(100))  NO SQL
BEGIN
	declare	idcarga int;
	INSERT INTO tg_carga (ose_ncorr, 
						  esca_ncorr, 
						  tica_ncorr, 
						  car_vobservaciones,
						  fact_ncorr,
						  car_nbooking,
						  car_voperacion)
	VALUES( codOrden,
			1,
			2,
			observaciones,
			null,
			booking,
			operacion);
	select 	max(car_ncorr)
	into	idcarga
	from	tg_carga;
	INSERT INTO tg_info_cargalibre (car_ncorr, car_cantidad, um_ncorr)
	VALUES (idcarga, cantidad, codUM);
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_cargalibre_ingresar` (`tnCodCarga` INT, `tnCodUM` INT, `tnCantidad` INT)  BEGIN
    DECLARE lnExisteItem INT;
    select count(CAR_NCORR)
    into lnExisteItem  
    from tg_info_cargalibre
    where CAR_NCORR = tnCodCarga;
    IF lnExisteItem  = 0 THEN
        INSERT INTO tg_info_cargalibre(CAR_NCORR, UM_NCORR, CAR_CANTIDAD)
        VALUES(tnCodCarga,tnCodUM,tnCantidad);
    else
        update tg_info_cargalibre
        set UM_NCORR = tnCodUM,
              CAR_CANTIDAD = tnCantidad
        where CAR_NCORR = tnCodCarga;
    END IF;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_cargalibre_listar` (`tnidcarga` INT)  BEGIN
        select 
            `car_ncorr`,
            `um_ncorr`,
            `car_cantidad`
        from tg_info_cargalibre
        where car_ncorr=tnidcarga;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_cargaprogramada_eliminar` (`idcarga` INT)  BEGIN
    declare lnStatus int;    
    DECLARE CONTINUE HANDLER FOR 1451 set lnStatus = 1451;    
    delete from tg_camion where  cam_ncorr = idcarga;
    if lnStatus = 1451 then
        select 0,'La tarifa no puede ser eliminada ya que hay registros asociados';
    else
        select 1,'-';
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_cargaprogramada_listar` (IN `fechaConsulta` DATETIME)  BEGIN
	if ISNULL(fechaConsulta) THEN
		select    serv.car_ncorr,
				DATE_FORMAT(serv.serv_dinicio,'%Y/%m/%d %H:%i')     serv_dinicio,
				DATE_FORMAT(serv.serv_dtermino,'%Y/%m/%d %H:%i')    serv_dtermino,
				UPPER(clie.clie_vnombre)      clie_vnombre,
				tise.tise_ncorr,
				UPPER(tise.tise_vdescripcion) tise_vdescripcion,
				lug1.tlu_ncorr              idlugarorigen,
				UPPER(lug1.lug_vnombre)     descripcionlugarorigen,
				lug2.tlu_ncorr              idlugardestino,
				UPPER(lug2.lug_vnombre)     descripcionlugardestino,
				UPPER(emp.emp_vnombre)      emp_vnombre,
				emp.emp_ncorr,
				cam.cam_vpatente,
				cam.cam_ncorr,
				cha.cha_ncorr,
				cha_vpatente,
				car.ose_ncorr,
				cho.chof_ncorr,
				UPPER(cho.chof_vnombre)     chof_vnombre,
				serv.serv_vcelular,
				guia.guia_ncorr, 
				CONCAT(LPAD(guia.guia_numero,6,'0'),' (', if(guia.guia_ntipo=1,'SII','Virtual'),')') guia_numero,
				guia.guia_ntipo
		from    tg_carga car
		inner join tg_servicio serv on serv.car_ncorr = car.car_ncorr
		inner join tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
		inner join tb_cliente clie on clie.clie_vrut = ose.clie_vrut
		inner join tb_tiposervicio tise on tise.tise_ncorr = ose.tise_ncorr
		inner join tb_lugar lug1 on lug1.lug_ncorr = ose.lug_ncorrorigen
		left join tb_lugar lug2 on lug2.lug_ncorr = serv.lug_ncorr_destino
		left join tg_empresatransporte emp on emp.emp_ncorr = serv.emp_ncorr
		left join tg_camion cam on cam.cam_ncorr = serv.cam_ncorr
		left join tg_chasis cha on cha.cha_ncorr = serv.cha_ncorr
		left join tg_chofer cho on cho.chof_ncorr = serv.chof_ncorr
		left join tg_guiatransporte guia on guia.guia_ncorr = car.guia_ncorr;
	ELSE
		select    serv.car_ncorr,
				DATE_FORMAT(serv.serv_dinicio,'%Y/%m/%d %H:%i')     serv_dinicio,
				DATE_FORMAT(serv.serv_dtermino,'%Y/%m/%d %H:%i')    serv_dtermino,
				UPPER(clie.clie_vnombre)      clie_vnombre,
				tise.tise_ncorr,
				UPPER(tise.tise_vdescripcion) tise_vdescripcion,
				lug1.tlu_ncorr              idlugarorigen,
				UPPER(lug1.lug_vnombre)     descripcionlugarorigen,
				lug2.tlu_ncorr              idlugardestino,
				UPPER(lug2.lug_vnombre)     descripcionlugardestino,
				UPPER(emp.emp_vnombre)      emp_vnombre,
				emp.emp_ncorr,
				cam.cam_vpatente,
				cam.cam_ncorr,
				cha.cha_ncorr,
				cha_vpatente,
				car.ose_ncorr,
				cho.chof_ncorr,
				UPPER(cho.chof_vnombre)     chof_vnombre,
				serv.serv_vcelular,
				guia.guia_ncorr, 
				CONCAT(LPAD(guia.guia_numero,6,'0'),' (', if(guia.guia_ntipo=1,'SII','Virtual'),')') guia_numero,
				guia.guia_ntipo
		from    tg_carga car
		inner join tg_servicio serv on serv.car_ncorr = car.car_ncorr
		inner join tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
		inner join tb_cliente clie on clie.clie_vrut = ose.clie_vrut
		inner join tb_tiposervicio tise on tise.tise_ncorr = ose.tise_ncorr
		inner join tb_lugar lug1 on lug1.lug_ncorr = ose.lug_ncorrorigen
		left join tb_lugar lug2 on lug2.lug_ncorr = serv.lug_ncorr_destino
		left join tg_empresatransporte emp on emp.emp_ncorr = serv.emp_ncorr
		left join tg_camion cam on cam.cam_ncorr = serv.cam_ncorr
		left join tg_chasis cha on cha.cha_ncorr = serv.cha_ncorr
		left join tg_chofer cho on cho.chof_ncorr = serv.chof_ncorr
		left join tg_guiatransporte guia on guia.guia_ncorr = car.guia_ncorr
		where   date(serv.serv_dinicio) = date(fechaConsulta) and serv.serv_nterminado = 0;
	END IF;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_cargasinprogramar_listar` ()  BEGIN
    select  car.car_ncorr idcarga,
            DATE_FORMAT(ose.ose_dfechaservicio,'%Y/%m/%d') fechaeta,
            lug.lug_ncorr codpuntocarguio,
            lug.lug_vnombre puntocarguio,
            IF(car.esca_ncorr = 1,lug.lug_vnombre,ubicacion.lug_vnombre) ubicacion,
            IF(ose.lug_ncorrdestino > 0,destino.lug_vnombre, destinoplan.lug_vnombre) destino,
            ose.ose_vnombrenave nombrenave,
            clie.clie_vnombre cliente,
            inco.cont_vnumcontenedor numcontenedor,
            med.med_vdescripcion medida,
            IF (car.tica_ncorr=1,inco.cont_npeso,IF(cali.um_ncorr=2,cali.car_cantidad,0)) pesocarga,
            cond.cond_vdescripcion condicionespecial,
            car.car_nbooking operacion
    from   tg_carga car
    inner join tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
    inner join tb_cliente clie on clie.clie_vrut = ose.clie_vrut
    inner join tb_lugar lug on ose.lug_ncorrorigen = lug.lug_ncorr
    left join tg_servicio serv on serv.car_ncorr = car.car_ncorr
    left join tb_lugar ubicacion on ubicacion.lug_ncorr = serv.lug_ncorr_origen
    left join tb_lugar destino on destino.lug_ncorr = ose.lug_ncorrdestino
    left join tg_info_container inco on inco.car_ncorr = car.car_ncorr
    left join tg_info_traslado tras on tras.car_ncorr = car.car_ncorr
    left join tb_lugar destinoplan on destinoplan.lug_ncorr = tras.lug_ncorr_destino
    left join tb_medidacontenedor med on med.med_ncorr = inco.med_ncorr
    left join tb_condicionespecial cond on cond.cond_ncorr = inco.cond_ncorr
    left join  tg_info_cargalibre cali on cali.car_ncorr = car.car_ncorr
    where car.esca_ncorr in (1,4);
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_carga_eliminar` (IN `idcarga` INT)  BEGIN
    declare lnStatus int;    
    DECLARE CONTINUE HANDLER FOR 1451 set lnStatus = 1451;
    delete from tg_info_adicional where  car_ncorr = idcarga;
    delete from tg_info_cargalibre where  car_ncorr = idcarga;
    delete from tg_info_consolidacion where  car_ncorr = idcarga;
    delete from tg_info_container where  car_ncorr = idcarga;
    delete from tg_info_traslado where  car_ncorr = idcarga;
    delete from tg_carga where  car_ncorr = idcarga;
    if lnStatus = 1451 then
        select 0,'La carga no puede ser eliminada ya que hay registros asociados';
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_chasistransportista_ingresar` (`codchasis` INT, `patente` VARCHAR(20), `codempresa` INT)  BEGIN
    if codchasis = 0 then
        select if(max(cha_ncorr) is null, 1, max(cha_ncorr) +1)
        into    codchasis
        from    tg_chasis;
        insert into tg_chasis(CHA_NCORR, EMP_NCORR, CHA_VPATENTE)
        values(codchasis,codempresa,patente);
    else
        update  tg_chasis
        set     cha_vpatente = patente,
                emp_ncorr = codempresa
        where   cha_ncorr = codchasis;
    end if;
    select 1,'-';
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_chasistransportista_listar` (`idtransportista` INT)  BEGIN
    select  cha.cha_ncorr, cha.cha_vpatente
    from    tg_chasis cha
    where   cha.emp_ncorr = idtransportista
    order by cha.cha_vpatente asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_chasis_listar` (`codEmpresaTransporte` INT)  BEGIN
   DECLARE lnExisteCamion INT;
   IF codEmpresaTransporte = 0 THEN
        SELECT  0 orden,cha_ncorr id, emp_ncorr idparent, cha_vpatente description
        FROM    tg_chasis  
        ORDER BY orden ASC, description ASC;
   ELSE
        SELECT  COUNT(*)
        INTO    lnExisteCamion
        FROM    tg_chasis
        WHERE   emp_ncorr = codEmpresaTransporte;
        IF lnExisteCamion > 0 THEN
            SELECT  0 orden,cha_ncorr id, emp_ncorr  idparent, cha_vpatente description
            FROM    tg_chasis
            WHERE   emp_ncorr = codEmpresaTransporte
            UNION
            SELECT  1 orden,0 id, null idparent,'--- OTRAS PATENTES ---' description
            UNION
            SELECT  2 orden, cha_ncorr id, emp_ncorr  idparent, CONCAT('-  ',cha_vpatente) description
            FROM    tg_chasis
            WHERE   emp_ncorr !=codEmpresaTransporte OR emp_ncorr IS NULL
            ORDER BY orden ASC, description ASC;
        ELSE
            SELECT  0 orden,cha_ncorr id, emp_ncorr  idaprent, cha_vpatente description
            FROM    tg_chasis  
            ORDER BY orden ASC, description ASC;
        END IF;
   END IF;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_ciudad_listar` (`subtiposervicio` INT, `rutcliente` VARCHAR(20))  BEGIN
       select
       `tb_lugar`.`lug_ncorr` id,
        null idparent,
       `tb_lugar`.`tlu_ncorr`,
       `tb_lugar`.`lug_vnombre` description,
       `tb_lugar`.`lug_vdireccion`,
       1 orden
        from `tb_lugar`
        inner join tg_tarifaservicio tise on tise.lug_ncorr_origen = tb_lugar.lug_ncorr
        where tlu_ncorr = 5 and
              tise.sts_ncorr = subtiposervicio and
              tise.clie_vrut = rutcliente
        order by description asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_cliente_eliminar` (`rut` VARCHAR(10))  BEGIN
    declare lnStatus int;    
    DECLARE CONTINUE HANDLER FOR 1451 set lnStatus = 1451;    
    delete from tb_cliente where  clie_vrut = rut;
    if lnStatus = 1451 then
        select 0,'El hito no pudo ser eliminado porque posee registros asociados';
    else
        select 1,'-';
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_cliente_ingresar` (`rut` INT, `dv` VARCHAR(1), `nombre` VARCHAR(50), `contactolegal` VARCHAR(50), `direccion` VARCHAR(50), `comuna` VARCHAR(50), `giro` VARCHAR(50), `fono` VARCHAR(50))  BEGIN
    declare lnexiste int;
    select  count(*)
    into    lnexiste
    from    tb_cliente
    where   clie_vrut = rut;
    if lnexiste = 0 then
        insert into tb_cliente (clie_vrut, 
                                clie_vdv, 
                                clie_vnombre, 
                                clie_vcontactolegal, 
                                clie_vdireccion, 
                                clie_vcomuna, 
                                clie_vgiro, 
                                clie_vfono)
        values (rut, dv, nombre, contactolegal,direccion, comuna, giro, fono);
    else
        update  tb_cliente
        set     clie_vnombre = nombre, 
                clie_vcontactolegal = contactolegal, 
                clie_vdireccion = direccion, 
                clie_vcomuna = comuna, 
                clie_vgiro = giro, 
                clie_vfono = fono
        where   clie_vrut = rut;
    end if;
    select 1,'';
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_cliente_listar` ()  BEGIN
    select  clie_vrut id,
            clie_nrutpadre idparent,
            clie_vnombre description,
            clie_vnombre nombre,
            CONCAT(clie_vrut,'-',clie_vdv) rut,
            clie_vdireccion, 
            clie_vdv, 
            clie_vcomuna, 
            clie_vgiro, 
            clie_vfono
    from tb_cliente
    where clie_nrutpadre IS null and clie_vrut > 0
    order by clie_vnombre asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_cliente_obtener` (`rut` VARCHAR(20))  begin
    select  clie_vrut,
            clie_vdv,
            clie_vnombre,    
            clie_vdireccion,
            clie_vcontactolegal,
            clie_vgiro,
            ciu_ncorr
    from    tb_cliente
    where   clie_vrut =  rut;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_combolugardestino_listar` (`codOrigen` INT, `rutEmpresa` INT)  BEGIN
    SELECT  distinct lug.lug_ncorr id,
            null idparent,
            lug.tlu_ncorr,
            lug.lug_vnombre description,
            lug.lug_vdireccion,
            1 orden        
    FROM    tb_lugar lug
    INNER JOIN tg_tarifaservicio tasi on lug.lug_ncorr = tasi.lug_ncorr_destino
            AND tasi.lug_ncorr_origen = codOrigen
            AND tasi.clie_vrut = rutEmpresa
    ORDER BY lug_vnombre ASC;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_condicionespecial_listar` ()  BEGIN
    select  COND_NCORR id, COND_VDESCRIPCION description
    from    tb_condicionespecial
    order by description asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_conductorestransportista_eliminar` (`idchofer` INT)  BEGIN
    declare lnStatus int;    
    DECLARE CONTINUE HANDLER FOR 1451 set lnStatus = 1451;    
    delete from tg_chofer where  chof_ncorr = idchofer;
    if lnStatus = 1451 then
        select 0,'La tarifa no puede ser eliminada ya que hay registros asociados';
    else
        select 1,'-';
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_conductorestransportista_ingresar` (`idchofer` INT, `idcamion` INT, `nombre` VARCHAR(50), `rut` VARCHAR(20), `codempresa` INT, `fono` VARCHAR(50))  BEGIN
    if idchofer = 0 then
        select  if(max(chof_ncorr) is null,1,max(chof_ncorr)+1)
        into    idchofer
        from    tg_chofer;
        insert into tg_chofer (CHOF_NCORR, CAM_NCORR, CHOF_VNOMBRE, CHOF_VRUT, EMP_NCORR, CHOF_VFONO)
        values(idchofer,idcamion,nombre,rut,codempresa,fono);
        select 1,'-';
    else
        update  tg_chofer
        set     cam_ncorr = idcamion, 
                chof_vnombre = nombre, 
                chof_vrut = rut, 
                emp_ncorr = codempresa, 
                chof_vfono = fono 
        where   chof_ncorr = idchofer;
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_conductorestransportista_listar` (`codempresa` INT)  BEGIN
    select  chof.chof_ncorr,
            cam.cam_ncorr,
            cam.cam_vpatente,
            chof.chof_vnombre,
            chof.chof_vrut,
            chof.chof_vfono
    from    tg_chofer chof
    left join tg_camion cam on cam.cam_ncorr = chof.cam_ncorr
    where   chof.emp_ncorr = codempresa
    order by chof.chof_vnombre asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_conductores_listar` (`codempresatransporte` INT)  BEGIN
    select  0 orden, chof_ncorr id, null idparent, CONCAT(chof_vrut, " ", UPPER(chof_vnombre)) description
    from    tg_chofer
    where   tg_chofer.emp_ncorr = codempresatransporte 
    UNION   
    select  1 orden,0 id, null idparent, '--OTROS CHOFERES--' description
    UNION
    select  2 orden, chof_ncorr id, null idparent, CONCAT(chof_vrut, " ", UPPER(chof_vnombre)) description
    from    tg_chofer
    where   tg_chofer.emp_ncorr not in(codempresatransporte )
    order by orden asc, description asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_conductor_obtener` (`codchofer` INT)  BEGIN
  select  chof_ncorr, chof_vnombre, chof_vrut, chof_vfono
  from     tg_chofer
  where  chof_ncorr = codchofer ;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_contactoagencia_listar` (`tncodAgencia` INT)  BEGIN
    if tncodAgencia = 0 then
        select  CADA_NCORR id, null idparent, CADA_VNOMBRE description
        from    tg_contacto_agencia
        order by description asc;
    else
        select  CADA_NCORR id, null idparent, CADA_VNOMBRE description
        from    tg_contacto_agencia
        where   ada_ncorr = tncodAgencia 
        order by description asc;    
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_container_importar` (IN `codOrden` INT, IN `contenedor` VARCHAR(50) CHARSET utf8, IN `sello` VARCHAR(50) CHARSET utf8, IN `peso` INT, IN `codMedida` INT, IN `codCondicion` INT, IN `observaciones` VARCHAR(200), IN `codAgencia` INT, IN `booking` VARCHAR(50) CHARSET utf8, IN `operacion` VARCHAR(50) CHARSET utf8, IN `marcaContenededor` VARCHAR(100) CHARSET utf8, IN `contenido` VARCHAR(200) CHARSET utf8, IN `terminoStacking` DATE, IN `diasLibres` INT, IN `contactoEntrega` VARCHAR(50) CHARSET utf8, IN `temperatura` INT, IN `ventilacion` INT, IN `otros` VARCHAR(200) CHARSET utf8, IN `obsEntrega` VARCHAR(299) CHARSET utf8)  NO SQL
BEGIN
	declare	idcarga int;
	INSERT INTO tg_carga (ose_ncorr, 
						  esca_ncorr, 
						  tica_ncorr, 
						  car_vobservaciones,
						  fact_ncorr,
						  car_nbooking,
						  car_voperacion)
	VALUES( codOrden,
			1,
			1,
			observaciones,
			null,
			booking,
			operacion);
	select 	max(car_ncorr)
	into	idcarga
	from	tg_carga;
	INSERT INTO tg_info_container(CAR_NCORR, CONT_VNUMCONTENEDOR, CONT_VSELLO, CONT_NPESO, MED_NCORR, COND_NCORR, CONT_VOBSERVACIONSELLO, ADA_NCORR, CONT_VMARCA, CONT_VCONTENIDO, CONT_NDIASLIBRES, CONT_DTERMINOSTACKING)
	VALUES(idcarga, contenedor, sello, peso, codMedida, codCondicion, observaciones, codAgencia, marcaContenededor, contenido, diasLibres, terminoStacking);
	if temperatura > 0 or ventilacion > 0 then
		INSERT INTO tg_info_adicional (CAR_NCORR, CAR_NTEMPERATURA, CAR_NVENTILACION, CAR_VOTROS, CAR_VOBSERVACIONES)
		VALUES (idcarga, temperatura, ventilacion, otros, obsEntrega);
	end if;
	if contactoEntrega <> "" then
		INSERT INTO tg_info_traslado (CAR_NCORR, CAR_VCONTACTOENTREGA)
		VALUES (idcarga, contactoEntrega);
	end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_datosfactura_obtener` (`cargasasociar` VARCHAR(200))  BEGIN
    SET @s = CONCAT('SELECT  car.car_ncorr idcarga,
                             tise.tise_vdescripcion servicio,
                             cont.cont_vnumcontenedor contenedor,
                             tarifa.tasi_nmonto monto
                    FROM    tg_carga car
                    INNER JOIN tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
                    INNER JOIN tb_tiposervicio tise on tise.tise_ncorr = ose.tise_ncorr
                    LEFT JOIN tg_info_container cont on cont.car_ncorr = car.car_ncorr
                    LEFT JOIN tg_tarifaservicio tarifa 
                                on ose.LUG_NCORR_PUNTOCARGUIO = tarifa.lug_ncorr_origen
                                and ose.LUG_NCORRDESTINO = tarifa.lug_ncorr_destino
                                and ose.sts_ncorr = tarifa.sts_ncorr
                                and ose.clie_vrut = tarifa.clie_vrut                            
                    WHERE   car.car_ncorr IN (', cargasasociar,')');
    PREPARE stmt FROM @s;
    EXECUTE stmt;        
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_destinosposibles_listar` (`codlugarorigen` INT)  BEGIN
    if codlugarorigen > 0 then
       select  tra.lug_ncorr_destino id, null idparent, lug.lug_vnombre description
       from    tg_tramo tra
       inner join tb_lugar lug on tra.lug_ncorr_destino = lug.lug_ncorr
       where   tra.lug_ncorr_origen = codlugarorigen
       order by description asc;
    else
       select  lug.lug_ncorr id, null idparent, lug.lug_vnombre description
       from    tg_tramo tra
       right join tb_lugar lug on tra.lug_ncorr_destino = lug.lug_ncorr
       order by description asc;
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_detallecarga_eliminar` (IN `idcarga` INT)  BEGIN
    declare lnStatus int;    
    DECLARE CONTINUE HANDLER FOR 1451 set lnStatus = 1451;    
    delete from tg_info_adicional where  car_ncorr = idcarga;
    delete from tg_info_cargalibre where  car_ncorr = idcarga;
    delete from tg_info_consolidacion where  car_ncorr = idcarga;
    delete from tg_info_container where  car_ncorr = idcarga;
    delete from tg_info_traslado where  car_ncorr = idcarga;
    delete from tg_carga where  car_ncorr = idcarga;    
    if lnStatus = 1451 then
        select 0,'La tarifa no puede ser eliminada ya que hay registros asociados';
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_detallecarga_exportar` (`inicio` DATETIME, `termino` DATETIME)  BEGIN
    SELECT  car.ose_ncorr IdOrdenServicio,
            clie.clie_vnombre Cliente,
            subcliente.clie_vnombre SubCliente,
            ose.ose_vnombrenave Nave,
            ose.ose_dfechaservicio FechaServicio,
            tise.tise_vdescripcion TipoServicio,
            sts.STS_VNOMBRE SubTipoServicio,
            lugretiro.LUG_VNOMBRE Lugarretiro,
            puntocarguio.LUG_VNOMBRE Puntocarguio,
            lugardestino.LUG_VNOMBRE LugarDestino,
            car.car_ncorr IdCarga,
            tica.tica_vdescripcion TipoCarga,
            UPPER(esca.ESCA_VDESCRIPCION) EstadoCarga,
            car.car_nbooking NumBooking,
            car.car_voperacion NumOperacion,
            car.car_vobservaciones,
            inco.CONT_VMARCA MarcaContenedor,
            inco.CONT_VNUMCONTENEDOR NumContenedor,
            inco.CONT_VCONTENIDO Contenido,
            inco.CONT_DTERMINOSTACKING TerminoStacking,
            lugardevolucion.LUG_VNOMBRE LugarDevolucion,
            inco.CONT_NDIASLIBRES DiasLibres,
            inco.CONT_VSELLO Sello,
            ada.ada_vnombre AgenciaAduana,
            inco.CONT_NPESO PesoContenedor,
            med.med_vdescripcion Medida,
            cond.cond_vdescripcion CondicionEspecial,
            serv.serv_dinicio InicioServicio,
            serv.serv_dtermino Terminoservicio,
            origenservicio.LUG_VNOMBRE OrigenServicio,
            destinoservicio.LUG_VNOMBRE DestinoServicio,
            emp.emp_vnombre Empresa,
            cam.cam_vpatente Camion,
            cha.cha_vpatente chasis,
            chof.chof_vnombre Chofer,
            guia.guia_numero NumGuia,        
            if(guia.guia_ntipo=1,'SII',if(guia.guia_ntipo=2,'Virtual','-')) Tipoguia
    FROM    tg_carga car
            INNER JOIN tb_tipocarga tica on car.tica_ncorr = tica.tica_ncorr
            INNER JOIN tb_estadocarga esca on car.esca_ncorr = esca.esca_ncorr
            INNER JOIN tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
            INNER JOIN tb_cliente clie on clie.clie_vrut = ose.clie_vrut
            INNER JOIN tb_tiposervicio tise on tise.tise_ncorr = ose.tise_ncorr
            LEFT JOIN tb_subtiposervicio sts on sts.sts_ncorr = ose.sts_ncorr
            LEFT JOIN tb_cliente subcliente on subcliente.clie_vrut = ose.CLIE_VRUTSUBCLIENTE
            LEFT JOIN tg_servicio serv on car.car_ncorr = serv.serv_ncorr
            LEFT JOIN tb_lugar lugretiro on lugretiro.lug_ncorr = ose.LUG_NCORRORIGEN
            LEFT JOIN tb_lugar puntocarguio on puntocarguio.lug_ncorr = ose.LUG_NCORR_PUNTOCARGUIO
            LEFT JOIN tb_lugar lugardestino on lugardestino.lug_ncorr = ose.LUG_NCORRDESTINO
            LEFT JOIN tg_info_container inco on inco.car_ncorr = car.car_ncorr
            LEFT JOIN tb_lugar lugardevolucion on lugardevolucion.lug_ncorr = inco.LUG_NCORR_DEVOLUCION
            LEFT JOIN tb_agenciaaduana ada on ada.ada_ncorr = inco.ada_ncorr
            LEFT JOIN tb_medidacontenedor med on med.med_ncorr = inco.med_ncorr
            LEFT JOIN tb_condicionespecial cond on cond.cond_ncorr = inco.cond_ncorr
            LEFT JOIN tb_lugar origenservicio on origenservicio.lug_ncorr = serv.LUG_NCORR_ORIGEN
            LEFT JOIN tb_lugar destinoservicio on destinoservicio.lug_ncorr = serv.LUG_NCORR_DESTINO
            LEFT JOIN tg_empresatransporte emp on emp.emp_ncorr = serv.emp_ncorr
            LEFT JOIN tg_camion cam on cam.cam_ncorr = serv.cam_ncorr
            LEFT JOIN tg_chasis cha on cha.cha_ncorr = serv.cha_ncorr
            LEFT JOIN tg_chofer chof on chof.chof_ncorr = serv.chof_ncorr
            LEFT JOIN tg_guiatransporte guia on guia.guia_ncorr = car.guia_ncorr;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_detallefactura_listar` (`idfactura` INT)  BEGIN
    select  fact.fact_ncorr,
            fact.fact_numfactura,
            fact.fact_dfecha,
            clie.clie_vnombre,
            concat(clie.clie_vrut,'-',clie.clie_vdv) rut,
            clie.clie_vdireccion,
            clie.clie_vcomuna,
            clie.clie_vgiro,
            clie.clie_vfono,
            fact.fact_vobservaciones,
            fact.fact_ndescuento,
            fact.fact_nsubtotal,
            fact.fact_niva,
            fact.fact_ntotal,
            car.car_ncorr idcarga,
            guia.guia_numero,
            guia.guia_ntipo,
            if (cont_vnumcontenedor is null,
                '-',
                CONCAT('1 X ',
                        med.med_vdescripcion, 
                        ' Cont N°:',
                        cont_vnumcontenedor,
                        if (ose.tise_ncorr <= 4,
                            concat(' ',origen.lug_vnombre,' > ', destino.lug_vnombre),
                            '-'
                        ),
                        ' ',
                        concat('(',date(serv.serv_dtermino),')')
                )
            ) detalle,
            detalle.defa_monto
    from    tg_factura fact
    inner join tg_detallefactura detalle on detalle.fact_ncorr = fact.fact_ncorr
    inner join tg_carga car on car.car_ncorr = detalle.car_ncorr
    inner join tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
    inner join tb_cliente clie on clie.clie_vrut = ose.clie_vrut
    left join  tb_lugar origen on origen.lug_ncorr = ose.lug_ncorrorigen
    left join  tb_lugar destino on destino.lug_ncorr = ose.lug_ncorrdestino
    left join  tg_guiatransporte guia on guia.guia_ncorr = car.guia_ncorr
    left join  tg_info_container cont on cont.car_ncorr = car.car_ncorr
    left join  tb_medidacontenedor med on med.med_ncorr = cont.med_ncorr
    left join  tg_servicio serv on serv.car_ncorr = car.car_ncorr
    where fact.fact_ncorr = idfactura;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_detalleguiadespacho_listar` (`numguiadespacho` INT)  BEGIN
   select  car.guia_ncorr,
             ose.ose_ncorr, car.car_ncorr, 
             CONCAT(
                IF(med.med_ncorr is null,'',CONCAT('1 x', med.med_vdescripcion)),
                IF(cont.cont_vnumcontenedor is null,'',CONCAT(' NÂ° ',cont.cont_vnumcontenedor)),
                IF(cont.cont_vsello is null,'',CONCAT(' Sello ',cont.cont_vsello)),
                IF(lug1.lug_vnombre is null,'',lug1.lug_vnombre),
                 ' - ' ,
                IF(lug2.lug_vnombre is null,'',lug2.lug_vnombre)
              ) glosa,
              if (tar.tar_nmonto is null,0,tar.tar_nmonto) precioUnitario, 
              if (tar.tar_nmonto is null,0,tar.tar_nmonto) precioTotal
    from    tg_ordenservicio ose
    left join tb_lugar lug1 on ose.lug_ncorr_puntocarguio = lug1.lug_ncorr
    left join tb_lugar lug2 on ose.lug_ncorrdestino = lug2.lug_ncorr
    inner join tg_carga car on car.ose_ncorr = ose.ose_ncorr
    left join  tg_info_container cont on cont.car_ncorr = car.car_ncorr
    left join tb_medidacontenedor med on med.med_ncorr = cont.med_ncorr
    left join tg_servicio serv on serv.car_ncorr = cont.car_ncorr
    left join tg_tarifa tar
            on ose.sts_ncorr = tar.sts_ncorr
            and tar.lug_ncorr_origen = ose.lug_ncorr_puntocarguio
            and tar.lug_ncorr_destino = ose.lug_ncorrdestino
  where car.guia_ncorr = numguiadespacho ;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_detalleordenservicio_listar` (`codorden` INT)  begin
select  `tg_carga`.`car_ncorr`, 
            `tg_carga`.`car_nbooking`, 
            `tg_carga`.`car_voperacion`,
            `tg_carga`.`car_vcontenidocarga`, 
            `tg_carga`.`car_ndiascontenedor`, 
            `tg_info_container`.`cont_vmarca` car_vmarca,
            if (`tg_carga`.`tica_ncorr` =1,tg_info_container.cont_npeso, if (`tg_info_cargalibre`.`um_ncorr`=2,tg_info_cargalibre.car_cantidad,'-')) car_npesocarga,
            if (`tg_carga`.`tica_ncorr` =1,1,if (`tg_info_cargalibre`.`um_ncorr`=1,tg_info_cargalibre.car_cantidad,1)) car_ncantidad,
            `tg_carga`.`car_vobservaciones`, 
            `tg_carga`.`tica_ncorr`,
            `tb_tipocarga`.`tica_vdescripcion`,
            `tb_tipocontenedor`.`tico_ncorr`, 
            `tb_tipocontenedor`.`tico_vdescripcion`,
            `tb_estadocarga`.`esca_ncorr`,
            `tb_estadocarga`.`esca_vdescripcion`,
            `tg_info_container`.`ada_ncorr`,
            `tg_info_container`.`cada_ncorr`,
            `tb_agenciaaduana`.`ada_vnombre`,
            `tg_info_container`.`cont_vmarca`, 
            `tg_info_container`.`cont_vnumcontenedor`,
            `tg_info_container`.`cont_vcontenido`, 
            DATE_FORMAT(`tg_info_container`.`cont_dterminostacking`,'%Y/%m/%d') cont_dterminostacking,
            `tg_info_container`.`cont_ndiaslibres`, 
            `tg_info_container`.`cont_vsello`, 
            `tg_info_container`.`lug_ncorr_devolucion`,
            `tg_info_container`.`cont_npeso`, 
            `tg_info_container`.`med_ncorr`, 
            `tg_info_container`.`cond_ncorr`, 
            `tg_info_traslado`.`lug_ncorr_destino`, 
            `tg_info_traslado`.`lug_ncorr_retiro`, 
            DATE_FORMAT(`tg_info_traslado`.`car_dfecharetiro`,'%Y/%m/%d') car_dfecharetiro,
            DATE_FORMAT(`tg_info_traslado`.`car_dfechapresentacion`,'%Y/%m/%d') car_dfechapresentacion,
            `tg_info_traslado`.`car_vcontactoentrega`,
            `tg_info_consolidacion`.`car_vcontacto` as car_vcontactocons, 
            `tg_info_consolidacion`.`car_dfecha` as car_dfechacons, 
            `tg_info_consolidacion`.`lug_ncorr_consolidacion`,
            `tg_info_adicional`.`car_ntemperatura`, 
            `tg_info_adicional`.`car_nventilacion`,
            `tg_info_adicional`.`car_votros` as car_vadic_otros,
            `tg_info_adicional`.`car_vobservaciones` as car_vadic_obs,
            `tg_carga`.`um_ncorr`, 
            `tg_carga`.`fact_ncorr`,
            `tg_info_cargalibre`.`um_ncorr` as carlibre_um,
            `tg_info_cargalibre`.`car_cantidad` as carlibre_cantidad
    from    tg_carga
            inner join tb_tipocarga 
                    on tg_carga.tica_ncorr = tb_tipocarga.tica_ncorr
            inner join tb_estadocarga
                    on tg_carga.esca_ncorr = tb_estadocarga.esca_ncorr
            left join tb_tipocontenedor
                    on tg_carga.tico_ncorr = tb_tipocontenedor.tico_ncorr
            left join tg_info_container
                    on tg_info_container.car_ncorr = tg_carga.car_ncorr
            left join tb_agenciaaduana
                    on tg_info_container.ada_ncorr = tb_agenciaaduana.ada_ncorr
            left join tg_info_traslado
                    on tg_info_traslado.car_ncorr = tg_carga.car_ncorr                
            left join tg_info_cargalibre
                    on tg_info_cargalibre.car_ncorr = tg_carga.car_ncorr
            left join tg_info_consolidacion
                    on tg_info_consolidacion.car_ncorr = tg_carga.car_ncorr                
            left join tg_info_adicional
                    on tg_info_adicional.car_ncorr = tg_carga.car_ncorr  
    where   tg_carga.ose_ncorr = codorden;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_detalleorden_ingresar` (`tncodcarga` INT, `tsnumbooking` VARCHAR(100), `tscontenidocarga` VARCHAR(200), `tndiascontenedor` INT, `tsmarcacontenedor` VARCHAR(100), `tsnumcontenedor` VARCHAR(50), `tnpesocarga` INT, `tssello` VARCHAR(50), `tsobservaciones` VARCHAR(200), `tntipocarga` INT, `tntipocontenedor` INT, `tnordenservicio` INT, `tnestadocarga` INT, `tnagenciaaduana` INT, `tncantidad` INT, `tnunidadmedida` INT, `tnidfacturaasociada` INT)  begin
    declare lnidcarga int;
    declare lnversioncarga int;
    if tncodcarga = 0 then
        insert into `tg_carga`
        (
            `car_nbooking`,`car_vcontenidocarga`,
            `car_ndiascontenedor`,`car_vmarca`,`car_vnumcontenedor`,
            `car_npesocarga`,`car_vsello`,`car_vobservaciones`,
            `tica_ncorr`,`tico_ncorr`,`ose_ncorr`,
            `esca_ncorr`,`ada_ncorr`,`car_ncantidad`, `um_ncorr`, `fact_ncorr`
        )
        values
        (
            tsnumbooking,tscontenidocarga,
            tndiascontenedor, tsmarcacontenedor, tsnumcontenedor,
            tnpesocarga, tssello, tsobservaciones,
            tntipocarga, tntipocontenedor, tnordenservicio,
            tnestadocarga, tnagenciaaduana, tncantidad,
            tnunidadmedida,tnidfacturaasociada
        );
		set lnidcarga= last_insert_id();
    else
        update `tg_carga`
        set
        `car_nbooking` = tsnumbooking,
        `car_vcontenidocarga` = tscontenidocarga,
        `car_ndiascontenedor` = tndiascontenedor,
        `car_vmarca` = tsmarcacontenedor,
        `car_vnumcontenedor` = tsnumcontenedor,
        `car_npesocarga` = tnpesocarga,
        `car_vsello` = tssello,
        `car_vobservaciones` = tsobservaciones,
        `tica_ncorr` = tntipocarga,
        `tico_ncorr` = tntipocontenedor,
        `ose_ncorr` = tnordenservicio,
        `esca_ncorr` = tnestadocarga,
        `ada_ncorr` = tnagenciaaduana,
        `car_ncantidad` = tncantidad,             
        `um_ncorr` = tnunidadmedida, 
        `fact_ncorr`=tnidfacturaasociada
        where car_ncorr = tncodcarga;
		set lnidcarga= tncodcarga;
    end if;
    insert into tg_versioncarga
    (
        car_ncorr,car_nbooking,car_vcontenidocarga,
        car_ndiascontenedor,car_vmarca,car_vnumcontenedor,
        car_npesocarga,car_vsello,car_vobservaciones,
        tica_ncorr,tico_ncorr,ose_ncorr,
        esca_ncorr,ada_ncorr
    )
    values
    (
        lnidcarga,tsnumbooking,tscontenidocarga,
        tndiascontenedor, tsmarcacontenedor, tsnumcontenedor,
        tnpesocarga, tssello, tsobservaciones,
        tntipocarga, tntipocontenedor, tnordenservicio,
        tnestadocarga, tnagenciaaduana
    );     
    select lnidcarga car_ncorr
    from dual;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_detalleorden_ingresar2` (IN `tnCodCarga` INT, IN `tnCodOrdenServicio` INT, IN `tnEstadoCarga` INT, IN `tnTipoCarga` INT, IN `tsNumBooking` VARCHAR(100), IN `tsNumOperacion` VARCHAR(100), IN `tsObservaciones` VARCHAR(200), OUT `lnIdCarga` INT, OUT `OutStatus` VARCHAR(200))  BEGIN
    DECLARE lnExisteCarga INT;
    DECLARE lnIdCarga INT;
    DECLARE lnVersionCarga INT;   
    DECLARE lnCodorigen INT;
	select	max(lug_ncorrorigen)
	into	lnCodorigen
	from	tg_ordenservicio ose
	where	ose.ose_ncorr = tnCodOrdenServicio;
    IF tnCodCarga = 0 THEN
        INSERT INTO tg_carga (ose_ncorr, 
                              esca_ncorr, 
                              tica_ncorr, 
                              car_nbooking,
                              car_vobservaciones,
                              car_voperacion,
                              fact_ncorr,
                              lug_ncorr_actual)
        VALUES( tnCodOrdenServicio,
                tnEstadoCarga,
                tnTipoCarga,
                tsNumBooking,
                tsObservaciones,
                tsNumOperacion,
                null,
                lnCodorigen);    
        SELECT last_insert_id()
        INTO   lnIdCarga;
        select  lnIdCarga car_ncorr;
    ELSE
        UPDATE tg_carga
        SET    tica_ncorr = tnTipoCarga,
               car_nbooking = tsNumBooking,
               car_vobservaciones = tsObservaciones,
               car_voperacion = tsNumOperacion,
               lug_ncorr_actual = lnCodorigen
        WHERE car_ncorr = tnCodCarga;    
       select  tnCodCarga car_ncorr;
    END IF;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_diaslibre_obtener` (`rutcliente` VARCHAR(20), `agencia` INT)  BEGIN
    select  clie_ndiaslibres
    from    tb_cliente
    where   clie_vrut = rutcliente;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_encabezadoguiadespacho_obtener` (`numguiadespacho` INT)  BEGIN
	declare guia_ncorr 	int;
	declare fecha		date;
	declare clievnombre	varchar(100);
	declare clievrut	varchar(100);
	declare direccion	varchar(100);
	declare comuna		varchar(100);
	declare giro		varchar(100);
	declare telefono	varchar(100);
  declare tipoguia 	int;
  declare guianumero varchar(6);
    SELECT  distinct
            guia.guia_ncorr,
            guia.guia_dfecha fecha,
            clie.clie_vnombre clievnombre,
            if (clie.clie_vdv is null,clie.clie_vrut,
            CONCAT(clie.clie_vrut,'-',clie.clie_vdv)) clievrut,
            clie_vdireccion direccion,
            if(clie.clie_vcomuna is null,'-',clie.clie_vcomuna) comuna,
            if(clie.clie_vgiro is null,'-',clie.clie_vgiro) giro,
            if(clie.clie_vfono is null,'-',clie.clie_vfono) telefono,
            guia.guia_ntipo,
            lpad(guia.guia_numero,6,'0') guia_numero
	into 	guia_ncorr,
			fecha,
			clievnombre,
			clievrut,
			direccion,
			comuna,
			giro,
			telefono,
      tipoguia,
      guianumero
    FROM    tg_guiatransporte guia
    INNER JOIN tg_carga car on car.guia_ncorr = guia.guia_ncorr
    INNER JOIN tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
    INNER JOIN tb_cliente clie on clie.clie_vrut = ose.clie_vrut
    WHERE   guia.guia_ncorr = numguiadespacho;
    select  
    fecha,
    clievnombre,
    clievrut,
    direccion,
    comuna,
    giro,
    telefono,
    tipoguia,
    guianumero,
    ose.ose_ncorr, car.car_ncorr, 
    CONCAT( IF(med.med_ncorr is null,'',CONCAT('1 x', med.med_vdescripcion)),
                   IF(cont.cont_vnumcontenedor is null,'',CONCAT(' NÂ° ',cont.cont_vnumcontenedor)),
                   IF(cont.cont_vsello is null,'',CONCAT(' Sello ',cont.cont_vsello)),
                   IF(lug1.lug_vnombre is null,'',lug1.lug_vnombre),
                  ' - ' ,
                  IF(lug2.lug_vnombre is null,'',lug2.lug_vnombre)
) glosa,
              if (tar.tar_nmonto is null,0,tar.tar_nmonto) preciounitario, 
              if (tar.tar_nmonto is null,0,tar.tar_nmonto) preciototal
    from    tg_ordenservicio ose
    left join tb_lugar lug1 on ose.lug_ncorr_puntocarguio = lug1.lug_ncorr
    left join tb_lugar lug2 on ose.lug_ncorrdestino = lug2.lug_ncorr
    inner join tg_carga car on car.ose_ncorr = ose.ose_ncorr
    left join  tg_info_container cont on cont.car_ncorr = car.car_ncorr
    left join tb_medidacontenedor med on med.med_ncorr = cont.med_ncorr
    left join tg_servicio serv on serv.car_ncorr = cont.car_ncorr
    left join tg_tarifa tar
            on ose.sts_ncorr = tar.sts_ncorr
            and tar.lug_ncorr_origen = ose.lug_ncorr_puntocarguio
            and tar.lug_ncorr_destino = ose.lug_ncorrdestino
  where car.guia_ncorr = numguiadespacho ;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_estadocarga_listar` ()  BEGIN
    SELECT
    `tb_estadocarga`.`esca_ncorr` id,
     null idparent, 
    `tb_estadocarga`.`esca_vdescripcion` description
    FROM `tb_estadocarga`
    ORDER BY `tb_estadocarga`.esca_vdescripcion ASC ;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_estadofactura_cambiar` (`idfactura` DOUBLE, `codestado` INT)  BEGIN
    UPDATE  tg_factura fact
    SET     fact.esfa_ncorr = codestado
    WHERE   fact.fact_ncorr = idfactura;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_exportacioncarga` (`inicio` DATETIME, `termino` DATETIME)  BEGIN
    SELECT  car.ose_ncorr IdOrdenServicio,
            clie.clie_vnombre Cliente,
            subcliente.clie_vnombre SubCliente,
            ose.ose_vnombrenave Nave,
            ose.ose_dfechaservicio FechaServicio,
            tise.tise_vdescripcion TipoServicio,
            sts.STS_VNOMBRE SubTipoServicio,
            lugretiro.LUG_VNOMBRE Lugarretiro,
            puntocarguio.LUG_VNOMBRE Puntocarguio,
            lugardestino.LUG_VNOMBRE LugarDestino,
            car.car_ncorr IdCarga,
            tica.tica_vdescripcion TipoCarga,
            UPPER(esca.ESCA_VDESCRIPCION) EstadoCarga,
            car.car_nbooking NumBooking,
            car.car_voperacion NumOperacion,
            car.car_vobservaciones,
            inco.CONT_VMARCA MarcaContenedor,
            inco.CONT_VNUMCONTENEDOR NumContenedor,
            inco.CONT_VCONTENIDO Contenido,
            inco.CONT_DTERMINOSTACKING TerminoStacking,
            lugardevolucion.LUG_VNOMBRE LugarDevolucion,
            inco.CONT_NDIASLIBRES DiasLibres,
            inco.CONT_VSELLO Sello,
            ada.ada_vnombre AgenciaAduana,
            inco.CONT_NPESO PesoContenedor,
            med.med_vdescripcion Medida,
            cond.cond_vdescripcion CondicionEspecial,
            serv.serv_dinicio InicioServicio,
            serv.serv_dtermino Terminoservicio,
            origenservicio.LUG_VNOMBRE OrigenServicio,
            destinoservicio.LUG_VNOMBRE DestinoServicio,
            emp.emp_vnombre Empresa,
            cam.cam_vpatente Camion,
            cha.cha_vpatente chasis,
            chof.chof_vnombre Chofer,
            guia.guia_numero NumGuia,        
            if(guia.guia_ntipo=1,'SII',if(guia.guia_ntipo=2,'Virtual','-')) Tipoguia
    FROM    tg_carga car
            INNER JOIN tb_tipocarga tica on car.tica_ncorr = tica.tica_ncorr
            INNER JOIN tb_estadocarga esca on car.esca_ncorr = esca.esca_ncorr
            INNER JOIN tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
            INNER JOIN tb_cliente clie on clie.clie_vrut = ose.clie_vrut
            INNER JOIN tb_tiposervicio tise on tise.tise_ncorr = ose.tise_ncorr
            LEFT JOIN tb_subtiposervicio sts on sts.sts_ncorr = ose.sts_ncorr
            LEFT JOIN tb_cliente subcliente on subcliente.clie_vrut = ose.CLIE_VRUTSUBCLIENTE
            LEFT JOIN tg_servicio serv on car.car_ncorr = serv.serv_ncorr
            LEFT JOIN tb_lugar lugretiro on lugretiro.lug_ncorr = ose.LUG_NCORRORIGEN
            LEFT JOIN tb_lugar puntocarguio on puntocarguio.lug_ncorr = ose.LUG_NCORR_PUNTOCARGUIO
            LEFT JOIN tb_lugar lugardestino on lugardestino.lug_ncorr = ose.LUG_NCORRDESTINO
            LEFT JOIN tg_info_container inco on inco.car_ncorr = car.car_ncorr
            LEFT JOIN tb_lugar lugardevolucion on lugardevolucion.lug_ncorr = inco.LUG_NCORR_DEVOLUCION
            LEFT JOIN tb_agenciaaduana ada on ada.ada_ncorr = inco.ada_ncorr
            LEFT JOIN tb_medidacontenedor med on med.med_ncorr = inco.med_ncorr
            LEFT JOIN tb_condicionespecial cond on cond.cond_ncorr = inco.cond_ncorr
            LEFT JOIN tb_lugar origenservicio on origenservicio.lug_ncorr = serv.LUG_NCORR_ORIGEN
            LEFT JOIN tb_lugar destinoservicio on destinoservicio.lug_ncorr = serv.LUG_NCORR_DESTINO
            LEFT JOIN tg_empresatransporte emp on emp.emp_ncorr = serv.emp_ncorr
            LEFT JOIN tg_camion cam on cam.cam_ncorr = serv.cam_ncorr
            LEFT JOIN tg_chasis cha on cha.cha_ncorr = serv.cha_ncorr
            LEFT JOIN tg_chofer chof on chof.chof_ncorr = serv.chof_ncorr
            LEFT JOIN tg_guiatransporte guia on guia.guia_ncorr = car.guia_ncorr;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_facturas_listar` (`factura` DOUBLE, `ordenservicio` DOUBLE, `rutcliente` VARCHAR(20))  BEGIN
    SELECT DISTINCT  fact.fact_ncorr, 
            fact.fact_numfactura numfactura,
            clie.clie_vnombre cliente,
            fact.fact_dfecha fecha,
            fact.fact_ntotal total,
            esfa.ESFA_VDESCRIPCION estado
    FROM    tg_factura fact
            INNER JOIN tg_detallefactura detalle on detalle.fact_ncorr = fact.fact_ncorr
            INNER JOIN tg_carga car on car.car_ncorr = detalle.car_ncorr
            INNER JOIN tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
            INNER JOIN tb_cliente clie on clie.clie_vrut = ose.clie_vrut
            INNER JOIN tb_estado_factura esfa on esfa.esfa_ncorr = fact.esfa_ncorr    
    WHERE   fact.fact_numfactura = if(factura=0,fact.fact_numfactura,factura) AND
            ose.ose_ncorr = if(ordenservicio=0,ose.ose_ncorr,ordenservicio) AND
            ose.clie_vrut = if(rutcliente=0,ose.clie_vrut,rutcliente);
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_factura_crear` (`cargasasociar` VARCHAR(200), `numfactura` DOUBLE, `observaciones` VARCHAR(200), `descuento` DOUBLE)  BEGIN
    declare idfactura double;
    declare subtotal double;
    declare iva double;
    declare total double;
    SELECT  if(MAX(fact.fact_ncorr) is null,1,MAX(fact.fact_ncorr)+1)
    INTO    idfactura
    FROM    tg_factura fact;
    INSERT INTO tg_factura (FACT_NCORR, FACT_DFECHA, FACT_NUMFACTURA, ESFA_NCORR, FACT_NDESCUENTO, FACT_VOBSERVACIONES)
    VALUES(idfactura,CURDATE(),numfactura,1,descuento,observaciones);
    SET @s = CONCAT('INSERT INTO tg_detallefactura(car_ncorr,defa_monto,fact_ncorr)
                     SELECT  car.car_ncorr,
                             tarifa.tasi_nmonto,',idfactura,' ',
                    'FROM    tg_carga car
                    INNER JOIN tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
                    INNER JOIN tb_tiposervicio tise on tise.tise_ncorr = ose.tise_ncorr
                    LEFT JOIN tg_info_container cont on cont.car_ncorr = car.car_ncorr
                    LEFT JOIN tg_tarifaservicio tarifa 
                                on ose.LUG_NCORR_PUNTOCARGUIO = tarifa.lug_ncorr_origen
                                and ose.LUG_NCORRDESTINO = tarifa.lug_ncorr_destino
                                and ose.sts_ncorr = tarifa.sts_ncorr
                                and ose.clie_vrut = tarifa.clie_vrut                            
                    WHERE   car.car_ncorr IN (', cargasasociar,')');
    PREPARE stmt FROM @s;
    EXECUTE stmt;     
    UPDATE tg_carga
    SET     fact_ncorr = idfactura
    WHERE   car_ncorr in (SELECT    car_ncorr 
                          FROM      tg_detallefactura 
                          WHERE     fact_ncorr = idfactura);
    SELECT  SUM(defa_monto)
    INTO    subtotal
    FROM    tg_detallefactura detalle
    WHERE   detalle.fact_ncorr = idfactura;
    set iva = subtotal * 0.19;
    set total = subtotal + iva - descuento;
    update  tg_factura fact
    set     fact_nsubtotal = subtotal,
            fact_niva = iva,
            fact_ntotal = total
    where   fact.fact_ncorr = idfactura;    
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_guiatransporte_crear` (IN `cargasasociar` VARCHAR(500), IN `numguia` DOUBLE, IN `codempresa` INT, IN `fecha` DATE)  BEGIN
    declare lsSql varchar(500);
    declare existencia int;
    declare numguiacreada double;
    declare validacioningreso double;
    declare tipoguia int;
    if numguia > 0 then
        /*-------GuÃ­a SII------*/
        set tipoguia = 1;
    else
        /*-------GuÃ­a virtual------*/
        set tipoguia = 2;
        select ifnull(max(guia_numero)+1,1)
        into   numguia
        from   tg_guiatransporte
        where  guia_ntipo = 2;
    end if;
    SET @s = CONCAT('UPDATE tg_servicio SET GUIA_NCORR = -1 WHERE guia_ncorr = 0 and serv_ncorr in (', cargasasociar,')');
    PREPARE stmt FROM @s;
    EXECUTE stmt;        
	insert into tg_guiatransporte(guia_dfecha,guia_numero, guia_ntipo, emp_ncorr) 
	values (fecha,numguia,tipoguia,codempresa);
	select  last_insert_id() 
	into    numguiacreada
	from dual;
	UPDATE 	tg_servicio
	SET     GUIA_NCORR = numguiacreada
	WHERE   GUIA_NCORR = -1;  
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_hitoingresado_editar` (IN `codservicio` INT, IN `numhito` INT, IN `hora` DATETIME)  BEGIN
	/*Atributos*/
    declare lnexiste 			int;
    declare lnregistro 			int;
    declare ldservinicio 		datetime;
    declare ldhoraplan 			datetime;
    declare lnTiempoViaje 		int;
    declare lnIdcarga 			int;
    declare lnHitoFinal 		int;
    declare lnCodDestinoOrden 	int;
    declare lnCodDestinoTramo 	int;
    declare lnCodServicio2		int;
    declare lnTipoCarga			int;
	/*Verifica si el hito ya fue controlado previamente*/
    select count(*)
    into   lnexiste
    from   tg_hitocontrolado hico
    where  hico.serv_ncorr = codservicio
           and hico.hito_ncorr = numhito;
    /*Obtiene el codigo de destino de la orden de servicio*/
	select 	max(ose.lug_ncorrdestino)
	into	lnCodDestinoOrden
	from	tg_ordenservicio ose
	inner join tg_carga car on ose.ose_ncorr = car.ose_ncorr
	inner join tg_servicio serv on serv.car_ncorr = car.car_ncorr
	where	serv.serv_ncorr = codservicio;    
	/*Valida el ingreso de hora*/
    if hora = '' then
        if lnexiste > 0 then
            delete from tg_hitocontrolado
            where  serv_ncorr = codservicio
                   and hito_ncorr = numhito;
        end if;
    else
        if time(hora) is null then
            select 0,'La hora ingresada no es valida';
        else            
			/*Obtiene la hora de inicio del servicio*/
            select  serv_dinicio
            into    ldservinicio
            from    tg_servicio
            where   serv_ncorr = codservicio;
			/*Obtiene el tiempo de viaje*/
            select  hito_tiempoviaje
            into    lnTiempoViaje
            from    tg_hito
            where   hito_ncorr = numhito;  
            if lnexiste > 0 then
				/*update  tg_hitocontrolado hico
                set     hico.hico_horareal = time(hora),
                        hico.hico_horaplan = ADDTIME(time(ldservinicio),sec_to_time(lnTiempoViaje*60))
                where  serv_ncorr = codservicio
                       and hito_ncorr = numhito; */
                update  tg_hitocontrolado hico
                set     hico.hico_horareal = hora,
						hico.hico_horaplan = ADDDATE(ldservinicio, INTERVAL lnTiempoViaje MINUTE)
                where  serv_ncorr = codservicio
                       and hito_ncorr = numhito;	
else
				/*Obtiene el id de hito controlado*/
                select  if(max(hico_ncorr) is null,1,max(hico_ncorr)+1)
                into    lnregistro
                from    tg_hitocontrolado;
                /*Actualiza los datos de hito controlado*/
				/*
                insert into tg_hitocontrolado(HICO_NCORR,SERV_NCORR, HITO_NCORR, HICO_HORAREAL, HICO_HORAPLAN)
                values(lnregistro, codservicio,numhito,time(hora),
                ADDTIME(time(ldservinicio),sec_to_time(lnTiempoViaje*60)));
				*/
                insert into tg_hitocontrolado(HICO_NCORR,SERV_NCORR, HITO_NCORR, HICO_HORAREAL, HICO_HORAPLAN)
                values(lnregistro, codservicio,numhito,hora, ADDDATE(ldservinicio, INTERVAL lnTiempoViaje MINUTE));	
				/*Obtiene el id de la carga asociada al servicio*/
                select  max(serv.car_ncorr)
                into    lnIdcarga
                from    tg_hitocontrolado hico
                inner join tg_servicio serv on hico.serv_ncorr = serv.serv_ncorr
                where   serv.serv_ncorr = codservicio;
				/*Verifica si el hito es termino de viaje*/
				select  hito_final
				into    lnHitoFinal
				from    tg_hito
				where   hito_ncorr = numhito;  				
                if lnHitoFinal > 0 then
					select 	max(tra.lug_ncorr_destino)
					into	lnCodDestinoTramo
					from   	tg_hito hito
							inner join tg_tramo tra on hito.tra_ncorr = tra.tra_ncorr
					where  	hito.hito_ncorr = numhito;                
					insert into tg_log (log_vdescripcion) values ("paso 1");
					if lnCodDestinoTramo = lnCodDestinoOrden then
						/* Carga en estado "Entregada" */
						select	tica_ncorr
						into	lnTipoCarga
						from	tg_carga
						where	car_ncorr = lnIdCarga;   
						if lnTipoCarga > 1 then
                        	/* Si es carga libre, la carga queda como finalizada */
							update  tg_carga
							set     esca_ncorr = 6, lug_ncorr_actual = lnCodDestinoTramo
							where   car_ncorr = lnIdcarga;    								
						else						
                        	/* Si es contenedor, la carga queda como entregada */
							update  tg_carga
							set     esca_ncorr = 5, lug_ncorr_actual = lnCodDestinoTramo
							where   car_ncorr = lnIdcarga;    		
						end if;
					else
						/* Carga en "Almacen intermedio" */
						update  tg_carga
						set     esca_ncorr = 4, lug_ncorr_actual = lnCodDestinoTramo
						where   car_ncorr = lnIdcarga;       
						insert into tg_log (log_vdescripcion) values ("paso 3");             					
					end if;				
					insert into tg_log (log_vdescripcion) values ("paso 4");					
					update	tg_servicio
					set		esca_nterminado = 1
					where	car_ncorr = lnIdcarga;	
					insert into tg_log (log_vdescripcion) values ("paso 5");
                else
					/*Si no es hito final, deja la carga en estado "En traslado"*/
					update  tg_carga
					set     esca_ncorr = 3, lug_ncorr_actual = 0
					where   car_ncorr = lnIdcarga;                                         
                end if;
            end if;
            select 1,'-';
        end if;        
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_hitosingresados_listar` (IN `codservicio` INT)  BEGIN
    SELECT  tise.tise_vdescripcion tiposervicio,
            CONCAT(lugarorigen.lug_vnombre,' -> ',lugardestino.lug_vnombre) tramo,
            car.car_ncorr,
            cam.cam_vpatente patentecamion,
            if(chof.chof_vnombre is null,'-',chof.chof_vnombre) nombrechofer,
            hito.hito_ncorr numhito,
            hito.hito_vnombre nombrehito,
            hito.hito_km km,
            date_format(ADDDATE(serv.serv_dinicio, INTERVAL hito.hito_tiempoviaje MINUTE), '%d/%m/%Y %H:%i') horaprogramada,
            date_format(hico.hico_horareal, '%d/%m/%Y %H:%i') horareal
    FROM    tg_hito hito
    INNER JOIN tg_tramo tra on tra.tra_ncorr = hito.tra_ncorr
    INNER JOIN tg_servicio serv 
                on serv.LUG_NCORR_ORIGEN = tra.LUG_NCORR_ORIGEN 
                and serv.LUG_NCORR_DESTINO = tra.LUG_NCORR_DESTINO
    INNER JOIN  tg_carga car
                on car.car_ncorr = serv.car_ncorr
    INNER JOIN tg_ordenservicio ose 
                on ose.ose_ncorr = car.ose_ncorr    
    INNER JOIN  tb_tiposervicio tise
                on tise.tise_ncorr = ose.tise_ncorr       
    INNER JOIN  tb_lugar lugarorigen
                on lugarorigen.lug_ncorr = serv.LUG_NCORR_ORIGEN
    INNER JOIN  tb_lugar lugardestino
                on lugardestino.lug_ncorr = serv.LUG_NCORR_DESTINO     
    LEFT JOIN  tg_camion cam
                on cam.cam_ncorr = serv.cam_ncorr
    LEFT JOIN  tg_chofer chof
                on chof.chof_ncorr = serv.chof_ncorr
    LEFT JOIN tg_hitocontrolado hico
                on hico.serv_ncorr = serv.serv_ncorr
                and hico.hito_ncorr = hito.hito_ncorr
    WHERE serv.serv_ncorr = codservicio
    order by hito.hito_km;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_hito_editar` (`idHito` INT, `idtramo` INT, `nombrehito` VARCHAR(50), `km` INT, `minutos` INT)  BEGIN
    /*ValidaciÃ³n de datos-------------------------*/
    declare textovalidacion varchar(500);
    declare numhito int;
    set textovalidacion = '';
    if nombrehito='' then
        set textovalidacion = 'El hito debe poseer un nombre';
    end if;
    if km = 0 then
        set textovalidacion = CONCAT(textovalidacion,',','Debe ingresar un kilometraje');
    end if;
    if minutos = 0 then
        set textovalidacion = CONCAT(textovalidacion,',','Debe ingresar los minutos del tramo');
    end if;
    if textovalidacion = '' then
        if idHito > 0 then
            update  tg_hito
            set     hito_vnombre = nombrehito,
                    hito_km = km,
                    hito_tiempoviaje = minutos
            where   hito_ncorr = idHito;
        else
            select  count(*)
            into    numhito
            from    tg_hito
            where   tra_ncorr = idtramo and upper(hito_vnombre) = nombrehito;        
            if numhito > 0 then
                select 0,'El hito ya existe';
            else
                SELECT  COUNT(*)
                INTO    numhito
                FROM    tg_hito
                WHERE   tra_ncorr = idtramo;            
                UPDATE  tg_hito
                SET     hito_final = 0
                WHERE   tra_ncorr = idtramo; 
                INSERT INTO tg_hito (HITO_NCORR, TRA_NCORR, HITO_VNOMBRE, HITO_KM, HITO_TIEMPOVIAJE, HITO_FINAL)
                VALUES (numhito +1, idtramo,nombrehito,km,minutos,1);
                if numhito = 0 then
                    UPDATE  tg_hito set HITO_INICIAL = 1 WHERE tra_ncorr = idtramo;
                end if;
                select 1,'';
            end if;            
        end if;        
    else
        select 0, concat('Se han encontrado los siguientes errores:\n',textovalidacion);
    end if;    
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_hito_eliminar` (`numhito` INT)  BEGIN
    declare lnStatus int;    
    DECLARE CONTINUE HANDLER FOR 1451 set lnStatus = 1451;    
    delete from tg_hito where  hito_ncorr = numhito;
    if lnStatus = 1451 then
        select 0,'El hito no pudo ser eliminado porque posee registros asociados';
    else
        select 1,'-';
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_infoadicional_ingresar` (`tnidcarga` INT, `tntemperatura` INT, `tnventilacion` INT, `tsotros` VARCHAR(200), `tsobservaciones` VARCHAR(200))  begin
    declare lnexisteregistro int;
    declare lnidordencrear int;
    select  count(*)
    into    lnexisteregistro
    from   `tg_info_adicional`
    where   car_ncorr = tnidcarga;  
    if lnexisteregistro = 0 then
        insert into `tg_info_adicional`
        (`car_ncorr`,
        `car_ntemperatura`,
        `car_nventilacion`,
        `car_votros`, 
        `car_vobservaciones`)
        values
        (
        tnidcarga,
        tntemperatura,
        tnventilacion,
        tsotros,
        tsobservaciones
        );    
    else
        update `tg_info_adicional`
        set
        `car_ntemperatura` = tntemperatura,
        `car_nventilacion` = tnventilacion,
        `car_votros` = tsotros, 
        `car_vobservaciones` = tsobservaciones
        where car_ncorr = tnidcarga;    
    end if;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_infoadicional_listar` (`tnidcarga` INT)  BEGIN
        select 
        `car_ncorr`,
        `car_ntemperatura`,
        `car_nventilacion`
        from `tg_info_adicional`
        where car_ncorr=tnidcarga;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_infoconsolidacion_ingresar` (`tnidcarga` INT, `tscontactoconsolidacion` VARCHAR(200), `tdfechaconsolidacion` DATETIME, `tnlugarconsolidacion` INT)  begin
    declare lnexisteregistro int;
    declare lnidordencrear int;
    select  count(*)
    into    lnexisteregistro
    from 	`tg_info_consolidacion`
    where   car_ncorr = tnidcarga ;
    if lnexisteregistro = 0 then
        insert into `tg_info_consolidacion`
        (`car_ncorr`,
        `car_vcontacto`,
        `car_dfecha`,
        `lug_ncorr_consolidacion`)
        values
        (
        tnidcarga,
        tscontactoconsolidacion,
        tdfechaconsolidacion,
        tnlugarconsolidacion
        );
    else
        update `tg_info_consolidacion`
        set
        `car_vcontacto` = tscontactoconsolidacion,
        `car_dfecha` = tdfechaconsolidacion,
        `lug_ncorr_consolidacion` = tnlugarconsolidacion
        where car_ncorr = tnidcarga;
    end if;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_infoconsolidacion_listar` (`tnidcarga` INT)  BEGIN
        select 
            `car_ncorr`,
            `car_vcontacto`,
            `car_dfecha`,
            `lug_ncorr_consolidacion`
        from `tg_info_consolidacion`
        where car_ncorr=tnidcarga;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_infocontenedor_ingresar` (`tnidcarga` INT, `tncodtipocontenedor` INT, `tsmarcacontenedor` VARCHAR(100), `tsnumcontenedor` VARCHAR(100), `tscontenidocontenedor` VARCHAR(100), `tdterminostacking` DATETIME, `tncodlugardevolucion` INT, `tndiaslibres` INT, `tssellocontenedor` VARCHAR(30), `tssellocontenedor2` VARCHAR(30), `tsobservacionessello` VARCHAR(200), `tsobservacionessello2` VARCHAR(200))  begin
    declare lnexisteregistro int;
    declare lnidordencrear int;
    select  count(*)
    into    lnexisteregistro
    from   `tg_info_container`
    where   car_ncorr = tnidcarga;
    if lnexisteregistro = 0 then
        insert into `tg_info_container`
            (`car_ncorr`,
            `cont_vmarca`,
            `cont_vnumcontenedor`,
            `cont_vcontenido`,
            `cont_dterminostacking`,
            `cont_ndiaslibres`,
            `cont_vsello`,
            `lug_ncorr_devolucion`,
            `cont_vsello2`, 
            `cont_vobservacionsello`, 
            `cont_vobservacionsello2`)
        values
        (
            tnidcarga,
            tsmarcacontenedor,
            tsnumcontenedor,
            tscontenidocontenedor,
            tdterminostacking,
            tndiaslibres,
            tssellocontenedor,
            tncodlugardevolucion,
            tssellocontenedor2,
            tsobservacionessello,
            tsobservacionessello2
        );
    else
        update `tg_info_container`
        set
        `cont_vmarca` = tsmarcacontenedor,
        `cont_vnumcontenedor` = tsnumcontenedor,
        `cont_vcontenido` = tscontenidocontenedor,
        `cont_dterminostacking` = tdterminostacking,
        `cont_ndiaslibres` = tndiaslibres,
        `cont_vsello` = tssellocontenedor,
        `lug_ncorr_devolucion` = tncodlugardevolucion,
        `cont_vsello2` = tssellocontenedor2, 
        `cont_vobservacionsello` = tsobservacionessello,
        `cont_vobservacionsello2` = tsobservacionessello2
        where car_ncorr = tnidcarga;
    end if;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_infocontenedor_ingresar2` (`tnidcarga` INT, `tsmarcacontenedor` VARCHAR(100), `tsnumcontenedor` VARCHAR(100), `tscontenidocontenedor` VARCHAR(100), `tdterminostacking` DATETIME, `tncodlugardevolucion` INT, `tndiaslibres` INT, `tssellocontenedor` VARCHAR(30), `tnAgenciaAduana` INT, `tnContactoAgencia` INT, `tnPesoCarga` INT, `tnMedidaContenedor` INT, `tnCondicionEspecial` INT)  begin
    declare lnexisteregistro int;
    declare lnidordencrear int;
    select  count(*)
    into    lnexisteregistro
    from   `tg_info_container`
    where   car_ncorr = tnidcarga;
    if lnexisteregistro = 0 then
        insert into `tg_info_container`
            (`car_ncorr`,
            `cont_vmarca`,
            `cont_vnumcontenedor`,
            `cont_vcontenido`,
            `cont_dterminostacking`,
            `cont_ndiaslibres`,
            `cont_vsello`,
            `lug_ncorr_devolucion`,
            `ada_ncorr`,
            `cont_npeso`,
            `cond_ncorr`,
            `med_ncorr`,
             cada_ncorr)
        values
        (
            tnidcarga,
            tsmarcacontenedor,
            tsnumcontenedor,
            tscontenidocontenedor,
            tdterminostacking,
            tndiaslibres,
            tssellocontenedor,
            tncodlugardevolucion,
            tnAgenciaAduana ,
            tnPesoCarga,
            tnCondicionEspecial,
            tnMedidaContenedor,
           tnContactoAgencia
        );
    else
        update `tg_info_container`
        set
        `cont_vmarca` = tsmarcacontenedor,
        `cont_vnumcontenedor` = tsnumcontenedor,
        `cont_vcontenido` = tscontenidocontenedor,
        `cont_dterminostacking` = tdterminostacking,
        `cont_ndiaslibres` = tndiaslibres,
        `cont_vsello` = tssellocontenedor,
        `lug_ncorr_devolucion` = tncodlugardevolucion,
        `med_ncorr` = tnMedidaContenedor,
        `cond_ncorr` = tnCondicionEspecial,
        cada_ncorr=tnContactoAgencia
        where car_ncorr = tnidcarga;
    end if;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_infocontenedor_listar` (`tnidcarga` INT)  BEGIN
        select 
            `car_ncorr`,
            `cont_vmarca`,
            `cont_vnumcontenedor`,
            `cont_vcontenido`,
            `cont_dterminostacking`,
            `cont_ndiaslibres`,
            `cont_vsello`,
            `lug_ncorr_devolucion`
        from `tg_info_container`
        where car_ncorr=tnidcarga;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_inforequerimiento_ingresar` (`tnidcarga` INT, `tscontactoconsolidacion` VARCHAR(200), `tdfechaconsolidacion` DATETIME, `tnlugarconsolidacion` INT)  begin
    declare lnexisteregistro int;
    declare lnidordencrear int;
    select  count(*)
    into    lnexisteregistro
    from 	`tg_info_consolidacion`
    where   car_ncorr = tnidcarga ;
    if lnexisteregistro = 0 then
        insert into `tg_info_consolidacion`
        (`car_ncorr`,
        `car_vcontacto`,
        `car_dfecha`,
        `lug_ncorr_consolidacion`)
        values
        (
        tnidcarga,
        tscontactoconsolidacion,
        tdfechaconsolidacion,
        tnlugarconsolidacion
        );
    else
        update `tg_info_consolidacion`
        set
        `car_vcontacto` = tscontactoconsolidacion,
        `car_dfecha` = tdfechaconsolidacion,
        `lug_ncorr_consolidacion` = tnlugarconsolidacion
        where car_ncorr = tnidcarga;
    end if;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_infotraslado_ingresar` (`tlnidcarga` INT, `tnlugardestino` INT, `tnlugarretiro` INT, `tdfecharetiro` DATETIME, `tdfechapresentacion` DATETIME, `tscontactoentrega` VARCHAR(200))  begin
    declare lnexisteregistro int;
    select  count(*)
    into    lnexisteregistro
    from 	`tg_info_traslado`
    where   car_ncorr = tlnidcarga;
    if lnexisteregistro = 0 then
        insert into `tg_info_traslado`
        (`car_ncorr`,
        `lug_ncorr_destino`,
        `lug_ncorr_retiro`,
        `car_dfecharetiro`,
        `car_dfechapresentacion`,
        `car_vcontactoentrega`)
        values
        (
        tlnidcarga,
        tnlugarretiro,
        tnlugardestino,
        tdfecharetiro,
        tdfechapresentacion,
        tscontactoentrega
        );
    else
        update `tg_info_traslado`
        set
        `lug_ncorr_destino` =tnlugarretiro ,
        `lug_ncorr_retiro` = tnlugardestino,
        `car_dfecharetiro` = tdfecharetiro,
        `car_dfechapresentacion` = tdfechapresentacion,
        `car_vcontactoentrega` = tscontactoentrega
        where car_ncorr = tlnidcarga;    
    end if;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_infotraslado_ingresar2` (`tlnidcarga` INT, `tdfecharetiro` DATETIME, `tdfechapresentacion` DATETIME, `tscontactoentrega` VARCHAR(200))  begin
    declare lnexisteregistro int;
    select  count(*)
    into    lnexisteregistro
    from 	`tg_info_traslado`
    where   car_ncorr = tlnidcarga;
    if lnexisteregistro = 0 then
        insert into `tg_info_traslado`
        (`car_ncorr`,
        `car_dfecharetiro`,
        `car_dfechapresentacion`,
        `car_vcontactoentrega`)
        values
        (
        tlnidcarga,
        tdfecharetiro,
        tdfechapresentacion,
        tscontactoentrega
        );
    else
        update `tg_info_traslado`
        set
        `car_dfecharetiro` = tdfecharetiro,
        `car_dfechapresentacion` = tdfechapresentacion,
        `car_vcontactoentrega` = tscontactoentrega
        where car_ncorr = tlnidcarga;    
    end if;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_infotraslado_listar` (`tnidcarga` INT)  BEGIN
        select 
            `car_ncorr`,
             lug_ncorr_retiro,
             lug_ncorr_destino,
             car_dfecharetiro,
             car_dfechapresentacion,
             car_vcontactoentrega
        from `tg_info_traslado`
        where car_ncorr=tnidcarga;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_inventario_listar` ()  NO SQL
select	car.car_ncorr, 
		IF(lug.lug_ncorr>0,lug.lug_vnombre,'En traslado') as ubicacion, 
		esca.esca_vdescripcion, cont.cont_vnumcontenedor, cont.cont_npeso, cont.cont_vcontenido, car.car_vobservaciones, esca.esca_ncorr, lug.lug_ncorr, clie.clie_vnombre, DATE_FORMAT(max(serv.serv_dtermino),'%d/%m/%Y %k:%i') termino,
		datediff(curdate(),max(serv.serv_dtermino)) diasbodega,
		datediff(curdate(),min(serv.serv_dinicio)) diascustodia,
        IF(car.tica_ncorr=1 and tise.tine_ncorr = 4,datediff(curdate(),DATE_ADD(car.car_fechaeta,INTERVAL clie.clie_ndiaslibres DAY)),0) demurrage,
        guia.emp_ncorr empguia, 
        DATE_FORMAT(guia_dfecha,'%d/%m/%Y') guia_dfecha,
        guia.guia_ncorr, guia_ntipo, guia_numero, max(serv.serv_ncorr) codServicio
from	tg_carga car
		inner join tb_estadocarga esca on esca.esca_ncorr = car.esca_ncorr
		inner join tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
        inner join vw_tiposervicio tise on tise.tise_ncorr = ose.tise_ncorr
		inner join tb_cliente clie on ose.clie_vrut = clie.clie_vrut
		inner join tg_servicio serv on serv.car_ncorr = car.car_ncorr
		left join  tg_info_container cont on cont.car_ncorr = car.car_ncorr
		left join  tb_lugar lug on lug.lug_ncorr = car.lug_ncorr_actual
        left join tg_guiatransporte guia on guia.guia_ncorr = serv.guia_ncorr
where 	car.esca_ncorr<6 and serv.serv_nterminado = 0
group by car.car_ncorr, lug.lug_ncorr, esca.esca_vdescripcion, cont.cont_vnumcontenedor, cont.cont_npeso, cont.cont_vcontenido, car.car_vobservaciones, esca.esca_ncorr, lug.lug_ncorr, clie.clie_vnombre, guia.emp_ncorr, guia_dfecha, guia.guia_ncorr, guia_ntipo, guia_numero
order by esca.esca_vdescripcion asc$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_lugar_ingresar` (`codlugar` INT, `tipo` INT, `nombre` VARCHAR(50), `direccion` VARCHAR(100))  BEGIN
    IF codlugar = 0 THEN
        select  if(max(lug_ncorr)is null,1,max(lug_ncorr))
        into    codlugar
        from    tb_lugar;       
        insert into tb_lugar (LUG_NCORR, TLU_NCORR, LUG_VNOMBRE, LUG_VDIRECCION)
        values (codlugar+1, tipo, nombre, direccion);
    ELSE
        update  tb_lugar
        set     TLU_NCORR = tipo, LUG_VNOMBRE = nombre, LUG_VDIRECCION = direccion
        where   LUG_NCORR = codlugar;
    END IF;
    select 1,'';
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_lugar_listar` (`codtipolugar` INT)  begin
if codtipolugar > 0 then
    if codtipolugar = 1 then
       select
       `tb_lugar`.`lug_ncorr` id,
        null idparent,
       `tb_lugar`.`tlu_ncorr`,
       `tb_lugar`.`lug_vnombre` description,
       `tb_lugar`.`lug_vdireccion`,
       1 orden
        from `tb_lugar`
        where tlu_ncorr = 5
        union
        select 0 id, null idparent, 0 tlu_ncorr,  '-------------'  description, '' lug_vdireccion, 2 orden
        union
       select `tb_lugar`.`lug_ncorr` id,
        null idparent,
       `tb_lugar`.`tlu_ncorr`,
       `tb_lugar`.`lug_vnombre` description,
       `tb_lugar`.`lug_vdireccion`,
        3 orden
        from `tb_lugar`
        where tlu_ncorr < 5
       order by orden asc, description asc;
    else
       select
       `tb_lugar`.`lug_ncorr` id,
        null idparent,
       `tb_lugar`.`tlu_ncorr`,
       `tb_lugar`.`lug_vnombre` description,
       `tb_lugar`.`lug_vdireccion`
        from `tb_lugar`
        where tlu_ncorr = codtipolugar
        order by description asc;
     end if;
else
    select
    `tb_lugar`.`lug_ncorr` id,
     null idparent,
    `tb_lugar`.`tlu_ncorr` description,
    `tb_lugar`.`lug_vnombre`,
    `tb_lugar`.`lug_vdireccion`
    from `tb_lugar`
    order by description asc;
end if;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_medidacontenedor_listar` ()  BEGIN
    SELECT MED_NCORR id,MED_VDESCRIPCION description
    FROM   tb_medidacontenedor
    ORDER BY MED_VDESCRIPCION ASC;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_ordenservicio_ingresar` (`ordenservicio` INT, `fechaservicio` DATETIME, `nombrenave` VARCHAR(100), `observaciones` VARCHAR(500), `rutcliente` INT, `codnaviera` INT, `idvendedor` INT, `tiposervicio` INT, `codlugarorigen` INT, `codviaje` INT, `rutsubcliente` INT)  begin
    declare lnexisteregistro int;
    declare lnidordencrear int;
   select count(*)
    into lnexisteregistro
    from `tg_ordenservicio`
    where   ose_ncorr = ordenservicio;
    if lnexisteregistro = 0 then
        insert into `tg_ordenservicio`
                    (
                    `ose_dfechaservicio`,
                    `ose_vnombrenave`,
                    `ose_vobservaciones`,
                    `clie_vrut`,
                    `nav_ncorr`,
                    `usua_ncorr`,
                    `tise_ncorr`,
                    `lug_ncorrorigen`,
                    `via_ncorr`,
                    `clie_vrutsubcliente`)
        values      (
                    fechaservicio,
                    nombrenave,
                    observaciones,
                    rutcliente,
                    codnaviera,
                    idvendedor,
                    tiposervicio,
                    codlugarorigen,
                    codviaje,
                    rutsubcliente
        );
        select last_insert_id() ose_ncorr from dual;
    else
        update  `tg_ordenservicio`
        set
                `ose_dfechaservicio` = fechaservicio,
                `ose_vnombrenave` = nombrenave,
                `ose_vobservaciones` = observaciones,
                `clie_vrut` = rutcliente,
                `nav_ncorr` = codnaviera,
                `usua_ncorr` = idvendedor,
                `tise_ncorr` = tiposervicio,
                `lug_ncorrorigen` = codlugarorigen,
                `via_ncorr` = codviaje,
                `clie_vrutsubcliente` = rutsubcliente
        where   ose_ncorr = ordenservicio;
        select ordenservicio ose_ncorr from dual;
    end if;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_ordenservicio_ingresar2` (`ordenservicio` INT, `rutcliente` INT, `rutsubcliente` INT, `idvendedor` INT, `fechaservicio` DATETIME, `nombrenave` VARCHAR(100), `codlugarretiro` INT, `codtiposervicio` INT, `codsubtiposervicio` INT, `codpuntocarguio` INT, `observaciones` VARCHAR(500), `codlugardestino` INT)  begin
    declare lnexisteregistro int;
    declare lnidordencrear int;
    select  count(*)
    into    lnexisteregistro
    from    tg_ordenservicio
    where   ose_ncorr = ordenservicio;
    if lnexisteregistro = 0 then
        insert into tg_ordenservicio
                    (clie_vrut,
                     clie_vrutsubcliente,
                     ose_dfechaservicio,
                     ose_vnombrenave,
                     lug_ncorrorigen,
                     tise_ncorr,
                     sts_ncorr,
                     lug_ncorr_puntocarguio,
                     ose_vobservaciones,
                     lug_ncorrdestino,
                     usua_ncorr)
        values      ( 
                      rutcliente,
                      rutsubcliente,
                      fechaservicio,
                      nombrenave,
                      codlugarretiro,
                      codtiposervicio,
                      codsubtiposervicio,
                      codpuntocarguio,                      
                      observaciones,
                      codlugardestino,
                      idvendedor                   
        );
        select last_insert_id() ose_ncorr from dual;
    else
        update  tg_ordenservicio
        set     clie_vrut = rutcliente,
                clie_vrutsubcliente = rutsubcliente,                
                ose_dfechaservicio = fechaservicio,                
                ose_vnombrenave = nombrenave,
                lug_ncorrorigen = codlugarretiro,
                tise_ncorr = codtiposervicio,
                sts_ncorr = codsubtiposervicio,
                lug_ncorr_puntocarguio = codpuntocarguio,                
                ose_vobservaciones = observaciones,
                lug_ncorrdestino = codlugardestino 
        where   ose_ncorr = ordenservicio;
        select ordenservicio ose_ncorr from dual;
    end if;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_ordenservicio_listar` (`tncodestado` INT)  begin
    if tncodestado > 0 then
        select
            ose.ose_ncorr,
            DATE_FORMAT(ose_dfechaservicio,'%Y/%m/%d %H:%i') ose_dfechaservicio,
            ose_vnombrenave,
            ose_vobservaciones,
            cte.clie_vrut,
            cte.clie_vnombre,
            nav_ncorr,
            usua_ncorr,
            tise.tise_ncorr,
            tise.tise_vdescripcion,
            lug_ncorrorigen,
            via_ncorr,
            count(*) as items,
            esca.esca_ncorr,
            esca.esca_vdescripcion
        from tg_ordenservicio ose
        left join tg_carga car on ose.ose_ncorr = car.ose_ncorr
        left join tb_estadocarga esca on car.esca_ncorr = esca.esca_ncorr
        left join tb_cliente cte on ose.clie_vrut = cte.clie_vrut
        left join tb_tiposervicio tise on tise.tise_ncorr = ose.tise_ncorr
        where car.esca_ncorr = tncodestado
        group by 
            ose.ose_ncorr,
            ose_dfechaservicio,
            ose_vnombrenave,
            ose_vobservaciones,
            cte.clie_vrut,
            cte.clie_vnombre,
            nav_ncorr,
            usua_ncorr,
            tise.tise_ncorr,
            tise.tise_vdescripcion,
            lug_ncorrorigen,
            via_ncorr,
            esca.esca_ncorr,
            esca.esca_vdescripcion;
    else
        select
            ose.ose_ncorr,
            ose_dfechaservicio,
            ose_vnombrenave,
            ose_vobservaciones,
            cte.clie_vrut,
            cte.clie_vnombre,
            nav_ncorr,
            usua_ncorr,
            tise.tise_ncorr,
            tise.tise_vdescripcion,
            lug_ncorrorigen,
            via_ncorr,
            count(*) as items,
            0 as esca_ncorr,
            '' as esca_vdescripcion
        from tg_ordenservicio ose
        left join tg_carga car on ose.ose_ncorr = car.ose_ncorr
        left join tb_cliente cte on ose.clie_vrut = cte.clie_vrut
        left join tb_tiposervicio tise on tise.tise_ncorr = ose.tise_ncorr
        group by 
            ose.ose_ncorr,
            ose_dfechaservicio,
            ose_vnombrenave,
            ose_vobservaciones,
            cte.clie_vrut,
            cte.clie_vnombre,
            nav_ncorr,
            usua_ncorr,
            tise.tise_ncorr,
            tise.tise_vdescripcion,
            lug_ncorrorigen,
            via_ncorr;
    end if;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_ordenservicio_obtener` (`codorden` INT)  begin
    select  `tg_ordenservicio`.`ose_ncorr`, 
           date_format(`tg_ordenservicio`.`ose_dfechaservicio`,'%d/%m/%Y') ose_dfechaservicio, 
            `tg_ordenservicio`.`ose_vnombrenave`, 
            `tg_ordenservicio`.`ose_vobservaciones`, 
            `tg_ordenservicio`.`clie_vrutsubcliente`,
            `subcliente`.`clie_vnombre` clie_vnombresubcliente,     
            `tb_cliente`.`clie_vrut`, 
            `tb_cliente`.`clie_vnombre`,       
            `tg_ordenservicio`.`nav_ncorr`, 
            `tg_ordenservicio`.`usua_ncorr`, 
            `tg_ordenservicio`.`tise_ncorr`, 
            `tg_ordenservicio`.`lug_ncorrorigen`, 
            `tg_ordenservicio`.`via_ncorr`,
            `tb_tiposervicio`.`tise_ncorr`, 
            `tb_tiposervicio`.`tise_vdescripcion`,
            `tb_lugar`.`lug_ncorr`, 
            `tb_lugar`.`lug_vnombre`,
            `tb_viaje`.`via_ncorr`, 
            `tb_viaje`.`via_vdescripcion`,
            `tg_ordenservicio`.`clie_vrutsubcliente` ,
            `tg_ordenservicio`.`sts_ncorr`, 
            `tg_ordenservicio`.`lug_ncorrdestino`, 
            `tg_ordenservicio`.`lug_ncorr_puntocarguio`
    from    tg_ordenservicio
            inner join tb_cliente
                on tg_ordenservicio.clie_vrut = tb_cliente.clie_vrut
            left join tb_cliente subcliente
                on tg_ordenservicio.clie_vrutsubcliente = tb_cliente.clie_vrut
            inner join tb_tiposervicio
                on tg_ordenservicio.tise_ncorr = tb_tiposervicio.tise_ncorr
            left join tb_naviera
                on tg_ordenservicio.nav_ncorr = tb_naviera.nav_ncorr
            left join tb_lugar
                on tb_lugar.lug_ncorr = tg_ordenservicio.lug_ncorrorigen
            left join tb_viaje
                on tb_viaje.via_ncorr = tg_ordenservicio.via_ncorr
    where ose_ncorr = codorden;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_ordenservicio_obtener2` (`codorden` INT)  begin
    select  `tg_ordenservicio`.`ose_ncorr`, 
           date_format(`tg_ordenservicio`.`ose_dfechaservicio`,'%Y/%m/%d') ose_dfechaservicio, 
            `tg_ordenservicio`.`ose_vnombrenave`, 
            `tg_ordenservicio`.`ose_vobservaciones`, 
            `tg_ordenservicio`.`clie_vrutsubcliente`,
            `subcliente`.`clie_vnombre` clie_vnombresubcliente,     
            `tg_ordenservicio`.`sts_ncorr`, 
            `tg_ordenservicio`.`lug_ncorrorigen`, 
            `tg_ordenservicio`.`lug_ncorr_puntocarguio`,
            `tg_ordenservicio`.`lug_ncorrdestino`, 
            `tg_ordenservicio`.`nav_ncorr`, 
            `tg_ordenservicio`.`usua_ncorr`, 
            `tg_ordenservicio`.`tise_ncorr`, 
            `tb_cliente`.`clie_vrut`, 
            `tb_cliente`.`clie_vnombre`,       
            `tb_tiposervicio`.`tise_ncorr`, 
            `tb_tiposervicio`.`tise_vdescripcion`,
            `tb_lugar`.`lug_ncorr`, 
            `tb_lugar`.`lug_vnombre`,
            `tb_viaje`.`via_ncorr`, 
            `tb_viaje`.`via_vdescripcion`
    from    tg_ordenservicio
            inner join tb_cliente
                on tg_ordenservicio.clie_vrut = tb_cliente.clie_vrut
            inner join tb_cliente subcliente
                on tg_ordenservicio.clie_vrutsubcliente =subcliente.clie_vrut
            inner join tb_tiposervicio
                on tg_ordenservicio.tise_ncorr = tb_tiposervicio.tise_ncorr
            left join tb_naviera
                on tg_ordenservicio.nav_ncorr = tb_naviera.nav_ncorr
            left join tb_lugar
                on tb_lugar.lug_ncorr = tg_ordenservicio.lug_ncorrorigen
            left join tb_viaje
                on tb_viaje.via_ncorr = tg_ordenservicio.via_ncorr
    where ose_ncorr = codorden;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_programacioninicial_ingresar` (IN `idcarga` INT, IN `fechahora` DATETIME, IN `coddestinoservicio` INT, IN `codempresa` INT)  BEGIN
    declare existecarga 	int;
    declare existeservicio 	int;
    declare codlugarorigen 	int;
    declare codEstadoCarga	int;
    select  count(*)
    into    existecarga
    from    tg_carga
    where   car_ncorr = idcarga;
    /* Validacion de la carga*/
    if existecarga = 1 then    
        select  ifnull(max(serv_ncorr),0)
        into    existeservicio
        from    tg_servicio
        where   car_ncorr = idcarga;    
        /*Si no existe el servicio se ingresa tomando el origen con el origen de la orden de servicio*/
        if existeservicio = 0 then
            select  ose.lug_ncorrorigen
            into    codlugarorigen
            from    tg_ordenservicio ose
            inner join tg_carga car on car.ose_ncorr = ose.ose_ncorr
            where   car.car_ncorr = idcarga;            
        else
			/*Obtencion de estado de la carga*/
			select  esca_ncorr
			into    codEstadoCarga
			from    tg_carga
			where   car_ncorr = idcarga;	
			/*Si existe la orden de servicio, se valida si la orden se encuentra en almacen intermedio o en estado final*/
			if codEstadoCarga=4	then
				select  lug_ncorr_actual
				into    codlugarorigen
				from    tg_carga
				where   car_ncorr = idcarga;				
			else
				select  serv.lug_ncorr_origen
				into    codlugarorigen
				from    tg_servicio serv        
				where   serv.serv_ncorr = existeservicio;   			
			end if;			
        end if;
        update 	tg_servicio
        set		serv_nterminado = 1
        where	car_ncorr = idcarga;        
        insert into tg_servicio (
            car_ncorr,
            serv_dinicio,
            serv_dtermino,
            lug_ncorr_origen,
            lug_ncorr_destino,
            emp_ncorr
        )
        values(idcarga,
               fechahora,
               fechahora,
               codlugarorigen,
               coddestinoservicio,
               codempresa);
        update tg_carga
        set esca_ncorr = 2
        where car_ncorr = idcarga;
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_programacion_ingresar` (`idcarga` INT, `fechahorainicio` DATETIME, `fechahoratermino` DATETIME, `coddestinoservicio` INT, `codtransportista` INT, `codcamion` INT, `codchasis` INT, `codconductor` INT, `celular` VARCHAR(50))  BEGIN
    declare idservicio int;
    declare codlugarorigen int;
    select  ifnull(max(serv.serv_ncorr),0)
    into    idservicio
    from    tg_servicio serv
    inner join tg_carga car on serv.car_ncorr = car.car_ncorr
    where   car.car_ncorr = idcarga;
    if idservicio > 0 then
        update  tg_servicio
        set     lug_ncorr_destino = coddestinoservicio,
                emp_ncorr = codtransportista,
                cam_ncorr = codcamion,
                cha_ncorr = codchasis,
                chof_ncorr = codconductor,
                serv_dinicio = fechahorainicio ,
                serv_dtermino = fechahoratermino,
                serv_vcelular = celular
        where   serv_ncorr = idservicio;
    else
        select  ose.lug_ncorrorigen
        into    codlugarorigen
        from    tg_ordenservicio ose
        inner join tg_carga car on car.ose_ncorr = ose.ose_ncorr
        where   car.car_ncorr = idcarga;       
        insert into tg_servicio (
            lug_ncorr_origen,
            lug_ncorr_destino,
            emp_ncorr,
            cam_ncorr,
            cha_ncorr,
            chof_ncorr
        )
        values (
           codlugarorigen,
           coddestinoservicio,
           codtransportista,
           codcamion,
           codchasis,
           codconductor
        );
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_puerto_listar` (`codciudad` INT)  BEGIN
    select tb_lugar.lug_ncorr id,
           lug_ncorr_padre idparent,
           tlu_ncorr,
           lug_vnombre description,
           lug_vdireccion,
           1 orden
    from tb_lugar
    where tlu_ncorr = 1 and lug_ncorr_padre = codciudad
    order by description asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_registralog` (`texto` VARCHAR(500))  BEGIN
    DECLARE registralog INT;
    SELECT COUNT(*)
    INTO   registralog
    FROM   TG_PARAMETRO
    WHERE  PAR_NCORR = 1 AND PAR_VALOR = '1';
    IF registralog = 1 THEN
        INSERT INTO TG_LOG(log_vdescripcion, log_fecha, log_dhora)
        VALUES (texto,CURDATE(),CURTIME());
    END IF;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_reportefinanciero_listar` (IN `rutCliente` VARCHAR(100))  NO SQL
select		ose.ose_ncorr,	
			clie.clie_vnombre, 
			origen.lug_vnombre Origen, 
			destino.lug_vnombre Destino, 
			usua.usua_vnombre Vendedor, 
			esca.esca_vdescripcion EstadoCarga,
			car.car_ncorr,
			tica.tica_vdescripcion Tipo,
			sts_nmonto Tarifa,
			0 codServicio,
			'-' Empresa,
			'-' Tramo,
			0 Costo,
			ose_dfechaservicio IngresoOrden
from		tg_ordenservicio ose
inner join 	tb_cliente clie on clie.clie_vrut = ose.clie_vrut
inner join 	tb_lugar origen on origen.lug_ncorr = ose.lug_ncorrorigen
inner join 	tb_lugar destino on destino.lug_ncorr = ose.lug_ncorrdestino
inner join 	tg_usuario usua on usua.usua_ncorr = ose.usua_ncorr
inner join 	tg_carga car on car.ose_ncorr = ose.ose_ncorr
inner join 	tb_estadocarga esca on esca.esca_ncorr = car.esca_ncorr
inner join 	tb_tipocarga tica on tica.tica_ncorr = car.tica_ncorr
inner join  tb_subtiposervicio sts on sts.sts_ncorr = ose.sts_ncorr$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_seguimientotransporte_listar` (IN `codorden` INT, IN `codcliente` INT, IN `codtransportista` INT, IN `inicioperiodo` DATE, IN `terminoperiodo` DATE)  BEGIN
    SELECT     serv.car_ncorr,
               serv.serv_ncorr,
               ose.clie_vrut,
               ose.ose_ncorr,
               serv.emp_ncorr,
               emp.emp_vnombre nombreempresa,
               cam.cam_vpatente camion,
               chof.chof_vnombre chofer,
               chof.chof_vfono fono,
               origen.lug_vnombre origen,
               destino.lug_vnombre destino,
               sts.sts_vnombre tiposervicio,
               cont.cont_vnumcontenedor numcontenedor,
               DATE_FORMAT(serv.serv_dinicio,'%Y/%m/%d') diaservicio,
               DATE_FORMAT(serv.serv_dinicio,'%d/%m/%Y %H:%i') inicioplan,
               DATE_FORMAT(if(avance.controlado = 1, avance.inicioreal,  time(serv.serv_dinicio)),'%d/%m/%Y %H:%i') inicioreal,
               DATE_FORMAT(serv.serv_dtermino,'%d/%m/%Y %H:%i')  terminoplan,
               avance.controlado,
               count(hico.hico_ncorr) hitosingresados,
               if(hitofinal=1,ultimoavance,NULL) terminoreal,
               timediff(serv.serv_dtermino, serv.serv_dinicio) total,
               max(hito.hito_km) movimiento,			   
               '0 km' distancia ,
               DATE_FORMAT(if (avance.controlado=1,avance.ultimoavance, time(serv.serv_dinicio)),'%d/%m/%Y %H:%i') uavance,
if (avance.controlado=0,null,(minute(timediff(avance.inicioplan, avance.inicioreal))+ 60 *hour(timediff(avance.inicioplan, avance.inicioreal)))) atrasoinicio,
if (avance.controlado=0,null, if(count(hico.hico_ncorr)=1,0, if(avance.ultimoavance<=avance.avancesperado,0,minute(timediff(avance.ultimoavance,avance.avancesperado))+ 60 * (hour(timediff(avance.ultimoavance,avance.avancesperado)))))) atrasoavance,
               if(count(hico.hico_ncorr)=1,0, (hour(timediff(avance.avancesperado,inicioreal))*60) + minute(timediff(avance.avancesperado,inicioreal))) avance,
               minute(timediff(serv.serv_dtermino,serv.serv_dinicio)) + (hour(timediff(serv.serv_dtermino,serv.serv_dinicio))*60) totaltiempo,
               tica.tica_vdescripcion,
               car.esca_ncorr,
			   max(hito2.hito_km) kmmax
    FROM tg_servicio serv
    INNER JOIN tg_carga car on car.car_ncorr = serv.car_ncorr
    INNER JOIN tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
    INNER JOIN tb_tiposervicio tise on tise.tise_ncorr = ose.tise_ncorr
    INNER JOIN vw_avancehito avance on avance.car_ncorr = serv.car_ncorr
    INNER JOIN tb_subtiposervicio sts on sts.sts_ncorr = ose.sts_ncorr
    LEFT JOIN tg_camion cam on cam.cam_ncorr = serv.cam_ncorr
    LEFT JOIN tb_tipocarga tica on tica.tica_ncorr = car.tica_ncorr
    LEFT JOIN tg_chofer chof on chof.chof_ncorr = serv.chof_ncorr
    LEFT JOIN tg_hitocontrolado hico on hico.serv_ncorr = serv.serv_ncorr and hico.hico_horareal IS NOT NULL
    LEFT JOIN tg_hito hito on hito.hito_ncorr = hico.hito_ncorr
	LEFT JOIN tg_hito hito2 on hito2.tra_ncorr = hito.tra_ncorr
    LEFT JOIN tg_empresatransporte emp on emp.emp_ncorr = serv.emp_ncorr
    LEFT JOIN tb_lugar origen on origen.lug_ncorr = serv.lug_ncorr_origen
    LEFT JOIN tb_lugar destino on destino.lug_ncorr = serv.lug_ncorr_destino
    LEFT JOIN tg_info_container cont on cont.car_ncorr = car.car_ncorr
    WHERE   serv.cam_ncorr > 0 and car.esca_ncorr in (1,2,3) and serv.serv_nterminado = 0
    GROUP BY  serv.car_ncorr,
               serv.serv_ncorr,
               ose.clie_vrut,
               ose.ose_ncorr,
               serv.emp_ncorr,
               serv.serv_dinicio,
               cam_vpatente,
               tica.tica_vdescripcion,
               car.esca_ncorr
   ORDER BY serv.serv_dinicio asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_serviciosinfacturar_listar` (`ordenservicio` INT, `rutcliente` VARCHAR(20), `estadocarga` INT)  BEGIN
    SELECT  car.ose_ncorr ordenservicio,
            clie.clie_vnombre cliente,
            car.car_ncorr idcarga,
            tica.tica_vdescripcion tipocarga,
            inco.cont_vnumcontenedor contenedor,
            tise.tise_vdescripcion tiposervicio,
            concat(if(ose.lug_ncorrorigen is null,'',origen.lug_vnombre),'-',if(ose.lug_ncorrdestino is null,'',destino.lug_vnombre)) viaje,
            esca.esca_vdescripcion estado,
            DATE_FORMAT(serv.serv_dtermino,'%Y/%m/%d') termino         
    FROM    tg_carga car
            INNER JOIN tg_ordenservicio ose on ose.ose_ncorr = car.ose_ncorr
            INNER JOIN tb_cliente clie on clie.clie_vrut = ose.clie_vrut
            INNER JOIN tb_tipocarga tica on car.tica_ncorr = tica.tica_ncorr
            INNER JOIN tb_tiposervicio tise on tise.tise_ncorr = ose.tise_ncorr
            INNER JOIN tb_estadocarga esca on car.esca_ncorr = esca.esca_ncorr
            LEFT JOIN tb_lugar origen on origen.lug_ncorr = ose.lug_ncorrorigen
            LEFT JOIN tb_lugar destino on destino.lug_ncorr = ose.lug_ncorrdestino
            LEFT JOIN tg_servicio serv on serv.car_ncorr = car.car_ncorr
            LEFT JOIN tg_info_container inco on inco.car_ncorr = car.car_ncorr
    WHERE   (car.fact_ncorr = 0 or car.fact_ncorr is null)
            AND ose.ose_ncorr = if(ordenservicio = 0,ose.ose_ncorr,ordenservicio)
            AND ose.clie_vrut = if(rutcliente='',ose.clie_vrut,rutcliente)
            AND car.esca_ncorr = if(estadocarga=0,car.esca_ncorr,estadocarga)
    ORDER BY ose.ose_ncorr asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_servicio_ingresar` (IN `rut` INT(10), IN `codTipoServicio` INT, IN `codSubTipoServicio` INT, IN `nombreServicio` VARCHAR(100), IN `codOrigen` INT, IN `codDestino` INT, IN `monto` FLOAT)  BEGIN
	if codSubTipoServicio = 0 then
        select if(max(sts_ncorr) is null,1,max(sts_ncorr)+1)
        into   codSubTipoServicio
        from   tb_subtiposervicio;	
		insert into tb_subtiposervicio (sts_ncorr, 
										sts_vnombre, 
										tise_ncorr, 
										lug_ncorr_origen,
										lug_ncorr_destino,
										clie_vrut,
										sts_nmonto)
		values (codSubTipoServicio, 
				nombreServicio,
				codTipoServicio,
				codOrigen,
				codDestino,
				rut,
				monto);
	else
		update 	tb_subtiposervicio
		set		sts_vnombre = nombreServicio,
				lug_ncorr_origen = codOrigen,
				lug_ncorr_destino = codDestino,
				sts_nmonto = monto
		where	sts_ncorr = codSubTipoServicio;
	end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_subclientelistar` (`codcliente` INT)  BEGIN    
    select  clie.clie_vrut, if(clie.clie_nrutpadre>0,clie.clie_vnombre, concat('[',clie.clie_vnombre,']'))
    from    tb_cliente clie
    where   clie.clie_nrutpadre = codcliente or clie.clie_vrut = codcliente
    order by clie.clie_nrutpadre desc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_subtiposerviciolistar` (`codtiposervicio` INT)  BEGIN
    select  sts_ncorr, sts_vnombre
    from    tb_subtiposervicio sts
    where   sts.tise_ncorr = codtiposervicio
    order by sts.sts_vnombre asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_tarifacliente_eliminar` (`idtarifa` INT)  BEGIN
    declare lnStatus int;    
    DECLARE CONTINUE HANDLER FOR 1451 set lnStatus = 1451;    
    delete from tg_tarifaservicio where  tasi_ncorr = idtarifa;
    if lnStatus = 1451 then
        select 0,'La tarifa no puede ser eliminada ya que hay registros asociados';
    else
        select 1,'-';
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_tarifacliente_ingresar` (`idtarifa` INT, `monto` INT, `tiposervicio` INT, `subtiposervicio` INT, `rut` INT, `origen` INT, `destino` INT)  BEGIN
    declare lnIdTarifa int;
    declare lnexistente int;
    if idtarifa = 0 then
        select  count(*)
        into    lnexistente
        from    tg_tarifaservicio
        where   tise_ncorr = tiposervicio
                and sts_ncorr = subtiposervicio
                and clie_vrut = rut
                and lug_ncorr_origen = origen
                and lug_ncorr_destino = destino;    
        if lnexistente = 0 then
            select  if(max(tasi_ncorr) is null,1,max(tasi_ncorr)+1)
            into    lnIdTarifa
            from    tg_tarifaservicio;
            insert into tg_tarifaservicio (TASI_NCORR, TASI_NMONTO, TISE_NCORR, STS_NCORR, CLIE_VRUT, 
                                           LUG_NCORR_ORIGEN, LUG_NCORR_DESTINO)
            values (lnIdTarifa,monto,tiposervicio,subtiposervicio,rut,origen,destino);
            select 1,'-';
        else
            select 0,'Este servicio ya se ha ingresado previamente';
        end if;
    else
        update  tg_tarifaservicio
        set     TASI_NMONTO = monto,
                TISE_NCORR = tiposervicio,
                STS_NCORR = subtiposervicio,
                CLIE_VRUT = rut,
                LUG_NCORR_ORIGEN = origen,
                LUG_NCORR_DESTINO = destino
        where   tasi_ncorr = idtarifa;
        select 1,'-';
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_tarifacliente_listar` (`rut` INT)  BEGIN
    select  tasi.tasi_ncorr,
            tise.tise_vdescripcion,
            sts.sts_vnombre,
            origen.lug_vnombre origen,
            destino.lug_vnombre destino,
            tasi.tasi_nmonto,
            '-' cotizacion
    from    tg_tarifaservicio tasi
            inner join tb_tiposervicio tise on tise.tise_ncorr = tasi.tise_ncorr
            left join tb_subtiposervicio sts on sts.sts_ncorr = tasi.sts_ncorr
            left join tb_lugar origen on origen.lug_ncorr = tasi.lug_ncorr_origen
            left join tb_lugar destino on destino.lug_ncorr = tasi.lug_ncorr_destino
    where   tasi.clie_vrut = rut;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_tarifatransportista_eliminar` (`idtarifa` INT)  BEGIN
    declare lnStatus int;    
    DECLARE CONTINUE HANDLER FOR 1451 set lnStatus = 1451;    
    delete from tg_tarifa where  tar_ncorr = idtarifa;
    if lnStatus = 1451 then
        select 0,'La tarifa no puede ser eliminada ya que hay registros asociados';
    else
        select 1,'-';
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_tarifatransportista_ingresar` (`idtarifa` INT, `codempresa` INT, `codservicio` INT, `codsubservicio` INT, `origen` INT, `destino` INT, `monto` INT)  BEGIN
    declare lnExistencia int;
    if idtarifa = 0 then
        select  if(max(tar_ncorr) is null,1,max(tar_ncorr)+1)
        into    idtarifa
        from    tg_tarifa;
        select  count(*)
        into    lnExistencia
        from    tg_tarifa tar
        where   tar.emp_ncorr = codempresa and
                tar.tise_ncorr = codservicio and
                tar.sts_ncorr = codsubservicio and
                tar.lug_ncorr_origen = origen and
                tar.lug_ncorr_destino = destino;
        if lnExistencia = 0 then
            insert into tg_tarifa ( TAR_NCORR, 
                                    EMP_NCORR, 
                                    TISE_NCORR, 
                                    STS_NCORR, 
                                    LUG_NCORR_ORIGEN, 
                                    LUG_NCORR_DESTINO, 
                                    TAR_NMONTO) 
            values (idtarifa,codempresa,codservicio,codsubservicio,origen,destino,monto);
            select 1,'-';
        else
            select 0,'El servicio ya fue ingresado previamente';
        end if;
    else
        update  tg_tarifa
        set     EMP_NCORR = codempresa,
                TISE_NCORR = codservicio,
                STS_NCORR = codsubservicio,
                LUG_NCORR_ORIGEN = origen,
                LUG_NCORR_DESTINO = destino,
                TAR_NMONTO = monto
        where   TAR_NCORR = idtarifa;
        select 1,'-';
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_tarifatransportista_listar` (`codtransportista` INT)  BEGIN
    select  tar.tar_ncorr, 
            tise.tise_ncorr,
            tise.tise_vdescripcion Servicio,
            sts.sts_ncorr,
            sts.sts_vnombre Subtiposervicio,
            if (origen.lug_ncorr is null,'-',concat(origen.lug_vnombre,' > ' , destino.lug_vnombre)) Tramo,
            tar.tar_nmonto Monto
    from    tg_tarifa tar
            inner join tb_tiposervicio tise on tise.tise_ncorr = tar.tise_ncorr
            inner join tb_subtiposervicio sts on sts.sts_ncorr = tar.sts_ncorr
            left join tb_lugar origen on origen.lug_ncorr = tar.lug_ncorr_origen
            left join tb_lugar destino on destino.lug_ncorr = tar.lug_ncorr_destino
    where   tar.emp_ncorr = codtransportista
    order by    tise.tise_vdescripcion asc,
                sts.sts_vnombre asc,
                origen.lug_vnombre asc,
                destino.lug_vnombre asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_tipocarga_listar` ()  begin
select
`tb_tipocarga`.`tica_ncorr` id,
null idparent,
`tb_tipocarga`.`tica_vdescripcion` description
from `tb_tipocarga`
order by `tb_tipocarga`.`tica_vdescripcion` asc;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_tipocontenedor_listar` ()  begin
select
tico_ncorr id,
null idparent,
tico_vdescripcion description
from tb_tipocontenedor
order by tico_vdescripcion asc;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_tiposervicio_listar` ()  begin
    select
    tise_ncorr id, null idparent, tise_vdescripcion description
    from tb_tiposervicio
    order by tise_vdescripcion;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_tramos_listar` ()  BEGIN
    SELECT  TRA_NCORR, LUG_NCORR_ORIGEN IdOrigen, LUG_NCORR_DESTINO IdDestino, 
            origen.lug_vnombre DescOrigen, destino.lug_vnombre DescDestino,
            tra.tra_kms, tra.tra_tiempo
    FROM    tg_tramo tra
    INNER JOIN tb_lugar origen on origen.lug_ncorr = LUG_NCORR_ORIGEN
    INNER JOIN tb_lugar destino on destino.lug_ncorr = LUG_NCORR_DESTINO
    ORDER BY origen.lug_vnombre ASC, destino.lug_vnombre ASC;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_tramo_eliminar` (`idtramo` INT)  BEGIN
    declare lnStatus int;    
    DECLARE CONTINUE HANDLER FOR 1451 set lnStatus = 1451;    
    delete from tg_tramo where  tra_ncorr = idtramo;
    if lnStatus = 1451 then
        select 0,'El tramo no pudo ser eliminado porque posee registros asociados';
    else
        select 1,'-';
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_transportista_eliminar` (`idempresa` INT)  BEGIN
    declare lnStatus int;    
    DECLARE CONTINUE HANDLER FOR 1451 set lnStatus = 1451;    
    delete from tg_empresatransporte where  emp_ncorr = idempresa;
    if lnStatus = 1451 then
        select 0,'La empresa no puede ser eliminada porque posee registros asociados';
    else
        select 1,'-';
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_transportista_ingresar` (`idempresa` INT, `nombre` VARCHAR(50), `rut` VARCHAR(20), `direccion` VARCHAR(200), `giro` VARCHAR(50), `contacto` VARCHAR(50), `fono` VARCHAR(50), `mail` VARCHAR(50))  BEGIN
    if idempresa = 0 then
        select  if(max(emp_ncorr) is null,1,max(emp_ncorr)+1)
        into    idempresa
        from    tg_empresatransporte;
        insert into tg_empresatransporte (emp_ncorr, emp_vnombre, emp_vrut, emp_vdireccion, emp_vgiro, 
                    emp_vcontacto, emp_vfono, emp_vmail)
        values(idempresa,nombre,rut,direccion,giro,contacto,fono,mail);
    else
        update  tg_empresatransporte
        set     emp_vnombre = nombre,
                emp_vrut = rut,
                emp_vdireccion = direccion,
                emp_vgiro = giro,
                emp_vcontacto = contacto,
                emp_vfono =fono,
                emp_vmail = mail
        where   emp_ncorr = idempresa;
    end if;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_transportista_listar` ()  BEGIN
    select  emp.emp_ncorr id, 
            null idparent, 
            UPPER(emp.emp_vnombre) description,
            emp.emp_vrut,
            emp.emp_vdireccion,
            emp.emp_vgiro
    from    tg_empresatransporte emp
    order by emp.emp_vnombre asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_transportista_obtener` (`idempresa` INT)  BEGIN
    select  emp_ncorr, emp_vrut, emp_vnombre, emp_vgiro, emp_vdireccion, emp_vgiro, emp_vcontacto, emp_vfono, emp_vmail
    from    tg_empresatransporte
    where   emp_ncorr = idempresa;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_unidadmedida_listar` ()  BEGIN
    select um_ncorr id,
    null idparent, 
    im_vdescripcion description
    from   tb_unidadmedida
    order by im_vdescripcion asc;
END$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_usuarios_listar` ()  begin
            select  usua_ncorr id, 
                    null idparent,
                    concat(usua_vnombre,' ' , usua_vapellido1, ' ', usua_vapellido2) description
            from    tg_usuario;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_vendedor_listar` ()  begin
    select  usua_ncorr,usua_vnombre,usua_vapellido1,usua_vapellido2
    from    tg_usuario
    where   rol_ncorr = 2;
end$$

CREATE DEFINER=`simplex1`@`localhost` PROCEDURE `prc_viajes_listar` ()  begin
    select
    `tb_viaje`.`via_ncorr` id,
     null idparent,
    `tb_viaje`.`via_vdescripcion` description
    from `tb_viaje`
    order by via_vdescripcion;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_agenciaaduana`
--

CREATE TABLE `tb_agenciaaduana` (
  `ADA_NCORR` int(11) NOT NULL COMMENT 'Identificador de la agencia de aduana',
  `ADA_VNOMBRE` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre de la agencia de aduana'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee las agencias de aduana existentes en el sist';

--
-- Volcado de datos para la tabla `tb_agenciaaduana`
--

INSERT INTO `tb_agenciaaduana` (`ADA_NCORR`, `ADA_VNOMBRE`) VALUES
(1, 'Agencia A'),
(2, 'Agencia B');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_ciudad`
--

CREATE TABLE `tb_ciudad` (
  `CIU_NCORR` int(11) NOT NULL COMMENT 'Identificador de la ciudad',
  `CIU_VNOMBRE` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre de la ciudad'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla con las ciudades';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_cliente`
--

CREATE TABLE `tb_cliente` (
  `CLIE_VRUT` int(10) NOT NULL COMMENT 'Identificador del cliente',
  `CLIE_VNOMBRE` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre del cliente',
  `EMP_VRAZONSOCIAL` varchar(100) COLLATE latin1_spanish_ci NOT NULL,
  `CLIE_VCONTACTOLEGAL` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Contacto legal del cliente',
  `CLIE_VDIRECCION` varchar(250) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'DirecciÃ³n legal del cliente',
  `CIU_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador de la ciudad',
  `CLIE_NRUTPADRE` int(11) DEFAULT NULL COMMENT 'Id. del cliente padre',
  `CLIE_VCOMUNA` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL,
  `CLIE_VGIRO` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL,
  `CLIE_VFONO` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL,
  `CLIE_VDV` varchar(1) COLLATE latin1_spanish_ci NOT NULL,
  `CLIE_NDIASLIBRES` int(11) NOT NULL,
  `CLIE_VRAZONSOCIAL` varchar(100) COLLATE latin1_spanish_ci NOT NULL,
  `CLIE_VACTIVIDAD` varchar(100) COLLATE latin1_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee el detalle de todos los clientes registrados';

--
-- Volcado de datos para la tabla `tb_cliente`
--

INSERT INTO `tb_cliente` (`CLIE_VRUT`, `CLIE_VNOMBRE`, `EMP_VRAZONSOCIAL`, `CLIE_VCONTACTOLEGAL`, `CLIE_VDIRECCION`, `CIU_NCORR`, `CLIE_NRUTPADRE`, `CLIE_VCOMUNA`, `CLIE_VGIRO`, `CLIE_VFONO`, `CLIE_VDV`, `CLIE_NDIASLIBRES`, `CLIE_VRAZONSOCIAL`, `CLIE_VACTIVIDAD`) VALUES
(55555555, 'Nestle Argentina Purina', '', 'Miguel Pereyra', 'Direccion', NULL, NULL, 'Bs Aires', 'Fabricacion de alimentos', 'Fono', '', 30, 'Nestle Argentina Purina', 'Actividad'),
(76056575, 'WAUSAU', '', 'Juan Politeo', 'COMPANIA', NULL, 76056575, 'Santiago', 'VENTA AL POR MAYOR DE PAPEL Y CARTON', '1234567', '', 20, 'Comercializadora WAUSAU Conosur', 'VENTA AL POR MAYOR DE PAPEL Y CARTON'),
(76242324, 'VICSA SEAFTY', '', 'Luis Castillo', 'Pintor Cicarelli 683', NULL, NULL, 'San Joanquin', 'VENTA AL POR MAYOR DE OTROS PRODUCTOS N.', ' 56 2 25894100', '', 20, 'VICSA SAFETY COMERCIAL LIMITADA', ''),
(76360653, 'DGRU S.A.', '', 'Jorge Martinez', 'Agustinas 1442 A907', NULL, NULL, 'Santiago', 'VENTA AL POR MAYOR DE MAQUINARIA, HERRAMIENTAS', '56 9 77641277', '', 5, 'DGRU S.A.', 'Arriendo de Gruas Torre'),
(81866400, 'Fosko S.A.', '', 'Luisa Contreras', 'Brown Norte  797', NULL, NULL, 'Nunoa', 'FABRICACION DE OTROS ARTICULOS DE PLASTI', '56 2 23986100', '', 5, 'Fabrica de Envases Fosko S.A.', ''),
(90914000, 'Moletto', '', 'Pablo Saavedra', 'Av. Matucana 1223', NULL, 90914000, 'Santiago', 'Manufacturas Textiles', '56 9 87464245', '', 10, 'Moletto Hermanos S.A.', 'Comercialización de Textiles'),
(93515000, 'General Motors', '', 'Jerome Faundez', 'Av. Américo Vespucio Norte 811', NULL, NULL, 'Huachuraba', 'Fabricación de Vehículos Automotores', '56 (2) 25206210', '', 30, 'General Motors Chile Industria Automotriz Ltda', 'Venta de Vehículos'),
(96690870, 'Integrity S.A.', '', 'Patricio Almonte', 'San Pablo Antiguo S/N ', NULL, NULL, 'San Pablo', 'Venta al por mayor de otros productos ', '56 2 2904791', '', 5, 'Integrity S.A.', 'Venta bandejas Plásticos'),
(96733780, 'Ultra Pac', '', 'Patricio Almonte', 'San Pablo Antiguo S/N ', NULL, NULL, 'Pudahuel', 'FABRICACION DE OTROS ARTICULOS DE PLASTI', '56 2 24904791', '', 5, 'Ultra Pac Sudamericana S.A', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_condicionespecial`
--

CREATE TABLE `tb_condicionespecial` (
  `COND_NCORR` int(11) NOT NULL COMMENT 'Id. de la condición',
  `COND_VDESCRIPCION` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Descripción de la condición'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee los distintos tipos de condiciones especiale';

--
-- Volcado de datos para la tabla `tb_condicionespecial`
--

INSERT INTO `tb_condicionespecial` (`COND_NCORR`, `COND_VDESCRIPCION`) VALUES
(1, 'Aforo fisico'),
(2, 'SAG'),
(3, 'IMO'),
(10, 'Otro'),
(9, 'Ninguna');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_estadocarga`
--

CREATE TABLE `tb_estadocarga` (
  `ESCA_NCORR` int(11) NOT NULL COMMENT 'Identicador numÃ©rico del estado',
  `ESCA_VDESCRIPCION` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'DescripciÃ³n de la tarea'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Estado de la tarea';

--
-- Volcado de datos para la tabla `tb_estadocarga`
--

INSERT INTO `tb_estadocarga` (`ESCA_NCORR`, `ESCA_VDESCRIPCION`) VALUES
(1, 'Ingresada'),
(2, 'Programada'),
(3, 'En traslado'),
(4, 'En almacen intermedio'),
(5, 'Entregada'),
(6, 'Finalizada');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_estadorol`
--

CREATE TABLE `tb_estadorol` (
  `ROL_NCORR` int(11) NOT NULL COMMENT 'Identificador del rol de usuario',
  `ESTA_NCORR` int(11) NOT NULL COMMENT 'Identicador numÃ©rico del estado'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que permite configurar los estados de tareas que puede';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_estado_factura`
--

CREATE TABLE `tb_estado_factura` (
  `ESFA_NCORR` int(11) NOT NULL COMMENT 'Estado de la factura',
  `ESFA_VDESCRIPCION` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Descripción del estado de la factura'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tb_estado_factura`
--

INSERT INTO `tb_estado_factura` (`ESFA_NCORR`, `ESFA_VDESCRIPCION`) VALUES
(1, 'Creada'),
(2, 'Anulada'),
(3, 'Pagada');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_funcionalidad`
--

CREATE TABLE `tb_funcionalidad` (
  `FUNC_NCORR` int(11) NOT NULL COMMENT 'Identificador de la funcionalidad',
  `FUNC_VDESCRIPCION` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'DescripciÃ³n de la funcionalidad, es el texto que aparecerÃ¡ en el menÃº',
  `FUNC_VURL` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'URL de la funcionalidad'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee las funcionalidades a las cuales el usuario ';

--
-- Volcado de datos para la tabla `tb_funcionalidad`
--

INSERT INTO `tb_funcionalidad` (`FUNC_NCORR`, `FUNC_VDESCRIPCION`, `FUNC_VURL`) VALUES
(11, 'Orden de Servicio', 'OrdenServicio.htm'),
(12, 'Coordinacion de transporte', 'CoordinacionTransporte.htm'),
(13, 'Programacion de transporte', 'ProgramacionTransporte.htm'),
(14, 'Seguimiento de transporte', 'Seguimiento.htm'),
(15, 'Inventario', 'inventario.htm'),
(21, 'Ingresos y costos', '../Reportes/reporteFinanciero-obtener.htm'),
(22, 'Exportacion inventario', '../Reportes/reporteInventario-obtener.htm'),
(31, 'Mantenedor lugares', '../Mantenedores/mantenedor-lugar.htm'),
(32, 'Mantenedor tramos', '../Mantenedores/mantenedor-tramos.htm'),
(33, 'Mantenedor empresas', '../Mantenedores/mantenedor-empresa.htm'),
(34, 'Mantenedor clientes', '../Mantenedores/mantenedor-cliente.htm'),
(35, 'Mantenedor naviera', '../Mantenedores/mantenedor-naviera.htm'),
(36, 'Mantenedor usuarios', '../Mantenedores/mantenedor-usuarios.htm'),
(37, 'Diseño de servicios', '../Mantenedores/disenador-servicios.htm');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_lugar`
--

CREATE TABLE `tb_lugar` (
  `LUG_NCORR` int(11) NOT NULL COMMENT 'Identificador del tipo de lugar',
  `TLU_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador del registro',
  `LUG_VNOMBRE` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre del lugar',
  `LUG_VDIRECCION` varchar(500) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'DirecciÃ³n',
  `LUG_VSIGLA` varchar(20) COLLATE latin1_spanish_ci DEFAULT NULL,
  `LUG_VCIUDAD` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL,
  `LUG_NCATEGORIA` int(11) DEFAULT NULL,
  `LUG_NCORR_PADRE` int(11) DEFAULT NULL COMMENT 'Id. del lugar padre',
  `LUG_NRETIRO` int(11) NOT NULL,
  `LUG_NCARGUIO` int(1) NOT NULL,
  `LUG_NDESTINO` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tb_lugar`
--

INSERT INTO `tb_lugar` (`LUG_NCORR`, `TLU_NCORR`, `LUG_VNOMBRE`, `LUG_VDIRECCION`, `LUG_VSIGLA`, `LUG_VCIUDAD`, `LUG_NCATEGORIA`, `LUG_NCORR_PADRE`, `LUG_NRETIRO`, `LUG_NCARGUIO`, `LUG_NDESTINO`) VALUES
(1, 1, 'TPS', '', 'L0001', 'Valparaiso', 1, 29, 1, 1, 1),
(2, 1, 'STI', '', 'L0002', 'San Antonio', 1, 30, 1, 1, 1),
(3, 1, 'LIRQUEN', '', 'L0003', 'Lirquen', 1, 31, 1, 1, 1),
(4, 1, 'CORNEL', 'Ã¡Ã±', 'L0004', 'Coronel', 1, 32, 1, 1, 1),
(5, 3, 'ZEAL', '', 'L0005', 'Valparaiso', 3, 29, 1, 1, 1),
(6, 3, 'SAAM (Valp)', '', 'L0006', 'Valparaiso', 3, 29, 1, 1, 1),
(7, 3, 'SAN FRANCISCO SAI', '', 'L0007', 'San Antonio', 3, 30, 1, 1, 1),
(8, 3, 'SAN FRANCISCO VAP', '', 'L0008', 'Valparaiso', 3, 29, 1, 1, 1),
(9, 3, 'DYC SAI', '', 'L0009', 'San Antonio', 3, 30, 1, 1, 1),
(10, 3, 'CONTOPSA SAI', '', 'L0010', 'San Antonio', 3, 30, 1, 1, 1),
(11, 3, 'DEPOT BIGGIO VAP', '', 'L0011', 'Valparaiso', 3, 29, 1, 1, 1),
(12, 3, 'DYC VAP', '', 'L0012', 'Valparaiso', 3, 29, 1, 1, 1),
(14, 2, 'DYC SCL', '', 'L0014', 'Santiago', 2, 14, 1, 0, 1),
(16, 2, 'LOCSA', '', 'L0016', 'Santiago', 2, 14, 1, 0, 1),
(17, 2, 'LABRA', '', 'L0017', 'Santiago', 2, 33, 1, 0, 1),
(18, 2, 'SITRANS SCL', '', 'L0018', 'Santiago', 2, 33, 1, 1, 1),
(19, 2, 'SAAM SCL', '', 'L0019', 'Santiago', 2, 33, 1, 1, 1),
(20, 2, 'AGUNSA SCL', '', 'L0020', 'Santiago', 2, 33, 1, 1, 1),
(22, 2, 'CONTOPSA SCL', '', 'L0022', 'Santiago', 2, 33, 1, 1, 1),
(23, 4, 'SODIMAC- CD Lo Espejo', '', 'L0023', 'Santiago', 4, 33, 0, 0, 1),
(24, 4, 'DERCO - Lo Boza', '', 'L0024', 'Santiago', 4, 33, 0, 1, 1),
(25, 4, 'SODIMAC - Lo Echevers', '', 'L0025', 'Santiago', 4, 33, 0, 1, 1),
(26, 4, 'Concha y Toro - Pirque', '', 'L0026', 'Santiago', 4, 33, 0, 1, 1),
(27, 4, 'Concha y Toro - Lo Espejo', '', 'L0027', 'Santiago', 4, 33, 0, 1, 1),
(28, 4, 'San Pedro - Lo Espejo', '', 'L0028', 'Santiago', 4, 33, 0, 1, 1),
(32, NULL, 'VICSA - Farfana', '', 'L0029', 'Santiago', 4, NULL, 0, 1, 1),
(33, NULL, 'Wausau - General Velasquez', ' CompaÃ±ia 1390 905', 'L0030', 'Santiago', 4, NULL, 0, 1, 1),
(34, NULL, 'Wausau - Papelera Herrera', 'Las CaÃ±as 924', 'L0031', 'Valparaiso', 4, NULL, 0, 0, 1),
(35, NULL, 'EASY - La Farfana', '', 'L0032', 'Santiago', 4, NULL, 0, 0, 1),
(36, NULL, 'Origen', 'Origen', 'L0033', 'Santiago', 4, NULL, 1, 1, 1),
(37, NULL, 'Moletto - Matucana', 'Av. Matucana 1223', 'L0034', 'Santiago', 4, NULL, 1, 1, 1),
(38, NULL, 'Moletto - Pto Madero', 'Puerto Madero 9710 Bodega Z19', 'L0035', 'Santiago', 4, 38, 1, 1, 1),
(39, NULL, 'Moletto - Laguna Sur', 'Laguna Sur Bodega A9', 'L0036', 'Santiago', 4, NULL, 1, 1, 1),
(40, NULL, 'DepÃ³sito Lo Herrera', 'Pdte Jorge Alessandri R. 24.481 Lo Herrera, San Bernardo', 'L0037', 'Santiago', 1, NULL, 1, 1, 1),
(41, NULL, 'GM - Lo Boza', 'Av. Lo Boza #120-C, Pudahuel', 'L0038', 'Santiago', 4, NULL, 1, 1, 1),
(42, NULL, 'Bodega Pacific Star', 'Buzeta 3915, Cerrillos', 'L0039', 'Santiago', 2, 42, 1, 1, 1),
(43, NULL, 'Nestle Santo Tomas', 'Ruta 11 Km 457, Santo Tomas', 'L0040', 'Santa Fe', 4, NULL, 0, 1, 1),
(44, NULL, 'DepÃ³sito RenÃ© SAI', '', 'L0041', 'San Antonio', 3, NULL, 1, 1, 1),
(45, NULL, 'DepÃ³sito RenÃ© VAP', '', 'L0042', 'Valparaiso', 3, NULL, 1, 1, 1),
(46, NULL, 'GM - ACDELCO Antofa', 'Av. El CoigÃ¼e 450 la portada Antofagasta', 'L0043', 'Antofagasta', 4, NULL, 0, 0, 1),
(47, NULL, 'Moletto - Cliente', 'Walmart - Jumbo', 'L0044', 'Santiago', 4, NULL, 0, 0, 1),
(48, NULL, 'Bodega Simplex Lo Boza', 'Volcan Lascar 801  3D, Pudahuel ', 'L0045', 'Santiago', 2, NULL, 1, 1, 1),
(49, NULL, 'STI (IMO)', 'Pto San Antonio', 'L0046', 'San Antonio', 1, NULL, 1, 1, 1),
(50, NULL, 'ZEAL (IMO)', 'Pto Valparaiso', 'L0047', 'Valparaiso', 1, NULL, 1, 1, 1),
(51, NULL, 'GM - Janssen', 'Panamericana Norte 5353 ConchalÃ­', 'L0048', 'Santiago', 4, NULL, 0, 0, 1),
(52, NULL, 'GM - Dimac', 'Til Til 1980 Ã‘uÃ±oa', 'L0049', 'Santiago', 4, NULL, 0, 0, 1),
(53, NULL, 'Trasvasije', '', 'LS001', 'Santiago', 2, 40, 1, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_medidacontenedor`
--

CREATE TABLE `tb_medidacontenedor` (
  `MED_NCORR` int(11) NOT NULL COMMENT 'Id. del registro',
  `MED_VDESCRIPCION` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Descripción de la medida'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Medida del contenedor';

--
-- Volcado de datos para la tabla `tb_medidacontenedor`
--

INSERT INTO `tb_medidacontenedor` (`MED_NCORR`, `MED_VDESCRIPCION`) VALUES
(1, '20'),
(2, '40'),
(3, '40HC');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_naviera`
--

CREATE TABLE `tb_naviera` (
  `NAV_NCORR` int(11) NOT NULL COMMENT 'Identificador de la naviera',
  `NAV_VNOMBRE` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre de la naviera'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee las navieras registradas en el sistema';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_permiso`
--

CREATE TABLE `tb_permiso` (
  `PER_NCORR` int(11) NOT NULL COMMENT 'Identificador del permiso',
  `ROL_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador del rol de usuario',
  `FUNC_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador de la funcionalidad'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee los permisos de acceso a las funcionalidades';

--
-- Volcado de datos para la tabla `tb_permiso`
--

INSERT INTO `tb_permiso` (`PER_NCORR`, `ROL_NCORR`, `FUNC_NCORR`) VALUES
(1, 1, 11),
(2, 1, 36),
(3, 1, 12),
(4, 1, 13),
(5, 1, 14),
(6, 1, 15),
(7, 1, 31),
(8, 1, 32),
(9, 1, 33),
(10, 1, 34),
(11, 1, 37),
(12, 1, 22),
(13, 1, 21),
(14, 2, 11),
(15, 3, 12),
(16, 3, 13),
(17, 4, 14),
(19, 2, 12),
(21, 2, 22),
(22, 2, 33),
(23, 2, 31),
(24, 2, 35),
(25, 2, 32),
(26, 2, 34),
(27, 3, 22),
(28, 3, 15),
(31, 3, 11),
(32, 3, 14),
(33, 4, 13),
(34, 2, 15),
(35, 2, 13),
(36, 2, 14);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_rolusuario`
--

CREATE TABLE `tb_rolusuario` (
  `ROL_NCORR` int(11) NOT NULL COMMENT 'Identificador del rol de usuario',
  `ROL_VDESCRIPCION` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'DescripciÃ³n del rol de usuario'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee los roles de usuario existentes en el sistem';

--
-- Volcado de datos para la tabla `tb_rolusuario`
--

INSERT INTO `tb_rolusuario` (`ROL_NCORR`, `ROL_VDESCRIPCION`) VALUES
(1, 'Administrador'),
(2, 'Customer Service'),
(3, 'Coordinador transporte'),
(4, 'Monitor de transporte');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_subtiposervicio`
--

CREATE TABLE `tb_subtiposervicio` (
  `STS_NCORR` int(11) NOT NULL COMMENT 'Id. del subtipo de servicio',
  `STS_VNOMBRE` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre del subtipo de servicio',
  `TISE_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de servicio',
  `LUG_NCORR_ORIGEN` int(11) DEFAULT NULL,
  `LUG_NCORR_DESTINO` int(11) DEFAULT NULL,
  `CLIE_VRUT` int(10) NOT NULL,
  `STS_NMONTO` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tb_subtiposervicio`
--

INSERT INTO `tb_subtiposervicio` (`STS_NCORR`, `STS_VNOMBRE`, `TISE_NCORR`, `LUG_NCORR_ORIGEN`, `LUG_NCORR_DESTINO`, `CLIE_VRUT`, `STS_NMONTO`) VALUES
(1, 'T.Importacion', 1, NULL, NULL, 0, 0),
(2, 'T.ExportaciÃ³n', 1, 14, 2, 76056575, 850000),
(3, 'T.Local', 1, 14, 14, 76056575, 920000),
(4, 'TC-26 IMO Indi SAI 20\' dev SCL', 7, 2, 41, 93515000, 240000),
(5, 'TC-29 IMO Indi SAI 40\' dev SCL', 7, 2, 41, 93515000, 240000),
(6, 'TC-32 IMO Indi VAP 20\' dev SCL', 7, 1, 41, 93515000, 286500),
(7, 'TC-35 IMO Indi VAP 40\' dev SCL', 7, 1, 41, 93515000, 286500),
(8, 'TC-62 Normal Indi SAI 20\' dev SCL', 7, 2, 41, 93515000, 215000),
(9, 'TC-65 Normal Indi SAI 40\' dev SCL', 7, 2, 41, 93515000, 215000),
(10, 'TC-68 Normal Indi VAP 20\' dev SCL', 7, 1, 41, 93515000, 225000),
(11, 'TC-71 Normal Indi VAP 40\' dev SCL', 7, 1, 41, 93515000, 225000),
(12, 'Despacho Cliente', 54, 38, 47, 90914000, 150000),
(13, 'Traslado entre Bodegas', 54, 38, 48, 90914000, 130000),
(14, 'prueba', 1, 20, 20, 76056575, 100),
(15, 'Transporte', 29, 42, 43, 55555555, 2800),
(16, 'Trasvasije 20 Std', 70, 53, 53, 93515000, 70000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_tipocarga`
--

CREATE TABLE `tb_tipocarga` (
  `TICA_NCORR` int(11) NOT NULL COMMENT 'Tipo de carga',
  `TICA_VDESCRIPCION` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'DescripciÃ³n del tipo de carga'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tb_tipocarga`
--

INSERT INTO `tb_tipocarga` (`TICA_NCORR`, `TICA_VDESCRIPCION`) VALUES
(1, 'CONTAINER'),
(2, 'CARGA LIBRE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_tipocontacto`
--

CREATE TABLE `tb_tipocontacto` (
  `TCON_NCORR` int(11) NOT NULL COMMENT 'Identificador del tipo de contacto',
  `TCON_VDESCRIPCION` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'DescripciÃ³n del tipo de contacto'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla con tipos de contacto';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_tipocontenedor`
--

CREATE TABLE `tb_tipocontenedor` (
  `TICO_NCORR` int(11) NOT NULL COMMENT 'Identificador de los contenedores',
  `TICO_VDESCRIPCION` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'DescripciÃ³n del tipo de contenedor'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee los distintos tipos de contenedores';

--
-- Volcado de datos para la tabla `tb_tipocontenedor`
--

INSERT INTO `tb_tipocontenedor` (`TICO_NCORR`, `TICO_VDESCRIPCION`) VALUES
(1, 'DRY STANDARD'),
(2, 'DRY REFORZADO'),
(3, 'DRY EXTRA REFORZADO'),
(4, 'TANKTAINER'),
(5, 'REEFER'),
(6, 'DRY'),
(7, 'HIGH CUBE'),
(8, 'REEFER STANDARD'),
(9, 'REEFER HIGH CUBE'),
(99, 'OTROS');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_tipodato`
--

CREATE TABLE `tb_tipodato` (
  `TDA_NCORR` int(11) NOT NULL COMMENT 'Tipo de dato',
  `TDA_VDESCRIPCION` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Descripción del tipo de dato'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tb_tipodato`
--

INSERT INTO `tb_tipodato` (`TDA_NCORR`, `TDA_VDESCRIPCION`) VALUES
(1, 'Integer'),
(2, 'Varchar'),
(3, 'Datetime');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_tipolugar`
--

CREATE TABLE `tb_tipolugar` (
  `TLU_NCORR` int(11) NOT NULL COMMENT 'Identificador del registro',
  `TLU_VDESCRIPCION` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'DescripciÃ³n del tipo de lugar'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tipo de lugar';

--
-- Volcado de datos para la tabla `tb_tipolugar`
--

INSERT INTO `tb_tipolugar` (`TLU_NCORR`, `TLU_VDESCRIPCION`) VALUES
(1, 'PUERTO'),
(2, 'DEPOSITO'),
(3, 'DEPOSITO PUERTO'),
(4, 'CLIENTE'),
(5, 'CIUDAD');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_tiponegocio`
--

CREATE TABLE `tb_tiponegocio` (
  `tine_ncorr` int(11) NOT NULL,
  `tine_vnombre` varchar(100) COLLATE latin1_spanish_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tb_tiponegocio`
--

INSERT INTO `tb_tiponegocio` (`tine_ncorr`, `tine_vnombre`) VALUES
(1, 'Impo Contenedores'),
(2, 'Expo Contenedores'),
(3, 'Tte Nacional'),
(4, 'Tte Internacional (Tierra)'),
(5, 'Tte Internacional (Maritimo)'),
(6, 'Arriendo Equipos'),
(7, 'Distribucion Local'),
(8, 'Servicios a la Carga');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_tiposervicio`
--

CREATE TABLE `tb_tiposervicio` (
  `TISE_NCORR` int(11) NOT NULL COMMENT 'Identificador del tipo de servicio',
  `TINE_NCORR` int(11) NOT NULL,
  `TISE_VDESCRIPCION` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'DescripciÃ³n del tipo de servicio'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee los tipos de servicio disponibles';

--
-- Volcado de datos para la tabla `tb_tiposervicio`
--

INSERT INTO `tb_tiposervicio` (`TISE_NCORR`, `TINE_NCORR`, `TISE_VDESCRIPCION`) VALUES
(1, 1, 'Transporte'),
(2, 1, 'Gate In/Out'),
(3, 1, 'Almacenaje Carga'),
(4, 1, 'Estadia Camion'),
(5, 1, 'Recepcion /Despacho Carga'),
(6, 1, 'Desconsolidacion'),
(7, 1, 'Repalletizado'),
(8, 1, 'Serv. Valor Agr Carga'),
(9, 1, 'Otros'),
(10, 2, 'Transporte'),
(11, 2, 'Gate In/Out'),
(12, 2, 'Almacenaje Carga'),
(13, 2, 'Estadia Camion'),
(14, 2, 'Recepcion /Despacho Carga'),
(15, 2, 'Consolidacion'),
(16, 2, 'Repalletizado'),
(17, 2, 'Serv. Valor Agr Carga'),
(18, 2, 'Otros'),
(19, 3, 'Transporte'),
(20, 3, 'Gate In/Out'),
(21, 3, 'Almacenaje Carga'),
(22, 3, 'Estadia Camion'),
(23, 3, 'Recepcion /Despacho Carga'),
(24, 3, 'Desconsolidacion'),
(25, 3, 'Repalletizado'),
(26, 3, 'Serv. Valor Agr Carga'),
(27, 3, 'Carguio / Descarguio'),
(28, 3, 'Otros'),
(29, 4, 'Transporte'),
(30, 4, 'Estadia Camion'),
(31, 4, 'Seguro'),
(32, 4, 'Gastos Aduaneros'),
(33, 4, 'Custodia'),
(34, 4, 'Representante'),
(35, 4, 'Recepcion /Despacho Carga'),
(36, 4, 'Consolidacion'),
(37, 4, 'Serv. Valor Agr Carga'),
(38, 4, 'Otros'),
(39, 5, 'Transporte'),
(40, 5, 'Estadia Camion'),
(41, 5, 'Seguro'),
(42, 5, 'Gastos Aduaneros'),
(43, 5, 'Custodia'),
(44, 5, 'Representante'),
(45, 5, 'Recepcion /Despacho Carga'),
(46, 5, 'Consolidacion'),
(47, 5, 'Serv. Valor Agr Carga'),
(48, 5, 'Otros'),
(49, 6, 'Traslado'),
(50, 6, 'Arriendo'),
(51, 6, 'Mantencion'),
(52, 6, 'Reparacion'),
(53, 6, 'Otros'),
(54, 7, 'Transporte'),
(55, 7, 'Almacenaje de Carga'),
(56, 7, 'Estadia de camion'),
(57, 7, 'Recepcion /Despacho Carga'),
(58, 7, 'Desconsolidacion'),
(59, 7, 'Repalletizado'),
(60, 7, 'Serv. Valor Agr Carga'),
(61, 7, 'Carguio / Descarguio'),
(62, 7, 'Otros'),
(63, 8, 'Almacenaje Carga'),
(64, 8, 'Recepcion /Despacho Carga'),
(65, 8, 'Desconsolidacion'),
(66, 8, 'Consolidacion'),
(67, 8, 'Repalletizado'),
(68, 8, 'Serv. Valor Agr Carga'),
(69, 8, 'Carguio / Descarguio'),
(70, 8, 'Otros');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_unidadmedida`
--

CREATE TABLE `tb_unidadmedida` (
  `UM_NCORR` int(11) NOT NULL,
  `IM_VDESCRIPCION` varchar(45) COLLATE latin1_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee las distintas unidades de medida';

--
-- Volcado de datos para la tabla `tb_unidadmedida`
--

INSERT INTO `tb_unidadmedida` (`UM_NCORR`, `IM_VDESCRIPCION`) VALUES
(1, 'Unid.'),
(2, 'Tons.'),
(3, 'Pallets'),
(4, 'Bultos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tb_viaje`
--

CREATE TABLE `tb_viaje` (
  `VIA_NCORR` int(11) NOT NULL COMMENT 'Id. del viaje',
  `VIA_VDESCRIPCION` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'DescripciÃ³n del viaje'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tb_viaje`
--

INSERT INTO `tb_viaje` (`VIA_NCORR`, `VIA_VDESCRIPCION`) VALUES
(1, 'VALPARAISO - SANTIAGO'),
(2, 'SAN ANTONIO - SANTIAGO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_camion`
--

CREATE TABLE `tg_camion` (
  `CAM_NCORR` int(11) NOT NULL COMMENT 'Identificador del camion',
  `CAM_VPATENTE` varchar(10) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Patente del camiÃ³n',
  `EMP_NCORR` int(11) NOT NULL,
  `CAM_VMARCA` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL,
  `CAM_VMODELO` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tg_camion`
--

INSERT INTO `tg_camion` (`CAM_NCORR`, `CAM_VPATENTE`, `EMP_NCORR`, `CAM_VMARCA`, `CAM_VMODELO`) VALUES
(1, 'DPRT-98', 1, NULL, NULL),
(2, 'DPRP-56', 1, NULL, NULL),
(3, 'CHHC-39', 1, NULL, NULL),
(4, 'ND-4653', 1, NULL, NULL),
(5, 'DPRT-99', 1, NULL, NULL),
(6, 'DPXP-59', 1, NULL, NULL),
(7, 'VH-1636', 45, NULL, NULL),
(8, 'ABCD12', 5, 'Camion 1', ''),
(9, 'ABCD11', 5, 'Camion 2', ''),
(10, 'FG4142', 48, '', ''),
(11, 'CSDL95', 48, '', ''),
(12, 'FG4142', 49, 'International', '1987'),
(13, 'CSDL95', 49, 'Freightliner', '2000 FLD120'),
(14, 'CT6039', 49, 'Volvo', ' CamiÃ³n de Alexis'),
(15, 'HQV083', 51, 'IVECO', '380'),
(16, 'ABCD123', 54, 'Volvo', 'Volvo'),
(17, 'ABCD12', 54, 'Volvo', 'Volvo'),
(18, 'ABC123', 54, 'Volvo', 'Volvo'),
(19, 'ACB123', 54, 'Volvo', 'Volvo'),
(20, 'ABC123', 54, 'Volvo', 'Volvo'),
(21, 'NH2948', 59, '', ''),
(22, 'FPD-432', 58, 'RENAULT 420P DCI', ''),
(23, 'YD-6392', 58, 'Internacional 2005', ''),
(24, 'YD-6392', 56, 'INTERNATIONAL', 'AÃ±o 2005'),
(25, 'YD-6392', 60, 'International', 'Plano'),
(26, 'NC 7567', 62, '', 'FL 2000');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_carga`
--

CREATE TABLE `tg_carga` (
  `CAR_NCORR` int(11) NOT NULL COMMENT 'Identificador de la carga',
  `CAR_NBOOKING` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'NÂ° de booking de la carga',
  `CAR_VCONTENIDOCARGA` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Contenido de la carga',
  `CAR_NDIASCONTENEDOR` int(11) DEFAULT NULL COMMENT 'DÃ­as del contenedor',
  `CAR_VMARCA` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Marca del contenedor',
  `CAR_VNUMCONTENEDOR` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'NÃºmero del contenedor',
  `CAR_NPESOCARGA` int(11) DEFAULT NULL COMMENT 'Peso de la carga',
  `CAR_VSELLO` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Sello del contenedor',
  `CAR_VOBSERVACIONES` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Observaciones de la carga',
  `TICA_NCORR` int(11) DEFAULT NULL COMMENT 'Tipo de carga',
  `TICO_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador de los contenedores',
  `OSE_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador del registro',
  `ESCA_NCORR` int(11) DEFAULT NULL COMMENT 'Identicador numÃ©rico del estado',
  `ADA_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador de la agencia de aduana',
  `CAR_NCANTIDAD` int(11) DEFAULT NULL,
  `UM_NCORR` int(11) DEFAULT NULL,
  `FACT_NCORR` bigint(20) DEFAULT 0,
  `CAR_VOPERACION` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL,
  `GUIA_NCORR` double DEFAULT 0,
  `LUG_NCORR_ACTUAL` int(11) NOT NULL,
  `LUG_NCORR_DEVOLUCION` int(11) NOT NULL,
  `CAR_FECHADEVOLUCION` date NOT NULL,
  `CAR_FECHAETA` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee los datos de una carga';

--
-- Volcado de datos para la tabla `tg_carga`
--

INSERT INTO `tg_carga` (`CAR_NCORR`, `CAR_NBOOKING`, `CAR_VCONTENIDOCARGA`, `CAR_NDIASCONTENEDOR`, `CAR_VMARCA`, `CAR_VNUMCONTENEDOR`, `CAR_NPESOCARGA`, `CAR_VSELLO`, `CAR_VOBSERVACIONES`, `TICA_NCORR`, `TICO_NCORR`, `OSE_NCORR`, `ESCA_NCORR`, `ADA_NCORR`, `CAR_NCANTIDAD`, `UM_NCORR`, `FACT_NCORR`, `CAR_VOPERACION`, `GUIA_NCORR`, `LUG_NCORR_ACTUAL`, `LUG_NCORR_DEVOLUCION`, `CAR_FECHADEVOLUCION`, `CAR_FECHAETA`) VALUES
(126, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Observaciones', 1, NULL, 55, 5, NULL, NULL, NULL, NULL, '', 0, 2, 0, '0000-00-00', NULL),
(128, '999999', NULL, NULL, NULL, NULL, NULL, NULL, '', 2, NULL, 55, 3, NULL, NULL, NULL, NULL, '45465', 0, 0, 0, '0000-00-00', NULL),
(131, '2222222222', NULL, NULL, NULL, NULL, NULL, NULL, '', 2, NULL, 55, 3, NULL, NULL, NULL, NULL, '333333333', 0, 0, 0, '0000-00-00', NULL),
(133, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Observaciones', 1, NULL, 55, 5, NULL, NULL, NULL, NULL, '', 0, 2, 0, '0000-00-00', NULL),
(137, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Sin observaciones', 1, NULL, 56, 6, NULL, NULL, NULL, NULL, '', 0, 2, 2, '2014-09-19', NULL),
(138, '999999', NULL, NULL, NULL, NULL, NULL, NULL, '', 2, NULL, 56, 6, NULL, NULL, NULL, NULL, '888888', 0, 2, 0, '0000-00-00', NULL),
(139, '1111111', NULL, NULL, NULL, NULL, NULL, NULL, '', 2, NULL, 56, 6, NULL, NULL, NULL, NULL, '222222', 0, 2, 0, '0000-00-00', NULL),
(140, '', NULL, NULL, NULL, NULL, NULL, NULL, '', 2, NULL, 56, 6, NULL, NULL, NULL, NULL, '', 0, 2, 0, '0000-00-00', NULL),
(142, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Sin Observaciones', 1, NULL, 56, 2, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, '0000-00-00', NULL),
(143, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Sin Observaciones 2', 1, NULL, 56, 2, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, '0000-00-00', NULL),
(144, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Sin Observaciones', 1, NULL, 56, 2, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, '0000-00-00', NULL),
(145, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Sin Observaciones 2', 1, NULL, 56, 2, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, '0000-00-00', NULL),
(146, '111', NULL, NULL, NULL, NULL, NULL, NULL, 'observ', 1, NULL, 55, 5, NULL, NULL, NULL, NULL, 'R-15/0109', 0, 2, 0, '0000-00-00', NULL),
(147, '22222', NULL, NULL, NULL, NULL, NULL, NULL, 'Prueba', 2, NULL, 57, 6, NULL, NULL, NULL, NULL, '', 0, 38, 0, '0000-00-00', NULL),
(148, '11111', NULL, NULL, NULL, NULL, NULL, NULL, 'Prueba 2', 2, NULL, 57, 6, NULL, NULL, NULL, NULL, '', 0, 38, 0, '0000-00-00', NULL),
(149, '', NULL, NULL, NULL, NULL, NULL, NULL, '', 2, NULL, 58, 6, NULL, NULL, NULL, NULL, '', 0, 47, 0, '0000-00-00', NULL),
(157, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'EJEMPLO CONTENEDOR 8', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, '0000-00-00', NULL),
(158, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'EJEMPLO CONTENEDOR 9', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, '0000-00-00', NULL),
(159, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'EJEMPLO CONTENEDOR 10', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, '0000-00-00', NULL),
(430, '1111', NULL, NULL, NULL, NULL, NULL, NULL, 'EJEMPLO CONTENEDOR 1', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '222', 0, 0, 0, '0000-00-00', NULL),
(447, '5998', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL001/2015', 2, NULL, 59, 6, NULL, NULL, NULL, NULL, '4548034597', 0, 43, 0, '0000-00-00', NULL),
(448, '5999', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL002/2015', 2, NULL, 59, 6, NULL, NULL, NULL, NULL, '4548035408 ', 0, 43, 0, '0000-00-00', NULL),
(449, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Destino Walmart', 2, NULL, 60, 6, NULL, NULL, NULL, NULL, '', 0, 47, 0, '0000-00-00', NULL),
(450, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Destino Walmart', 2, NULL, 60, 6, NULL, NULL, NULL, NULL, '', 0, 47, 0, '0000-00-00', NULL),
(451, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Destino Walmart', 2, NULL, 60, 3, NULL, NULL, NULL, NULL, '', 0, 0, 0, '0000-00-00', NULL),
(452, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Destino Walmart', 2, NULL, 60, 3, NULL, NULL, NULL, NULL, '', 0, 0, 0, '0000-00-00', NULL),
(453, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Destino Walmart', 2, NULL, 60, 2, NULL, NULL, NULL, NULL, '', 0, 38, 0, '0000-00-00', NULL),
(454, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Destino Walmart', 2, NULL, 60, 3, NULL, NULL, NULL, NULL, '', 0, 0, 0, '0000-00-00', NULL),
(455, '9599', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL001/2015', 2, NULL, 59, 6, NULL, NULL, NULL, NULL, '4549204336 ', 0, 43, 0, '0000-00-00', NULL),
(456, '6000', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL003-2015  25/02/2015', 1, NULL, 59, 2, NULL, NULL, NULL, NULL, '4548035408', 0, 0, 0, '0000-00-00', NULL),
(457, '6000', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL003-2015  25/02/2015', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548035408', 0, 0, 0, '0000-00-00', NULL),
(458, '6000', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL003-2015  25/02/2015', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548035408', 0, 0, 0, '0000-00-00', NULL),
(459, '6000', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL003-2015  25/02/2015', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548035408', 0, 0, 0, '0000-00-00', NULL),
(460, '6001', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL004-2015 11/03/2015', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548392437', 0, 0, 0, '0000-00-00', NULL),
(461, '9332', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL005-2015', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548491844', 0, 0, 0, '0000-00-00', NULL),
(462, '9387', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL006-2015', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548392437', 0, 0, 0, '0000-00-00', NULL),
(463, '9391', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL007-2015 ', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548656455', 0, 0, 0, '0000-00-00', NULL),
(464, '9323', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL027-2015', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548392437', 0, 0, 0, '0000-00-00', NULL),
(465, '9515', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT 001AR-2015  ', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548945643', 0, 0, 0, '0000-00-00', NULL),
(466, '9415', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT OFS0022 2015CL', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548662566', 0, 0, 0, '0000-00-00', NULL),
(467, '9552', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT 002AR2015', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548662566', 0, 0, 0, '0000-00-00', NULL),
(468, '6000', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL003-2015  25/02/2015', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548035408', 0, 0, 0, '0000-00-00', NULL),
(469, '6001', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL004-2015 11/03/2015', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548392437', 0, 0, 0, '0000-00-00', NULL),
(470, '9332', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL005-2015', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548491844', 0, 0, 0, '0000-00-00', NULL),
(471, '9387', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL006-2015', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548392437', 0, 0, 0, '0000-00-00', NULL),
(472, '9391', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL007-2015 ', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548656455', 0, 0, 0, '0000-00-00', NULL),
(473, '9323', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL027-2015', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548392437', 0, 0, 0, '0000-00-00', NULL),
(474, '9515', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT 001AR-2015  ', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548945643', 0, 0, 0, '0000-00-00', NULL),
(475, '9415', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT OFS0022 2015CL', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548662566', 0, 0, 0, '0000-00-00', NULL),
(476, '9552', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT 002AR2015', 1, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548662566', 0, 0, 0, '0000-00-00', NULL),
(486, '6000', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL003-2015  25/02/2015', 2, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548035408', 0, 0, 0, '0000-00-00', NULL),
(487, '6001', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL004-2015 11/03/2015', 2, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548392437', 0, 0, 0, '0000-00-00', NULL),
(488, '9332', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL005-2015', 2, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548491844', 0, 0, 0, '0000-00-00', NULL),
(489, '9387', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL006-2015', 2, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548392437', 0, 0, 0, '0000-00-00', NULL),
(490, '9391', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL007-2015 ', 2, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548656455', 0, 0, 0, '0000-00-00', NULL),
(491, '9323', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL027-2015', 2, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548392437', 0, 0, 0, '0000-00-00', NULL),
(492, '9515', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT 001AR-2015  ', 2, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548945643', 0, 0, 0, '0000-00-00', NULL),
(493, '9415', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT OFS0022 2015CL', 2, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548662566', 0, 0, 0, '0000-00-00', NULL),
(494, '9552', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT 002AR2015', 2, NULL, 55, 2, NULL, NULL, NULL, NULL, '4548662566', 0, 0, 0, '0000-00-00', NULL),
(495, '', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT CL006/2015', 2, NULL, 59, 6, NULL, NULL, NULL, NULL, '', 0, 43, 0, '0000-00-00', NULL),
(496, '10034', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT GEN007CH Aceite', 2, NULL, 59, 2, NULL, NULL, NULL, NULL, '', 0, 42, 0, '0000-00-00', NULL),
(497, '9955', NULL, NULL, NULL, NULL, NULL, NULL, 'CRT 23CINCA2015  HARINA', 2, NULL, 59, 6, NULL, NULL, NULL, NULL, '', 0, 43, 0, '0000-00-00', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_chasis`
--

CREATE TABLE `tg_chasis` (
  `CHA_NCORR` int(11) NOT NULL COMMENT 'id. del chasis',
  `EMP_NCORR` int(11) DEFAULT NULL COMMENT 'Id. de la empresa contratista',
  `CHA_VPATENTE` varchar(10) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Patente del chasis'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee la información de los chasis';

--
-- Volcado de datos para la tabla `tg_chasis`
--

INSERT INTO `tg_chasis` (`CHA_NCORR`, `EMP_NCORR`, `CHA_VPATENTE`) VALUES
(1, 1, 'JG-5352'),
(2, 1, 'JB-8691'),
(3, 1, 'JK-9029'),
(4, 1, 'JL-4077'),
(5, 1, 'JH-9488'),
(6, 1, 'JL-2779'),
(7, 5, 'AABB99'),
(8, 48, 'JD7611'),
(9, 48, 'JD4990'),
(10, 49, 'JD4990'),
(11, 49, 'JD7611'),
(12, 49, 'JD2706'),
(13, 51, 'HQV079'),
(14, 54, 'ABCD123'),
(15, 54, 'CDEF34'),
(16, 54, 'ABC123'),
(17, 54, 'ABC123'),
(18, 54, 'ABC123'),
(19, 54, 'ABC123'),
(20, 59, 'JF9946'),
(21, 58, 'MQT-637'),
(22, 58, 'JM3683'),
(23, 60, 'YD-6392'),
(24, 62, 'JJ 9283');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_chofer`
--

CREATE TABLE `tg_chofer` (
  `CHOF_NCORR` int(11) NOT NULL COMMENT 'Identificador del chofer',
  `CAM_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador del camion',
  `CHOF_VNOMBRE` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre del chofer',
  `CHOF_VRUT` varchar(15) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Rut del chofer',
  `EMP_NCORR` int(11) NOT NULL,
  `CHOF_VFONO` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tg_chofer`
--

INSERT INTO `tg_chofer` (`CHOF_NCORR`, `CAM_NCORR`, `CHOF_VNOMBRE`, `CHOF_VRUT`, `EMP_NCORR`, `CHOF_VFONO`) VALUES
(0, NULL, NULL, NULL, 0, NULL),
(1, 1, 'Alexis Saez', '9.215.011-9', 1, '66997013'),
(2, 2, 'Alvaro Aguilera', '14.188.154-K', 1, '66997012'),
(3, 3, 'Carlos Baeza', '11.661.426-K', 1, '79980176'),
(4, 4, 'Carlos Coloma', '6.702.809-0', 1, '66997009'),
(5, 5, 'Claudio Monserrat', '9.497.207-8', 1, '72780161'),
(6, 6, 'Elias Correa', '10.512.503-8', 1, '94199518'),
(7, NULL, 'Nombre 1', '11111111-1', 5, '111'),
(8, NULL, 'Alexis Gajardo', '17.980.526-k', 48, ''),
(9, NULL, 'German Oyarce', '16.555.759-k', 48, ''),
(10, NULL, 'Alexis Gajardo', '17.980.526-k', 49, '65628370'),
(11, NULL, 'GermÃ¡n Oyarce', '16.555.795-k', 49, '97035630'),
(12, NULL, 'Juan Oyarce', '10.161.180-9', 49, '90113083'),
(13, NULL, 'Marco Aguero', '', 51, '54*785*5672'),
(14, NULL, 'Chofer', '12345678-9', 54, '55555555'),
(15, NULL, 'Juan Mena', '12345678-9', 54, '11111111'),
(16, NULL, 'Juan Mena', '12345678-9', 54, '22222222'),
(17, NULL, 'Ariel Valenti', '12345678-9', 54, '22222222'),
(18, NULL, 'Daniel Garay', '12345678-9', 54, '11111111'),
(19, NULL, 'Carlos Riffo', '8.304.040-8', 59, '98626823'),
(20, NULL, 'DANIEL GARAY', '25.329.952', 58, '54*483*1593 '),
(21, NULL, 'NORBERTO DANIEL GARAY ', '25329952', 56, ''),
(22, NULL, 'NORBERTO DANIEL GARAY CEDULA ', '25329952', 60, ''),
(23, NULL, 'Stefano Tatti Lomboy', '12.274.710-7', 62, '222222222');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_contactocarga`
--

CREATE TABLE `tg_contactocarga` (
  `COCA_NCORR` int(11) NOT NULL COMMENT 'Identificador del registro',
  `TCON_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de contacto',
  `CAR_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador de la carga',
  `COCA_VNOMBRE` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre del contacto',
  `COCA_VFONO` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Fono de contacto'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla con contactos asociados a una carga';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_contacto_agencia`
--

CREATE TABLE `tg_contacto_agencia` (
  `CADA_NCORR` int(11) NOT NULL COMMENT 'Id. del contacto',
  `ADA_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador de la agencia de aduana',
  `CADA_VNOMBRE` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre del contacto',
  `CADA_VFONO` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Fono del contacto',
  `CADA_VMAIL` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Mail de contacto'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee los contactos en las agencias de aduana';

--
-- Volcado de datos para la tabla `tg_contacto_agencia`
--

INSERT INTO `tg_contacto_agencia` (`CADA_NCORR`, `ADA_NCORR`, `CADA_VNOMBRE`, `CADA_VFONO`, `CADA_VMAIL`) VALUES
(1, 1, 'Contacto A.D.A 1', '534645645', 'contacto@ada.cl'),
(2, 1, 'Contacto A.D.A 2', '5434654', 'contacto2@ada.cl');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_detallefactura`
--

CREATE TABLE `tg_detallefactura` (
  `DEFA_NCORR` double NOT NULL COMMENT 'Id. del detalle de la factura',
  `FACT_NCORR` bigint(20) DEFAULT NULL COMMENT 'Id. de la factura',
  `CAR_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador de la carga',
  `DEFA_MONTO` double DEFAULT NULL COMMENT 'Monto a cobrar'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_empresatransporte`
--

CREATE TABLE `tg_empresatransporte` (
  `EMP_NCORR` int(11) NOT NULL COMMENT 'Id. de la empresa contratista',
  `EMP_VNOMBRE` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre de la empresa contratista',
  `EMP_VRUT` varchar(15) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Rut de la empresa contratista',
  `EMP_VDIRECCION` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Dirección',
  `EMP_VGIRO` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Giro',
  `EMP_VCONTACTO` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL,
  `EMP_VFONO` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL,
  `EMP_VMAIL` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL,
  `EMP_VRAZONSOCIAL` varchar(100) COLLATE latin1_spanish_ci NOT NULL,
  `EMP_VACTIVIDAD` varchar(100) COLLATE latin1_spanish_ci NOT NULL,
  `EMP_NGENERAGUIA` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Posee las empresas de transporte que prestan servicios.';

--
-- Volcado de datos para la tabla `tg_empresatransporte`
--

INSERT INTO `tg_empresatransporte` (`EMP_NCORR`, `EMP_VNOMBRE`, `EMP_VRUT`, `EMP_VDIRECCION`, `EMP_VGIRO`, `EMP_VCONTACTO`, `EMP_VFONO`, `EMP_VMAIL`, `EMP_VRAZONSOCIAL`, `EMP_VACTIVIDAD`, `EMP_NGENERAGUIA`) VALUES
(2, 'Sociedad Servicios Maritimos ltda.', '79730700-9', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(3, 'Transportes  Altas Cumbres S.A.', '96756150-9', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(4, 'Mario Antonio Zepeda Alvarez', '2979737-4', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(5, 'Alex Tomas Gonzalez', '13456262-5', 'Direccion', 'Transporte', 'Contacto', 'Fono', 'mail', 'Alex Tomas Gonzalez', 'Actividad', 1),
(6, 'JOSE IGNACIO SAEZ GUINEZ TRANSPORTES E.I.R.L.', '76346090-8', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(8, 'Comercial Karina Aranguiz Galleguillos EIRL', '76024082-6', '', 'Transporte', '', '', '', '', '', 0),
(9, 'Daniel Pavez Tapia', '3934695-8', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(10, 'Elza Ines Sanzi e hijos Ltda', '78773020-5', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(11, 'Enrique Ahumada Silva', '5561448-2', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(12, 'Guillermo Rafael Arenas Peraz', '7496709-4', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(13, 'Gustavo  Cabeza', '76097101-4', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(14, 'Hector Pacheco', '11970188-0', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(15, 'Inmobiliaria Transporte la Portena', '76052817-k', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(16, 'Inmobiliria e inversiones  Sta. Catalina Ltda.', '76679510-2', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(17, 'Juan Carlos Alvear gil', '6297205-k', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(18, 'Karina Aranguiz', '76024082-6', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(19, 'Lorena Villaviciencio Hidalgo', '13369014-k', NULL, 'Trasnporte', NULL, NULL, NULL, '', '', 0),
(20, 'Manuel Alvarez', '2979737-4', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(21, 'Maria Alejandra Soto diaz', '7859957-K', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(22, 'Sociedad Trancarrasco y CIA. Ltda.', '76790550-5', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(23, 'Transporte de Contenedores de Chile SA', '76566490-K', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(24, 'Transporte Logistica Placilla 88', '76116595-k', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(25, 'Transporte RVE Ltda.', '77889320-7', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(26, 'Transportes Andreu Ltda.', '78763220-3', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(27, 'Transportes Lamber', '76023010-3', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(28, 'Transportes Nunez Roco CIA.Ltda.', '76160610-7', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(29, 'Trujillo Ltda.', '76123750-0', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(30, 'Transportes Pia Ltda.', '76018-663-5', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(31, 'RUBEN VINUELA', '78293170-9', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(32, 'CECILIA MATILDE RIVEROS MARIN', '7293295-1', '', 'Transporte', '', '', '', 'áñ', '', 1),
(33, 'ELIZABETH CECILIA SANTANDER RAMOS', '15.352.588-9', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(35, 'GONZALO ANDRES CATALAN MORA', '13.032.501-7', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(36, 'LEONARDO ANTONIO SANTA MARIA GAETE', '9.586.936-K', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(37, 'MIREYA CORINA CARRENO MARIN', '17.680.889-6', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(38, 'ROSA EDELMIRA ALIAGA BAEZA', '5.896.223-6', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(39, 'SEGUNDO ALEJANDRO CASTILLO MARTINEZ', '5.084.348-3', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(40, 'SONIA ELENA BRAVO ACUNA', '7.430.867-8', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(41, 'MANUEL ALVAREZ MUNOZ', '5.904.754-K', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(43, 'IVAN ALEJANDRO VEGA OLATE', '12.832.986-2', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(44, 'T. NATALIA DEL CARMEN VERA URRA EIRL.', '76.037.113-0', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(45, 'SOTRACON LTDA.', '78.999.370-K', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(46, 'ENRIQUE FELIPE ZANETTA TELLO', '14.093.226-4', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(49, 'German Andres Oyarce Ramirez', '16555759-k', '', 'Transporte de Carga', 'Germán Oyarce', ' 56 (9) 50005570', 'transportes_agm@live.cl', 'German Andres Oyarce Ramirez', 'Transporte con  Rampla', 0),
(50, 'Servicios San Fabian', '96979980-4', 'Longitudinal Sur km 202 3 - Molina', 'Transporte de Carga por Carretera', 'Joel Salamanca', '752472120', '', 'Servicios San Fabian', 'Transporte y Alamcenaje de Cnt', 1),
(51, 'AMV Transportes Ltda', '76303924-2', 'Carretera Los Libertadores N 415 - Depto B5, Los Andes', 'Transporte Nacional e Interancional de carga', 'Larry Salazar', '', 'intraml@gmail.com', 'AMV Transportes Ltda', 'Transporte por carretera', 0),
(52, 'Simplex Logistica', '76220905-5', 'General Holley 2363 A 1301', 'Servicios Logisticos y Transporte', 'yo', '', '', 'Simplex Inversiones Spa', 'Transporte y Logistica', 1),
(54, 'Logistica CIMCA SA', '22222222-2', '', 'Transporte Internacional', '', '', '', 'Logistica CIMCA SA', '33-71229872-9', 0),
(55, 'Jose Rodrigo Calderon', '12.817.665-9', '', 'Transporte Internaiconal', '', '', '', 'Jose Rodrigo Calderon', 'Transporte Internaiconal', 0),
(56, 'J L T Transporte y  Logistica', '33333333-3', '', 'Transporte y  Logistica', '', '', '', 'J L T Transporte y  Logistica', '20-13533975-0', 0),
(57, 'Trans Fer', '44444444-4', '', 'Transporte Internacional', '', '', '', 'Transportes Fernandez', '20-08154383-7', 0),
(58, 'Fardaos', '66666666-6', '', 'Transporte Nacional', '', '', '', 'Fardaos', '20-08154383-7', 0),
(59, 'Carlos Riffo', '11.403.788-5', '', 'Transporte de Carga por carretera', 'Carlos Riffo', '', 'gabriela.ogaz.aguilera@gmail.com', 'Gabriela Esperanza Ogaz Aguilera', 'Transporte de Carga por carretera', 0),
(60, 'Transportes Tornello', '76440124-7 ', 'PUERTO TERRESTRE LOS ANDES OFICINA 332 EL SAUCE LOS ANDES', 'Transporte Terrestre', 'José Luis Tornello', '', '', 'EMPRESA SOCIEDAD COMERCIAL TRANSPORTES TRANS JR LI', 'Transporte Internacional y Nacional', 0),
(61, 'Mauricio Arriagada', '11111111-1', '', '', '', '', '', 'Mauricio Arriagada', '', 0),
(62, 'Transportes Generales Cia', '79.753.140-5', 'Av. Irarrazabal 0180', 'Transporte Internacional', 'Angel Gamaro', '', '', 'Transportes Generales', 'Transporte', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_factura`
--

CREATE TABLE `tg_factura` (
  `FACT_NCORR` bigint(20) NOT NULL COMMENT 'Id. de la factura',
  `FACT_DFECHA` date DEFAULT NULL COMMENT 'Fecha de la factura',
  `FACT_NUMFACTURA` double DEFAULT NULL,
  `ESFA_NCORR` int(11) DEFAULT 1,
  `FACT_NTOTAL` double DEFAULT NULL,
  `FACT_NIVA` double DEFAULT NULL,
  `FACT_NSUBTOTAL` double DEFAULT NULL,
  `FACT_NDESCUENTO` double DEFAULT NULL,
  `FACT_VOBSERVACIONES` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee la informaciÃ³n asociada a la factura';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_guiatransporte`
--

CREATE TABLE `tg_guiatransporte` (
  `guia_ncorr` double NOT NULL,
  `guia_dfecha` date DEFAULT NULL,
  `guia_numero` double DEFAULT 0,
  `guia_ntipo` int(11) DEFAULT 0,
  `EMP_NCORR` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tg_guiatransporte`
--

INSERT INTO `tg_guiatransporte` (`guia_ncorr`, `guia_dfecha`, `guia_numero`, `guia_ntipo`, `EMP_NCORR`) VALUES
(37, '2014-09-18', 124346, 1, 5),
(38, '2014-09-18', 9867587, 1, 5),
(39, '2014-09-25', 11133, 1, 5),
(40, '2014-09-25', 12345, 1, 5),
(41, '2014-09-25', 98765, 1, 5),
(42, '2014-09-25', 7777, 1, 5),
(43, '2014-09-24', 66666, 1, 5),
(44, '2015-04-02', 100, 1, 52),
(45, '2015-04-02', 100, 1, 52),
(46, '2015-04-02', 101, 1, 52),
(47, '2015-04-02', 101, 1, 52),
(48, '2015-04-02', 1111, 1, 52);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_hito`
--

CREATE TABLE `tg_hito` (
  `HITO_NCORR` decimal(10,0) NOT NULL COMMENT 'Id. del hito',
  `TRA_NCORR` int(11) DEFAULT NULL COMMENT 'Id. del tramo',
  `HITO_VNOMBRE` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre del hito',
  `HITO_KM` decimal(10,0) DEFAULT NULL COMMENT 'Kilometraje recorrido',
  `HITO_TIEMPOVIAJE` decimal(10,0) DEFAULT NULL COMMENT 'Tiempo de viaje (Minutos)',
  `HITO_INCIAL` int(11) DEFAULT NULL,
  `HITO_FINAL` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee los hitos asociados los tramos de viajes exi';

--
-- Volcado de datos para la tabla `tg_hito`
--

INSERT INTO `tg_hito` (`HITO_NCORR`, `TRA_NCORR`, `HITO_VNOMBRE`, `HITO_KM`, `HITO_TIEMPOVIAJE`, `HITO_INCIAL`, `HITO_FINAL`) VALUES
(1, 1, 'Inicio', 0, 0, 1, 0),
(2, 1, 'Peaje', 50, 45, 0, 0),
(3, 1, 'Termino', 80, 70, 0, 1),
(4, 2, 'Peaje', 20, 40, 0, 0),
(5, 2, 'Inicio', 0, 0, 1, 0),
(6, 2, 'Termino', 40, 80, 0, 1),
(7, 3, 'Inicio', 0, 0, 1, 0),
(8, 3, 'Control 1', 20, 30, 0, 0),
(9, 3, 'Termino', 90, 130, 0, 1),
(10, 3, 'Control 2', 40, 80, 0, 0),
(11, 3, 'Control 3', 70, 110, 0, 0),
(12, 7, 'Inicio', 0, 0, 1, 0),
(13, 7, 'Termino', 135, 130, 0, 1),
(14, 8, 'Inicio', 0, 0, 1, 0),
(15, 8, 'Termino', 105, 100, 0, 1),
(16, 9, 'Inicio', 0, 0, 1, 0),
(17, 9, 'Termino', 35, 50, 0, 1),
(18, 10, 'Inicio', 0, 0, 1, 0),
(19, 10, 'Termino', 1550, 8640, 0, 1),
(22, 12, 'Inicio', 0, 0, 1, 0),
(23, 12, 'Termino', 20, 30, 0, 1),
(24, 13, 'Inicio', 0, 0, 1, 0),
(25, 13, 'Termino', 40, 40, 0, 1),
(28, 5, 'Punto 1', 0, 0, 1, 0),
(29, 5, 'Punto 3', 10, 10, 0, 0),
(30, 5, 'Punto fin', 20, 20, 0, 1),
(31, 15, 'Inicio', 0, 0, 1, 0),
(32, 15, 'Termino', 135, 130, 0, 1),
(33, 16, 'Inicio', 0, 0, 1, 0),
(34, 16, 'Termino', 135, 130, 0, 1),
(35, 17, 'Inicio', 0, 0, 1, 0),
(36, 17, 'Termino', 30, 30, 0, 1),
(37, 18, 'Inicio', 0, 0, 1, 0),
(38, 18, 'Termino', 45, 45, 0, 1),
(39, 19, 'Inicio', 0, 0, 1, 0),
(40, 19, 'Termino', 1400, 999, 0, 1),
(41, 20, 'Inicio', 0, 0, 1, 0),
(42, 20, 'Termino', 60, 20, 0, 1),
(43, 10, 'Aduana Los Andes', 247, 1440, 0, 0),
(44, 10, 'Aduana Uspallata', 336, 2880, 0, 0),
(45, 10, 'Aduana Santa Fe', 1470, 5760, 0, 0),
(46, 21, 'Inicio', 0, 0, 1, 0),
(47, 21, 'Termino', 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_hitocontrolado`
--

CREATE TABLE `tg_hitocontrolado` (
  `HICO_NCORR` decimal(10,0) NOT NULL COMMENT 'Id. del control',
  `SERV_NCORR` int(11) DEFAULT NULL COMMENT 'Id. de la programación',
  `HITO_NCORR` decimal(10,0) DEFAULT NULL COMMENT 'Id. del hito',
  `HICO_HORAPLAN` datetime DEFAULT NULL COMMENT 'Hora planeada',
  `HICO_HORAREAL` datetime DEFAULT NULL COMMENT 'Hora real'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Hito controlado de un servicio';

--
-- Volcado de datos para la tabla `tg_hitocontrolado`
--

INSERT INTO `tg_hitocontrolado` (`HICO_NCORR`, `SERV_NCORR`, `HITO_NCORR`, `HICO_HORAPLAN`, `HICO_HORAREAL`) VALUES
(1, 91, 18, '2015-01-20 10:10:00', '2015-01-20 09:00:00'),
(2, 91, 43, '2015-01-21 10:10:00', '2015-01-21 10:07:00'),
(3, 91, 44, '2015-01-22 10:10:00', '2015-01-22 10:28:00'),
(4, 91, 45, '2015-01-24 10:10:00', '2015-01-24 10:07:00'),
(5, 85, 5, '2015-04-02 20:00:00', '2015-04-02 20:12:00'),
(6, 89, 5, '2015-06-15 15:00:00', '2015-06-15 14:32:00'),
(7, 85, 4, '2015-04-02 20:40:00', '2015-04-02 20:55:00'),
(8, 99, 18, '2015-11-03 00:00:00', '0000-00-00 00:00:00'),
(9, 103, 2, '2014-09-02 18:45:00', '0000-00-00 00:00:00'),
(10, 103, 1, '2014-09-02 18:00:00', '0000-00-00 00:00:00'),
(11, 103, 3, '2014-09-02 19:10:00', '0000-00-00 00:00:00'),
(12, 102, 1, '2014-09-28 19:00:00', '2014-09-28 19:00:00'),
(13, 101, 1, '2014-09-28 17:06:00', '2014-09-28 17:06:00'),
(14, 101, 2, '2014-09-28 17:51:00', '2014-09-28 17:55:00'),
(15, 102, 2, '2014-09-28 19:45:00', '2014-09-28 19:45:00'),
(16, 102, 3, '2014-09-28 20:10:00', '2014-09-28 20:00:00'),
(17, 101, 3, '2014-09-28 18:16:00', '2014-09-28 19:00:00'),
(18, 95, 43, '2015-06-18 14:00:00', '2015-06-18 14:00:00'),
(19, 91, 19, '2015-01-26 10:10:00', '2015-01-26 10:10:00'),
(20, 85, 6, '2015-04-02 21:20:00', '2015-04-02 21:20:00'),
(21, 95, 19, '2015-06-23 14:00:00', '2015-04-02 21:20:00'),
(22, 97, 19, '2015-10-15 13:00:00', '2015-10-15 13:00:00'),
(23, 89, 6, '2015-06-15 16:20:00', '2015-06-15 16:20:00'),
(24, 99, 19, '2015-11-09 00:00:00', '2015-11-09 00:00:00'),
(25, 98, 9, '2015-11-25 16:10:00', '2015-11-25 16:10:00'),
(26, 147, 6, '2016-01-25 10:20:00', '2016-01-25 11:00:00'),
(27, 146, 5, '2016-01-22 09:00:00', '2016-01-22 09:10:00'),
(28, 147, 4, '2016-01-25 09:40:00', '2016-01-25 09:50:00'),
(29, 147, 5, '2016-01-25 09:00:00', '2016-01-25 09:10:00'),
(30, 146, 4, '2016-01-22 09:40:00', '2016-01-22 09:55:00'),
(31, 146, 6, '2016-01-22 10:20:00', '2016-01-22 10:50:00'),
(32, 148, 5, '2016-01-26 08:00:00', '2016-01-26 09:00:00'),
(33, 148, 4, '2016-01-26 08:40:00', '2016-01-26 09:10:00'),
(34, 96, 24, '2015-06-19 10:00:00', '2015-06-19 10:00:00'),
(35, 149, 24, '2015-06-16 10:00:00', '2015-06-16 10:00:00'),
(36, 151, 24, '2015-06-16 10:00:00', '2015-06-16 10:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_info_adicional`
--

CREATE TABLE `tg_info_adicional` (
  `CAR_NCORR` int(11) NOT NULL COMMENT 'Identificador de la carga',
  `CAR_NTEMPERATURA` int(11) DEFAULT NULL COMMENT 'Temperatura requerida para la carga',
  `CAR_NVENTILACION` int(11) DEFAULT NULL COMMENT 'VentilaciÃ³n requerida por la carga ',
  `CAR_VOTROS` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL,
  `CAR_VOBSERVACIONES` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee informaciÃ³n adicional de la carga';

--
-- Volcado de datos para la tabla `tg_info_adicional`
--

INSERT INTO `tg_info_adicional` (`CAR_NCORR`, `CAR_NTEMPERATURA`, `CAR_NVENTILACION`, `CAR_VOTROS`, `CAR_VOBSERVACIONES`) VALUES
(146, 10, 20, 'otros', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_info_cargalibre`
--

CREATE TABLE `tg_info_cargalibre` (
  `CAR_NCORR` int(11) NOT NULL COMMENT 'Identificador de la carga',
  `UM_NCORR` int(11) DEFAULT NULL COMMENT 'Id.',
  `CAR_CANTIDAD` int(11) DEFAULT NULL COMMENT 'Cantida'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee los datos asociados a la información de carg';

--
-- Volcado de datos para la tabla `tg_info_cargalibre`
--

INSERT INTO `tg_info_cargalibre` (`CAR_NCORR`, `UM_NCORR`, `CAR_CANTIDAD`) VALUES
(447, 3, 20),
(468, 2, 20),
(470, 2, 28),
(469, 2, 20),
(138, 3, 10),
(139, 4, 100),
(140, 4, 100),
(147, 3, 28),
(148, 1, 1),
(149, 1, 1),
(379, 1, 11),
(380, 1, 12),
(381, 1, 13),
(382, 1, 14),
(383, 1, 15),
(384, 1, 16),
(385, 1, 17),
(386, 1, 18),
(387, 1, 19),
(388, 1, 20),
(389, 1, 21),
(390, 1, 22),
(391, 1, 23),
(392, 1, 24),
(393, 1, 25),
(394, 1, 26),
(395, 1, 27),
(396, 1, 28),
(397, 1, 29),
(486, 2, 20),
(487, 2, 20),
(488, 2, 28),
(489, 2, 20),
(490, 2, 28),
(491, 2, 20),
(492, 2, 28),
(493, 2, 20),
(494, 2, 20),
(476, 2, 20),
(475, 2, 20),
(474, 2, 28),
(473, 2, 20),
(472, 2, 28),
(471, 2, 20),
(448, 3, 20),
(449, 1, 1),
(450, 1, 1),
(451, 1, 1),
(452, 1, 1),
(453, 1, 1),
(454, 1, 1),
(455, 3, 20),
(459, 2, 20),
(460, 2, 20),
(461, 2, 28),
(462, 2, 20),
(463, 2, 28),
(464, 2, 20),
(465, 2, 28),
(466, 2, 20),
(467, 2, 20),
(495, 3, 20),
(496, 3, 20),
(497, 3, 20);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_info_consolidacion`
--

CREATE TABLE `tg_info_consolidacion` (
  `CAR_NCORR` int(11) NOT NULL COMMENT 'Identificador de la carga',
  `CAR_VCONTACTO` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre de contacto',
  `CAR_DFECHA` date DEFAULT NULL COMMENT 'Fecha de consolidaciÃ³n',
  `LUG_NCORR_CONSOLIDACION` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee la informaciÃ³n de consolidaciÃ³n';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_info_container`
--

CREATE TABLE `tg_info_container` (
  `CAR_NCORR` int(11) NOT NULL COMMENT 'Identificador de la carga',
  `CONT_VMARCA` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Marca del conteiner',
  `CONT_VNUMCONTENEDOR` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'NÂ° de contenedor',
  `CONT_VCONTENIDO` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Contenido del contenedor',
  `CONT_DTERMINOSTACKING` date DEFAULT NULL COMMENT 'Termino de stacking',
  `CONT_NDIASLIBRES` int(11) DEFAULT NULL COMMENT 'DÃ­as libres del contenedor',
  `CONT_VSELLO` varchar(30) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Sello del contenedor',
  `LUG_NCORR_DEVOLUCION` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar',
  `CONT_VSELLO2` varchar(30) COLLATE latin1_spanish_ci DEFAULT NULL,
  `CONT_VOBSERVACIONSELLO` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL,
  `CONT_VOBSERVACIONSELLO2` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL,
  `ADA_NCORR` int(11) DEFAULT NULL,
  `CONT_NPESO` int(11) DEFAULT NULL,
  `MED_NCORR` int(11) DEFAULT NULL,
  `COND_NCORR` int(11) DEFAULT NULL,
  `CADA_NCORR` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tg_info_container`
--

INSERT INTO `tg_info_container` (`CAR_NCORR`, `CONT_VMARCA`, `CONT_VNUMCONTENEDOR`, `CONT_VCONTENIDO`, `CONT_DTERMINOSTACKING`, `CONT_NDIASLIBRES`, `CONT_VSELLO`, `LUG_NCORR_DEVOLUCION`, `CONT_VSELLO2`, `CONT_VOBSERVACIONSELLO`, `CONT_VOBSERVACIONSELLO2`, `ADA_NCORR`, `CONT_NPESO`, `MED_NCORR`, `COND_NCORR`, `CADA_NCORR`) VALUES
(137, '', 'MSKU1234565', '', '0000-00-00', 0, 'rp3945858', 0, NULL, NULL, NULL, 1, 8000, 1, 9, 0),
(146, 'marca', 'PONU7272773', 'contenido', '0000-00-00', 30, '0000', 0, NULL, NULL, NULL, 1, 10000, 2, 3, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_info_traslado`
--

CREATE TABLE `tg_info_traslado` (
  `CAR_NCORR` int(11) NOT NULL COMMENT 'Identificador de la carga',
  `LUG_NCORR_DESTINO` int(11) DEFAULT NULL COMMENT 'Lugar de destino',
  `LUG_NCORR_RETIRO` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar',
  `CAR_DFECHARETIRO` date DEFAULT NULL COMMENT 'Fecha de retiro',
  `CAR_DFECHAPRESENTACION` date DEFAULT NULL COMMENT 'Fecha de presentaciÃ³n',
  `CAR_VCONTACTOENTREGA` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Contacto de entrega'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee la informaciÃ³n asociada al traslado de carg';

--
-- Volcado de datos para la tabla `tg_info_traslado`
--

INSERT INTO `tg_info_traslado` (`CAR_NCORR`, `LUG_NCORR_DESTINO`, `LUG_NCORR_RETIRO`, `CAR_DFECHARETIRO`, `CAR_DFECHAPRESENTACION`, `CAR_VCONTACTOENTREGA`) VALUES
(137, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(138, NULL, NULL, '0000-00-00', '0000-00-00', 'Camilo'),
(139, NULL, NULL, '0000-00-00', '0000-00-00', 'Medicamentos'),
(140, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(146, NULL, NULL, '0000-00-00', '0000-00-00', 'contacto'),
(147, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(148, NULL, NULL, '0000-00-00', '0000-00-00', 'Jumbo'),
(149, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(447, NULL, NULL, '0000-00-00', '0000-00-00', 'Cristian León'),
(448, NULL, NULL, '0000-00-00', '0000-00-00', 'Cristian León'),
(449, NULL, NULL, '0000-00-00', '0000-00-00', 'Victor Jara'),
(450, NULL, NULL, '0000-00-00', '0000-00-00', 'Victor Jara'),
(451, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(452, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(453, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(454, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(455, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(495, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(496, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(497, NULL, NULL, '0000-00-00', '0000-00-00', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_log`
--

CREATE TABLE `tg_log` (
  `log_ncorr` int(11) NOT NULL,
  `log_vdescripcion` varchar(500) COLLATE latin1_spanish_ci DEFAULT NULL,
  `log_fecha` date DEFAULT NULL,
  `log_dhora` time DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tg_log`
--

INSERT INTO `tg_log` (`log_ncorr`, `log_vdescripcion`, `log_fecha`, `log_dhora`) VALUES
(229, 'paso 1', NULL, NULL),
(230, 'paso 3', NULL, NULL),
(231, 'paso 4', NULL, NULL),
(232, 'paso 1', NULL, NULL),
(233, 'paso 4', NULL, NULL),
(234, 'paso 1', NULL, NULL),
(235, 'paso 3', NULL, NULL),
(236, 'paso 4', NULL, NULL),
(237, 'paso 1', NULL, NULL),
(238, 'paso 4', NULL, NULL),
(239, 'paso 1', NULL, NULL),
(240, 'paso 4', NULL, NULL),
(241, 'paso 1', NULL, NULL),
(242, 'paso 3', NULL, NULL),
(243, 'paso 4', NULL, NULL),
(244, 'paso 1', NULL, NULL),
(245, 'paso 4', NULL, NULL),
(246, 'paso 1', NULL, NULL),
(247, 'paso 4', NULL, NULL),
(248, 'paso 1', NULL, NULL),
(249, 'paso 3', NULL, NULL),
(250, 'paso 4', NULL, NULL),
(251, 'paso 1', NULL, NULL),
(252, 'paso 4', NULL, NULL),
(253, 'paso 1', NULL, NULL),
(254, 'paso 4', NULL, NULL),
(255, 'paso 1', NULL, NULL),
(256, 'paso 4', NULL, NULL),
(257, 'paso 1', NULL, NULL),
(258, 'paso 4', NULL, NULL),
(259, 'paso 1', NULL, NULL),
(260, 'paso 3', NULL, NULL),
(261, 'paso 4', NULL, NULL),
(262, 'paso 1', NULL, NULL),
(263, 'paso 3', NULL, NULL),
(264, 'paso 4', NULL, NULL),
(265, 'paso 1', NULL, NULL),
(266, 'paso 3', NULL, NULL),
(267, 'paso 4', NULL, NULL),
(268, 'paso 1', NULL, NULL),
(269, 'paso 4', NULL, NULL),
(270, 'paso 1', NULL, NULL),
(271, 'paso 4', NULL, NULL),
(272, 'paso 1', NULL, NULL),
(273, 'paso 4', NULL, NULL),
(274, 'paso 1', NULL, NULL),
(275, 'paso 4', NULL, NULL),
(276, 'paso 1', NULL, NULL),
(277, 'paso 4', NULL, NULL),
(278, 'paso 1', NULL, NULL),
(279, 'paso 4', NULL, NULL),
(280, 'paso 1', NULL, NULL),
(281, 'paso 4', NULL, NULL),
(282, 'paso 1', NULL, NULL),
(283, 'paso 4', NULL, NULL),
(284, 'paso 1', NULL, NULL),
(285, 'paso 4', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_mapeoimportacion`
--

CREATE TABLE `tg_mapeoimportacion` (
  `MIM_NCORR` int(11) NOT NULL COMMENT 'Id. de registro',
  `PIM_NCORR` int(11) DEFAULT NULL COMMENT 'Id. del proceso de importacion',
  `MIM_NORDEN` int(11) DEFAULT NULL COMMENT 'Orden de presentación en la importación',
  `TDA_NCORR` int(11) DEFAULT NULL COMMENT 'Tipo de dato',
  `MIM_VLABEL` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Label',
  `MIM_NLARGO` int(11) DEFAULT NULL COMMENT 'Largo máximo del campo',
  `MIM_VNOMBRECAMPO` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre del campo de la tabla de base de datos',
  `MIM_VTABLABD` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre de la tabla de base de datos'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tg_mapeoimportacion`
--

INSERT INTO `tg_mapeoimportacion` (`MIM_NCORR`, `PIM_NCORR`, `MIM_NORDEN`, `TDA_NCORR`, `MIM_VLABEL`, `MIM_NLARGO`, `MIM_VNOMBRECAMPO`, `MIM_VTABLABD`) VALUES
(1, 1, 1, 1, 'Estado', 0, 'ESCA_NCORR', 'tg_carga'),
(2, 1, 2, 1, 'Cantidad', 0, 'CAR_NCANTIDAD', 'tg_carga'),
(3, 1, 3, 1, 'Tipo carga', 0, 'TICA_NCORR', 'tg_carga'),
(4, 1, 4, 2, 'Operacion', 100, 'CAR_VOPERACION', 'tg_carga'),
(5, 1, 5, 1, 'N° booking', 100, 'CAR_NBOOKING', 'tg_carga'),
(6, 1, 6, 2, 'Observaciones', 200, 'CAR_VOBSERVACIONES', 'tg_carga');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_ordenservicio`
--

CREATE TABLE `tg_ordenservicio` (
  `OSE_NCORR` int(11) NOT NULL COMMENT 'Identificador del registro',
  `OSE_DFECHASERVICIO` datetime DEFAULT NULL COMMENT 'Fecha de servicio',
  `OSE_VNOMBRENAVE` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre de la nave',
  `OSE_VOBSERVACIONES` varchar(500) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Observaciones',
  `CLIE_VRUT` varchar(20) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Identificador del cliente',
  `NAV_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador de la naviera',
  `USUA_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador de la ciudad',
  `TISE_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de servicio',
  `LUG_NCORRORIGEN` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar',
  `VIA_NCORR` int(11) DEFAULT NULL COMMENT 'Id. del viaje',
  `CLIE_VRUTSUBCLIENTE` varchar(20) COLLATE latin1_spanish_ci DEFAULT NULL,
  `STS_NCORR` int(11) DEFAULT NULL COMMENT 'Sub tipo de servicio',
  `LUG_NCORRDESTINO` int(11) DEFAULT NULL COMMENT 'Lugar de destino',
  `LUG_NCORR_PUNTOCARGUIO` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee el detalle de todas las Ã³rdenes de servicio';

--
-- Volcado de datos para la tabla `tg_ordenservicio`
--

INSERT INTO `tg_ordenservicio` (`OSE_NCORR`, `OSE_DFECHASERVICIO`, `OSE_VNOMBRENAVE`, `OSE_VOBSERVACIONES`, `CLIE_VRUT`, `NAV_NCORR`, `USUA_NCORR`, `TISE_NCORR`, `LUG_NCORRORIGEN`, `VIA_NCORR`, `CLIE_VRUTSUBCLIENTE`, `STS_NCORR`, `LUG_NCORRDESTINO`, `LUG_NCORR_PUNTOCARGUIO`) VALUES
(55, '2014-09-02 00:00:00', 'Nave 1', 'Observaciones', '76056575', NULL, 6, 1, 14, NULL, '76056575', 2, 2, 33),
(56, '2014-09-17 00:00:00', 'MLS Vicente Bastian', '', '76056575', NULL, 1, 1, 14, NULL, '76056575', 2, 2, 20),
(57, '2015-04-02 00:00:00', '', 'Prueba', '90914000', NULL, 1, 7, 38, NULL, '90914000', 12, 47, 38),
(58, '2015-04-06 00:00:00', '', 'Jumbo', '90914000', NULL, 1, 7, 38, NULL, '90914000', 12, 47, 38),
(59, '2015-06-14 00:00:00', '', 'Pacific Star', '55555555', NULL, 1, 4, 42, NULL, '55555555', 15, 43, 38),
(60, '2015-06-16 00:00:00', '', 'Despacho Rampla a Cliente', '90914000', NULL, 1, 7, 38, NULL, '90914000', 12, 47, 38);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_parametro`
--

CREATE TABLE `tg_parametro` (
  `par_ncorr` int(11) NOT NULL,
  `par_vdescripcion` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL,
  `par_valor` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tg_parametro`
--

INSERT INTO `tg_parametro` (`par_ncorr`, `par_vdescripcion`, `par_valor`) VALUES
(1, 'Registra log', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_procesoimportacion`
--

CREATE TABLE `tg_procesoimportacion` (
  `PIM_NCORR` int(11) NOT NULL COMMENT 'Id. del proceso de importacion',
  `PIM_VDESCRIPCION` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Descripción del proceso'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tg_procesoimportacion`
--

INSERT INTO `tg_procesoimportacion` (`PIM_NCORR`, `PIM_VDESCRIPCION`) VALUES
(1, 'Importación cargas');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_servicio`
--

CREATE TABLE `tg_servicio` (
  `serv_ncorr` int(11) NOT NULL COMMENT 'Id. de la programación',
  `SERV_VCELULAR` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Celular',
  `CAR_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador de la carga',
  `LUG_NCORR_ORIGEN` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar de destino',
  `LUG_NCORR_DESTINO` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar de origen',
  `EMP_NCORR` int(11) DEFAULT NULL COMMENT 'Id. de la empresa contratista',
  `CHA_NCORR` int(11) DEFAULT NULL COMMENT 'id. del chasis',
  `CHOF_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador del chofer',
  `CAM_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador del camion',
  `SERV_DINICIO` datetime DEFAULT NULL COMMENT 'Fecha y hora del inicio del servicio',
  `SERV_DTERMINO` datetime DEFAULT NULL COMMENT 'Fecha y hora del término programado del servicio',
  `SERV_NTERMINADO` int(11) NOT NULL DEFAULT 0,
  `GUIA_NCORR` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Programación del servicio de la carga';

--
-- Volcado de datos para la tabla `tg_servicio`
--

INSERT INTO `tg_servicio` (`serv_ncorr`, `SERV_VCELULAR`, `CAR_NCORR`, `LUG_NCORR_ORIGEN`, `LUG_NCORR_DESTINO`, `EMP_NCORR`, `CHA_NCORR`, `CHOF_NCORR`, `CAM_NCORR`, `SERV_DINICIO`, `SERV_DTERMINO`, `SERV_NTERMINADO`, `GUIA_NCORR`) VALUES
(79, '98769876', 137, 14, 12, 5, 7, 7, 8, '2014-09-18 09:00:00', '2014-09-18 14:00:00', 1, 37),
(80, '98769876', 138, 14, 12, 5, 7, 7, 9, '2014-09-18 09:00:00', '2014-09-18 09:00:00', 1, 38),
(81, '12345678', 137, 12, 2, 5, 7, 7, 9, '2014-09-19 10:00:00', '2014-09-19 12:00:00', 0, 0),
(82, '98349879', 138, 12, 2, 5, 7, 7, 9, '2014-09-22 10:00:00', '2014-09-22 12:00:00', 0, 0),
(83, '112233333', 139, 14, 2, 5, 7, 7, 9, '2014-09-22 10:00:00', '2014-09-22 12:00:00', 0, 0),
(84, '12345678', 140, 14, 12, 5, 7, 7, 9, '2014-09-18 19:42:00', '2014-09-18 19:42:00', 1, 0),
(85, '69696969', 140, 12, 2, 5, 7, 7, 9, '2015-04-02 20:00:00', '2015-04-02 23:00:00', 0, 43),
(86, '4444444', 146, 14, 12, 5, 7, 7, 9, '2015-03-30 23:31:00', '2015-03-31 05:00:00', 1, 48),
(87, '1111111', 147, 38, 47, 49, 12, 11, 13, '2015-04-02 20:00:00', '2015-04-02 23:00:00', 0, 44),
(88, '22222', 148, 38, 47, 49, 10, 12, 14, '2015-04-02 20:00:00', '2015-04-03 20:00:00', 0, 46),
(89, '\"111\"', 146, 12, 2, 5, 7, 7, 9, '2015-06-15 15:00:00', '2015-06-16 19:00:00', 0, 0),
(90, '11111111', 149, 38, 47, 49, 12, 10, 14, '2015-04-06 11:00:00', '2015-04-06 12:00:00', 0, 0),
(91, '\"11111111\"', 447, 42, 43, 54, 16, 15, 18, '2015-01-20 10:10:00', '2015-06-15 10:10:00', 0, 0),
(92, '\"55555555\"', 448, 42, 43, 54, 16, 14, 18, '2015-06-15 10:10:00', '2015-06-15 11:00:00', 0, 0),
(93, '\"65628370\"', 449, 38, 47, 49, 10, 10, 14, '2015-06-17 10:00:00', '2015-06-17 14:00:00', 0, 0),
(94, '\"98626823\"', 450, 38, 47, 59, 20, 19, 21, '2015-06-17 10:00:00', '2015-06-17 15:00:00', 0, 0),
(95, '54', 455, 42, 43, 60, 23, 22, 25, '2015-06-17 14:00:00', '2015-06-24 14:00:00', 0, 0),
(96, '\"65628370\"', 451, 38, 47, 49, 12, 10, 13, '2015-06-19 10:00:00', '2015-06-22 10:00:00', 0, 0),
(97, '\"11111111\"', 495, 42, 43, 54, 16, 15, 18, '2015-10-09 13:00:00', '2015-10-15 15:00:00', 0, 0),
(98, '\"111\"', 126, 14, 2, 5, 7, 7, 9, '2015-11-25 14:00:00', '2015-11-26 14:00:00', 0, 0),
(99, '\"22222222\"', 497, 42, 43, 54, 16, 17, 18, '2015-11-03 00:00:00', '2015-11-08 00:00:00', 0, 0),
(100, '\"55555555\"', 496, 42, 43, 54, 16, 14, 18, '2015-12-01 12:00:00', '2015-12-07 12:00:00', 0, 0),
(101, '\"111\"', 128, 14, 12, 5, 7, 7, 9, '2014-09-28 17:06:00', '2014-09-29 17:06:00', 1, 0),
(102, '\"111\"', 131, 14, 12, 5, 7, 7, 9, '2014-09-28 19:00:00', '2014-09-29 19:00:00', 1, 0),
(103, '\"111\"', 133, 14, 12, 5, 7, 7, 9, '2014-09-02 18:00:00', '2014-09-03 18:00:00', 1, 0),
(104, NULL, 142, 14, 0, 5, NULL, NULL, NULL, '2014-09-18 15:00:00', '2014-09-18 15:00:00', 0, 0),
(105, NULL, 143, 14, 0, 5, NULL, NULL, NULL, '2014-09-18 16:00:00', '2014-09-18 16:00:00', 0, 0),
(106, NULL, 144, 14, 0, 5, NULL, NULL, NULL, '2014-09-18 17:00:00', '2014-09-18 17:00:00', 0, 0),
(107, NULL, 145, 14, 0, 5, NULL, NULL, NULL, '2014-09-19 19:00:00', '2014-09-19 19:00:00', 0, 0),
(108, NULL, 158, 14, 0, 5, NULL, NULL, NULL, '2014-09-19 19:00:00', '2014-09-19 19:00:00', 0, 0),
(109, NULL, 157, 14, 0, 5, NULL, NULL, NULL, '2014-09-19 19:00:00', '2014-09-19 19:00:00', 1, 0),
(110, NULL, 157, 14, 0, 5, NULL, NULL, NULL, '2014-09-03 20:00:00', '2014-09-03 20:00:00', 0, 0),
(111, NULL, 159, 14, 0, 5, NULL, NULL, NULL, '2014-09-03 20:00:00', '2014-09-03 20:00:00', 0, 0),
(112, NULL, 430, 14, 0, 5, NULL, NULL, NULL, '2014-09-03 20:00:00', '2014-09-03 20:00:00', 0, 0),
(113, NULL, 457, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 02:00:00', '2014-09-05 02:00:00', 0, 0),
(114, NULL, 458, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 06:00:00', '2014-09-05 06:00:00', 0, 0),
(115, NULL, 461, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 06:00:00', '2014-09-05 06:00:00', 0, 0),
(116, NULL, 462, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 06:00:00', '2014-09-05 06:00:00', 0, 0),
(117, NULL, 463, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 06:00:00', '2014-09-05 06:00:00', 0, 0),
(118, NULL, 464, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 06:00:00', '2014-09-05 06:00:00', 0, 0),
(119, NULL, 465, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 06:00:00', '2014-09-05 06:00:00', 0, 0),
(120, NULL, 466, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 06:00:00', '2014-09-05 06:00:00', 0, 0),
(121, NULL, 459, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 06:00:00', '2014-09-05 06:00:00', 0, 0),
(122, NULL, 460, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 06:00:00', '2014-09-05 06:00:00', 1, 0),
(123, NULL, 467, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 08:00:00', '2014-09-05 08:00:00', 0, 0),
(124, NULL, 460, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 08:00:00', '2014-09-05 08:00:00', 0, 0),
(125, NULL, 468, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 08:00:00', '2014-09-05 08:00:00', 1, 0),
(126, NULL, 468, 14, 0, 5, NULL, NULL, NULL, '2014-09-10 10:00:00', '2014-09-10 10:00:00', 0, 0),
(127, NULL, 469, 14, 0, 5, NULL, NULL, NULL, '2014-09-10 10:00:00', '2014-09-10 10:00:00', 0, 0),
(128, NULL, 470, 14, 0, 5, NULL, NULL, NULL, '2014-09-10 10:00:00', '2014-09-10 10:00:00', 1, 0),
(129, NULL, 470, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 12:00:00', '2014-09-05 12:00:00', 0, 0),
(130, NULL, 471, 14, 0, 5, NULL, NULL, NULL, '2014-09-08 14:00:00', '2014-09-08 14:00:00', 1, 0),
(131, NULL, 471, 14, 0, 5, NULL, NULL, NULL, '2014-09-07 15:00:00', '2014-09-07 15:00:00', 0, 0),
(132, NULL, 472, 14, 0, 5, NULL, NULL, NULL, '2014-09-07 15:00:00', '2014-09-07 15:00:00', 0, 0),
(133, NULL, 473, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 17:00:00', '2014-09-05 17:00:00', 0, 0),
(134, NULL, 474, 14, 0, 5, NULL, NULL, NULL, '2014-09-05 17:00:00', '2014-09-05 17:00:00', 0, 0),
(135, NULL, 475, 14, 0, 5, NULL, NULL, NULL, '2014-09-03 21:00:00', '2014-09-03 21:00:00', 0, 0),
(136, NULL, 476, 14, 0, 5, NULL, NULL, NULL, '2014-09-04 15:00:00', '2014-09-04 15:00:00', 0, 0),
(137, NULL, 486, 14, 0, 5, NULL, NULL, NULL, '2014-09-10 17:00:00', '2014-09-10 17:00:00', 0, 0),
(138, NULL, 487, 14, 0, 5, NULL, NULL, NULL, '2014-09-04 19:00:00', '2014-09-04 19:00:00', 0, 0),
(139, NULL, 488, 14, 0, 5, NULL, NULL, NULL, '2014-09-08 20:00:00', '2014-09-08 20:00:00', 0, 0),
(140, NULL, 489, 14, 0, 5, NULL, NULL, NULL, '2014-09-11 05:00:00', '2014-09-11 05:00:00', 0, 0),
(141, NULL, 490, 14, 0, 5, NULL, NULL, NULL, '2014-09-08 06:00:00', '2014-09-08 06:00:00', 0, 0),
(142, NULL, 491, 14, 0, 5, NULL, NULL, NULL, '2014-09-18 11:00:00', '2014-09-18 11:00:00', 0, 0),
(143, NULL, 492, 14, 0, 5, NULL, NULL, NULL, '2014-09-23 13:00:00', '2014-09-23 13:00:00', 0, 0),
(144, NULL, 493, 14, 0, 5, NULL, NULL, NULL, '2014-09-19 16:00:00', '2014-09-19 16:00:00', 0, 0),
(145, NULL, 494, 14, 0, 5, NULL, NULL, NULL, '2014-09-16 19:00:00', '2014-09-16 19:00:00', 0, 0),
(146, '\"111\"', 133, 12, 2, 5, 7, 7, 9, '2016-01-22 09:00:00', '2016-01-22 16:00:00', 0, 0),
(147, '\"111\"', 128, 12, 2, 5, 7, 7, 9, '2016-01-25 09:00:00', '2016-01-25 16:00:00', 0, 0),
(148, '\"111\"', 131, 12, 2, 5, 7, 7, 8, '2016-01-26 08:00:00', '2016-01-26 16:55:00', 0, 0),
(149, '\"65628370\"', 452, 38, 47, 49, 12, 10, 13, '2015-06-16 10:00:00', '2015-06-16 14:00:00', 0, 0),
(150, '\"65628370\"', 453, 38, 47, 49, 12, 10, 13, '2015-06-16 10:00:00', '2015-06-16 12:00:00', 0, 0),
(151, '\"98626823\"', 454, 38, 47, 59, 20, 19, 21, '2015-06-16 10:00:00', '2015-06-16 13:00:00', 0, 0),
(152, NULL, 456, 42, 0, NULL, NULL, NULL, NULL, '2015-06-14 15:57:00', '2015-06-14 15:57:00', 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_tarifa`
--

CREATE TABLE `tg_tarifa` (
  `TAR_NCORR` int(11) NOT NULL COMMENT 'Id. de la tarifa',
  `TRA_NCORR` int(11) DEFAULT NULL,
  `EMP_NCORR` int(11) DEFAULT NULL COMMENT 'Id. de la empresa contratista',
  `TISE_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de servicio',
  `LUG_NCORR_ORIGEN` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar',
  `LUG_NCORR_DESTINO` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar',
  `STS_NCORR` int(11) DEFAULT NULL COMMENT 'Id. del subtipo de servicio',
  `TAR_NMONTO` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee las tarifas de los servicios realizados';

--
-- Volcado de datos para la tabla `tg_tarifa`
--

INSERT INTO `tg_tarifa` (`TAR_NCORR`, `TRA_NCORR`, `EMP_NCORR`, `TISE_NCORR`, `LUG_NCORR_ORIGEN`, `LUG_NCORR_DESTINO`, `STS_NCORR`, `TAR_NMONTO`) VALUES
(1, 1, 5, NULL, NULL, NULL, NULL, 450000),
(2, 2, 5, NULL, NULL, NULL, NULL, 320000),
(3, 3, 5, NULL, NULL, NULL, NULL, 500000),
(4, 7, 1, NULL, NULL, NULL, NULL, 120000),
(5, 9, 1, NULL, NULL, NULL, NULL, 70000),
(6, 8, 1, NULL, NULL, NULL, NULL, 120000),
(7, 7, 50, NULL, NULL, NULL, NULL, 120000),
(8, 8, 50, NULL, NULL, NULL, NULL, 120000),
(9, 9, 50, NULL, NULL, NULL, NULL, 70000),
(10, 15, 50, NULL, NULL, NULL, NULL, 140000),
(11, 16, 50, NULL, NULL, NULL, NULL, 70000),
(12, 12, 49, NULL, NULL, NULL, NULL, 65000),
(13, 13, 49, NULL, NULL, NULL, NULL, 90000),
(14, 17, 50, NULL, NULL, NULL, NULL, 82000),
(15, 18, 50, NULL, NULL, NULL, NULL, 82000),
(16, 10, 51, NULL, NULL, NULL, NULL, 2100),
(17, 10, 54, NULL, NULL, NULL, NULL, 2100),
(18, 10, 55, NULL, NULL, NULL, NULL, 2100),
(19, 10, 56, NULL, NULL, NULL, NULL, 2100),
(20, 10, 57, NULL, NULL, NULL, NULL, 2100),
(21, 10, 58, NULL, NULL, NULL, NULL, 2100),
(22, 10, 53, NULL, NULL, NULL, NULL, 2100),
(23, 13, 59, NULL, NULL, NULL, NULL, 90000),
(24, 10, 60, NULL, NULL, NULL, NULL, 2100),
(25, 10, 62, NULL, NULL, NULL, NULL, 2100);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_tarifaservicio`
--

CREATE TABLE `tg_tarifaservicio` (
  `TASI_NCORR` int(11) NOT NULL COMMENT 'Id. de la tarifa de servicio del cliente',
  `TASI_NMONTO` int(11) DEFAULT NULL COMMENT 'Monto de la tarifa de servicio',
  `TISE_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de servicio',
  `CLIE_VRUT` varchar(20) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Identificador del cliente',
  `LUG_NCORR_ORIGEN` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar',
  `LUG_NCORR_DESTINO` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar',
  `STS_NCORR` int(11) DEFAULT NULL COMMENT 'Id. del subtipo de servicio'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tg_tarifaservicio`
--

INSERT INTO `tg_tarifaservicio` (`TASI_NCORR`, `TASI_NMONTO`, `TISE_NCORR`, `CLIE_VRUT`, `LUG_NCORR_ORIGEN`, `LUG_NCORR_DESTINO`, `STS_NCORR`) VALUES
(1, 25000, 1, '76056575', 1, 16, 1),
(2, 11800, NULL, '13512725', NULL, NULL, 1),
(3, 12000, NULL, '13512725', NULL, NULL, 1),
(4, 9800, NULL, '13512725', NULL, NULL, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_tramo`
--

CREATE TABLE `tg_tramo` (
  `TRA_NCORR` int(11) NOT NULL COMMENT 'Id. del tramo',
  `VIA_NCORR` int(11) DEFAULT NULL COMMENT 'Id. del viaje',
  `LUG_NCORR_ORIGEN` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar de destino',
  `LUG_NCORR_DESTINO` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar de destino',
  `TRA_KMS` int(11) DEFAULT NULL,
  `TRA_TIEMPO` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tg_tramo`
--

INSERT INTO `tg_tramo` (`TRA_NCORR`, `VIA_NCORR`, `LUG_NCORR_ORIGEN`, `LUG_NCORR_DESTINO`, `TRA_KMS`, `TRA_TIEMPO`) VALUES
(1, NULL, 14, 12, 50, 70),
(2, NULL, 12, 2, 40, 80),
(3, NULL, 14, 2, 90, 130),
(4, NULL, 32, 23, 18, 40),
(5, NULL, 32, 35, 1, 10),
(6, NULL, 33, 34, 95, 4),
(7, NULL, 5, 40, 135, 130),
(8, NULL, 2, 40, 105, 100),
(9, NULL, 40, 41, 35, 50),
(10, NULL, 42, 43, 1550, 8640),
(12, NULL, 38, 48, 20, 30),
(13, NULL, 38, 47, 40, 40),
(15, NULL, 49, 40, 135, 130),
(16, NULL, 50, 40, 135, 130),
(17, NULL, 40, 51, 30, 30),
(18, NULL, 40, 52, 45, 45),
(19, NULL, 41, 46, 1400, 1900),
(20, NULL, 1, 5, 60, 20),
(21, NULL, 40, 53, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_tramo_subtiposervicio`
--

CREATE TABLE `tg_tramo_subtiposervicio` (
  `tss_ncorr` bigint(20) UNSIGNED NOT NULL,
  `sts_ncorr` int(11) NOT NULL,
  `tra_ncorr` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

--
-- Volcado de datos para la tabla `tg_tramo_subtiposervicio`
--

INSERT INTO `tg_tramo_subtiposervicio` (`tss_ncorr`, `sts_ncorr`, `tra_ncorr`) VALUES
(8, 2, 5),
(7, 2, 4),
(4, 4, 1),
(5, 4, 2),
(6, 4, 3),
(9, 2, 6),
(10, 2, 1),
(11, 2, 2),
(12, 2, 3),
(13, 12, 13),
(14, 13, 12),
(15, 15, 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_usuario`
--

CREATE TABLE `tg_usuario` (
  `USUA_NCORR` int(11) NOT NULL COMMENT 'Identificador de la ciudad',
  `ROL_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador del rol de usuario',
  `USUA_VLOGIN` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Login del usuario',
  `USUA_VNOMBRE` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Nombre del usuario',
  `USUA_VAPELLIDO1` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Apellido 1',
  `USUA_VAPELLIDO2` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Apellido 2',
  `USUA_VMAIL` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Mail',
  `USUA_VCLAVE` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Clave'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla con los usuarios del sistema';

--
-- Volcado de datos para la tabla `tg_usuario`
--

INSERT INTO `tg_usuario` (`USUA_NCORR`, `ROL_NCORR`, `USUA_VLOGIN`, `USUA_VNOMBRE`, `USUA_VAPELLIDO1`, `USUA_VAPELLIDO2`, `USUA_VMAIL`, `USUA_VCLAVE`) VALUES
(1, 1, 'admin', 'Administrador', '-', '-', '.', 'admin'),
(2, 2, 'pperez', 'Pedro', 'Perez', '-', '-', 'pperez'),
(3, 3, 'coordinador', 'Coordinador', 'Transporte', '-', '-', 'coordinador'),
(4, 1, 'cgonzalez', 'Camilo', 'Gonzalez', NULL, NULL, ',.cgonzalez'),
(5, 1, 'haichele', 'Hardy', 'Aichele', 'Oyarzún', 'hardy.aichele@capturactiva.com', ',.haichele'),
(6, 2, 'vendedor', 'usuario', 'vendedor', '-', 'vendedor@simplexlogisitca.cl', 'vendedor'),
(7, 2, 'Igna', 'Ignacio', 'Unzueta', '', 'info@simplexlogistica.cl', 'ignacio'),
(8, 3, 'Javiera', 'Javiera ', 'Araya', '', 'jaraya@simplexlogistica.cl', 'jaraya');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_versioncarga`
--

CREATE TABLE `tg_versioncarga` (
  `CAR_NVERSION` int(11) NOT NULL,
  `CAR_NCORR` int(11) NOT NULL COMMENT 'Identificador de la carga',
  `CAR_NBOOKING` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'NÂ° de booking de la carga',
  `CAR_VCONTENIDOCARGA` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Contenido de la carga',
  `CAR_NDIASCONTENEDOR` int(11) DEFAULT NULL COMMENT 'DÃ­as del contenedor',
  `CAR_VMARCA` varchar(100) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Marca del contenedor',
  `CAR_VNUMCONTENEDOR` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'NÃºmero del contenedor',
  `CAR_NPESOCARGA` int(11) DEFAULT NULL COMMENT 'Peso de la carga',
  `CAR_VSELLO` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Sello del contenedor',
  `CAR_VOBSERVACIONES` varchar(200) COLLATE latin1_spanish_ci DEFAULT NULL COMMENT 'Observaciones de la carga',
  `TICA_NCORR` int(11) DEFAULT NULL COMMENT 'Tipo de carga',
  `TICO_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador de los contenedores',
  `OSE_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador del registro',
  `ESCA_NCORR` int(11) DEFAULT NULL COMMENT 'Identicador numÃ©rico del estado',
  `ADA_NCORR` int(11) DEFAULT NULL COMMENT 'Identificador de la agencia de aduana'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci COMMENT='Tabla que posee los datos de una carga';

--
-- Volcado de datos para la tabla `tg_versioncarga`
--

INSERT INTO `tg_versioncarga` (`CAR_NVERSION`, `CAR_NCORR`, `CAR_NBOOKING`, `CAR_VCONTENIDOCARGA`, `CAR_NDIASCONTENEDOR`, `CAR_VMARCA`, `CAR_VNUMCONTENEDOR`, `CAR_NPESOCARGA`, `CAR_VSELLO`, `CAR_VOBSERVACIONES`, `TICA_NCORR`, `TICO_NCORR`, `OSE_NCORR`, `ESCA_NCORR`, `ADA_NCORR`) VALUES
(1, 1, 'xxxx', NULL, NULL, NULL, NULL, 30, NULL, 'xxxxxxxxxxxxyyyyy', 1, NULL, 1, 1, 2),
(2, 1, 'xxxx', NULL, NULL, NULL, NULL, 30, NULL, 'xxxxxxxxxxxxyyyyy', 1, NULL, 1, 1, 2),
(3, 1, 'xxxx', NULL, NULL, NULL, NULL, 30, NULL, 'xxxxxxxxxxxxyyyyy', 1, NULL, 1, 1, 2),
(4, 1, 'xxxx', NULL, NULL, NULL, NULL, 30, NULL, 'fff', 1, NULL, 1, 1, 2),
(5, 6, 'fgfggg', NULL, NULL, NULL, NULL, 67890, NULL, 'pruebas', 1, NULL, 1, 3, 2),
(6, 7, 'ffff', NULL, NULL, NULL, NULL, 4444, NULL, 'hhhhh', 2, NULL, 1, 5, 1),
(7, 8, 'eee', NULL, NULL, NULL, NULL, 333, NULL, 'dsdd', 2, NULL, 1, 5, 1),
(8, 8, 'eee', NULL, NULL, NULL, NULL, 333, NULL, 'dsddddeee', 2, NULL, 1, 5, 1),
(9, 8, 'eee', NULL, NULL, NULL, NULL, 333, NULL, 'dsddddeee', 2, NULL, 1, 5, 2),
(10, 8, 'eee', NULL, NULL, NULL, NULL, 333, NULL, 'dsddddeee', 2, NULL, 1, 5, 2),
(11, 1, 'xxxx', NULL, NULL, NULL, NULL, 30, NULL, 'fff', 1, NULL, 1, 1, 2),
(12, 2, '555', NULL, NULL, NULL, NULL, 30, NULL, 'sdsssd', 1, NULL, 1, 1, 1),
(13, 3, '3wqewe', NULL, NULL, NULL, NULL, 30, NULL, 'wwwr', 1, NULL, 1, 1, 2),
(14, 1, 'xxxx', NULL, NULL, NULL, NULL, 30, NULL, 'fff', 1, NULL, 1, 1, 2),
(15, 2, '555', NULL, NULL, NULL, NULL, 30, NULL, 'sdsssd', 1, NULL, 1, 1, 1),
(16, 3, '3wqewe', NULL, NULL, NULL, NULL, 30, NULL, 'wwwr', 1, NULL, 1, 1, 2),
(17, 6, 'fgfggg', NULL, NULL, NULL, NULL, 67890, NULL, 'pruebas', 1, NULL, 1, 3, 2),
(18, 7, 'ffff', NULL, NULL, NULL, NULL, 4444, NULL, 'hhhhh', 2, NULL, 1, 5, 1),
(19, 8, 'eee', NULL, NULL, NULL, NULL, 333, NULL, 'dsddddeee', 2, NULL, 1, 5, 2),
(20, 1, 'xxxx', NULL, NULL, NULL, NULL, 30, NULL, 'fff', 1, NULL, 1, 1, 2),
(21, 9, '2343224', NULL, NULL, NULL, NULL, 1500, NULL, 'Prueba', 1, NULL, 6, 1, 1),
(22, 10, '455345gfhgfh', NULL, NULL, NULL, NULL, 1000, NULL, 'rewtrertret', 1, NULL, 6, 1, 2),
(23, 11, 'ffergtre', NULL, NULL, NULL, NULL, 1500, NULL, 's/o', 1, NULL, 7, 1, 1),
(24, 12, 'rtrrytryrt', NULL, NULL, NULL, NULL, 2500, NULL, 'rttyrytrytr', 1, NULL, 7, 1, 1),
(25, 13, '55', NULL, NULL, NULL, NULL, 55, NULL, '555', 2, NULL, 1, 3, 2),
(26, 14, '3323', NULL, NULL, NULL, NULL, 1000, NULL, '', 1, NULL, 10, 1, 1),
(27, 15, '213232', NULL, NULL, NULL, NULL, 1000, NULL, '', 1, NULL, 11, 1, 1),
(28, 16, '1324342', NULL, NULL, NULL, NULL, 1500, NULL, '', 1, NULL, 12, 1, 1),
(29, 17, '34243423', NULL, NULL, NULL, NULL, 2090, NULL, '', 1, NULL, 12, 1, NULL),
(30, 18, '0', NULL, NULL, NULL, NULL, 1000, NULL, '', 2, NULL, 12, 1, NULL),
(31, 19, '21879217298', NULL, NULL, NULL, NULL, 1200, NULL, '', 1, NULL, 12, 1, 1),
(32, 20, '323323', NULL, NULL, NULL, NULL, 1000, NULL, '', 1, NULL, 12, 1, 2),
(33, 16, '1324342', NULL, NULL, NULL, NULL, 1500, NULL, '', 1, NULL, 12, 1, 1),
(34, 21, '123456', NULL, NULL, NULL, NULL, 0, NULL, '', 1, NULL, 13, 1, NULL),
(35, 22, '566777777', NULL, NULL, NULL, NULL, 111, NULL, 'xxx', 1, NULL, 14, 1, 1),
(36, 23, '987654', NULL, NULL, NULL, NULL, 1000, NULL, '', 1, NULL, 13, 1, 1),
(37, 24, '987654', NULL, NULL, NULL, NULL, 1200, NULL, '', 1, NULL, 13, 1, 2),
(38, 25, '9889897', NULL, NULL, NULL, NULL, 0, NULL, '', 2, NULL, 13, 1, 2),
(39, 26, '435534', NULL, NULL, NULL, NULL, 2000, NULL, '', 1, NULL, 13, 1, 2),
(40, 27, '989898', NULL, NULL, NULL, NULL, 2500, NULL, '', 1, NULL, 13, 1, NULL),
(41, 28, '9898', NULL, NULL, NULL, NULL, 1800, NULL, '', 1, NULL, 13, 1, NULL),
(42, 29, '43434', NULL, NULL, NULL, NULL, 1900, NULL, '', 1, NULL, 13, 1, NULL),
(43, 30, '809898', NULL, NULL, NULL, NULL, 0, NULL, '', 2, NULL, 13, 1, NULL),
(44, 31, '8999787', NULL, NULL, NULL, NULL, 0, NULL, '', 2, NULL, 13, 1, NULL),
(45, 32, '3432432432', NULL, NULL, NULL, NULL, 20, NULL, '', 1, NULL, 13, 1, 2),
(46, 33, '8797897', NULL, NULL, NULL, NULL, 1200, NULL, '', 1, NULL, 13, 1, NULL),
(47, 34, '9797797', NULL, NULL, NULL, NULL, 1500, NULL, '', 1, NULL, 13, 1, 2),
(48, 35, '978988779', NULL, NULL, NULL, NULL, 1300, NULL, '', 1, NULL, 13, 1, 2),
(49, 36, '987987', NULL, NULL, NULL, NULL, 1200, NULL, '', 1, NULL, 15, 1, 1),
(50, 37, '757563', NULL, NULL, NULL, NULL, 1300, NULL, '', 1, NULL, 15, 1, 2),
(51, 38, '99', NULL, NULL, NULL, NULL, 99, NULL, 'xxx', 2, NULL, 1, 1, 1),
(52, 39, '987987', NULL, NULL, NULL, NULL, 1500, NULL, '', 1, NULL, 15, 1, 2),
(53, 39, '987987', NULL, NULL, NULL, NULL, 1500, NULL, '', 1, NULL, 15, 1, 2),
(54, 40, '789797', NULL, NULL, NULL, NULL, 1200, NULL, '', 1, NULL, 15, 1, 2),
(55, 41, '55555', NULL, NULL, NULL, NULL, 55, NULL, 'vvvv', 2, NULL, 17, 1, 1),
(56, 42, '999', NULL, NULL, NULL, NULL, 999, NULL, '', 1, NULL, 17, 1, 2),
(57, 43, '99999', NULL, NULL, NULL, NULL, 9999, NULL, '', 2, NULL, 1, 1, 1),
(58, 44, '9080890', NULL, NULL, NULL, NULL, 1200, NULL, '', 1, NULL, 17, 1, 1),
(59, 45, '09890', NULL, NULL, NULL, NULL, 1200, NULL, '', 2, NULL, 17, 1, 2),
(60, 46, '454654', NULL, NULL, NULL, NULL, 1200, NULL, 'rre5454', 1, NULL, 17, 1, 2),
(61, 47, '9890', NULL, NULL, NULL, NULL, 1900, NULL, 'rerer', 1, NULL, 17, 1, 2),
(62, 48, '890889', NULL, NULL, NULL, NULL, 1200, NULL, '', 1, NULL, 1, 1, 2),
(63, 49, '89898', NULL, NULL, NULL, NULL, 1300, NULL, '', 1, NULL, 1, 1, 1),
(64, 50, '7567675', NULL, NULL, NULL, NULL, 1200, NULL, '', 1, NULL, 17, 1, NULL),
(65, 51, '989989', NULL, NULL, NULL, NULL, 1300, NULL, '', 1, NULL, 17, 1, NULL),
(66, 52, '65454', NULL, NULL, NULL, NULL, 1700, NULL, '', 1, NULL, 17, 1, NULL),
(67, 53, '989089890', NULL, NULL, NULL, NULL, 1200, NULL, '', 1, NULL, 17, 1, NULL),
(68, 54, '809890', NULL, NULL, NULL, NULL, 1700, NULL, '', 1, NULL, 17, 1, NULL),
(69, 55, '979789', NULL, NULL, NULL, NULL, 1300, NULL, '', 1, NULL, 17, 1, NULL),
(70, 56, '989798', NULL, NULL, NULL, NULL, 1700, NULL, '', 1, NULL, 17, 1, NULL),
(71, 57, '76576575', NULL, NULL, NULL, NULL, 1700, NULL, '', 1, NULL, 17, 1, NULL),
(72, 58, '898890', NULL, NULL, NULL, NULL, 1490, NULL, '', 1, NULL, 17, 1, NULL),
(73, 59, '989068905', NULL, NULL, NULL, NULL, 1300, NULL, '', 1, NULL, 17, 1, 1),
(74, 42, '999', NULL, NULL, NULL, NULL, 999, NULL, '', 1, NULL, 17, 2, 2),
(75, 60, '8979787897', NULL, NULL, NULL, NULL, 1200, NULL, '', 1, NULL, 17, 1, NULL),
(76, 60, '8979787897', NULL, NULL, NULL, NULL, 1200, NULL, '', 1, NULL, 17, 1, NULL),
(77, 61, '765756', NULL, NULL, NULL, NULL, 1300, NULL, '', 1, NULL, 17, 1, 1),
(78, 62, '756756756756', NULL, NULL, NULL, NULL, 1700, NULL, '', 1, NULL, 17, 1, 1),
(79, 63, '8348238', NULL, NULL, NULL, NULL, 1650, NULL, '', 1, NULL, 17, 1, 2),
(80, 64, '8754386834', NULL, NULL, NULL, NULL, 1950, NULL, '', 1, NULL, 17, 1, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tg_viaje`
--

CREATE TABLE `tg_viaje` (
  `VIA_NCORR` int(11) NOT NULL COMMENT 'Id. del viaje',
  `LUG_NCORR_ORIGEN` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar',
  `LUG_NCORR_DESTINO` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `viaje`
--

CREATE TABLE `viaje` (
  `VIA_NCORR` int(11) NOT NULL COMMENT 'Id. del viaje',
  `LUG_NCORR_ORIGEN` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar',
  `LUG_NCORR_DESTINO` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de lugar'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_avancehito`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_avancehito` (
`car_ncorr` int(11)
,`hitofinal` int(11)
,`ultimoavance` datetime
,`avancesperado` datetime
,`inicioreal` datetime
,`inicioplan` datetime
,`controlado` int(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_gastosOperacionales_listar`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_gastosOperacionales_listar` (
`ose_ncorr` int(11)
,`clie_vnombre` char(0)
,`Origen` char(0)
,`Destino` char(0)
,`Vendedor` char(0)
,`EstadoCarga` char(0)
,`car_ncorr` int(11)
,`Tipo` char(0)
,`Tarifa` char(0)
,`codServicio` int(11)
,`Empresa` varchar(100)
,`Tramo` varchar(404)
,`Costo` double
,`IngresoOrden` char(0)
,`clie_vrut` varchar(20)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_ingresosfinancieros_listar`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_ingresosfinancieros_listar` (
`ose_ncorr` int(11)
,`clie_vnombre` varchar(100)
,`Origen` varchar(200)
,`Destino` varchar(200)
,`Vendedor` varchar(100)
,`EstadoCarga` varchar(100)
,`car_ncorr` int(11)
,`Tipo` varchar(100)
,`Tarifa` float
,`codServicio` int(1)
,`Empresa` varchar(1)
,`Tramo` varchar(1)
,`Costo` int(1)
,`IngresoOrden` datetime
,`clie_vrut` int(10)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_tiposervicio`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_tiposervicio` (
`tine_ncorr` int(11)
,`tise_vdescripcion` varchar(100)
,`tise_ncorr` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_tramo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_tramo` (
`tra_ncorr` int(11)
,`lug_ncorr_origen` int(11)
,`origen` varchar(200)
,`lug_ncorr_destino` int(11)
,`destino` varchar(200)
,`tra_kms` int(11)
,`tra_tiempo` int(11)
,`nombre` varchar(404)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_avancehito`
--
DROP TABLE IF EXISTS `vw_avancehito`;

CREATE ALGORITHM=UNDEFINED DEFINER=`simplex1`@`localhost` SQL SECURITY DEFINER VIEW `vw_avancehito`  AS SELECT `car`.`CAR_NCORR` AS `car_ncorr`, max(`hito`.`HITO_FINAL`) AS `hitofinal`, max(`hico`.`HICO_HORAREAL`) AS `ultimoavance`, max(`hico`.`HICO_HORAPLAN`) AS `avancesperado`, min(`hico`.`HICO_HORAREAL`) AS `inicioreal`, min(`hico`.`HICO_HORAPLAN`) AS `inicioplan`, if(max(`hico`.`HICO_NCORR`) is null,0,1) AS `controlado` FROM (((`tg_carga` `car` left join `tg_servicio` `serv` on(`car`.`CAR_NCORR` = `serv`.`CAR_NCORR`)) left join `tg_hitocontrolado` `hico` on(`hico`.`SERV_NCORR` = `serv`.`serv_ncorr`)) left join `tg_hito` `hito` on(`hito`.`HITO_NCORR` = `hico`.`HITO_NCORR`)) GROUP BY `car`.`CAR_NCORR` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_gastosOperacionales_listar`
--
DROP TABLE IF EXISTS `vw_gastosOperacionales_listar`;

CREATE ALGORITHM=UNDEFINED DEFINER=`simplex1`@`localhost` SQL SECURITY DEFINER VIEW `vw_gastosOperacionales_listar`  AS SELECT `CAR`.`OSE_NCORR` AS `ose_ncorr`, '' AS `clie_vnombre`, '' AS `Origen`, '' AS `Destino`, '' AS `Vendedor`, '' AS `EstadoCarga`, `CAR`.`CAR_NCORR` AS `car_ncorr`, '' AS `Tipo`, '' AS `Tarifa`, `SERV`.`serv_ncorr` AS `codServicio`, `EMP`.`EMP_VNOMBRE` AS `Empresa`, concat(`ORIGEN`.`LUG_VNOMBRE`,' -> ',`DESTINO`.`LUG_VNOMBRE`) AS `Tramo`, `TAR`.`TAR_NMONTO` AS `Costo`, '' AS `IngresoOrden`, `OSE`.`CLIE_VRUT` AS `clie_vrut` FROM (((((((`tg_carga` `CAR` join `tg_ordenservicio` `OSE` on(`OSE`.`OSE_NCORR` = `CAR`.`OSE_NCORR`)) left join `tg_servicio` `SERV` on(`CAR`.`CAR_NCORR` = `SERV`.`CAR_NCORR`)) left join `tg_empresatransporte` `EMP` on(`SERV`.`EMP_NCORR` = `EMP`.`EMP_NCORR`)) left join `tg_tramo` `TRA` on(`TRA`.`LUG_NCORR_ORIGEN` = `SERV`.`LUG_NCORR_ORIGEN` and `TRA`.`LUG_NCORR_DESTINO` = `SERV`.`LUG_NCORR_DESTINO`)) left join `tg_tarifa` `TAR` on(`TAR`.`TRA_NCORR` = `TRA`.`TRA_NCORR`)) left join `tb_lugar` `ORIGEN` on(`ORIGEN`.`LUG_NCORR` = `SERV`.`LUG_NCORR_ORIGEN`)) left join `tb_lugar` `DESTINO` on(`DESTINO`.`LUG_NCORR` = `SERV`.`LUG_NCORR_DESTINO`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_ingresosfinancieros_listar`
--
DROP TABLE IF EXISTS `vw_ingresosfinancieros_listar`;

CREATE ALGORITHM=UNDEFINED DEFINER=`simplex1`@`localhost` SQL SECURITY DEFINER VIEW `vw_ingresosfinancieros_listar`  AS SELECT `ose`.`OSE_NCORR` AS `ose_ncorr`, `clie`.`CLIE_VNOMBRE` AS `clie_vnombre`, `origen`.`LUG_VNOMBRE` AS `Origen`, `destino`.`LUG_VNOMBRE` AS `Destino`, `usua`.`USUA_VNOMBRE` AS `Vendedor`, `esca`.`ESCA_VDESCRIPCION` AS `EstadoCarga`, `car`.`CAR_NCORR` AS `car_ncorr`, `tica`.`TICA_VDESCRIPCION` AS `Tipo`, `sts`.`STS_NMONTO` AS `Tarifa`, 0 AS `codServicio`, '-' AS `Empresa`, '-' AS `Tramo`, 0 AS `Costo`, `ose`.`OSE_DFECHASERVICIO` AS `IngresoOrden`, `clie`.`CLIE_VRUT` AS `clie_vrut` FROM ((((((((`tg_ordenservicio` `ose` join `tb_cliente` `clie` on(`clie`.`CLIE_VRUT` = `ose`.`CLIE_VRUT`)) join `tb_lugar` `origen` on(`origen`.`LUG_NCORR` = `ose`.`LUG_NCORRORIGEN`)) join `tb_lugar` `destino` on(`destino`.`LUG_NCORR` = `ose`.`LUG_NCORRDESTINO`)) join `tg_usuario` `usua` on(`usua`.`USUA_NCORR` = `ose`.`USUA_NCORR`)) join `tg_carga` `car` on(`car`.`OSE_NCORR` = `ose`.`OSE_NCORR`)) join `tb_estadocarga` `esca` on(`esca`.`ESCA_NCORR` = `car`.`ESCA_NCORR`)) join `tb_tipocarga` `tica` on(`tica`.`TICA_NCORR` = `car`.`TICA_NCORR`)) join `tb_subtiposervicio` `sts` on(`sts`.`STS_NCORR` = `ose`.`STS_NCORR`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_tiposervicio`
--
DROP TABLE IF EXISTS `vw_tiposervicio`;

CREATE ALGORITHM=UNDEFINED DEFINER=`simplex1`@`localhost` SQL SECURITY DEFINER VIEW `vw_tiposervicio`  AS SELECT `A`.`tine_ncorr` AS `tine_ncorr`, `B`.`TISE_VDESCRIPCION` AS `tise_vdescripcion`, `B`.`TISE_NCORR` AS `tise_ncorr` FROM (`tb_tiponegocio` `A` join `tb_tiposervicio` `B` on(`A`.`tine_ncorr` = `B`.`TINE_NCORR`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_tramo`
--
DROP TABLE IF EXISTS `vw_tramo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`simplex1`@`localhost` SQL SECURITY DEFINER VIEW `vw_tramo`  AS SELECT `TRA`.`TRA_NCORR` AS `tra_ncorr`, `TRA`.`LUG_NCORR_ORIGEN` AS `lug_ncorr_origen`, `ORIGEN`.`LUG_VNOMBRE` AS `origen`, `TRA`.`LUG_NCORR_DESTINO` AS `lug_ncorr_destino`, `DESTINO`.`LUG_VNOMBRE` AS `destino`, `TRA`.`TRA_KMS` AS `tra_kms`, `TRA`.`TRA_TIEMPO` AS `tra_tiempo`, concat(`ORIGEN`.`LUG_VNOMBRE`,' -> ',`DESTINO`.`LUG_VNOMBRE`) AS `nombre` FROM ((`tg_tramo` `TRA` join `tb_lugar` `ORIGEN` on(`TRA`.`LUG_NCORR_ORIGEN` = `ORIGEN`.`LUG_NCORR`)) join `tb_lugar` `DESTINO` on(`TRA`.`LUG_NCORR_DESTINO` = `DESTINO`.`LUG_NCORR`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `tb_agenciaaduana`
--
ALTER TABLE `tb_agenciaaduana`
  ADD PRIMARY KEY (`ADA_NCORR`);

--
-- Indices de la tabla `tb_ciudad`
--
ALTER TABLE `tb_ciudad`
  ADD PRIMARY KEY (`CIU_NCORR`);

--
-- Indices de la tabla `tb_cliente`
--
ALTER TABLE `tb_cliente`
  ADD PRIMARY KEY (`CLIE_VRUT`),
  ADD KEY `FK_REFERENCE_3` (`CIU_NCORR`);

--
-- Indices de la tabla `tb_condicionespecial`
--
ALTER TABLE `tb_condicionespecial`
  ADD PRIMARY KEY (`COND_NCORR`);

--
-- Indices de la tabla `tb_estadocarga`
--
ALTER TABLE `tb_estadocarga`
  ADD PRIMARY KEY (`ESCA_NCORR`);

--
-- Indices de la tabla `tb_estadorol`
--
ALTER TABLE `tb_estadorol`
  ADD PRIMARY KEY (`ROL_NCORR`,`ESTA_NCORR`),
  ADD KEY `FK_REFERENCE_22` (`ESTA_NCORR`);

--
-- Indices de la tabla `tb_estado_factura`
--
ALTER TABLE `tb_estado_factura`
  ADD PRIMARY KEY (`ESFA_NCORR`);

--
-- Indices de la tabla `tb_funcionalidad`
--
ALTER TABLE `tb_funcionalidad`
  ADD PRIMARY KEY (`FUNC_NCORR`);

--
-- Indices de la tabla `tb_lugar`
--
ALTER TABLE `tb_lugar`
  ADD PRIMARY KEY (`LUG_NCORR`),
  ADD KEY `FK_REFERENCE_25` (`TLU_NCORR`);

--
-- Indices de la tabla `tb_medidacontenedor`
--
ALTER TABLE `tb_medidacontenedor`
  ADD PRIMARY KEY (`MED_NCORR`);

--
-- Indices de la tabla `tb_naviera`
--
ALTER TABLE `tb_naviera`
  ADD PRIMARY KEY (`NAV_NCORR`);

--
-- Indices de la tabla `tb_permiso`
--
ALTER TABLE `tb_permiso`
  ADD PRIMARY KEY (`PER_NCORR`),
  ADD KEY `FK_REFERENCE_23` (`ROL_NCORR`),
  ADD KEY `FK_REFERENCE_24` (`FUNC_NCORR`);

--
-- Indices de la tabla `tb_rolusuario`
--
ALTER TABLE `tb_rolusuario`
  ADD PRIMARY KEY (`ROL_NCORR`);

--
-- Indices de la tabla `tb_subtiposervicio`
--
ALTER TABLE `tb_subtiposervicio`
  ADD PRIMARY KEY (`STS_NCORR`);

--
-- Indices de la tabla `tb_tipocarga`
--
ALTER TABLE `tb_tipocarga`
  ADD PRIMARY KEY (`TICA_NCORR`);

--
-- Indices de la tabla `tb_tipocontacto`
--
ALTER TABLE `tb_tipocontacto`
  ADD PRIMARY KEY (`TCON_NCORR`);

--
-- Indices de la tabla `tb_tipocontenedor`
--
ALTER TABLE `tb_tipocontenedor`
  ADD PRIMARY KEY (`TICO_NCORR`);

--
-- Indices de la tabla `tb_tipodato`
--
ALTER TABLE `tb_tipodato`
  ADD PRIMARY KEY (`TDA_NCORR`);

--
-- Indices de la tabla `tb_tipolugar`
--
ALTER TABLE `tb_tipolugar`
  ADD PRIMARY KEY (`TLU_NCORR`);

--
-- Indices de la tabla `tb_tiponegocio`
--
ALTER TABLE `tb_tiponegocio`
  ADD PRIMARY KEY (`tine_ncorr`);

--
-- Indices de la tabla `tb_tiposervicio`
--
ALTER TABLE `tb_tiposervicio`
  ADD PRIMARY KEY (`TISE_NCORR`);

--
-- Indices de la tabla `tb_unidadmedida`
--
ALTER TABLE `tb_unidadmedida`
  ADD PRIMARY KEY (`UM_NCORR`);

--
-- Indices de la tabla `tb_viaje`
--
ALTER TABLE `tb_viaje`
  ADD PRIMARY KEY (`VIA_NCORR`);

--
-- Indices de la tabla `tg_camion`
--
ALTER TABLE `tg_camion`
  ADD PRIMARY KEY (`CAM_NCORR`);

--
-- Indices de la tabla `tg_carga`
--
ALTER TABLE `tg_carga`
  ADD PRIMARY KEY (`CAR_NCORR`),
  ADD KEY `FK_REFERENCE_18` (`OSE_NCORR`),
  ADD KEY `FK_REFERENCE_20` (`ESCA_NCORR`),
  ADD KEY `FK_REFERENCE_27` (`ADA_NCORR`),
  ADD KEY `FK_REFERENCE_8` (`TICA_NCORR`),
  ADD KEY `FK_REFERENCE_9` (`TICO_NCORR`),
  ADD KEY `FK_CARG_FACT_01` (`FACT_NCORR`);

--
-- Indices de la tabla `tg_chasis`
--
ALTER TABLE `tg_chasis`
  ADD PRIMARY KEY (`CHA_NCORR`);

--
-- Indices de la tabla `tg_chofer`
--
ALTER TABLE `tg_chofer`
  ADD PRIMARY KEY (`CHOF_NCORR`),
  ADD KEY `FK_REFERENCE_19` (`CAM_NCORR`);

--
-- Indices de la tabla `tg_contactocarga`
--
ALTER TABLE `tg_contactocarga`
  ADD PRIMARY KEY (`COCA_NCORR`),
  ADD KEY `FK_REFERENCE_10` (`TCON_NCORR`),
  ADD KEY `FK_REFERENCE_11` (`CAR_NCORR`);

--
-- Indices de la tabla `tg_contacto_agencia`
--
ALTER TABLE `tg_contacto_agencia`
  ADD PRIMARY KEY (`CADA_NCORR`),
  ADD KEY `FK_CADA_ADA` (`ADA_NCORR`);

--
-- Indices de la tabla `tg_detallefactura`
--
ALTER TABLE `tg_detallefactura`
  ADD PRIMARY KEY (`DEFA_NCORR`),
  ADD KEY `FK_DETA_FACT_01` (`FACT_NCORR`),
  ADD KEY `FK_DETA_CAR_01` (`CAR_NCORR`);

--
-- Indices de la tabla `tg_empresatransporte`
--
ALTER TABLE `tg_empresatransporte`
  ADD PRIMARY KEY (`EMP_NCORR`);

--
-- Indices de la tabla `tg_factura`
--
ALTER TABLE `tg_factura`
  ADD PRIMARY KEY (`FACT_NCORR`);

--
-- Indices de la tabla `tg_guiatransporte`
--
ALTER TABLE `tg_guiatransporte`
  ADD PRIMARY KEY (`guia_ncorr`);

--
-- Indices de la tabla `tg_hito`
--
ALTER TABLE `tg_hito`
  ADD PRIMARY KEY (`HITO_NCORR`),
  ADD KEY `FK_REFERENCE_74` (`TRA_NCORR`);

--
-- Indices de la tabla `tg_hitocontrolado`
--
ALTER TABLE `tg_hitocontrolado`
  ADD PRIMARY KEY (`HICO_NCORR`),
  ADD KEY `FK_REFERENCE_75` (`SERV_NCORR`),
  ADD KEY `FK_REFERENCE_76` (`HITO_NCORR`);

--
-- Indices de la tabla `tg_info_adicional`
--
ALTER TABLE `tg_info_adicional`
  ADD PRIMARY KEY (`CAR_NCORR`);

--
-- Indices de la tabla `tg_info_cargalibre`
--
ALTER TABLE `tg_info_cargalibre`
  ADD PRIMARY KEY (`CAR_NCORR`);

--
-- Indices de la tabla `tg_info_consolidacion`
--
ALTER TABLE `tg_info_consolidacion`
  ADD PRIMARY KEY (`CAR_NCORR`),
  ADD KEY `FK_REFERENCE_33` (`LUG_NCORR_CONSOLIDACION`);

--
-- Indices de la tabla `tg_info_container`
--
ALTER TABLE `tg_info_container`
  ADD PRIMARY KEY (`CAR_NCORR`),
  ADD KEY `FK_REFERENCE_28` (`LUG_NCORR_DEVOLUCION`);

--
-- Indices de la tabla `tg_info_traslado`
--
ALTER TABLE `tg_info_traslado`
  ADD PRIMARY KEY (`CAR_NCORR`),
  ADD KEY `FK_REFERENCE_31` (`LUG_NCORR_DESTINO`),
  ADD KEY `FK_REFERENCE_32` (`LUG_NCORR_RETIRO`);

--
-- Indices de la tabla `tg_log`
--
ALTER TABLE `tg_log`
  ADD PRIMARY KEY (`log_ncorr`);

--
-- Indices de la tabla `tg_mapeoimportacion`
--
ALTER TABLE `tg_mapeoimportacion`
  ADD PRIMARY KEY (`MIM_NCORR`),
  ADD KEY `fk_map_tda_01` (`TDA_NCORR`);

--
-- Indices de la tabla `tg_ordenservicio`
--
ALTER TABLE `tg_ordenservicio`
  ADD PRIMARY KEY (`OSE_NCORR`),
  ADD KEY `fk_puntocarguio` (`LUG_NCORR_PUNTOCARGUIO`);

--
-- Indices de la tabla `tg_parametro`
--
ALTER TABLE `tg_parametro`
  ADD PRIMARY KEY (`par_ncorr`);

--
-- Indices de la tabla `tg_procesoimportacion`
--
ALTER TABLE `tg_procesoimportacion`
  ADD PRIMARY KEY (`PIM_NCORR`);

--
-- Indices de la tabla `tg_servicio`
--
ALTER TABLE `tg_servicio`
  ADD PRIMARY KEY (`serv_ncorr`),
  ADD KEY `FK_REFERENCE_42` (`CAR_NCORR`),
  ADD KEY `FK_REFERENCE_43` (`LUG_NCORR_DESTINO`),
  ADD KEY `FK_REFERENCE_44` (`EMP_NCORR`),
  ADD KEY `FK_REFERENCE_46` (`CHA_NCORR`),
  ADD KEY `FK_REFERENCE_47` (`CHOF_NCORR`),
  ADD KEY `FK_REFERENCE_52` (`LUG_NCORR_ORIGEN`),
  ADD KEY `FK_REFERENCE_53` (`CAM_NCORR`);

--
-- Indices de la tabla `tg_tarifa`
--
ALTER TABLE `tg_tarifa`
  ADD PRIMARY KEY (`TAR_NCORR`);

--
-- Indices de la tabla `tg_tarifaservicio`
--
ALTER TABLE `tg_tarifaservicio`
  ADD PRIMARY KEY (`TASI_NCORR`),
  ADD KEY `FK_REFERENCE_60` (`TISE_NCORR`),
  ADD KEY `FK_REFERENCE_61` (`CLIE_VRUT`),
  ADD KEY `FK_REFERENCE_62` (`LUG_NCORR_ORIGEN`),
  ADD KEY `FK_REFERENCE_63` (`LUG_NCORR_DESTINO`),
  ADD KEY `FK_REFERENCE_65` (`STS_NCORR`);

--
-- Indices de la tabla `tg_tramo`
--
ALTER TABLE `tg_tramo`
  ADD PRIMARY KEY (`TRA_NCORR`);

--
-- Indices de la tabla `tg_tramo_subtiposervicio`
--
ALTER TABLE `tg_tramo_subtiposervicio`
  ADD UNIQUE KEY `tss_ncorr` (`tss_ncorr`);

--
-- Indices de la tabla `tg_usuario`
--
ALTER TABLE `tg_usuario`
  ADD PRIMARY KEY (`USUA_NCORR`);

--
-- Indices de la tabla `tg_versioncarga`
--
ALTER TABLE `tg_versioncarga`
  ADD PRIMARY KEY (`CAR_NVERSION`);

--
-- Indices de la tabla `tg_viaje`
--
ALTER TABLE `tg_viaje`
  ADD PRIMARY KEY (`VIA_NCORR`),
  ADD KEY `FK_REFERENCE_54` (`LUG_NCORR_ORIGEN`),
  ADD KEY `FK_REFERENCE_55` (`LUG_NCORR_DESTINO`);

--
-- Indices de la tabla `viaje`
--
ALTER TABLE `viaje`
  ADD PRIMARY KEY (`VIA_NCORR`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `tg_carga`
--
ALTER TABLE `tg_carga`
  MODIFY `CAR_NCORR` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador de la carga', AUTO_INCREMENT=498;

--
-- AUTO_INCREMENT de la tabla `tg_detallefactura`
--
ALTER TABLE `tg_detallefactura`
  MODIFY `DEFA_NCORR` double NOT NULL AUTO_INCREMENT COMMENT 'Id. del detalle de la factura';

--
-- AUTO_INCREMENT de la tabla `tg_guiatransporte`
--
ALTER TABLE `tg_guiatransporte`
  MODIFY `guia_ncorr` double NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT de la tabla `tg_log`
--
ALTER TABLE `tg_log`
  MODIFY `log_ncorr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=286;

--
-- AUTO_INCREMENT de la tabla `tg_ordenservicio`
--
ALTER TABLE `tg_ordenservicio`
  MODIFY `OSE_NCORR` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador del registro', AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT de la tabla `tg_servicio`
--
ALTER TABLE `tg_servicio`
  MODIFY `serv_ncorr` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id. de la programación', AUTO_INCREMENT=153;

--
-- AUTO_INCREMENT de la tabla `tg_tramo`
--
ALTER TABLE `tg_tramo`
  MODIFY `TRA_NCORR` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id. del tramo', AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `tg_tramo_subtiposervicio`
--
ALTER TABLE `tg_tramo_subtiposervicio`
  MODIFY `tss_ncorr` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `tg_versioncarga`
--
ALTER TABLE `tg_versioncarga`
  MODIFY `CAR_NVERSION` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
