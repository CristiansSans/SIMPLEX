-- phpMyAdmin SQL Dump
-- version 4.9.7
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 07-04-2022 a las 13:06:19
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
-- Base de datos: `simplex1_sqm_tst`
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
(55555555, 'Nestle Argentina Purina', '', 'Miguel Pereyra', 'Carlos Pellegrini, 887 (1009)', NULL, NULL, 'Bs Aires', 'Fabricacion de alimentos', 'Fono', '', 60, 'Nestle Argentina Purina', 'Fabricación de Alimentos'),
(76056575, 'Wausau', '', 'Juan Politeo', 'Compañia', NULL, 76056575, 'Santiago', 'Venta al por mayor de papel y cartón', '56 (9)', '', 20, 'Comercializadora WAUSAU Conosur', 'Venta al por mayor de papel y cartón'),
(76181967, 'Imolog', '', 'Juan Riquelme', 'Camino Lampa Noviciado KM 14,5', NULL, NULL, 'Lampa', 'Transporte y bodega', '56 (2) 25872809', '', 15, 'Logistica e Inmobiliaria Lipangue', 'Bodegaje'),
(76242324, 'Vicsa Seafty', '', 'Luis Castillo', 'Pintor Cicarelli 683', NULL, NULL, 'San Joanquin', 'Venta al por mayor de otros productos N. N.', '56 (2) 25894100', '', 20, 'Vicsa Seafty comercial limitada', ''),
(76360653, 'Dgru S.A.', '', 'Jorge Martinez', 'Agustinas 1442 A907', NULL, NULL, 'Santiago', 'Venta al por mayor de maquinaria, herramientas', '56 (9) 77641277', '', 5, 'Dgru S.A.', 'Arriendo de Gruas Torre'),
(76384229, 'Promotive', '', 'Pablo Salas', 'General Holley 2363 A of 1301', NULL, NULL, 'Providencia', 'Venta al por mayor ', '56 (2) 23018314', '', 10, 'Importadora y Comercializadora Promotive Spa', 'Importadora y Comercializadora'),
(76448589, 'Porteo', '', 'Oscar Vasquez', 'Pasaje 6 1047 Don Horacio-', NULL, NULL, 'Molina', 'Transporte de Carga por Carretera', '56 (9) 30867763', '', 15, 'Sociedad de Transportes Porteo Ltda', 'Transporte'),
(76613670, 'Royal Canin', '', 'Ana Isabel Marchant', 'Hermanos Carrera Pinto 95-A Los Liberadores', NULL, NULL, 'Quilicura', 'Venta al por mayor de otros productos', '56 (2) 26 18 75 43', '', 15, 'Importadora y Comercializadora Royal Canin Chile L', 'Venta de Alimento para Mascotas'),
(77006430, 'Cav', '', 'José Bustamante', 'Camino La Montaña', NULL, NULL, 'Quilicura', 'Venta Licores', '56 (2) 23938170', '', 15, 'Cav Sociedad Anonima', 'Venta Vino'),
(77517270, 'Transportes DESA ltda', '', 'Sebastian Millie', 'Av. La Montaña 776', NULL, NULL, 'Quilicura', 'Transporte de Carga por Carretera', '56 (2) 24891523', '', 15, 'Transportes DESA ltda', 'Transporte'),
(77753250, 'Transportes Calidra', '', 'Guillermo Purdham', 'Chorrillos 1, Parcela 9 - Lampa', NULL, NULL, 'Noviciado - Lampa.', 'Transporte de carga por carretera.', '56 (9) 44890882', '', 1, 'Transporte Calidra Ltda.', 'transporte de carga'),
(81866400, 'Fosko S.A.', '', 'Luisa Contreras', 'Brown Norte  797', NULL, NULL, 'Nunoa', 'FABRICACION DE OTROS ARTICULOS DE PLASTI', '56 (2) 23986100', '', 5, 'Fabrica de Envases Fosko S.A.', ''),
(89201400, 'Envases Impresos S.A  (CMPC)', '', 'Valentina Alvarez', 'Camino Alto Jahuel 0360', NULL, NULL, 'Buin', 'Fábrica de Envases de papel y carton', '56 (2) 2471352', '', 10, 'Envases Impresos S.A', 'Fábrica de Envases de papel y carton'),
(90914000, 'Moletto', '', 'Pablo Saavedra', 'Av. Matucana 1223', NULL, 90914000, 'Santiago', 'Manufacturas Textiles', '56 (9) 87464245', '', 10, 'Moletto Hermanos S.A.', 'Comercialización de Textiles'),
(93515000, 'General Motors', '', 'Jerome Faundez', 'Av. Américo Vespucio Norte 811', NULL, NULL, 'Huachuraba', 'Fabricación de Vehículos Automotores', '56 (2) 25206210', '', 30, 'General Motors Chile Industria Automotriz Ltda', 'Venta de Vehículos'),
(96690870, 'Integrity S.A.', '', 'Patricio Almonte', 'San Pablo Antiguo S/N ', NULL, NULL, 'San Pablo', 'Venta al por mayor de otros productos ', '56 (2) 2904791', '', 5, 'Integrity S.A.', 'Venta bandejas Plásticos'),
(96733780, 'Ultra Pac', '', 'Patricio Almonte', 'San Pablo Antiguo S/N ', NULL, NULL, 'Pudahuel', 'Fabricación de otros artículos de plastic', '56 (2) 24904791', '', 5, 'Ultra Pac Sudamericana S.A', ''),
(96756430, 'Chilexpress ', '', 'Ricardo lopez', 'José Joaquín Perez N°1376', NULL, NULL, 'Pudahuel, Santiago', 'Transporte de carga', '56 (2) 2384878', '', 1, 'Chilexpress S.A', 'transporte de carga'),
(96792430, 'Sodimac S.A.', '', 'Richard Simpson', 'Av Pdte Frei Montalva  3092', NULL, NULL, 'Renca', 'Servicio de Almacenamiento y Deposito', '56 (9) 61577519', '', 30, 'Sodimac S.A.', 'Retail'),
(96853150, 'Cmpc', '', 'Manuel Alberto Vergara Rodriguez', 'Av. Eyzaguirre 01098 Puente Alto, Santiago', NULL, NULL, 'Puente Alto', 'Fabricación de papeles y cartones', '56 (2) 23675632', '', 10, 'Papeles Cordillera S.A.', 'Exportación de papeles y cartones');

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
(3, 1, 'Lirquen', '', 'L0003', 'Lirquen', 1, 68, 1, 1, 1),
(4, 1, 'Cornel', '', 'L0004', 'Coronel', 1, 36, 1, 1, 1),
(5, 3, 'ZEAL', '', 'L0005', 'Valparaiso', 3, 29, 1, 1, 1),
(6, 3, 'SAAM (Valp)', '', 'L0006', 'Valparaiso', 3, 29, 1, 1, 1),
(7, 3, 'San Francisco SAI', '', 'L0007', 'San Antonio', 3, 68, 1, 1, 1),
(8, 3, 'San Francisco VAP', '', 'L0008', 'Valparaiso', 3, 68, 1, 1, 1),
(9, 3, 'DYC SAI', '', 'L0009', 'San Antonio', 3, 30, 1, 1, 1),
(10, 3, 'Contopsa SAI', '', 'L0010', 'San Antonio', 3, 68, 1, 1, 1),
(11, 3, 'Depot Biggio VAP', '', 'L0011', 'Valparaiso', 3, 68, 1, 1, 1),
(12, 3, 'DYC VAP', '', 'L0012', 'Valparaiso', 3, 29, 1, 1, 1),
(14, 2, 'DYC SCL', '', 'L0014', 'Santiago', 2, 14, 1, 0, 1),
(16, 2, 'LOCSA', '', 'L0016', 'Santiago', 2, 14, 1, 0, 1),
(17, 2, 'Labra', '', 'L0017', 'Santiago', 2, 33, 1, 0, 1),
(18, 2, 'Sitrans SCL', '', 'L0018', 'Santiago', 2, 33, 1, 1, 1),
(19, 2, 'SAAM SCL', '', 'L0019', 'Santiago', 2, 33, 1, 1, 1),
(20, 2, 'Agunsa SCL', '', 'L0020', 'Santiago', 2, 33, 1, 1, 1),
(22, 2, 'Contopsa SCL', '', 'L0022', 'Santiago', 2, 33, 1, 1, 1),
(23, 4, 'SODIMAC-CD Lo Espejo', '', 'L0023', 'Santiago', 4, 33, 0, 0, 1),
(24, 4, 'Derco-Lo Boza', '', 'L0024', 'Santiago', 4, 33, 0, 1, 1),
(25, 4, 'SODIMAC-Lo Echevers', '', 'L0025', 'Santiago', 4, 33, 0, 1, 1),
(26, 4, 'Concha y Toro-Pirque', '', 'L0026', 'Santiago', 4, 33, 0, 1, 1),
(27, 4, 'Concha y Toro-Lo Espejo', '', 'L0027', 'Santiago', 4, 33, 0, 1, 1),
(28, 4, 'San Pedro-Lo Espejo', '', 'L0028', 'Santiago', 4, 33, 0, 1, 1),
(32, NULL, 'VICSA-Farfana', '', 'L0029', 'Santiago', 4, 68, 0, 1, 1),
(33, NULL, 'Wausau-General Velasquez', 'CompaÃ±ia 1390 905', 'L0030', 'Santiago', 4, 68, 0, 1, 1),
(34, NULL, 'Wausau-Papelera Herrera', 'Las CaÃ±as 924', 'L0031', 'Valparaiso', 4, 68, 0, 0, 1),
(35, NULL, 'EASY-La Farfana', '', 'L0032', 'Santiago', 4, 68, 0, 0, 1),
(36, NULL, 'Origen', 'Origen', 'L0033', 'Santiago', 4, NULL, 1, 1, 1),
(37, NULL, 'Moletto-Matucana', 'Av. Matucana 1223', 'L0034', 'Santiago', 4, 68, 1, 1, 1),
(38, NULL, 'Moletto-Pto Madero', 'Puerto Madero 9710 Bodega Z19', 'L0035', 'Santiago', 4, 38, 1, 1, 1),
(39, NULL, 'Moletto-Laguna Sur', 'Laguna Sur Bodega A9', 'L0036', 'Santiago', 4, 68, 1, 1, 1),
(40, NULL, 'DepÃ³sito Lo Herrera', 'Pdte Jorge Alessandri R. 24.481 Lo Herrera, San Bernardo', 'L0037', 'Santiago', 1, NULL, 1, 1, 1),
(41, NULL, 'GM-Enea', 'Boulevard Poniente 1313, Enea', 'L0038', 'Santiago', 4, 36, 1, 1, 1),
(42, NULL, 'Bodega Pacific Star', 'Buzeta 3915, Cerrillos', 'L0039', 'Santiago', 2, 42, 1, 1, 1),
(43, NULL, 'Nestle Santo Tome', 'Ruta 11 Km 457, Santo Tomas', 'L0040', 'Santa Fe', 4, 36, 1, 1, 1),
(44, NULL, 'DepÃ³sito RenÃ© SAI', '', 'L0041', 'San Antonio', 3, NULL, 1, 1, 1),
(45, NULL, 'DepÃ³sito RenÃ© VAP', '', 'L0042', 'Valparaiso', 3, NULL, 1, 1, 1),
(46, NULL, 'GM-Acdelco Antofa', 'Av. El CoigÃ¼e 450 la portada Antofagasta', 'L0043', 'Antofagasta', 4, 68, 0, 0, 1),
(47, NULL, 'Moletto-Cliente', 'Walmart - Jumbo', 'L0044', 'Santiago', 4, 68, 0, 0, 1),
(48, NULL, 'Bodega Simplex Lo Boza', 'Volcan Lascar 801  3D, Pudahuel ', 'L0045', 'Santiago', 2, NULL, 1, 1, 1),
(49, NULL, 'STI (IMO)', 'Pto San Antonio', 'L0046', 'San Antonio', 1, NULL, 1, 1, 1),
(50, NULL, 'ZEAL (IMO)', 'Pto Valparaiso', 'L0047', 'Valparaiso', 1, NULL, 1, 1, 1),
(51, NULL, 'GM-Janssen', 'Panamericana Norte 5353 ConchalÃ­', 'L0048', 'Santiago', 4, 68, 0, 0, 1),
(52, NULL, 'GM-Dimac', 'Til Til 1980 Ã‘uÃ±oa', 'L0049', 'Santiago', 4, 68, 0, 0, 1),
(53, NULL, 'Trasvasije', '', 'LS001', 'Santiago', 2, 40, 1, 1, 1),
(54, NULL, 'Arriendo Contenedor 20', '	', 'S0001', 'Santiago', 2, 54, 1, 1, 1),
(55, NULL, 'Arriendo Contenedor 40', '', 'S0002', 'Santiago', 2, 55, 1, 1, 1),
(56, NULL, 'SODIMAC-La Farfana', 'La Farfana B163', 'L0050', 'Santiago', 2, 56, 1, 1, 1),
(57, NULL, 'SODIMAC-Rancagua', 'Av. Nueva Albert Einstein 297', 'L0051', 'Rancagua', 5, 57, 0, 1, 1),
(58, NULL, 'SODIMAC-San Fernando', 'Av. Libertador BDO O.Higgins San Fernando', 'L0052', 'San Fernando', 5, 58, 0, 1, 1),
(59, NULL, 'SODIMAC-Curico', 'Av. Condell NÂ° 1192', 'L0053', 'Curico', 5, 59, 0, 1, 1),
(60, NULL, 'SODIMAC-ConcepciÃ³n', '', 'L0054', 'ConcepciÃ³n', 5, 56, 0, 1, 1),
(61, NULL, 'Planta Envases Impresos', 'Alto Jahuel', 'L0055', 'Paine', 4, 20, 0, 1, 1),
(62, NULL, 'SODIMAC-Melipilla', 'Melipilla', 'L0057', 'Melipilla', 4, 68, 0, 1, 1),
(63, NULL, 'CMPC planta Puente Alto', 'Av. Eyzaguire 01098 Puente Alto', 'L0058', 'Santiago', 4, 68, 0, 1, 0),
(64, NULL, 'Puerto San Antonio (SAI)', 'Barros Luco San Antonio', 'L0059', 'San Antonio', 1, 68, 1, 1, 1),
(65, NULL, 'GM Planta Sao Paulo', '', 'L0060', 'Sao Paulo', 4, 65, 1, 1, 1),
(66, NULL, 'Aduana Suzano-BR', '', 'L0061', 'Sao Paulo', 1, 68, 0, 0, 0),
(67, NULL, 'Aduana Uspallata-ARG', '', 'L0062', 'Mendoza', 1, NULL, 0, 0, 0),
(68, NULL, 'Aduana los Andes-CH', '', 'L0063', 'Los Andes', 1, 68, 0, 0, 0),
(69, NULL, 'Aduana Uruguaiana- BR', '', 'L0064', 'Uruguaiana', 1, NULL, 0, 0, 0),
(70, NULL, 'Aeropuerto ', 'Depocargo', 'L0065', 'Santiago', 2, 70, 1, 1, 1),
(71, NULL, 'Chilexpress  Enea 4', 'JoaquÃ­n PÃ©rez 776', 'L0066', 'Santiago', 4, 71, 0, 1, 1),
(72, NULL, 'Chilexpress Los Maitenes', 'Los Maitenes oriente 1287 ', 'L0067', 'Santiago', 2, 36, 1, 1, 1),
(73, NULL, 'Chilexpress Oficina Comercial', '', 'L0068', 'Santiago', 4, 72, 0, 0, 1),
(74, NULL, 'Chilexpress Oficina Comercial Spot', '', 'L0069', 'Santiago', 4, 72, 0, 0, 1),
(75, NULL, 'GM Planta Sao Paulo IMO', '', 'L0070', 'Sau Paulo', 4, 75, 1, 1, 1),
(76, NULL, 'GM Planta Sao Paulo', '', 'L0071', 'Sao Paulo', 4, 65, 1, 1, 1),
(77, NULL, 'Chilexpress Enea 4 Spot', 'JoaquÃ­n PÃ©rez 776', 'L0072', 'Santiago', 4, 71, 1, 1, 1),
(78, NULL, 'Chilexpress Enea 4 Festivos', 'JoaquÃ­n PÃ©rez 776', 'L0078', 'Santiago', 4, 71, 1, 1, 1);

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
(16, 'Trasvasije 20 Std', 70, 53, 53, 93515000, 70000),
(17, 'Arriendo y Almacenaje cnt 20', 50, 54, 54, 93515000, 116000),
(19, 'TRANSPORTE RANCAGUA', 19, 56, 57, 96792430, 185265),
(20, 'TRANSPORTE SAN FERNANDO', 19, 56, 58, 96792430, 212175),
(21, 'TRANSPORTE CURICO', 19, 56, 59, 96792430, 235000),
(22, 'EXPO CONTENEDORES SAI', 10, 61, 2, 89201400, 195000),
(23, 'EXPO CONTENEDORES VAP', 10, 61, 1, 89201400, 195000),
(24, 'TRANSPORTE MELIPILLA', 19, 56, 62, 96792430, 139725),
(25, 'TRANSPORTE CONCEPCION', 19, 56, 60, 96792430, 450000),
(26, 'EXPO CONTENEDORES SAI', 19, 63, 20, 96853150, 0),
(27, 'Transporte Aeropuerto ', 54, 70, 71, 96756430, 167000),
(28, 'Transporte Abastecimiento ', 54, 72, 73, 96756430, 175560),
(29, 'Transporte Abastecimientos Spot', 54, 72, 74, 96756430, 188900),
(30, 'Transporte GM Internacional', 29, 65, 41, 93515000, 3950),
(31, 'transporte GM IMO Internacional', 29, 75, 41, 93515000, 4090),
(32, 'Transporte Aeropuerto Dom/Festivos', 54, 70, 77, 96756430, 200400),
(33, 'Transporte Aeropuerto Spot', 54, 70, 71, 96756430, 167000),
(34, 'Arriendo', 50, 79, 79, 77233449, 50000),
(35, 'Distribucion', 54, 79, 79, 77233449, 50000),
(36, 'otro mas', 54, 70, 20, 77233449, 10000),
(37, 'Prueba', 54, 68, 66, 96756430, 150000);

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
(26, 'NC 7567', 62, '', 'FL 2000'),
(27, 'CAXU995305', 65, '', ''),
(28, 'MSCU375949', 65, '40', ''),
(29, 'CRXV981036', 65, '40', ''),
(30, 'NYKU403584', 65, '40', ''),
(31, 'MSCU912308', 65, '40', ''),
(32, 'FG4142', 68, 'INTERNATIONAL', 'INTERNATIONAL'),
(33, 'YD8083', 68, 'INTERNATIONAL', 'INTERNATIONAL'),
(34, '', 68, '', ''),
(35, 'RA6485', 67, 'VOLVO', 'FM 12'),
(36, 'HCDL21', 69, 'RENAULT', 'PRIMIUM 460'),
(37, 'PD4576', 69, 'VOLVO', 'FM12'),
(38, 'TI4089', 69, 'FREIGHLINE', 'M12 112'),
(39, 'BPWD24', 69, 'VOLVO', 'FM 12'),
(40, 'YD8083', 70, 'International', '9800i'),
(41, 'FG4142', 70, 'International', '1994'),
(42, 'CFYS-48', 72, 'Mercedes-Benz ', 'FurgÃ³n  14 Pallet, Atego1718 '),
(43, 'KX-6148', 73, '', '8 Pallet'),
(44, 'DLYX-36', 73, '', '8 Pallet'),
(45, 'BWGB-97', 74, '', ''),
(46, 'RO 1111', 71, '', ''),
(47, 'MA1111', 78, '', ''),
(48, 'IN000', 79, '', ''),
(49, 'KX6149', 56, '', ''),
(50, 'DLYX36', 56, '', ''),
(51, 'KX6X48', 80, 'FOTON', 'NEW AUMARK S815E5'),
(52, 'DLYX36', 80, 'MITSUBISHI', ''),
(53, 'MAV001', 81, '', ''),
(54, 'LXWJ28', 77, '', ''),
(55, 'DDFW72', 75, 'HYUNDAY', 'H1'),
(56, 'KJJF45', 82, 'KIA', 'FRONTIER'),
(57, 'BWGB97', 83, 'PEUGEOT', 'BOXER'),
(58, 'PBHT85', 84, '', ''),
(59, 'ABc342', 85, 'Ford', 'l3');

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
(502, '2009977', NULL, NULL, NULL, NULL, NULL, NULL, '', 2, NULL, 63, 6, NULL, NULL, NULL, NULL, '1745480', 0, 57, 0, '0000-00-00', NULL),
(504, '1787421', NULL, NULL, NULL, NULL, NULL, NULL, '', 2, NULL, 64, 6, NULL, NULL, NULL, NULL, '2060469', 0, 58, 0, '0000-00-00', NULL),
(505, '1787481', NULL, NULL, NULL, NULL, NULL, NULL, '', 2, NULL, 63, 6, NULL, NULL, NULL, NULL, '2060539', 0, 57, 0, '0000-00-00', NULL),
(506, '', NULL, NULL, NULL, NULL, NULL, NULL, ' 01/09/2020', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(507, '', NULL, NULL, NULL, NULL, NULL, NULL, '02/09/2020  Retiro ATO Enea 4.', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(508, '', NULL, NULL, NULL, NULL, NULL, NULL, '03/09/2020 Retiro ATO  Enea 4', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(509, '', NULL, NULL, NULL, NULL, NULL, NULL, ' 01/09/2020 Jornada ', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 72, 0, '0000-00-00', NULL),
(510, '', NULL, NULL, NULL, NULL, NULL, NULL, '01/09/2020 Jornada', 2, NULL, 68, 6, NULL, NULL, NULL, NULL, '', 0, 72, 0, '0000-00-00', NULL),
(511, '', NULL, NULL, NULL, NULL, NULL, NULL, '02/09/2020 Jornada', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 72, 0, '0000-00-00', NULL),
(512, '', NULL, NULL, NULL, NULL, NULL, NULL, '03/09/2020  Jornada ', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(513, '', NULL, NULL, NULL, NULL, NULL, NULL, '02/09/2020 Jornada', 2, NULL, 68, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(514, '', NULL, NULL, NULL, NULL, NULL, NULL, '03/09/2020 Jornada ', 2, NULL, 68, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(517, '', NULL, NULL, NULL, NULL, NULL, NULL, '04/09/2020 Retiro ATO Enea 4', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(518, '', NULL, NULL, NULL, NULL, NULL, NULL, '05/09/2020  Retiro ATO Enea 4', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(519, '', NULL, NULL, NULL, NULL, NULL, NULL, '07/09/2020 Retiro ATO Enea 4', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(520, '3004580', NULL, NULL, NULL, NULL, NULL, NULL, '04/09/2020  Jornada Carga programada 6 pallet.', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 72, 0, '0000-00-00', NULL),
(521, '3004611', NULL, NULL, NULL, NULL, NULL, NULL, '07/09/2020 Jornada Carga programada 13 pallet.', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 72, 0, '0000-00-00', NULL),
(522, '3004611', NULL, NULL, NULL, NULL, NULL, NULL, '08/09/2020 Jornada.', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 72, 0, '0000-00-00', NULL),
(523, '', NULL, NULL, NULL, NULL, NULL, NULL, '09/08/2020  Jornada.', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 72, 0, '0000-00-00', NULL),
(524, '', NULL, NULL, NULL, NULL, NULL, NULL, '10/09/2020 Jornada', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(525, '', NULL, NULL, NULL, NULL, NULL, NULL, '11/09/2020 Jornada ', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(527, '', NULL, NULL, NULL, NULL, NULL, NULL, '08/09/2020 Retiro ATO  a Enea 4', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(528, '', NULL, NULL, NULL, NULL, NULL, NULL, '09/09/2020 Retiro ATO a Enea 4.', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(529, '', NULL, NULL, NULL, NULL, NULL, NULL, '10/09/2020 Jornada.', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(530, '', NULL, NULL, NULL, NULL, NULL, NULL, '11/09/2020 Jornada.', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(531, '', NULL, NULL, NULL, NULL, NULL, NULL, '12/09/2020 Jornada.', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(532, '', NULL, NULL, NULL, NULL, NULL, NULL, '14/09/2020  Jornada.', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(533, '', NULL, NULL, NULL, NULL, NULL, NULL, '15/09/2020 Jornada.', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(534, '', NULL, NULL, NULL, NULL, NULL, NULL, '16/09/2020 Turno 1', 2, NULL, 65, 2, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(535, '', NULL, NULL, NULL, NULL, NULL, NULL, '17/09/2020 Jornada.', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(536, '', NULL, NULL, NULL, NULL, NULL, NULL, '14/09/2020 Jornada.', 2, NULL, 67, 2, NULL, NULL, NULL, NULL, '', 0, 72, 0, '0000-00-00', NULL),
(537, '', NULL, NULL, NULL, NULL, NULL, NULL, '15/09/2020 Jornada.', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(538, '', NULL, NULL, NULL, NULL, NULL, NULL, '16/09/2020 Jornada.', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(539, '', NULL, NULL, NULL, NULL, NULL, NULL, '17/09/2020 Jornada.', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(541, '14270', NULL, NULL, NULL, NULL, NULL, NULL, ' Viaje - 04/08/2020 F: R14270, R14280, R15170,  R11790   CRT: 400.501.648/649/650/651 Descarga - 17/08/2020.', 2, NULL, 69, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(542, '14060', NULL, NULL, NULL, NULL, NULL, NULL, 'Viaje - 06/08/2020F: R14060, R13660CRT: 400.501.654/655Descarga - 18/08/2020', 2, NULL, 70, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(543, '15590', NULL, NULL, NULL, NULL, NULL, NULL, 'Viaje - 07/08/2020F: R15590   CRT: 400.501.656Descarga - 19/08/2020.', 2, NULL, 69, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(544, '16000', NULL, NULL, NULL, NULL, NULL, NULL, 'Viaje - 12/08/2020F: R16000, R15580, R15600CRT: 400.501.661/662/663Descarga - 24/08/2020.', 2, NULL, 69, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(545, '16770', NULL, NULL, NULL, NULL, NULL, NULL, 'Viaje - 21/08/2020F: R16770CRT: 400.501.666Descarga - 28/08/2020', 2, NULL, 69, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(546, '16130', NULL, NULL, NULL, NULL, NULL, NULL, 'Viaje - 24/08/2020F: R16130CRT: 400.501.672', 2, NULL, 69, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(547, '17600', NULL, NULL, NULL, NULL, NULL, NULL, 'Viaje - 04/09/2020F: R17600CRT: 400.501.671', 2, NULL, 69, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(548, '18330', NULL, NULL, NULL, NULL, NULL, NULL, 'Viajes - 11/09/2020 F: R18330, R18360 CRT: 400.501. 675/676', 2, NULL, 69, 6, NULL, NULL, NULL, NULL, '', 0, 65, 0, '0000-00-00', NULL),
(549, '15770', NULL, NULL, NULL, NULL, NULL, NULL, 'Viaje - 11/08/2020F: R15770, R15780, R16010CRT:400.501.657/658/659Descarga - 24/08/2020', 2, NULL, 70, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(550, '18300', NULL, NULL, NULL, NULL, NULL, NULL, 'Viaje - 11/09/2020F: R18300CRT: 400.501.674', 2, NULL, 70, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(551, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Retiro ATO - 21/09/2020', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(552, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Retiro ATO - Enea 4 22/09/2020.', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(553, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Retiro ATO - Enea  4 23/09/2020.', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(554, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Retiro ATO -Enea 4', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(555, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Retiro ATO -Enea 4 25/09/2020.', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(556, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Retiro ATO - Enea 426/09/2020.', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(562, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Jornada', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(563, '', NULL, NULL, NULL, NULL, NULL, NULL, '8/09/2020 camión adicional ', 2, NULL, 65, 2, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(564, '', NULL, NULL, NULL, NULL, NULL, NULL, '08/09/2020 Segundo camión', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(565, '', NULL, NULL, NULL, NULL, NULL, NULL, '08/09/2020', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(566, '', NULL, NULL, NULL, NULL, NULL, NULL, '08/09/2020 2do camión', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(567, '', NULL, NULL, NULL, NULL, NULL, NULL, '08/09/2020 2do camión', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(568, '', NULL, NULL, NULL, NULL, NULL, NULL, '15/09/2020 2do camión', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(569, '', NULL, NULL, NULL, NULL, NULL, NULL, '16/09/2020 2do camión', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(570, '', NULL, NULL, NULL, NULL, NULL, NULL, '15/09/2020 2da camión', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(571, '', NULL, NULL, NULL, NULL, NULL, NULL, '28/09/2020 2do camión ', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(572, '', NULL, NULL, NULL, NULL, NULL, NULL, '29/09/2020 2do camión', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(573, '', NULL, NULL, NULL, NULL, NULL, NULL, '30/09/2020 2do camión', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(577, '', NULL, NULL, NULL, NULL, NULL, NULL, '21-09-2020', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(578, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-09-2020', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(579, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-09-2020', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(580, '', NULL, NULL, NULL, NULL, NULL, NULL, '24-09-2020', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(581, '', NULL, NULL, NULL, NULL, NULL, NULL, '28-09-2020', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(582, '', NULL, NULL, NULL, NULL, NULL, NULL, '29-09-2020', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(583, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-09-2020', 2, NULL, 67, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(592, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-09-2020', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(594, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-09-2020', 2, NULL, 71, 6, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(595, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-09-2020', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(596, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-09-2020', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(597, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-09-2020', 2, NULL, 65, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(598, '', NULL, NULL, NULL, NULL, NULL, NULL, '21-09-2020', 2, NULL, 71, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(599, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-09-2020', 2, NULL, 71, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(600, '', NULL, NULL, NULL, NULL, NULL, NULL, '28-09-2020', 2, NULL, 71, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(601, '', NULL, NULL, NULL, NULL, NULL, NULL, '29-09-2020', 2, NULL, 71, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(602, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-09-2020', 2, NULL, 71, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(603, '', NULL, NULL, NULL, NULL, NULL, NULL, '01-10-2020', 2, NULL, 66, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(604, '', NULL, NULL, NULL, NULL, NULL, NULL, '2-10-2002', 2, NULL, 66, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(605, '', NULL, NULL, NULL, NULL, NULL, NULL, '01-10-2020', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(606, '', NULL, NULL, NULL, NULL, NULL, NULL, '02-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(607, '', NULL, NULL, NULL, NULL, NULL, NULL, '02-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(608, '', NULL, NULL, NULL, NULL, NULL, NULL, '03-10-2020', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(609, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-10-2020', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(610, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(611, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(612, '', NULL, NULL, NULL, NULL, NULL, NULL, '06-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(613, '', NULL, NULL, NULL, NULL, NULL, NULL, '06-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(614, '', NULL, NULL, NULL, NULL, NULL, NULL, '07-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(615, '', NULL, NULL, NULL, NULL, NULL, NULL, '07-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(616, '', NULL, NULL, NULL, NULL, NULL, NULL, '08-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(617, '', NULL, NULL, NULL, NULL, NULL, NULL, '08-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(618, '', NULL, NULL, NULL, NULL, NULL, NULL, '09-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(619, '', NULL, NULL, NULL, NULL, NULL, NULL, '09-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(620, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-10-2020', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(621, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-10-2020', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(622, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-10-2020 Feriado', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(623, '', NULL, NULL, NULL, NULL, NULL, NULL, '13-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(624, '', NULL, NULL, NULL, NULL, NULL, NULL, '13-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(625, '', NULL, NULL, NULL, NULL, NULL, NULL, '01-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(626, '', NULL, NULL, NULL, NULL, NULL, NULL, '02-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(627, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(628, '', NULL, NULL, NULL, NULL, NULL, NULL, '06-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(629, '', NULL, NULL, NULL, NULL, NULL, NULL, '07-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(630, '', NULL, NULL, NULL, NULL, NULL, NULL, '08-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(631, '', NULL, NULL, NULL, NULL, NULL, NULL, '09-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(632, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(633, '', NULL, NULL, NULL, NULL, NULL, NULL, '13-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(634, '', NULL, NULL, NULL, NULL, NULL, NULL, '14-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(635, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(636, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(637, '', NULL, NULL, NULL, NULL, NULL, NULL, '14-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(638, '', NULL, NULL, NULL, NULL, NULL, NULL, '14-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(639, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-10-2020 César', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(640, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(641, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(642, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(643, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-10-2020 ', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(644, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-10-2020', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(645, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(646, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(647, '', NULL, NULL, NULL, NULL, NULL, NULL, '20-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(648, '', NULL, NULL, NULL, NULL, NULL, NULL, '20-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(649, '', NULL, NULL, NULL, NULL, NULL, NULL, '20-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(650, '', NULL, NULL, NULL, NULL, NULL, NULL, '21-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(651, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(652, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(653, '', NULL, NULL, NULL, NULL, NULL, NULL, '21-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(654, '', NULL, NULL, NULL, NULL, NULL, NULL, '21-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(655, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(656, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(657, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(658, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(659, '', NULL, NULL, NULL, NULL, NULL, NULL, ' 23-10-2020 ', 2, NULL, 74, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(660, '', NULL, NULL, NULL, NULL, NULL, NULL, '24/10-2020 César', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(661, '', NULL, NULL, NULL, NULL, NULL, NULL, '25/10/2020 César', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(662, '', NULL, NULL, NULL, NULL, NULL, NULL, '26/10/2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(663, '', NULL, NULL, NULL, NULL, NULL, NULL, '26/10/2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(664, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(665, 'CRT1680/ CRT1681', NULL, NULL, NULL, NULL, NULL, NULL, '17-09-20 F:R18840/R18870R18840CRT: 400.501.680/681', 2, NULL, 70, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(666, 'CRT1676', NULL, NULL, NULL, NULL, NULL, NULL, '11-09-20 F: R18360 CRT: 400.501.676', 2, NULL, 69, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(667, 'CRT1682', NULL, NULL, NULL, NULL, NULL, NULL, '17-09-20 F:R18980 CRT:400.501.682', 2, NULL, 69, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(668, 'CRT1706', NULL, NULL, NULL, NULL, NULL, NULL, '08-10-20 F:R20220 CRT:400.501.706', 2, NULL, 75, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(669, 'CRT1707', NULL, NULL, NULL, NULL, NULL, NULL, '13-10-20F:R20370 CRT:400.501.707', 2, NULL, 75, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(670, 'CRT1710', NULL, NULL, NULL, NULL, NULL, NULL, '15-10-20 F:R21740 CRT:400.501.710', 2, NULL, 75, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(671, 'CRT1716', NULL, NULL, NULL, NULL, NULL, NULL, '19-10-20 F:R21460 CRT: 400.501.716', 2, NULL, 75, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(672, '', NULL, NULL, NULL, NULL, NULL, NULL, '27-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(673, 'CRT: 1718', NULL, NULL, NULL, NULL, NULL, NULL, '30-10-20 F:R22100 CRT: 400.501.718', 2, NULL, 75, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(674, 'CRT: 1722', NULL, NULL, NULL, NULL, NULL, NULL, '30-10-20 F:R22720 CRT:400.501.722', 2, NULL, 75, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(675, 'CRT: 1723', NULL, NULL, NULL, NULL, NULL, NULL, '30-10-20 F:R22480 CRT:400.501.723', 2, NULL, 75, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(676, '', NULL, NULL, NULL, NULL, NULL, NULL, '28-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(677, '', NULL, NULL, NULL, NULL, NULL, NULL, '28-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(678, '', NULL, NULL, NULL, NULL, NULL, NULL, '28-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(679, '', NULL, NULL, NULL, NULL, NULL, NULL, '29-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(680, '', NULL, NULL, NULL, NULL, NULL, NULL, '29-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(681, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-10-2020 Turno 1', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(682, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-10-2020 Turno 2', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(683, '', NULL, NULL, NULL, NULL, NULL, NULL, '28/10/2020 ', 2, NULL, 66, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(684, '', NULL, NULL, NULL, NULL, NULL, NULL, '29/10/2020', 2, NULL, 66, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(685, '', NULL, NULL, NULL, NULL, NULL, NULL, '30/10/2020', 2, NULL, 66, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(687, '', NULL, NULL, NULL, NULL, NULL, NULL, '29-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(688, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-10-2020', 2, NULL, 73, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(689, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-10-2020', 2, NULL, 73, 1, NULL, NULL, NULL, NULL, '', 0, 72, 0, '0000-00-00', NULL),
(690, '', NULL, NULL, NULL, NULL, NULL, NULL, '31-10-2020', 2, NULL, 72, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(691, '', NULL, NULL, NULL, NULL, NULL, NULL, '1-11-2020 Dom', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(692, '', NULL, NULL, NULL, NULL, NULL, NULL, '2-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(693, '', NULL, NULL, NULL, NULL, NULL, NULL, '2-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(694, '', NULL, NULL, NULL, NULL, NULL, NULL, '3-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(695, '', NULL, NULL, NULL, NULL, NULL, NULL, '3-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(696, '', NULL, NULL, NULL, NULL, NULL, NULL, '2-11-2020 Luis Olguín', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(697, '', NULL, NULL, NULL, NULL, NULL, NULL, '3-11-2020 Luis Olguín', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(698, '', NULL, NULL, NULL, NULL, NULL, NULL, '2-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(699, '', NULL, NULL, NULL, NULL, NULL, NULL, '3-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(700, '', NULL, NULL, NULL, NULL, NULL, NULL, '4-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(701, '', NULL, NULL, NULL, NULL, NULL, NULL, '5-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(702, '', NULL, NULL, NULL, NULL, NULL, NULL, '6-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(703, '', NULL, NULL, NULL, NULL, NULL, NULL, '9-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(704, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(705, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(706, '', NULL, NULL, NULL, NULL, NULL, NULL, '4-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(707, '', NULL, NULL, NULL, NULL, NULL, NULL, '4-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(708, '', NULL, NULL, NULL, NULL, NULL, NULL, '5-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(709, '', NULL, NULL, NULL, NULL, NULL, NULL, '5-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(710, '', NULL, NULL, NULL, NULL, NULL, NULL, '6-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(711, '', NULL, NULL, NULL, NULL, NULL, NULL, '6-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(712, '', NULL, NULL, NULL, NULL, NULL, NULL, '7-11-2020 Sabado', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(713, '', NULL, NULL, NULL, NULL, NULL, NULL, '8-11-2020 Domingo', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(714, '', NULL, NULL, NULL, NULL, NULL, NULL, '9-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(715, '', NULL, NULL, NULL, NULL, NULL, NULL, '9-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(716, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(717, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(718, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(719, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(720, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(721, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(722, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(723, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(724, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(725, '', NULL, NULL, NULL, NULL, NULL, NULL, '4/11/2020 Luis Olguín ', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(726, '', NULL, NULL, NULL, NULL, NULL, NULL, '5/11/2020 Luis Olguín ', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(727, '', NULL, NULL, NULL, NULL, NULL, NULL, '6/11/2020 Luis Olguín ', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(728, '', NULL, NULL, NULL, NULL, NULL, NULL, '7/11/2020 Luis Olguín ', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(729, '', NULL, NULL, NULL, NULL, NULL, NULL, '9/11/2020 Luis Olguín ', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(730, '', NULL, NULL, NULL, NULL, NULL, NULL, '10/11/2020 Luis Olguín ', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(731, '', NULL, NULL, NULL, NULL, NULL, NULL, '11/11/2020 Luis Olguín ', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(732, '', NULL, NULL, NULL, NULL, NULL, NULL, '12/11/2020 Luis Olguín ', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(733, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(734, '', NULL, NULL, NULL, NULL, NULL, NULL, '13-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(735, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(736, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(737, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(738, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(739, '', NULL, NULL, NULL, NULL, NULL, NULL, '20-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(740, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(741, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-11-2020', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(742, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-11-2020', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(743, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-11-2020 turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(744, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(745, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(746, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(747, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(748, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(749, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(750, '', NULL, NULL, NULL, NULL, NULL, NULL, '20-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(751, '', NULL, NULL, NULL, NULL, NULL, NULL, '20-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(752, '', NULL, NULL, NULL, NULL, NULL, NULL, '21-11-2020 Sab', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(753, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-11-2020 Dom', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(754, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(755, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(756, '', NULL, NULL, NULL, NULL, NULL, NULL, '24-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(757, '', NULL, NULL, NULL, NULL, NULL, NULL, '24-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(758, '', NULL, NULL, NULL, NULL, NULL, NULL, '25-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(759, '', NULL, NULL, NULL, NULL, NULL, NULL, '25-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(760, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(761, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(762, '', NULL, NULL, NULL, NULL, NULL, NULL, '27-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(763, '', NULL, NULL, NULL, NULL, NULL, NULL, '27-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(764, '', NULL, NULL, NULL, NULL, NULL, NULL, '28-11-2020 Sáb', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(765, '', NULL, NULL, NULL, NULL, NULL, NULL, '29-11-2020 Dom', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(766, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-11-2020 Turno 1', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(767, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-11-2020 Turno 2', 2, NULL, 76, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(768, '', NULL, NULL, NULL, NULL, NULL, NULL, '13-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(769, '', NULL, NULL, NULL, NULL, NULL, NULL, '14-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(770, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(771, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(772, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(773, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(774, '', NULL, NULL, NULL, NULL, NULL, NULL, '20-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(775, '', NULL, NULL, NULL, NULL, NULL, NULL, '21-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(776, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(777, '', NULL, NULL, NULL, NULL, NULL, NULL, '24-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(778, '', NULL, NULL, NULL, NULL, NULL, NULL, '25-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(779, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(780, '', NULL, NULL, NULL, NULL, NULL, NULL, '27-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(781, '', NULL, NULL, NULL, NULL, NULL, NULL, '28-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(782, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-11-2020', 2, NULL, 77, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(783, 'CRT1731', NULL, NULL, NULL, NULL, NULL, NULL, '18-11-2020 F:R23140 CRT:400.501.731', 2, NULL, 79, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(784, 'CRT1739', NULL, NULL, NULL, NULL, NULL, NULL, '18-11-2020 F:R24220 CRT:400.501.739 IMO', 2, NULL, 79, 6, NULL, NULL, NULL, NULL, '', 0, 65, 0, '0000-00-00', NULL),
(785, 'CRT1738', NULL, NULL, NULL, NULL, NULL, NULL, '18-11-2020 F: R24390 CRT: 400.501.738', 2, NULL, 79, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(786, 'CRT1740', NULL, NULL, NULL, NULL, NULL, NULL, '18-11-2020 F:R24400 CRT: 400.501.740 IMO', 2, NULL, 79, 6, NULL, NULL, NULL, NULL, '', 0, 65, 0, '0000-00-00', NULL),
(787, '', NULL, NULL, NULL, NULL, NULL, NULL, '24-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(788, '', NULL, NULL, NULL, NULL, NULL, NULL, '25-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(789, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(790, '', NULL, NULL, NULL, NULL, NULL, NULL, '27-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(791, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-11-2020', 2, NULL, 78, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(792, '', NULL, NULL, NULL, NULL, NULL, NULL, '01-12-2020 Turno 1', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(793, '', NULL, NULL, NULL, NULL, NULL, NULL, '01-12-2020 Turno 2', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(794, '', NULL, NULL, NULL, NULL, NULL, NULL, '02-12-2020 Turno 1', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(795, '', NULL, NULL, NULL, NULL, NULL, NULL, '02-12-2020 Turno 2', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(796, '', NULL, NULL, NULL, NULL, NULL, NULL, '03-12-2020 Turno 1', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(797, '', NULL, NULL, NULL, NULL, NULL, NULL, '03-12-2020 Turno 2', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(798, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-12-2020 Turno 1', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(799, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-12-2020 Turno 2', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(800, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-12-2020 Sab', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(801, '', NULL, NULL, NULL, NULL, NULL, NULL, '06-12-2020 Dom', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(802, '', NULL, NULL, NULL, NULL, NULL, NULL, '07-12-2020 Turno 1', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(803, '', NULL, NULL, NULL, NULL, NULL, NULL, '07-12-2020 Turno 2', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(804, '', NULL, NULL, NULL, NULL, NULL, NULL, '08-12-2020 Turno 1', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(805, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Esta ruta no se realizó. Era feriado.', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(806, '', NULL, NULL, NULL, NULL, NULL, NULL, '09-12-2020 Turno 1', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(807, '', NULL, NULL, NULL, NULL, NULL, NULL, '09-12-2020 Turno 2', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(808, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-12-2020 Turno 1', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(809, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-12-2020 Turno 2', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(810, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-12-2020 Turno 1', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(811, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-12-2020 Turno 2', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(812, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-12-2020 Turno 2', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(813, 'CRT1734', NULL, NULL, NULL, NULL, NULL, NULL, '19-11-2020 F:R23800 CRT: 400.501.734', 2, NULL, 79, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(814, 'CRT1758', NULL, NULL, NULL, NULL, NULL, NULL, '09-12-2020 F:R25700 CRT:400.501.758', 2, NULL, 81, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(815, 'CRT1759', NULL, NULL, NULL, NULL, NULL, NULL, '10-12-2020 F:R25570CRT:400.501.759', 2, NULL, 81, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(816, '', NULL, NULL, NULL, NULL, NULL, NULL, '01-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(817, '', NULL, NULL, NULL, NULL, NULL, NULL, '02-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(818, '', NULL, NULL, NULL, NULL, NULL, NULL, '03-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(819, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(820, '', NULL, NULL, NULL, NULL, NULL, NULL, '07-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(821, '', NULL, NULL, NULL, NULL, NULL, NULL, '09-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(822, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(823, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(824, '', NULL, NULL, NULL, NULL, NULL, NULL, '14-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(825, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(826, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(827, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(828, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(829, '', NULL, NULL, NULL, NULL, NULL, NULL, '21-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(830, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(831, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(832, '', NULL, NULL, NULL, NULL, NULL, NULL, '24-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(833, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(834, '', NULL, NULL, NULL, NULL, NULL, NULL, '31-12-2020', 2, NULL, 82, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(835, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-12-2020 Sáb Rodrigo', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(836, '', NULL, NULL, NULL, NULL, NULL, NULL, '14/12/2020 Turno 1', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(837, '', NULL, NULL, NULL, NULL, NULL, NULL, '14/12/2020 Turno 2', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(838, '', NULL, NULL, NULL, NULL, NULL, NULL, '15/12/2020 Turno 1', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(839, '', NULL, NULL, NULL, NULL, NULL, NULL, '15/12/2020 Turno 2', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(840, '', NULL, NULL, NULL, NULL, NULL, NULL, '16/12/2020 Turno 1', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(841, '', NULL, NULL, NULL, NULL, NULL, NULL, '16/12/2020 Turno 2', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(842, '', NULL, NULL, NULL, NULL, NULL, NULL, '17/12/2020 Turno 1', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(843, '', NULL, NULL, NULL, NULL, NULL, NULL, '17/12/2020 Turno 2', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(844, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-12-2020 Turno 1', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(845, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-12-2020 Turno 2', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(846, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-12-2020 Sab Rodrigo', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(847, '', NULL, NULL, NULL, NULL, NULL, NULL, '20-12-2020 Dom Rodrigo', 2, NULL, 80, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(848, '', NULL, NULL, NULL, NULL, NULL, NULL, '1-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(849, '', NULL, NULL, NULL, NULL, NULL, NULL, '2-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(850, '', NULL, NULL, NULL, NULL, NULL, NULL, '3-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(851, '', NULL, NULL, NULL, NULL, NULL, NULL, '4-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(852, '', NULL, NULL, NULL, NULL, NULL, NULL, '5-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(853, '', NULL, NULL, NULL, NULL, NULL, NULL, '7-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(854, '', NULL, NULL, NULL, NULL, NULL, NULL, '9-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(855, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(856, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(857, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(858, '', NULL, NULL, NULL, NULL, NULL, NULL, '14-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(859, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(860, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(861, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-12-2020 Luis Olguín ', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(862, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-12-2020 Luis Olguín ', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(863, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(864, '', NULL, NULL, NULL, NULL, NULL, NULL, '21-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(865, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(866, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(867, '', NULL, NULL, NULL, NULL, NULL, NULL, '24-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(868, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(869, '', NULL, NULL, NULL, NULL, NULL, NULL, '28-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(870, '', NULL, NULL, NULL, NULL, NULL, NULL, '29-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(871, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(872, '', NULL, NULL, NULL, NULL, NULL, NULL, '31-12-2020 Luis Olguín', 2, NULL, 84, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL);
INSERT INTO `tg_carga` (`CAR_NCORR`, `CAR_NBOOKING`, `CAR_VCONTENIDOCARGA`, `CAR_NDIASCONTENEDOR`, `CAR_VMARCA`, `CAR_VNUMCONTENEDOR`, `CAR_NPESOCARGA`, `CAR_VSELLO`, `CAR_VOBSERVACIONES`, `TICA_NCORR`, `TICO_NCORR`, `OSE_NCORR`, `ESCA_NCORR`, `ADA_NCORR`, `CAR_NCANTIDAD`, `UM_NCORR`, `FACT_NCORR`, `CAR_VOPERACION`, `GUIA_NCORR`, `LUG_NCORR_ACTUAL`, `LUG_NCORR_DEVOLUCION`, `CAR_FECHADEVOLUCION`, `CAR_FECHAETA`) VALUES
(873, '', NULL, NULL, NULL, NULL, NULL, NULL, '02-01-2021 Luis Olguín', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(874, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-01-2021 Luis Olguín', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(875, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-01-2021 Luis Olguín', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(876, '', NULL, NULL, NULL, NULL, NULL, NULL, '06-01-2021 Luis Olguín', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(877, '', NULL, NULL, NULL, NULL, NULL, NULL, '8-01-2021 Luis Olguín', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(878, '', NULL, NULL, NULL, NULL, NULL, NULL, '9-01-2021 Luis Olguín', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(879, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(880, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(881, '', NULL, NULL, NULL, NULL, NULL, NULL, '13-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(882, '', NULL, NULL, NULL, NULL, NULL, NULL, '14-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(883, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(884, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(885, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(886, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-01-2021 conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(887, '', NULL, NULL, NULL, NULL, NULL, NULL, '20-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(888, '', NULL, NULL, NULL, NULL, NULL, NULL, '21-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(889, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(890, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(891, '', NULL, NULL, NULL, NULL, NULL, NULL, '25-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(892, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(893, '', NULL, NULL, NULL, NULL, NULL, NULL, '27-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(894, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(895, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(896, '', NULL, NULL, NULL, NULL, NULL, NULL, '06-01-2021 Raúl ', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(897, '', NULL, NULL, NULL, NULL, NULL, NULL, '07-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(898, '', NULL, NULL, NULL, NULL, NULL, NULL, '08-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(899, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(900, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-01-2021 Luis Olguín', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(901, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-01-2021 Raúl ', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(902, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-01-2021 Luis', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(903, '', NULL, NULL, NULL, NULL, NULL, NULL, '13-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(904, '', NULL, NULL, NULL, NULL, NULL, NULL, '13-01-2021 Luis', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(905, '', NULL, NULL, NULL, NULL, NULL, NULL, '14-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(906, '', NULL, NULL, NULL, NULL, NULL, NULL, '14-01-2021 Luis', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(907, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(908, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-01-2021 Luis', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(909, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(910, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-01-2021 Luis', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(911, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(912, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-01-2021 Luis', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(913, '', NULL, NULL, NULL, NULL, NULL, NULL, '20-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(914, '', NULL, NULL, NULL, NULL, NULL, NULL, '20-01-2021 Luis', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(915, '', NULL, NULL, NULL, NULL, NULL, NULL, '21-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(916, '', NULL, NULL, NULL, NULL, NULL, NULL, '21-01-2021 Luis', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(917, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(918, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-01-2021 Luis', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(919, '', NULL, NULL, NULL, NULL, NULL, NULL, '25-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(920, '', NULL, NULL, NULL, NULL, NULL, NULL, '25-01-2021 Luis', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(921, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(922, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-01-2021 Luis', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(923, '', NULL, NULL, NULL, NULL, NULL, NULL, '27-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(924, '', NULL, NULL, NULL, NULL, NULL, NULL, '27-01-2021 Luis', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(925, '', NULL, NULL, NULL, NULL, NULL, NULL, '28-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(926, '', NULL, NULL, NULL, NULL, NULL, NULL, '28-01-2021 Luis', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(927, '', NULL, NULL, NULL, NULL, NULL, NULL, '29-01-2021 Raúl', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(928, '', NULL, NULL, NULL, NULL, NULL, NULL, '29-01-2021 Luis', 2, NULL, 83, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(929, '', NULL, NULL, NULL, NULL, NULL, NULL, '28-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(930, '', NULL, NULL, NULL, NULL, NULL, NULL, '29-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(931, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-01-2021 Conductor 3', 2, NULL, 85, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(932, '', NULL, NULL, NULL, NULL, NULL, NULL, '02-01-2021 Sáb César Mora', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(933, '', NULL, NULL, NULL, NULL, NULL, NULL, '03-01-2021 Dom César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(934, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-01-2021 Rodrigo Lozano', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(935, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-01-2021 César Mora', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(936, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-01-2021 Rodrigo Lozano', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(937, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-01-2021 Cesar Mora', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(938, '', NULL, NULL, NULL, NULL, NULL, NULL, '06-01-2021 Rodrigo Lozano', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(939, '', NULL, NULL, NULL, NULL, NULL, NULL, '06-01-2021 Cesar Mora', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(940, '', NULL, NULL, NULL, NULL, NULL, NULL, '07-01-2021 Rodrigo Lozano', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(941, '', NULL, NULL, NULL, NULL, NULL, NULL, '07-01-2021 Cesar Mora', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(942, '', NULL, NULL, NULL, NULL, NULL, NULL, '08-01-2021 Rodrigo Lozano', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(943, '', NULL, NULL, NULL, NULL, NULL, NULL, '08-01-2021 Cesar Mora', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(944, '', NULL, NULL, NULL, NULL, NULL, NULL, '09-01-2021 Sáb Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(945, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-01-2021 Dom Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(946, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(947, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-01-2021 César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(948, '', NULL, NULL, NULL, NULL, NULL, NULL, '13-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(949, '', NULL, NULL, NULL, NULL, NULL, NULL, '13-01-2021 Cesar', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(950, '', NULL, NULL, NULL, NULL, NULL, NULL, '14-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(951, '', NULL, NULL, NULL, NULL, NULL, NULL, '14-01-2021 Cesar', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(952, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(953, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-01-2021 Cesar', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(954, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-01-2021 Sáb Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(955, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-01-2021 Dom César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(956, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(957, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-01-2021 César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(958, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(959, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-01-2021 Cesar', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(960, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(961, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-01-2021 César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(962, '', NULL, NULL, NULL, NULL, NULL, NULL, '20-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(963, '', NULL, NULL, NULL, NULL, NULL, NULL, '20-01-2021 César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(964, '', NULL, NULL, NULL, NULL, NULL, NULL, '21-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(965, '', NULL, NULL, NULL, NULL, NULL, NULL, '21-01-2021 César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(966, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(967, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-01-2021 César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(968, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-01-2021 Sáb Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(969, '', NULL, NULL, NULL, NULL, NULL, NULL, '24-01-2021 Dom Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(970, '', NULL, NULL, NULL, NULL, NULL, NULL, '25-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(971, '', NULL, NULL, NULL, NULL, NULL, NULL, '25-01-2021 César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(972, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(973, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-01-2021 César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(974, '', NULL, NULL, NULL, NULL, NULL, NULL, '27-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(975, '', NULL, NULL, NULL, NULL, NULL, NULL, '27-01-2021 César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(976, '', NULL, NULL, NULL, NULL, NULL, NULL, '28-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(977, '', NULL, NULL, NULL, NULL, NULL, NULL, '28-01-2021 César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(978, '', NULL, NULL, NULL, NULL, NULL, NULL, '29-01-2021 Rodrigo', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(979, '', NULL, NULL, NULL, NULL, NULL, NULL, '29-01-2021 César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(980, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-01-2021 Sáb César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(981, '', NULL, NULL, NULL, NULL, NULL, NULL, '31-01-2021 Dom César', 2, NULL, 87, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(982, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-11-2020 Aurelio', 2, NULL, 88, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(983, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-11-2020 Aurelio Equipo 2', 2, NULL, 88, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(984, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-11-2020 Aurelio', 2, NULL, 88, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(985, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-01-2020 Aurelio Equipo 2', 2, NULL, 88, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(986, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-01-2020 Aurelio ', 2, NULL, 88, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(987, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-01-2020 Aurelio Equipo 2', 2, NULL, 88, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(988, '', NULL, NULL, NULL, NULL, NULL, NULL, '07-12-2020 Luis Olguín', 2, NULL, 89, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(989, '', NULL, NULL, NULL, NULL, NULL, NULL, '16/12/2020 Cristian Garrido', 2, NULL, 89, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(990, '', NULL, NULL, NULL, NULL, NULL, NULL, '16/12/2020 Aurelio Jiménez', 2, NULL, 89, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(991, '', NULL, NULL, NULL, NULL, NULL, NULL, '17/12/2020 Cristian Garrido', 2, NULL, 89, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(992, '', NULL, NULL, NULL, NULL, NULL, NULL, '17/12/2020 Aurelio Jiménez', 2, NULL, 89, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(993, '', NULL, NULL, NULL, NULL, NULL, NULL, '18/12/2020 Cristian Garrido', 2, NULL, 89, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(994, '', NULL, NULL, NULL, NULL, NULL, NULL, '18/12/2020 Aurelio Jiménez', 2, NULL, 89, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(995, '', NULL, NULL, NULL, NULL, NULL, NULL, '21/12/2020 Cristian Garrido', 2, NULL, 89, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(996, '', NULL, NULL, NULL, NULL, NULL, NULL, '21/12/2020 Aurelio Jiménez', 2, NULL, 89, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(997, '', NULL, NULL, NULL, NULL, NULL, NULL, '21/12/2020 Julio Leyton', 2, NULL, 89, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(998, '', NULL, NULL, NULL, NULL, NULL, NULL, '21/12/2020 Claudio Contreras', 2, NULL, 89, 1, NULL, NULL, NULL, NULL, '', 0, 72, 0, '0000-00-00', NULL),
(999, '', NULL, NULL, NULL, NULL, NULL, NULL, '22/12/2020 Cristian Garrido', 2, NULL, 89, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(1000, '', NULL, NULL, NULL, NULL, NULL, NULL, '22/12/2020 Aurelio Jiménez', 2, NULL, 89, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(1001, '', NULL, NULL, NULL, NULL, NULL, NULL, '22/12/2020 Julio Leyton', 2, NULL, 89, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(1002, '', NULL, NULL, NULL, NULL, NULL, NULL, '22/12/2020 Fernando Araya', 2, NULL, 89, 6, NULL, NULL, NULL, NULL, '', 0, 74, 0, '0000-00-00', NULL),
(1003, 'CRT1780', NULL, NULL, NULL, NULL, NULL, NULL, '08-01-2021 F:R28100CRT:400.501.780', 2, NULL, 86, 6, NULL, NULL, NULL, NULL, 'R28100', 0, 41, 0, '0000-00-00', NULL),
(1004, 'CRT1778', NULL, NULL, NULL, NULL, NULL, NULL, '08-01-2021 F: R28090 CRT:400.501.778', 2, NULL, 86, 6, NULL, NULL, NULL, NULL, '', 0, 41, 0, '0000-00-00', NULL),
(1005, 'CRT1779', NULL, NULL, NULL, NULL, NULL, NULL, '05-01-2021 F: R28510 CRT:400.501.777', 2, NULL, 86, 6, NULL, NULL, NULL, NULL, 'R28510', 0, 41, 0, '0000-00-00', NULL),
(1006, 'CRT1779', NULL, NULL, NULL, NULL, NULL, NULL, '08-01-2021 F:R28110CRT:400.501.779', 2, NULL, 90, 6, NULL, NULL, NULL, NULL, 'R28110', 0, 41, 0, '0000-00-00', NULL),
(1007, 'CRT1792', NULL, NULL, NULL, NULL, NULL, NULL, '09-02-2021 F:R32511CRT:400.501.792', 2, NULL, 91, 6, NULL, NULL, NULL, NULL, 'R32511', 0, 41, 0, '0000-00-00', NULL),
(1008, 'CRT1801', NULL, NULL, NULL, NULL, NULL, NULL, '15-02-2021 F:R32751CRT:400.501.801', 2, NULL, 92, 6, NULL, NULL, NULL, NULL, 'R32751', 0, 41, 0, '0000-00-00', NULL),
(1009, 'CRT1802', NULL, NULL, NULL, NULL, NULL, NULL, '15-02-2021 F:R32721CRT:400.501.802', 2, NULL, 92, 6, NULL, NULL, NULL, NULL, 'R32721', 0, 41, 0, '0000-00-00', NULL),
(1010, '', NULL, NULL, NULL, NULL, NULL, NULL, '01-02-2021 Luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1011, '', NULL, NULL, NULL, NULL, NULL, NULL, '01-02-2021 Sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1012, '', NULL, NULL, NULL, NULL, NULL, NULL, '02-02-2021 Luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1013, '', NULL, NULL, NULL, NULL, NULL, NULL, '02-02-2021 Sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1014, '', NULL, NULL, NULL, NULL, NULL, NULL, '03-02-2021 Luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1015, '', NULL, NULL, NULL, NULL, NULL, NULL, '03-02-2021 Sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1016, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-02-2021 Luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1017, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-02-2021 Sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1018, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-02-2021 Luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1019, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-02-2021 Sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1020, '', NULL, NULL, NULL, NULL, NULL, NULL, '08-02-2021 Luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1021, '', NULL, NULL, NULL, NULL, NULL, NULL, '08-02-2021 Sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1022, '', NULL, NULL, NULL, NULL, NULL, NULL, '09-02-2021 Luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1023, '', NULL, NULL, NULL, NULL, NULL, NULL, '09-02-2021 Sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1024, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-02-2021 Luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1025, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-02-2021 Sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1026, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-02-2021 Luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1027, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-02-2021 Sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1028, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-02-2021 Luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1029, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-02-2021 Sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1030, '', NULL, NULL, NULL, NULL, NULL, NULL, '13-02-2021 Luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1031, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-02-2021 luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1032, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-02-2021 Sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1033, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-02-2021 luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1034, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-02-2021 sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1035, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-02-2021 luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1036, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-02-2021 sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1037, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-02-2021 luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1038, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-02-2021 sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1039, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-02-2021 luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1040, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-02-2021 sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1041, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-02-2021 luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1042, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-02-2021 sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1043, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-02-2021 luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1044, '', NULL, NULL, NULL, NULL, NULL, NULL, '24-02-2021 sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1045, '', NULL, NULL, NULL, NULL, NULL, NULL, '24-02-2021 luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1046, '', NULL, NULL, NULL, NULL, NULL, NULL, '25-02-2021 sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1047, '', NULL, NULL, NULL, NULL, NULL, NULL, '25-02-2021 sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1048, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-02-2021 sergio', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1049, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-02-2021 luis', 2, NULL, 93, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1050, '', NULL, NULL, NULL, NULL, NULL, NULL, '01-03-2021 Sergio ', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1051, '', NULL, NULL, NULL, NULL, NULL, NULL, '01-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1052, '', NULL, NULL, NULL, NULL, NULL, NULL, '02-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1053, '', NULL, NULL, NULL, NULL, NULL, NULL, '02-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1054, '', NULL, NULL, NULL, NULL, NULL, NULL, '03-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1055, '', NULL, NULL, NULL, NULL, NULL, NULL, '03-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1056, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1057, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1058, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1059, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1060, '', NULL, NULL, NULL, NULL, NULL, NULL, '08-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1061, '', NULL, NULL, NULL, NULL, NULL, NULL, '08-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1062, '', NULL, NULL, NULL, NULL, NULL, NULL, '09-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1063, '', NULL, NULL, NULL, NULL, NULL, NULL, '09-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1064, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1065, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1066, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1067, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1068, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1069, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1070, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1071, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1072, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1073, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1074, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1075, '', NULL, NULL, NULL, NULL, NULL, NULL, '17-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1076, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1077, '', NULL, NULL, NULL, NULL, NULL, NULL, '18-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1078, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1079, '', NULL, NULL, NULL, NULL, NULL, NULL, '19-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1080, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1081, '', NULL, NULL, NULL, NULL, NULL, NULL, '22-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1082, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1083, '', NULL, NULL, NULL, NULL, NULL, NULL, '23-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1084, '', NULL, NULL, NULL, NULL, NULL, NULL, '24-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1085, '', NULL, NULL, NULL, NULL, NULL, NULL, '24-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1086, '', NULL, NULL, NULL, NULL, NULL, NULL, '25-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1087, '', NULL, NULL, NULL, NULL, NULL, NULL, '25-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1088, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1089, '', NULL, NULL, NULL, NULL, NULL, NULL, '26-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1090, '', NULL, NULL, NULL, NULL, NULL, NULL, '29-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1091, '', NULL, NULL, NULL, NULL, NULL, NULL, '29-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1092, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1093, '', NULL, NULL, NULL, NULL, NULL, NULL, '30-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1094, '', NULL, NULL, NULL, NULL, NULL, NULL, '31-03-2021 Sergio', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1095, '', NULL, NULL, NULL, NULL, NULL, NULL, '31-03-2021 Luis', 2, NULL, 95, 6, NULL, NULL, NULL, NULL, '', 0, 73, 0, '0000-00-00', NULL),
(1096, '', NULL, NULL, NULL, NULL, NULL, NULL, '01/03/2021 Equipo 1', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1097, '', NULL, NULL, NULL, NULL, NULL, NULL, '01/03/2021 Equipo 2', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1098, '', NULL, NULL, NULL, NULL, NULL, NULL, '01/03/2021 Equipo 3', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1099, '', NULL, NULL, NULL, NULL, NULL, NULL, '02/03/2021 Equipo 1', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1100, '', NULL, NULL, NULL, NULL, NULL, NULL, '02/03/2021 Equipo 2', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1101, '', NULL, NULL, NULL, NULL, NULL, NULL, '02/03/2021 Equipo 3', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1102, '', NULL, NULL, NULL, NULL, NULL, NULL, '03-03-2021 Equipo 1', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1103, '', NULL, NULL, NULL, NULL, NULL, NULL, '03-03-2021 Equipo 2', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1104, '', NULL, NULL, NULL, NULL, NULL, NULL, '03-03-2021 Equipo 3', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1105, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-03-2021 Equipo 1', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1106, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-03-2021 Equipo 2', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1107, '', NULL, NULL, NULL, NULL, NULL, NULL, '04-03-2021 Equipo 3', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1108, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-03-2021 Equipo 1', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1109, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-03-2021 Equipo 2', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1110, '', NULL, NULL, NULL, NULL, NULL, NULL, '05-03-2021 Equipo 3', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1111, '', NULL, NULL, NULL, NULL, NULL, NULL, '06-03-2021 Equipo 1', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1112, '', NULL, NULL, NULL, NULL, NULL, NULL, '06-03-2021 Equipo 3', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1113, '', NULL, NULL, NULL, NULL, NULL, NULL, '07-03-2021 Equipo 1', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1114, '', NULL, NULL, NULL, NULL, NULL, NULL, '08-03-2021 Equipo 1', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1115, '', NULL, NULL, NULL, NULL, NULL, NULL, '08-03-2021 Equipo 2', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1116, '', NULL, NULL, NULL, NULL, NULL, NULL, '08-03-2021 Equipo 3', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1117, '', NULL, NULL, NULL, NULL, NULL, NULL, '09-03-2021 Equipo 1', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1118, '', NULL, NULL, NULL, NULL, NULL, NULL, '09-03-2021 Equipo 2', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1119, '', NULL, NULL, NULL, NULL, NULL, NULL, '09-03-2021 Equipo 3', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1120, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-03-2021 Equipo 1', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1121, '', NULL, NULL, NULL, NULL, NULL, NULL, '10-03-2021 Equipo 2', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1122, '', NULL, NULL, NULL, NULL, NULL, NULL, 'Equipo 3', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1123, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-02-2021 equipo 1', 2, NULL, 94, 1, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(1124, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-02-2021 Equipo 2', 2, NULL, 94, 1, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(1125, '', NULL, NULL, NULL, NULL, NULL, NULL, '11-02-2021 Equipo 3', 2, NULL, 94, 1, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(1126, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-02-2021 Equipo 1', 2, NULL, 94, 1, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(1127, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-02-2021 Equipo 2', 2, NULL, 94, 1, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(1128, '', NULL, NULL, NULL, NULL, NULL, NULL, '12-02-2021 Equipo 3', 2, NULL, 94, 6, NULL, NULL, NULL, NULL, '', 0, 71, 0, '0000-00-00', NULL),
(1129, '', NULL, NULL, NULL, NULL, NULL, NULL, '13-02-2021 César', 2, NULL, 94, 1, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(1130, '', NULL, NULL, NULL, NULL, NULL, NULL, '13-02-2021 Patricio Meza', 2, NULL, 94, 1, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(1131, '', NULL, NULL, NULL, NULL, NULL, NULL, '14-02-2021 César ', 2, NULL, 94, 1, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(1132, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-02-2021 Equipo 1', 2, NULL, 94, 1, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(1133, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-02-2021 Equipo 2', 2, NULL, 94, 1, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(1134, '', NULL, NULL, NULL, NULL, NULL, NULL, '15-02-2021 equipo 3', 2, NULL, 94, 1, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(1135, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-02-2021 Equipo 1', 2, NULL, 94, 1, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(1136, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-02-2021 Equipo 2', 2, NULL, 94, 1, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(1137, '', NULL, NULL, NULL, NULL, NULL, NULL, '16-02-2021 equipo 3', 2, NULL, 94, 1, NULL, NULL, NULL, NULL, '', 0, 70, 0, '0000-00-00', NULL),
(1138, '1', NULL, NULL, NULL, NULL, NULL, NULL, 'sdasd', 2, NULL, 98, 6, NULL, NULL, NULL, NULL, '2', 0, 79, 0, '0000-00-00', NULL),
(1139, '1', NULL, NULL, NULL, NULL, NULL, NULL, 'asdasd', 2, NULL, 99, 1, NULL, NULL, NULL, NULL, '2', 0, 70, 0, '0000-00-00', NULL);

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
(24, 62, 'JJ 9283'),
(25, 68, 'JJ9321'),
(26, 68, 'GRHS14'),
(27, 68, 'JL1044'),
(28, 67, 'JB5972'),
(29, 69, 'JG6357'),
(30, 69, 'JB3443'),
(31, 70, 'JL1044'),
(32, 70, 'JJ9321'),
(33, 72, 'NNNN00'),
(34, 73, 'NNNN-00'),
(35, 74, 'NNNN-00'),
(36, 71, 'RO 1102'),
(37, 78, 'MA1102'),
(38, 79, 'IN0001'),
(39, 80, 'KX6X48'),
(40, 80, 'DLYX36'),
(41, 81, 'MAV0011'),
(42, 77, 'LXWJ28'),
(43, 75, 'DDFW72'),
(44, 82, 'KJJF45'),
(45, 83, 'BWGB97'),
(46, 84, 'PBHT85'),
(47, 85, '2245465498');

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
(23, NULL, 'Stefano Tatti Lomboy', '12.274.710-7', 62, '222222222'),
(24, NULL, 'GERMAN OYARCE', '16555759-K', 68, '+56998915005'),
(25, NULL, 'SEBASTIAN DELGADILLO', '16218487-3', 68, '+56970318879'),
(26, NULL, 'HECTOR ACOSTA', '11490723-5', 67, '+56965466250'),
(27, NULL, 'MARCOS MORENO', '16041032-9', 69, '+56947701745'),
(28, NULL, 'Sebastian Delgadillo', '16218487-3', 70, ''),
(29, NULL, 'German Oyarce', '16555759-k', 70, ''),
(30, NULL, 'Rodrigo Antonio Lozano Campos', '8908432-6', 72, '56 9 6919 2558'),
(31, NULL, 'Gabriel Aroca Alarcon', '13712620-6', 73, '56 9 39534651'),
(32, NULL, 'Raul Segundo MuÃ±oz Sambueza', '11539450-9', 73, '56 9 88315323'),
(33, NULL, 'Camilo Jimenez', '20943699-k', 74, '56 965471699'),
(34, NULL, 'Transportes Rofran', '59289160-3', 71, '56 (2) 25206210'),
(35, NULL, 'Transportes Mavicargo', '76168863-4', 78, '56 (2) 26565160'),
(36, NULL, 'CÃ©sar Mora Alfaro', '12794168-8', 78, '56 9 8913 8998'),
(39, NULL, 'Inv Transporte Spa', '76943022-9', 79, '56 9 64395435'),
(40, NULL, 'RaÃºl MuÃ±oz', '11.539.450-9', 56, ''),
(41, NULL, 'Gabriel Aroca', '13.712.620-6', 56, ''),
(42, NULL, 'RaÃºl MuÃ±oz', '11539450-9', 80, ''),
(43, NULL, 'Gabriel Aroca', '13712620-6', 80, ''),
(44, NULL, 'Fernando Cerda', '1111111-1', 81, ''),
(45, NULL, 'Fernando Araya', '22222-2', 81, ''),
(46, NULL, 'CÃ©sar Mora', '12794168-8', 72, '56 9 8913 8998'),
(47, NULL, 'Luis OlguÃ­n Chandia', '11750588-k', 77, ''),
(48, NULL, 'JimÃ©nez', 'Aurelio', 75, '56 966542008'),
(49, NULL, 'Julio Leyton', '20.943.699-K', 83, '56 (9) 65471699'),
(50, NULL, 'Oscar Abarzua', '9.008-509-3', 82, '56 9 95329081'),
(51, NULL, 'Sergio GÃ³mez', '16700086-k', 84, '940271261'),
(52, NULL, 'Patricio Meza', 'xxx-1', 72, '56 9 89138998'),
(53, NULL, 'Cristian Mendizabal', '11885547-7', 72, '56 9 8913 8998'),
(54, NULL, 'Conductor', 'xxx-0', 72, '56 9 8913 8998'),
(55, NULL, 'Miguel', '26253020-5', 85, '964868893');

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
(6, 'Transportes E.I.R.L.', '76346090-8', '', 'Transporte', 'Jose Ignacio Saez Guinez ', '', '', '', '', 0),
(10, 'Elza Ines Sanzi e hijos Ltda', '78773020-5', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(16, 'Inmobiliria e inversiones  Sta. Catalina Ltda.', '76679510-2', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(21, 'Maria Alejandra Soto diaz', '7859957-K', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(23, 'Transporte de Contenedores de Chile SA', '76566490-K', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(24, 'Transporte Logistica Placilla 88', '76116595-K', '', 'Transporte', '', '', '', '', '', 0),
(25, 'Transporte RVE Ltda.', '77889320-7', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(26, 'Transportes Andreu Ltda.', '78763220-3', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(28, 'Transportes Nunez Roco CIA.Ltda.', '76160610-7', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(29, 'Trujillo Ltda.', '76123750-0', NULL, 'Transporte', NULL, NULL, NULL, '', '', 0),
(31, 'Ruben Vinuela', '78293170-9', '', 'Transporte', '', '', '', '', '', 0),
(54, 'Logistica CIMCA SA', '22222222-2', '', 'Transporte Internacional', '', '', '', 'Logistica CIMCA SA', '33-71229872-9', 0),
(55, 'Jose Rodrigo Calderon', '12817665-9', 'Av. La Montaña 776', 'Transporte de Carga por Carretera', '', ' 56 (2) 24891523', '', 'Transportes DESA ltda', 'Transporte', 0),
(56, 'J L T Transporte y  Logistica', '33333333-3', '', 'Transporte y  Logistica', '', '', '', 'J L T Transporte y  Logistica', '20-13533975-0', 0),
(57, 'Trans Fer', '44444444-4', '', 'Transporte Internacional', '', '', '', 'Transportes Fernandez', '20-08154383-7', 0),
(58, 'Fardaos', '66666666-6', '', 'Transporte Nacional', '', '', '', 'Fardaos', '20-08154383-7', 0),
(63, 'MF Logistica', '76287695-7', 'Gervacio Valle 381, Calle Larga', 'Transporte y Logistica', 'Michael Perez', '', '', 'MF Logistica y Transporte Limitada', 'Transporte y Logistica', 1),
(64, 'Tranas JR  (Pizzolato)', '76440124-7', '', 'Transporte Internacional por carretera', 'Fabian Pizzolato', '', 'fabianpizzolato@yahoo.com.ar', 'Trans JR ', 'Transporte Internacional', 1),
(65, 'DYC', '96813450-7', '', 'Transporte de Carga por Carretera', '', '', '', 'Depositos y Contenedores SA', 'Transporte y Almacenaje de Contenedores', 0),
(66, 'Terracontainers', '76752755-1', 'Av. Américo Vespucio Norte 811', 'Fabricación de Vehículos Automotores', 'Sergio Droppelmann', '56 (2) 25206210', '', 'General Motors Chile Industria Automotriz Ltda', 'Venta de Vehículos', 0),
(69, 'Marcos Moreno', '18058819-1', 'Pasaje 5 441 Risopatron-Pedro Aguirre Cerda', 'Transporte de carga terrestre', 'Marcos Moreno', '56 (9) 47701745', 'Transportesdym6@gmail.com', 'Dominique Lisette Molinett Ravanales', 'Transporte de carga terrestre', 0),
(70, 'Cavada Logistics SpA', '76193152-0', 'Camino La Montaña', 'Venta Licores', 'Manuel Cavada', '562 23938170', 'mcavada@cavada.cl', 'CAV Sociedad Anonima', 'Venta Vino', 1),
(71, 'Rofran Transportes Chile', '59289160-3', 'Av. Américo Vespucio Norte 811', 'Fabricación de Vehículos Automotores', 'Rodrigo Rofran', '56 (2) 25206210', 'Rodrigo@rofimex.com.br', 'General Motors Chile Industria Automotriz Ltda', 'Venta de Vehículos', 1),
(72, 'RG Rental', '77116962-7', 'Las Bellotas 199 62- Providencia', 'Inversion, ariendo y compra venta de inmuebles', '', '', 'patricio@bpopyme.cl', 'RG Rental SPA', 'transporte de carga', 0),
(75, 'Aurelio Jimenez', '14452068-8', '', '', 'Aurelio Jimenez', '56 966 542008', '', '', 'transporte de carga', 0),
(77, 'Sociedad de Transporte Rubio e Hijos', '77143908-K', 'Jose Miguel carrera 5300 El Noviciado-Pudahuel', 'Transporte de carga por carretera.', 'Cristian Rubio', '', 'Cristia.rubio.encina@gmail.com', 'Sociedad de transporte Rubio E hijos Spa', 'transporte de carga', 1),
(79, 'Inversiones en Transporte SPA', '76943022-9', 'Las Cacha As 3753 Pte Alto', 'Transporte', 'Luis San Martin', '56 9 64395435', 'luis.invertrans@gmail.com', 'Inversiones en Transporte SPA', 'Transporte', 0),
(80, 'Transporte JyJ Limitada', '77015253-4', 'Coral del Monte 6323- Maipu', 'Transporte de Carga General', 'Jorge Prado', '56 (9) 81361393', 'jprador@gmail.com', 'Time 1 Spa', 'Transporte', 1),
(81, 'Mavicargo', '76168863-4', 'Av. Américo Vespucio 1309- Ofic. 404. Pudahuel', 'Transporte y Servicios Logísticos Mavicargo Spa', '', '56 (2) 24094157', 'auribe@mavicargo.cl', '', 'Transporte', 0),
(82, 'Cristian Alejandro Garrido Sagardia', '12684574-K', 'Cacique Maulican 10211 ST- El bosque', 'Transporte', 'Cristian Garrido', '56 956391456', 'roxanna.berriosvaldes@gmail.com', '', 'Transporte', 0),
(83, 'Malabares Group SPA', '76880463-K', 'Diagonal Paraguay 481, Of.105', 'Transporte', 'Rodrigo Cortes', '56 (9) 97999720', 'Rodrigocortesben@gmail.com', 'Malabares Group SPA', 'Transporte', 0),
(84, 'Transportes Matsan Ltda', '77250493-4', '', 'Transporte', '', '', 'matsan.ltda@gmail.com', '', 'Transporte', 1);

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
(54, '2020-02-27', 2060469, 1, 71),
(55, '2020-02-27', 21324, 1, 71),
(56, '2020-02-27', 2041, 1, 71),
(57, '2020-09-14', 140920201, 1, 80),
(58, '2020-09-14', 140920201, 1, 80),
(59, '2020-09-21', 210920201, 1, 80),
(60, '2020-09-22', 220920201, 1, 80),
(61, '2020-09-23', 230920201, 1, 80),
(62, '2020-09-24', 240920201, 1, 80),
(63, '2020-09-28', 280920201, 1, 80),
(64, '2020-09-29', 290920201, 1, 80),
(65, '2020-09-30', 300920201, 1, 80),
(66, '2020-10-01', 202010011, 1, 80),
(67, '2020-10-02', 202010021, 1, 80),
(68, '2020-10-05', 202010051, 1, 80),
(69, '2020-10-06', 202010061, 1, 80),
(70, '2020-10-07', 202010071, 1, 80),
(71, '2020-10-08', 202010081, 1, 80),
(72, '2020-10-09', 202010091, 1, 80),
(73, '2020-10-14', 202010141, 1, 80),
(74, '2020-10-15', 202010151, 1, 80),
(75, '2020-10-16', 202010161, 1, 80),
(76, '2020-10-19', 202010191, 1, 80),
(77, '2020-10-13', 202010131, 1, 80),
(78, '2020-10-20', 202010201, 1, 80),
(79, '2020-10-21', 202010211, 1, 80),
(80, '2020-10-22', 202010221, 1, 80),
(81, '2020-10-23', 202010231, 1, 80),
(82, '2020-10-23', 202010233, 1, 77),
(83, '2020-10-26', 202010261, 1, 80),
(84, '2020-10-27', 202010271, 1, 80),
(85, '2020-10-28', 202010281, 1, 80),
(86, '2020-10-28', 202010281, 1, 80),
(87, '2020-10-29', 202010291, 1, 80),
(88, '2020-10-30', 202010301, 1, 80),
(89, '2020-11-02', 202011021, 1, 80),
(90, '2020-11-03', 202011031, 1, 80),
(91, '2020-11-04', 202011041, 1, 80),
(92, '2020-11-05', 202011051, 1, 80),
(93, '2020-11-06', 202011061, 1, 80),
(94, '2020-11-09', 202011091, 1, 80),
(95, '2020-11-10', 202011101, 1, 80),
(96, '2020-11-11', 202011111, 1, 80),
(97, '2020-11-12', 2020111201, 1, 80),
(98, '0000-00-00', 2020111301, 1, 80),
(99, '2020-11-16', 2020111601, 1, 80),
(100, '2020-11-17', 2020111701, 1, 80),
(101, '2020-11-18', 2020111801, 1, 80),
(102, '2020-11-19', 2020111901, 1, 80),
(103, '2020-11-20', 2020112001, 1, 80),
(104, '2020-11-23', 2020112301, 1, 80),
(105, '2020-11-24', 2020112401, 1, 80),
(106, '2020-11-25', 2020112501, 1, 80),
(107, '2020-11-26', 2020112601, 1, 80),
(108, '2020-11-26', 2020112601, 1, 80),
(109, '2020-11-27', 2020112701, 1, 80),
(110, '2020-11-27', 2020112701, 1, 80),
(111, '2020-11-27', 2020112701, 1, 80),
(112, '2020-11-27', 2020112701, 1, 80),
(113, '2020-11-27', 2020112701, 1, 80),
(114, '2020-11-30', 2020113001, 1, 80),
(115, '2020-12-01', 2020120101, 1, 80),
(116, '2020-12-02', 2020120201, 1, 80),
(117, '2020-12-03', 2020120301, 1, 80),
(118, '2020-12-04', 2020120401, 1, 80),
(119, '2020-12-07', 2020120701, 1, 80),
(120, '2020-12-09', 2020120901, 1, 80),
(121, '2020-12-10', 2020121001, 1, 80),
(122, '2020-12-11', 2020121101, 1, 80),
(123, '2020-12-14', 2020121401, 1, 80),
(124, '2020-12-15', 2020121501, 1, 80),
(125, '2020-12-16', 2020121601, 1, 80),
(126, '2020-12-17', 2020121701, 1, 80),
(127, '2020-12-17', 2020121701, 1, 80),
(128, '2020-12-17', 2020121701, 1, 80),
(129, '2020-12-18', 2020121801, 1, 80),
(130, '2020-12-21', 2020122101, 1, 80),
(131, '2020-12-22', 2020122201, 1, 80),
(132, '2020-12-23', 2020122301, 1, 80),
(133, '2020-12-24', 2020122401, 1, 80),
(134, '2020-12-30', 2020123001, 1, 80),
(135, '2020-12-31', 2020123101, 1, 80),
(136, '2021-01-04', 2021010401, 1, 80),
(137, '2021-01-05', 2021010501, 1, 80),
(138, '2021-01-06', 2021010601, 1, 80),
(139, '2021-01-07', 2021010701, 1, 80),
(140, '2021-01-08', 2021010801, 1, 80),
(141, '2021-01-11', 2021011101, 1, 80),
(142, '2021-01-11', 2021011102, 1, 71),
(143, '2021-01-12', 2021011201, 1, 80),
(144, '2021-01-12', 2021011202, 1, 71),
(145, '2021-01-13', 2021011301, 1, 80),
(146, '2021-01-13', 2021011302, 1, 71),
(147, '2021-01-13', 2021011302, 1, 77),
(148, '2021-01-14', 2021011401, 1, 80),
(149, '2021-01-14', 2021011402, 1, 77),
(150, '2021-01-15', 2021011501, 1, 80),
(151, '2021-01-15', 2021011502, 1, 77),
(152, '2021-01-18', 2021011801, 1, 80),
(153, '2021-01-18', 2021011802, 1, 77),
(154, '2021-01-19', 2021011901, 1, 80),
(155, '2021-01-19', 2021011902, 1, 77),
(156, '2021-01-20', 2021012001, 1, 80),
(157, '2021-01-20', 2021012002, 1, 77),
(158, '2021-01-21', 2021012101, 1, 80),
(159, '2021-01-21', 2021012102, 1, 77),
(160, '2021-01-21', 2021012102, 1, 77),
(161, '2021-01-22', 2021012201, 1, 80),
(162, '2021-01-22', 2021012202, 1, 77),
(163, '2021-01-25', 2021012501, 1, 80),
(164, '2021-01-25', 2021012502, 1, 77),
(165, '2021-01-26', 2021012601, 1, 80),
(166, '2021-01-26', 2021012602, 1, 77),
(167, '2021-01-27', 2021012701, 1, 80),
(168, '2021-01-27', 2021012702, 1, 77),
(169, '2021-01-28', 2021012801, 1, 80),
(170, '2021-01-28', 2021012802, 1, 77),
(171, '2021-01-29', 2021012901, 1, 80),
(172, '2021-01-29', 2021012902, 1, 77),
(173, '2021-02-01', 202102012, 1, 77),
(174, '2021-02-01', 202102013, 1, 84),
(175, '2021-02-02', 202102022, 1, 77),
(176, '2021-02-02', 202102023, 1, 84),
(177, '2021-02-03', 202102033, 1, 84),
(178, '2021-02-03', 202102032, 1, 77),
(179, '2021-02-04', 202102043, 1, 84),
(180, '2021-02-04', 202102042, 1, 77),
(181, '2021-02-05', 202102053, 1, 84),
(182, '2021-02-05', 202102052, 1, 77),
(183, '2021-02-08', 202102083, 1, 84),
(184, '2021-02-08', 202102083, 1, 84),
(185, '2021-02-08', 202102082, 1, 77),
(186, '2021-02-09', 202102093, 1, 84),
(187, '2021-02-09', 202102092, 1, 77),
(188, '2021-02-10', 202102103, 1, 84),
(189, '2021-02-10', 202102102, 1, 77),
(190, '2021-02-11', 202102113, 1, 84),
(191, '2021-02-11', 202102113, 1, 84),
(192, '2021-02-11', 202102112, 1, 77),
(193, '2021-02-12', 202102123, 1, 84),
(194, '2021-02-12', 202102122, 1, 77),
(195, '2021-02-15', 202102153, 1, 84),
(196, '2021-02-15', 202102152, 1, 77),
(197, '2021-02-16', 202102163, 1, 84),
(198, '2021-02-16', 202102162, 1, 77),
(199, '2021-02-17', 202102173, 1, 84),
(200, '2021-02-17', 202102172, 1, 77),
(201, '2021-02-18', 202102183, 1, 84),
(202, '2021-02-18', 202102182, 1, 77),
(203, '2021-02-19', 202102193, 1, 84),
(204, '2021-02-19', 202102192, 1, 77),
(205, '2021-02-22', 202102223, 1, 84),
(206, '2021-02-22', 202102222, 1, 77),
(207, '2021-02-23', 202102233, 1, 84),
(208, '2021-02-23', 202102232, 1, 77),
(209, '2021-02-24', 202102243, 1, 84),
(210, '2021-02-24', 202102242, 1, 77),
(211, '2021-02-25', 202102253, 1, 84),
(212, '2021-02-25', 202102252, 1, 77),
(213, '2021-02-26', 202102263, 1, 84),
(214, '2021-02-26', 202102262, 1, 77);

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
(47, 21, 'Termino', 0, 0, 0, 1),
(48, 22, 'Inicio', 0, 0, 1, 0),
(49, 22, 'Termino', 1, 30, 0, 1),
(50, 23, 'Inicio', 0, 0, 1, 0),
(51, 23, 'Termino', 1, 30, 0, 1),
(52, 24, 'BODEGA LA FARFANA SODIMAC', 0, 0, 1, 0),
(53, 24, 'SODIMAC-RANCAGUA', 120, 70, 0, 1),
(54, 25, 'Inicio', 0, 0, 1, 0),
(55, 25, 'Termino', 135, 90, 0, 1),
(56, 26, 'Inicio', 0, 0, 1, 0),
(57, 26, 'Termino', 505, 320, 0, 1),
(58, 27, 'Inicio', 0, 0, 1, 0),
(59, 27, 'Termino', 201, 150, 0, 1),
(60, 28, 'Inicio', 0, 0, 1, 0),
(61, 28, 'Termino', 120, 70, 0, 1),
(62, 29, 'Inicio', 0, 0, 1, 0),
(63, 29, 'Termino', 105, 120, 0, 1),
(64, 30, 'Inicio', 0, 0, 1, 0),
(65, 30, 'Termino', 149, 120, 0, 1),
(66, 31, 'Inicio', 0, 0, 1, 0),
(67, 31, 'Termino', 64, 50, 0, 1),
(68, 32, 'Inicio', 0, 0, 1, 0),
(69, 32, 'Termino', 5, 10, 0, 1),
(70, 33, 'Inicio', 0, 0, 1, 0),
(71, 33, 'Termino', 75, 240, 0, 1),
(72, 34, 'Inicio', 0, 0, 1, 0),
(73, 34, 'Termino', 75, 240, 0, 1),
(74, 35, 'Planta GM Sau Paulo - Aduana Uruguayana, Brasil', 1550, 1320, 1, 0),
(75, 35, 'Uruguayana, Brasil - Los Andes, Chile', 3180, 5580, 0, 0),
(76, 19, 'Los Andes, Chile', 80, 60, 0, 1),
(77, 19, 'los andes, chile', 80, 70, 0, 1),
(78, 19, 'Los andes, chile', 80, 70, 0, 1),
(79, 19, 'Los andes, Chile', 80, 70, 0, 1),
(80, 19, 'los andes, chile', 80, 70, 0, 1),
(81, 19, 'Los andes, chile - GM Enea', 80, 70, 0, 1),
(82, 35, 'Los andes, Chile - GM Enea', 3363, 5679, 0, 1),
(84, 36, 'GM Planta sau paulo IMO - Uruguayana, Brasil', 1550, 1320, 1, 0),
(87, 36, 'Uruguayana,Brasil - Los andes, chile', 3188, 5580, 0, 0),
(88, 36, 'Los andes, Chile - GM Enea', 3363, 5679, 0, 1),
(89, 37, 'Inicio', 0, 0, 1, 0),
(90, 37, 'Termino', 5, 10, 0, 1),
(91, 38, 'Inicio', 0, 0, 1, 0),
(92, 38, 'Termino', 20, 40, 0, 1);

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
(1, 156, 52, '2019-09-10 11:00:00', '2019-09-10 00:00:00'),
(2, 156, 53, '2019-09-10 12:10:00', '2019-09-10 00:00:00'),
(6, 158, 54, '2020-02-27 19:00:00', '2020-02-27 19:00:00'),
(7, 159, 68, '2020-09-01 08:00:00', '2020-09-01 08:30:00'),
(8, 159, 69, '2020-09-01 08:10:00', '2020-09-01 18:40:00'),
(9, 160, 68, '2020-09-02 08:00:00', '2020-09-02 08:30:00'),
(10, 160, 69, '2020-09-02 08:10:00', '2020-09-02 18:40:00'),
(11, 161, 68, '2020-09-03 08:00:00', '2020-09-03 08:30:00'),
(12, 161, 69, '2020-09-03 08:10:00', '2020-09-03 18:40:00'),
(13, 163, 70, '2020-09-01 09:00:00', '2020-09-01 09:30:00'),
(14, 163, 71, '2020-09-01 13:00:00', '2020-09-01 18:40:00'),
(15, 165, 72, '2020-09-01 09:00:00', '2020-09-01 09:30:00'),
(16, 165, 73, '2020-09-01 13:00:00', '2020-09-01 18:40:00'),
(17, 164, 72, '2020-09-02 09:00:00', '2020-09-02 09:30:00'),
(18, 164, 73, '2020-09-02 13:00:00', '2020-09-02 18:40:00'),
(19, 157, 52, '2020-02-27 18:00:00', '2020-02-27 18:00:00'),
(20, 157, 53, '2020-02-27 19:10:00', '2020-09-30 08:00:00'),
(21, 158, 55, '2020-02-27 20:30:00', '2020-02-28 20:00:00'),
(22, 166, 70, '2020-09-02 09:00:00', '2020-09-02 09:30:00'),
(23, 166, 71, '2020-09-02 13:00:00', '2020-09-02 18:00:00'),
(24, 167, 70, '2020-09-03 09:00:00', '2020-09-03 09:30:00'),
(25, 167, 71, '2020-09-03 13:00:00', '2020-09-03 18:40:00'),
(26, 168, 72, '2020-09-02 09:00:00', '2020-09-02 09:30:00'),
(27, 168, 73, '2020-09-02 13:00:00', '2020-09-02 18:40:00'),
(28, 169, 72, '2020-09-03 09:00:00', '2020-09-03 09:30:00'),
(29, 169, 73, '2020-09-03 13:00:00', '2020-09-03 18:40:00'),
(30, 170, 68, '2020-09-04 08:00:00', '2020-09-04 08:30:00'),
(31, 170, 69, '2020-09-04 08:10:00', '2020-09-04 18:40:00'),
(32, 171, 68, '2020-09-05 08:00:00', '2020-09-05 08:30:00'),
(33, 171, 69, '2020-09-05 08:10:00', '2020-09-05 18:40:00'),
(34, 172, 68, '2020-09-07 08:00:00', '2020-09-07 08:30:00'),
(35, 172, 69, '2020-09-07 08:10:00', '2020-09-07 18:40:00'),
(36, 173, 70, '2020-09-04 09:00:00', '2020-09-04 09:30:00'),
(37, 173, 71, '2020-09-04 13:00:00', '2020-09-04 18:40:00'),
(38, 174, 70, '2020-09-07 09:00:00', '2020-09-07 09:30:00'),
(39, 174, 71, '2020-09-07 13:00:00', '2020-09-07 18:40:00'),
(40, 175, 68, '2020-09-08 08:00:00', '2020-09-08 08:30:00'),
(41, 175, 69, '2020-09-08 08:10:00', '2020-09-08 18:40:00'),
(42, 176, 70, '2020-09-08 09:00:00', '2020-09-08 09:30:00'),
(43, 176, 71, '2020-09-08 13:00:00', '2020-09-08 18:40:00'),
(44, 177, 70, '2020-09-09 09:00:00', '2020-09-09 09:30:00'),
(45, 177, 71, '2020-09-09 13:00:00', '2020-09-09 18:40:00'),
(46, 178, 68, '2020-09-09 08:00:00', '2020-09-09 08:30:00'),
(47, 178, 69, '2020-09-09 08:10:00', '2020-09-09 18:30:00'),
(48, 179, 70, '2020-09-10 09:00:00', '2020-09-10 09:30:00'),
(49, 179, 71, '2020-09-10 13:00:00', '2020-09-10 18:40:00'),
(50, 180, 70, '2020-09-11 09:00:00', '2020-09-11 09:30:00'),
(51, 180, 71, '2020-09-11 13:00:00', '2020-09-11 18:40:00'),
(52, 181, 68, '2020-09-10 08:00:00', '2020-09-10 08:30:00'),
(53, 181, 69, '2020-09-10 08:10:00', '2020-09-10 18:40:00'),
(54, 182, 68, '2020-09-11 08:00:00', '2020-09-11 08:30:00'),
(55, 182, 69, '2020-09-11 08:10:00', '2020-09-11 18:40:00'),
(56, 183, 68, '2020-09-12 08:00:00', '2020-09-12 08:30:00'),
(57, 183, 69, '2020-09-12 08:10:00', '2020-09-12 18:40:00'),
(58, 184, 69, '2020-09-14 08:10:00', '2020-09-14 18:40:00'),
(59, 187, 68, '2020-09-15 08:00:00', '2020-09-15 08:30:00'),
(60, 187, 69, '2020-09-15 08:10:00', '2020-09-15 18:40:00'),
(61, 186, 70, '2020-09-15 09:00:00', '2020-09-15 09:30:00'),
(62, 186, 71, '2020-09-15 13:00:00', '2020-09-15 18:40:00'),
(63, 189, 70, '2020-09-16 09:00:00', '2020-09-16 09:30:00'),
(64, 189, 71, '2020-09-16 13:00:00', '2020-09-16 18:40:00'),
(65, 190, 68, '2020-09-17 08:00:00', '2020-09-17 08:30:00'),
(66, 190, 69, '2020-09-17 08:10:00', '2020-09-17 18:40:00'),
(67, 191, 70, '2020-09-17 09:00:00', '2020-09-17 09:30:00'),
(68, 191, 71, '2020-09-17 13:00:00', '2020-09-17 18:40:00'),
(69, 193, 75, '2020-08-07 22:00:00', '2020-08-07 00:30:00'),
(70, 193, 74, '2020-08-08 00:00:00', '2020-08-07 00:40:00'),
(71, 193, 82, '2020-08-07 01:10:00', '2020-08-07 23:40:00'),
(72, 192, 75, '2020-08-04 22:00:00', '2020-08-04 00:30:00'),
(73, 192, 74, '2020-08-05 00:00:00', '2020-08-04 00:40:00'),
(74, 192, 82, '2020-08-04 01:10:00', '2020-08-04 23:40:00'),
(75, 194, 75, '2020-08-12 22:00:00', '2020-08-12 00:30:00'),
(76, 194, 74, '2020-08-13 00:00:00', '2020-08-12 00:40:00'),
(77, 194, 82, '2020-08-12 01:10:00', '2020-08-12 23:40:00'),
(78, 195, 75, '2020-08-21 22:00:00', '2020-08-21 00:30:00'),
(79, 195, 74, '2020-08-22 00:00:00', '2020-08-21 00:40:00'),
(80, 195, 82, '2020-08-21 01:10:00', '2020-08-21 23:40:00'),
(81, 196, 75, '2020-08-24 22:00:00', '2020-08-24 00:30:00'),
(82, 196, 74, '2020-08-25 00:00:00', '2020-08-24 00:40:00'),
(83, 196, 82, '2020-08-24 01:10:00', '2020-08-24 23:40:00'),
(84, 197, 75, '2020-09-04 22:00:00', '2020-09-04 00:30:00'),
(85, 197, 74, '2020-09-05 00:00:00', '2020-09-04 00:40:00'),
(86, 197, 82, '2020-09-04 01:10:00', '2020-09-04 23:40:00'),
(87, 198, 75, '2020-09-11 22:00:00', '2020-09-11 00:30:00'),
(88, 198, 74, '2020-09-12 00:00:00', '2020-09-11 00:40:00'),
(89, 198, 82, '2020-09-11 01:10:00', '2020-09-11 23:40:00'),
(90, 200, 68, '2020-09-21 08:00:00', '2020-08-21 08:30:00'),
(91, 200, 69, '2020-09-21 08:10:00', '2020-08-21 18:40:00'),
(92, 201, 68, '2020-09-22 08:00:00', '2020-09-22 08:30:00'),
(93, 201, 69, '2020-09-22 08:10:00', '2020-09-22 18:40:00'),
(94, 202, 68, '2020-09-23 08:00:00', '2020-09-23 08:30:00'),
(95, 202, 69, '2020-09-23 08:10:00', '2020-09-23 18:40:00'),
(96, 203, 68, '2020-09-24 08:00:00', '2020-09-24 08:30:00'),
(97, 203, 69, '2020-09-24 08:10:00', '2020-09-24 18:40:00'),
(98, 204, 68, '2020-09-25 08:00:00', '2020-09-25 08:30:00'),
(99, 204, 69, '2020-09-25 08:10:00', '2020-09-25 18:40:00'),
(100, 205, 68, '2020-09-17 10:00:00', '2020-09-17 10:00:00'),
(101, 205, 69, '2020-09-17 10:10:00', '2020-09-17 18:00:00'),
(102, 207, 68, '2020-09-21 09:00:00', '2020-09-21 09:00:00'),
(103, 207, 69, '2020-09-21 09:10:00', '2020-09-21 18:00:00'),
(104, 208, 68, '2020-09-08 09:00:00', '2020-09-08 09:00:00'),
(105, 208, 69, '2020-09-08 09:10:00', '2020-09-08 18:00:00'),
(106, 209, 68, '2020-09-10 09:00:00', '2020-09-10 09:00:00'),
(107, 209, 69, '2020-09-10 09:10:00', '2020-09-10 18:00:00'),
(108, 210, 68, '2020-09-12 09:00:00', '2020-09-12 09:00:00'),
(109, 210, 69, '2020-09-12 09:10:00', '2020-09-12 18:00:00'),
(110, 211, 68, '2020-09-14 09:00:00', '2020-09-14 09:00:00'),
(111, 211, 69, '2020-09-14 09:10:00', '2020-09-14 18:00:00'),
(112, 213, 68, '2020-09-15 09:00:00', '2020-09-15 09:00:00'),
(113, 213, 69, '2020-09-15 09:10:00', '2020-09-15 18:00:00'),
(114, 214, 68, '2020-09-16 09:00:00', '2020-09-16 09:00:00'),
(115, 214, 69, '2020-09-16 09:10:00', '2020-09-16 18:00:00'),
(116, 212, 68, '2020-09-25 09:00:00', '2020-09-25 09:00:00'),
(117, 212, 69, '2020-09-25 09:10:00', '2020-09-25 18:00:00'),
(118, 215, 68, '2020-09-28 09:00:00', '2020-09-28 09:00:00'),
(119, 215, 69, '2020-09-28 09:10:00', '2020-09-28 18:00:00'),
(120, 216, 68, '2020-09-29 09:00:00', '2020-09-29 09:00:00'),
(121, 216, 69, '2020-09-29 09:10:00', '2020-09-29 18:00:00'),
(122, 217, 68, '2020-09-30 09:00:00', '2020-09-30 09:00:00'),
(123, 217, 69, '2020-09-30 09:10:00', '2020-09-30 18:00:00'),
(124, 218, 70, '2020-09-21 08:00:00', '2020-09-21 08:00:00'),
(125, 218, 71, '2020-09-21 12:00:00', '2020-09-21 18:00:00'),
(126, 219, 70, '2020-09-22 08:00:00', '2020-09-22 08:00:00'),
(127, 219, 71, '2020-09-22 12:00:00', '2020-09-22 18:00:00'),
(128, 220, 70, '2020-09-23 08:00:00', '2020-09-23 08:00:00'),
(129, 220, 71, '2020-09-23 12:00:00', '2020-09-23 18:00:00'),
(130, 221, 70, '2020-09-24 08:00:00', '2020-09-24 08:00:00'),
(131, 221, 71, '2020-09-24 12:00:00', '2020-09-24 18:00:00'),
(132, 222, 70, '2020-09-28 08:00:00', '2020-09-28 08:00:00'),
(133, 222, 71, '2020-09-28 12:00:00', '2020-09-28 18:00:00'),
(134, 223, 70, '2020-09-29 08:00:00', '2020-09-29 08:00:00'),
(135, 223, 71, '2020-09-29 12:00:00', '2020-09-29 18:00:00'),
(136, 224, 70, '2020-09-30 08:00:00', '2020-09-30 08:00:00'),
(137, 224, 71, '2020-09-30 12:00:00', '2020-09-30 18:00:00'),
(138, 225, 68, '2020-09-26 09:00:00', '2020-09-26 09:00:00'),
(139, 225, 69, '2020-09-26 09:10:00', '2020-09-26 18:00:00'),
(140, 226, 68, '2020-09-26 09:00:00', '2020-09-26 09:00:00'),
(141, 226, 69, '2020-09-26 09:10:00', '2020-09-26 18:00:00'),
(142, 227, 68, '2020-09-28 09:00:00', '2020-09-28 09:00:00'),
(143, 227, 69, '2020-09-28 09:10:00', '2020-09-28 18:00:00'),
(144, 228, 68, '2020-09-29 09:00:00', '2020-09-29 09:00:00'),
(145, 228, 69, '2020-09-29 09:10:00', '2020-09-29 18:00:00'),
(146, 229, 68, '2020-09-30 09:00:00', '2020-09-30 09:00:00'),
(147, 229, 69, '2020-09-30 09:10:00', '2020-09-30 18:00:00'),
(148, 230, 68, '2020-09-21 09:00:00', '2020-09-21 09:00:00'),
(149, 230, 69, '2020-09-21 09:10:00', '2020-09-21 18:00:00'),
(150, 231, 68, '2020-09-26 09:00:00', '2020-09-26 09:00:00'),
(151, 231, 69, '2020-09-26 09:10:00', '2020-09-26 18:00:00'),
(152, 232, 68, '2020-09-28 09:00:00', '2020-09-28 09:00:00'),
(153, 232, 69, '2020-09-28 09:10:00', '2020-09-28 18:00:00'),
(154, 233, 68, '2020-09-29 09:00:00', '2020-09-29 09:00:00'),
(155, 233, 69, '2020-09-29 09:10:00', '2020-09-29 18:00:00'),
(156, 234, 68, '2020-09-30 09:00:00', '2020-09-30 09:00:00'),
(157, 234, 69, '2020-09-30 09:10:00', '2020-09-30 18:00:00'),
(158, 236, 68, '2020-10-01 09:00:00', '2020-10-01 09:00:00'),
(159, 236, 69, '2020-10-01 09:10:00', '2020-10-01 18:00:00'),
(160, 237, 68, '2020-10-02 09:00:00', '2020-10-02 09:00:00'),
(161, 237, 69, '2020-10-02 09:10:00', '2020-10-02 18:00:00'),
(162, 238, 68, '2020-10-01 08:00:00', '2020-10-01 08:00:00'),
(163, 238, 69, '2020-10-01 08:10:00', '2020-10-01 18:00:00'),
(164, 239, 68, '2020-10-02 05:00:00', '2020-10-02 05:00:00'),
(165, 239, 69, '2020-10-02 05:10:00', '2020-10-02 13:00:00'),
(166, 240, 68, '2020-10-02 13:00:00', '2020-10-02 13:00:00'),
(167, 240, 69, '2020-10-02 13:10:00', '2020-10-02 21:00:00'),
(168, 242, 68, '2020-10-03 09:00:00', '2020-10-03 09:00:00'),
(169, 242, 69, '2020-10-03 09:10:00', '2020-10-03 16:00:00'),
(170, 243, 68, '2020-10-04 09:00:00', '2020-10-04 09:00:00'),
(171, 243, 69, '2020-10-04 09:10:00', '2020-10-04 16:00:00'),
(172, 244, 68, '2020-10-05 05:00:00', '2020-10-05 05:00:00'),
(173, 244, 69, '2020-10-05 05:10:00', '2020-10-05 13:00:00'),
(174, 245, 68, '2020-10-05 13:00:00', '2020-10-05 13:00:00'),
(175, 245, 69, '2020-10-05 13:10:00', '2020-10-05 21:00:00'),
(176, 246, 68, '2020-10-06 05:00:00', '2020-10-06 05:00:00'),
(177, 246, 69, '2020-10-06 05:10:00', '2020-10-06 13:00:00'),
(178, 247, 68, '2020-10-06 13:00:00', '2020-10-06 13:00:00'),
(179, 247, 69, '2020-10-06 13:10:00', '2020-10-06 21:00:00'),
(180, 248, 68, '2020-10-07 05:00:00', '2020-10-07 05:00:00'),
(181, 248, 69, '2020-10-07 05:10:00', '2020-10-07 13:00:00'),
(182, 249, 68, '2020-10-07 05:00:00', '2020-10-07 13:00:00'),
(183, 249, 69, '2020-10-07 05:10:00', '2020-10-07 21:00:00'),
(184, 250, 68, '2020-10-08 05:00:00', '2020-10-08 05:00:00'),
(185, 250, 69, '2020-10-08 05:10:00', '2020-10-08 13:00:00'),
(186, 251, 68, '2020-10-08 13:00:00', '2020-10-08 13:00:00'),
(187, 251, 69, '2020-10-08 13:10:00', '2020-10-08 21:00:00'),
(188, 252, 68, '2020-10-09 05:00:00', '2020-10-09 05:00:00'),
(189, 252, 69, '2020-10-09 05:10:00', '2020-10-09 13:00:00'),
(190, 253, 68, '2020-10-09 13:00:00', '2020-10-09 13:00:00'),
(191, 253, 69, '2020-10-09 13:10:00', '2020-10-09 21:00:00'),
(192, 254, 68, '2020-10-10 09:00:00', '2020-10-10 09:00:00'),
(193, 254, 69, '2020-10-10 09:10:00', '2020-10-10 16:00:00'),
(194, 255, 68, '2020-10-11 09:00:00', '2020-10-11 09:00:00'),
(195, 255, 69, '2020-10-11 09:10:00', '2020-10-11 16:00:00'),
(196, 256, 68, '2020-10-12 09:00:00', '2020-10-12 09:00:00'),
(197, 256, 69, '2020-10-12 09:10:00', '2020-10-12 16:00:00'),
(198, 257, 68, '2020-10-13 05:00:00', '2020-10-13 05:00:00'),
(199, 257, 69, '2020-10-13 05:10:00', '2020-10-13 13:00:00'),
(200, 258, 68, '2020-10-13 13:00:00', '2020-10-13 13:00:00'),
(201, 258, 69, '2020-10-13 13:10:00', '2020-10-13 21:00:00'),
(202, 259, 70, '2020-10-01 08:00:00', '2020-10-01 08:00:00'),
(203, 259, 71, '2020-10-01 12:00:00', '2020-10-01 18:00:00'),
(204, 260, 70, '2020-10-02 08:00:00', '2020-10-02 08:00:00'),
(205, 260, 71, '2020-10-02 12:00:00', '2020-10-02 18:00:00'),
(206, 261, 70, '2020-10-05 08:00:00', '2020-10-05 08:00:00'),
(207, 261, 71, '2020-10-05 12:00:00', '2020-10-05 18:00:00'),
(208, 262, 70, '2020-10-06 08:00:00', '2020-10-06 08:00:00'),
(209, 262, 71, '2020-10-06 12:00:00', '2020-10-06 18:00:00'),
(210, 263, 70, '2020-10-07 08:00:00', '2020-10-07 08:00:00'),
(211, 263, 71, '2020-10-07 12:00:00', '2020-10-07 18:00:00'),
(212, 264, 70, '2020-10-08 08:00:00', '2020-10-08 08:00:00'),
(213, 264, 71, '2020-10-08 12:00:00', '2020-10-08 18:00:00'),
(214, 265, 70, '2020-10-09 08:00:00', '2020-10-09 08:00:00'),
(215, 265, 71, '2020-10-09 12:00:00', '2020-10-09 18:00:00'),
(216, 268, 70, '2020-10-14 08:00:00', '2020-10-14 08:00:00'),
(217, 268, 71, '2020-10-14 12:00:00', '2020-10-14 18:00:00'),
(218, 269, 70, '2020-10-15 08:00:00', '2020-10-15 08:00:00'),
(219, 269, 71, '2020-10-15 12:00:00', '2020-10-15 18:00:00'),
(220, 270, 70, '2020-10-16 08:00:00', '2020-10-16 08:00:00'),
(221, 270, 71, '2020-10-16 12:00:00', '2020-10-16 18:00:00'),
(222, 266, 70, '2020-10-19 08:00:00', '2020-10-19 08:00:00'),
(223, 266, 71, '2020-10-19 12:00:00', '2020-10-19 18:00:00'),
(224, 271, 68, '2020-10-14 05:00:00', '2020-10-14 05:00:00'),
(225, 271, 69, '2020-10-14 05:10:00', '2020-10-14 13:00:00'),
(226, 272, 68, '2020-10-14 13:00:00', '2020-10-14 13:00:00'),
(227, 272, 69, '2020-10-14 13:10:00', '2020-10-14 21:00:00'),
(228, 273, 68, '2020-10-15 05:00:00', '2020-10-15 05:00:00'),
(229, 273, 69, '2020-10-15 05:10:00', '2020-10-15 13:00:00'),
(230, 274, 68, '2020-10-15 13:00:00', '2020-10-15 13:00:00'),
(231, 274, 69, '2020-10-15 13:10:00', '2020-10-15 21:00:00'),
(232, 275, 68, '2020-10-16 05:00:00', '2020-10-16 05:00:00'),
(233, 275, 69, '2020-10-16 05:10:00', '2020-10-16 13:00:00'),
(234, 276, 68, '2020-10-16 13:00:00', '2020-10-16 13:00:00'),
(235, 276, 69, '2020-10-16 13:10:00', '2020-10-16 21:00:00'),
(236, 277, 68, '2020-10-17 09:00:00', '2020-10-17 09:00:00'),
(237, 277, 69, '2020-10-17 09:10:00', '2020-10-17 16:00:00'),
(238, 278, 68, '2020-10-18 09:00:00', '2020-10-18 09:00:00'),
(239, 278, 69, '2020-10-18 09:10:00', '2020-10-18 16:00:00'),
(240, 279, 68, '2020-10-19 05:00:00', '2020-10-19 05:00:00'),
(241, 279, 69, '2020-10-19 05:10:00', '2020-10-19 13:00:00'),
(242, 280, 68, '2020-10-19 13:00:00', '2020-10-19 13:00:00'),
(243, 280, 69, '2020-10-19 13:10:00', '2020-10-19 21:00:00'),
(244, 281, 68, '2020-10-20 05:00:00', '2020-10-20 05:00:00'),
(245, 281, 69, '2020-10-20 05:10:00', '2020-10-20 13:00:00'),
(246, 282, 68, '2020-10-20 13:00:00', '2020-10-20 13:00:00'),
(247, 282, 69, '2020-10-20 13:10:00', '2020-10-20 21:00:00'),
(248, 267, 70, '2020-10-13 08:00:00', '2020-10-13 08:00:00'),
(249, 267, 71, '2020-10-13 12:00:00', '2020-10-13 18:00:00'),
(250, 283, 70, '2020-10-20 08:00:00', '2020-10-20 08:00:00'),
(251, 283, 71, '2020-10-20 12:00:00', '2020-10-20 18:00:00'),
(252, 284, 70, '2020-10-21 08:00:00', '2020-10-21 08:00:00'),
(253, 284, 71, '2020-10-21 12:00:00', '2020-10-21 18:00:00'),
(254, 285, 70, '2020-10-22 08:00:00', '2020-10-22 08:00:00'),
(255, 285, 71, '2020-10-22 12:00:00', '2020-10-22 18:00:00'),
(256, 286, 70, '2020-10-23 08:00:00', '2020-10-23 08:00:00'),
(257, 286, 71, '2020-10-23 12:00:00', '2020-10-23 18:00:00'),
(258, 287, 68, '2020-10-21 05:00:00', '2020-10-21 05:00:00'),
(259, 287, 69, '2020-10-21 05:10:00', '2020-10-21 13:00:00'),
(260, 288, 68, '2020-10-21 13:00:00', '2020-10-21 13:00:00'),
(261, 288, 69, '2020-10-21 13:10:00', '2020-10-21 21:00:00'),
(262, 289, 68, '2020-10-22 05:00:00', '2020-10-22 05:00:00'),
(263, 289, 69, '2020-10-22 05:10:00', '2020-10-22 13:00:00'),
(264, 290, 68, '2020-10-22 13:00:00', '2020-10-22 13:00:00'),
(265, 290, 69, '2020-10-22 13:10:00', '2020-10-22 21:00:00'),
(266, 291, 68, '2020-10-23 05:00:00', '2020-10-23 05:00:00'),
(267, 291, 69, '2020-10-23 05:10:00', '2020-10-23 13:00:00'),
(268, 292, 68, '2020-10-23 13:00:00', '2020-10-23 13:00:00'),
(269, 292, 69, '2020-10-23 13:10:00', '2020-10-23 21:00:00'),
(270, 293, 72, '2020-10-23 10:00:00', '2020-10-23 10:00:00'),
(271, 293, 73, '2020-10-23 14:00:00', '2020-10-23 18:00:00'),
(272, 294, 68, '2020-10-24 09:00:00', '2020-10-24 09:00:00'),
(273, 294, 69, '2020-10-24 09:10:00', '2020-10-24 16:00:00'),
(274, 295, 68, '2020-10-25 09:00:00', '2020-10-25 09:00:00'),
(275, 295, 69, '2020-10-25 09:10:00', '2020-10-25 16:00:00'),
(276, 296, 68, '2020-10-26 05:00:00', '2020-10-26 05:00:00'),
(277, 296, 69, '2020-10-26 05:10:00', '2020-10-26 13:00:00'),
(278, 298, 70, '2020-10-26 08:00:00', '2020-10-26 08:00:00'),
(279, 298, 71, '2020-10-26 12:00:00', '2020-10-26 18:00:00'),
(280, 297, 68, '2020-10-26 13:00:00', '2020-10-26 13:00:00'),
(281, 297, 69, '2020-10-26 13:10:00', '2020-10-26 21:00:00'),
(282, 308, 70, '2020-10-27 08:00:00', '2020-10-27 08:00:00'),
(283, 308, 71, '2020-10-27 12:00:00', '2020-10-27 18:00:00'),
(284, 299, 84, '2020-08-12 03:00:00', '2020-08-17 05:00:00'),
(285, 299, 87, '2020-08-15 02:00:00', '2020-08-21 05:00:00'),
(286, 299, 88, '2020-08-15 03:39:00', '2020-08-24 18:00:00'),
(287, 300, 84, '2020-09-12 03:00:00', '2020-09-11 05:00:00'),
(288, 300, 87, '2020-09-15 02:00:00', '2020-09-15 05:00:00'),
(289, 300, 88, '2020-09-15 03:39:00', '2020-09-22 18:00:00'),
(290, 301, 84, '2020-09-18 03:00:00', '2020-09-17 05:00:00'),
(291, 301, 87, '2020-09-21 02:00:00', '2020-09-21 05:00:00'),
(292, 301, 88, '2020-09-21 03:39:00', '2020-09-25 18:00:00'),
(293, 302, 74, '2020-09-12 03:00:00', '2020-09-11 05:00:00'),
(294, 302, 75, '2020-09-15 02:00:00', '2020-09-15 05:00:00'),
(295, 302, 82, '2020-09-15 03:39:00', '2020-09-22 18:00:00'),
(296, 303, 74, '2020-09-18 03:00:00', '2020-09-17 05:00:00'),
(297, 303, 75, '2020-09-21 02:00:00', '2020-09-21 05:00:00'),
(298, 303, 82, '2020-09-21 03:39:00', '2020-09-25 18:00:00'),
(299, 199, 84, '2020-08-07 03:00:00', '2020-08-06 05:00:00'),
(300, 199, 87, '2020-08-10 02:00:00', '2020-08-11 05:00:00'),
(301, 199, 88, '2020-08-10 03:39:00', '0202-08-18 18:00:00'),
(302, 304, 74, '2020-10-09 03:00:00', '2020-10-08 05:00:00'),
(303, 304, 75, '2020-10-12 02:00:00', '2020-10-19 05:00:00'),
(304, 304, 82, '2020-10-12 03:39:00', '2020-10-26 18:00:00'),
(305, 305, 74, '2020-10-14 03:00:00', '2020-10-13 05:00:00'),
(306, 305, 75, '2020-10-17 02:00:00', '2020-10-19 05:00:00'),
(307, 305, 82, '2020-10-17 03:39:00', '2020-10-26 18:00:00'),
(308, 306, 74, '2020-10-16 03:00:00', '2020-10-15 05:00:00'),
(309, 306, 75, '2020-10-19 02:00:00', '2020-10-19 05:00:00'),
(310, 306, 82, '2020-10-19 03:39:00', '2020-10-27 18:00:00'),
(311, 307, 74, '2020-10-20 03:00:00', '2020-10-19 05:00:00'),
(312, 307, 75, '2020-10-23 02:00:00', '2020-10-23 05:00:00'),
(313, 307, 82, '2020-10-23 03:39:00', '2020-10-28 18:00:00'),
(314, 312, 70, '2020-10-28 08:00:00', '2020-10-28 08:00:00'),
(315, 312, 71, '2020-10-28 12:00:00', '2020-10-28 18:00:00'),
(316, 313, 68, '2020-10-28 05:00:00', '2020-10-28 05:00:00'),
(317, 313, 69, '2020-10-28 05:10:00', '2020-10-28 13:00:00'),
(318, 314, 68, '2020-10-28 13:00:00', '2020-10-28 13:00:00'),
(319, 314, 69, '2020-10-28 13:10:00', '2020-10-28 21:00:00'),
(320, 315, 68, '2020-10-29 05:00:00', '2020-10-29 05:00:00'),
(321, 315, 69, '2020-10-29 05:10:00', '2020-10-29 13:00:00'),
(322, 316, 68, '2020-10-29 13:00:00', '2020-10-29 13:00:00'),
(323, 316, 69, '2020-10-29 13:10:00', '2020-10-29 21:00:00'),
(324, 317, 68, '2020-10-30 05:00:00', '2020-10-30 05:00:00'),
(325, 317, 69, '2020-10-30 05:10:00', '2020-10-30 13:00:00'),
(326, 318, 68, '2020-10-30 13:00:00', '2020-10-30 13:00:00'),
(327, 318, 69, '2020-10-30 13:10:00', '2020-10-30 21:00:00'),
(328, 319, 68, '2020-10-28 08:00:00', '2020-10-28 08:00:00'),
(329, 319, 69, '2020-10-28 08:10:00', '2020-10-28 18:00:00'),
(330, 320, 68, '2020-10-29 08:00:00', '2020-10-29 08:00:00'),
(331, 320, 69, '2020-10-29 08:10:00', '2020-10-29 18:00:00'),
(332, 321, 68, '2020-10-30 08:00:00', '2020-10-30 08:00:00'),
(333, 321, 69, '2020-10-30 08:10:00', '2020-10-30 18:00:00'),
(334, 322, 70, '2020-10-29 08:00:00', '2020-10-29 08:00:00'),
(335, 322, 71, '2020-10-29 12:00:00', '2020-10-29 18:00:00'),
(336, 323, 70, '2020-10-30 08:00:00', '2020-10-30 08:00:00'),
(337, 323, 71, '2020-10-30 12:00:00', '2020-10-30 18:00:00'),
(338, 324, 68, '2020-10-31 09:00:00', '2020-10-31 09:00:00'),
(339, 324, 69, '2020-10-31 09:10:00', '2020-10-31 16:00:00'),
(340, 330, 68, '2020-11-02 08:00:00', '2020-11-02 08:00:00'),
(341, 330, 69, '2020-11-02 08:10:00', '2020-11-02 18:00:00'),
(342, 331, 68, '2020-11-03 08:00:00', '2020-11-03 08:00:00'),
(343, 331, 69, '2020-11-03 08:10:00', '2020-11-03 18:00:00'),
(344, 325, 68, '2020-11-01 09:00:00', '2020-11-01 09:00:00'),
(345, 325, 69, '2020-11-01 09:10:00', '2020-11-01 16:00:00'),
(346, 326, 68, '2020-11-02 05:00:00', '2020-11-02 05:00:00'),
(347, 326, 69, '2020-11-02 05:10:00', '2020-11-02 13:00:00'),
(348, 327, 68, '2020-11-02 13:00:00', '2020-11-02 13:00:00'),
(349, 327, 69, '2020-11-02 13:10:00', '2020-11-02 21:00:00'),
(350, 328, 68, '2020-11-03 05:00:00', '2020-11-03 05:00:00'),
(351, 328, 69, '2020-11-03 05:10:00', '2020-11-03 13:00:00'),
(352, 329, 68, '2020-11-03 13:00:00', '2020-11-03 13:00:00'),
(353, 329, 69, '2020-11-03 13:10:00', '2020-11-03 21:00:00'),
(354, 332, 70, '2020-11-02 08:00:00', '2020-11-02 08:00:00'),
(355, 332, 71, '2020-11-02 12:00:00', '2020-11-02 18:00:00'),
(356, 333, 70, '2020-11-03 08:00:00', '2020-11-03 08:00:00'),
(357, 333, 71, '2020-11-03 12:00:00', '2020-11-03 18:00:00'),
(358, 334, 70, '2020-11-04 08:00:00', '2020-11-04 08:00:00'),
(359, 334, 71, '2020-11-04 12:00:00', '2020-11-04 18:00:00'),
(360, 335, 70, '2020-11-05 08:00:00', '2020-11-05 08:00:00'),
(361, 335, 71, '2020-11-05 12:00:00', '2020-11-05 18:00:00'),
(362, 336, 70, '2020-11-06 08:00:00', '2020-11-06 08:00:00'),
(363, 336, 71, '2020-11-06 12:00:00', '2020-11-06 18:00:00'),
(364, 337, 70, '2020-11-09 08:00:00', '2020-11-09 08:00:00'),
(365, 337, 71, '2020-11-09 12:00:00', '2020-11-09 18:00:00'),
(366, 338, 70, '2020-11-10 08:00:00', '2020-11-10 08:00:00'),
(367, 338, 71, '2020-11-10 12:00:00', '2020-11-10 18:00:00'),
(368, 339, 70, '2020-11-11 08:00:00', '2020-11-11 08:00:00'),
(369, 339, 71, '2020-11-11 12:00:00', '2020-11-11 18:00:00'),
(370, 309, 74, '2020-10-31 06:00:00', '2020-10-30 06:00:00'),
(371, 309, 75, '2020-11-03 05:00:00', '2020-10-06 06:00:00'),
(372, 309, 82, '2020-11-03 06:39:00', '2020-11-10 14:00:00'),
(373, 310, 74, '2020-10-31 06:00:00', '2020-10-30 06:00:00'),
(374, 310, 75, '2020-11-03 05:00:00', '2020-11-06 06:00:00'),
(375, 310, 82, '2020-11-03 06:39:00', '2020-11-10 14:00:00'),
(376, 311, 74, '2020-10-31 06:00:00', '2020-10-30 06:00:00'),
(377, 311, 75, '2020-11-03 05:00:00', '2020-11-06 06:00:00'),
(378, 311, 82, '2020-11-03 06:39:00', '2020-11-10 14:00:00'),
(379, 340, 68, '2020-11-04 05:00:00', '2020-11-04 05:00:00'),
(380, 340, 69, '2020-11-04 05:10:00', '2020-11-04 13:00:00'),
(381, 341, 68, '2020-11-04 13:00:00', '2020-11-04 13:00:00'),
(382, 341, 69, '2020-11-04 13:10:00', '2020-11-04 21:00:00'),
(383, 342, 68, '2020-11-05 08:00:00', '2020-11-05 05:00:00'),
(384, 342, 69, '2020-11-05 08:10:00', '2020-11-05 13:00:00'),
(385, 343, 68, '2020-11-05 13:00:00', '2020-11-05 13:00:00'),
(386, 343, 69, '2020-11-05 13:10:00', '2020-11-05 21:00:00'),
(387, 344, 68, '2020-11-06 05:00:00', '2020-11-06 05:00:00'),
(388, 344, 69, '2020-11-06 05:10:00', '2020-11-06 13:00:00'),
(389, 345, 68, '2020-11-06 13:00:00', '2020-11-06 13:00:00'),
(390, 345, 69, '2020-11-06 13:10:00', '2020-11-06 21:00:00'),
(391, 346, 68, '2020-11-07 09:00:00', '2020-11-07 09:00:00'),
(392, 346, 69, '2020-11-07 09:10:00', '2020-11-07 16:00:00'),
(393, 347, 68, '2020-11-08 09:00:00', '2020-11-08 09:00:00'),
(394, 347, 69, '2020-11-08 09:10:00', '2020-11-08 16:00:00'),
(395, 348, 68, '2020-11-09 05:00:00', '2020-11-09 05:00:00'),
(396, 348, 69, '2020-11-09 05:10:00', '2020-11-09 13:00:00'),
(397, 349, 68, '2020-11-09 13:00:00', '2020-11-09 13:00:00'),
(398, 349, 69, '2020-11-09 13:10:00', '2020-11-09 21:00:00'),
(399, 350, 68, '2020-11-10 05:00:00', '2020-11-10 05:00:00'),
(400, 350, 69, '2020-11-10 05:10:00', '2020-11-10 13:00:00'),
(401, 351, 68, '2020-11-10 13:00:00', '2020-11-10 13:00:00'),
(402, 351, 69, '2020-11-10 13:10:00', '2020-11-10 21:00:00'),
(403, 352, 68, '2020-11-11 05:00:00', '2020-11-11 05:00:00'),
(404, 352, 69, '2020-11-11 05:10:00', '2020-11-11 13:00:00'),
(405, 353, 68, '2020-11-11 13:00:00', '2020-11-11 13:00:00'),
(406, 353, 69, '2020-11-11 13:10:00', '2020-11-11 21:00:00'),
(407, 354, 68, '2020-11-12 05:00:00', '2020-11-12 05:00:00'),
(408, 354, 69, '2020-11-12 05:10:00', '2020-11-12 13:00:00'),
(409, 355, 68, '2020-11-12 13:00:00', '2020-11-12 13:00:00'),
(410, 355, 69, '2020-11-12 13:10:00', '2020-11-12 21:00:00'),
(411, 356, 68, '2020-11-04 08:00:00', '2020-11-04 08:00:00'),
(412, 356, 69, '2020-11-04 08:10:00', '2020-11-04 18:00:00'),
(413, 357, 68, '2020-11-05 08:00:00', '2020-11-05 08:00:00'),
(414, 357, 69, '2020-11-05 08:10:00', '2020-11-05 18:00:00'),
(415, 358, 68, '2020-11-06 08:00:00', '2020-11-06 08:00:00'),
(416, 358, 69, '2020-11-06 08:10:00', '2020-11-06 18:00:00'),
(417, 359, 68, '2020-11-07 08:00:00', '2020-11-07 08:00:00'),
(418, 359, 69, '2020-11-07 08:10:00', '2020-11-07 18:00:00'),
(419, 360, 68, '2020-11-09 08:00:00', '2020-11-09 08:00:00'),
(420, 360, 69, '2020-11-09 08:10:00', '2020-11-09 18:00:00'),
(421, 361, 68, '2020-11-10 08:00:00', '2020-11-10 08:00:00'),
(422, 361, 69, '2020-11-10 08:10:00', '2020-11-10 18:00:00'),
(423, 362, 68, '2020-11-11 08:00:00', '2020-11-11 08:00:00'),
(424, 362, 69, '2020-11-11 08:10:00', '2020-11-11 18:00:00'),
(425, 363, 68, '2020-11-12 08:00:00', '2020-11-12 08:00:00'),
(426, 363, 69, '2020-11-12 08:10:00', '2020-11-12 18:00:00'),
(427, 364, 70, '2020-11-12 08:00:00', '2020-11-12 08:00:00'),
(428, 364, 71, '2020-11-12 12:00:00', '2020-11-12 18:00:00'),
(429, 365, 70, '2020-11-13 08:00:00', '2020-11-13 08:00:00'),
(430, 365, 71, '2020-11-13 12:00:00', '2020-11-13 18:00:00'),
(431, 366, 70, '2020-11-16 08:00:00', '2020-11-16 08:00:00'),
(432, 366, 71, '2020-11-16 12:00:00', '2020-11-16 18:00:00'),
(433, 367, 70, '2020-11-17 08:00:00', '2020-11-17 08:00:00'),
(434, 367, 71, '2020-11-17 12:00:00', '2020-11-17 18:00:00'),
(435, 368, 70, '2020-11-18 08:00:00', '2020-11-18 08:00:00'),
(436, 368, 71, '2020-11-18 12:00:00', '2020-11-18 18:00:00'),
(437, 369, 70, '2020-11-19 08:00:00', '2020-11-19 08:00:00'),
(438, 369, 71, '2020-11-19 12:00:00', '2020-11-19 18:00:00'),
(439, 370, 70, '2020-11-20 08:00:00', '2020-11-20 08:00:00'),
(440, 370, 71, '2020-11-20 12:00:00', '2020-11-20 18:00:00'),
(441, 371, 70, '2020-11-23 08:00:00', '2020-11-23 08:00:00'),
(442, 371, 71, '2020-11-23 12:00:00', '2020-11-23 18:00:00'),
(443, 372, 68, '2020-11-13 05:00:00', '2020-11-13 05:00:00'),
(444, 372, 69, '2020-11-13 05:10:00', '2020-11-13 13:00:00'),
(445, 373, 68, '2020-11-13 13:00:00', '2020-11-13 13:00:00'),
(446, 373, 69, '2020-11-13 13:10:00', '2020-11-13 21:00:00'),
(447, 374, 68, '2020-11-14 09:00:00', '2020-11-14 09:00:00'),
(448, 374, 69, '2020-11-14 09:10:00', '2020-11-14 16:00:00'),
(449, 375, 68, '2020-11-15 09:00:00', '2020-11-15 09:00:00'),
(450, 375, 69, '2020-11-15 09:10:00', '2020-11-15 16:00:00'),
(451, 376, 68, '2020-11-16 05:00:00', '2020-11-16 05:00:00'),
(452, 376, 69, '2020-11-16 05:10:00', '2020-11-16 13:00:00'),
(453, 377, 68, '2020-11-16 13:00:00', '2020-11-16 13:00:00'),
(454, 377, 69, '2020-11-16 13:10:00', '2020-11-16 21:00:00'),
(455, 378, 68, '2020-11-17 05:00:00', '2020-11-17 05:00:00'),
(456, 378, 69, '2020-11-17 05:10:00', '2020-11-17 13:00:00'),
(457, 379, 68, '2020-11-17 13:00:00', '2020-11-17 13:00:00'),
(458, 379, 69, '2020-11-17 13:10:00', '2020-11-17 21:00:00'),
(459, 380, 68, '2020-11-18 05:00:00', '2020-11-18 05:00:00'),
(460, 380, 69, '2020-11-18 05:10:00', '2020-11-18 13:00:00'),
(461, 381, 68, '2020-11-18 13:00:00', '2020-11-18 13:00:00'),
(462, 381, 69, '2020-11-18 13:10:00', '2020-11-18 21:00:00'),
(463, 382, 68, '2020-11-19 05:00:00', '2020-11-19 05:00:00'),
(464, 382, 69, '2020-11-19 05:10:00', '2020-11-19 13:00:00'),
(465, 383, 68, '2020-11-19 13:00:00', '2020-11-19 13:00:00'),
(466, 383, 69, '2020-11-19 13:10:00', '2020-11-19 21:00:00'),
(467, 384, 68, '2020-11-20 05:00:00', '2020-11-20 05:00:00'),
(468, 384, 69, '2020-11-20 05:10:00', '2020-11-20 13:00:00'),
(469, 385, 68, '2020-11-20 13:00:00', '2020-11-20 13:00:00'),
(470, 385, 69, '2020-11-20 13:10:00', '2020-11-20 21:00:00'),
(471, 386, 68, '2020-11-21 09:00:00', '2020-11-21 09:00:00'),
(472, 386, 69, '2020-11-21 09:10:00', '2020-11-21 16:00:00'),
(473, 387, 68, '2020-11-22 09:00:00', '2020-11-22 09:00:00'),
(474, 387, 69, '2020-11-22 09:10:00', '2020-11-22 16:00:00'),
(475, 388, 68, '2020-11-23 05:00:00', '2020-11-23 05:00:00'),
(476, 388, 69, '2020-11-23 05:10:00', '2020-11-23 13:00:00'),
(477, 389, 68, '2020-11-23 13:00:00', '2020-11-23 13:00:00'),
(478, 389, 69, '2020-11-23 13:10:00', '2020-11-23 21:00:00'),
(479, 390, 68, '2020-11-24 05:00:00', '2020-11-24 05:00:00'),
(480, 390, 69, '2020-11-24 05:10:00', '2020-11-24 13:00:00'),
(481, 391, 68, '2020-11-24 13:00:00', '2020-11-24 13:00:00'),
(482, 391, 69, '2020-11-24 13:10:00', '2020-11-24 21:00:00'),
(483, 392, 68, '2020-11-25 05:00:00', '2020-11-25 05:00:00'),
(484, 392, 69, '2020-11-25 05:10:00', '2020-11-25 13:00:00'),
(485, 393, 68, '2020-11-25 13:00:00', '2020-11-25 13:00:00'),
(486, 393, 69, '2020-11-25 13:10:00', '2020-11-25 21:00:00'),
(487, 394, 68, '2020-11-26 05:00:00', '2020-11-26 05:00:00'),
(488, 394, 69, '2020-11-26 05:10:00', '2020-11-26 13:00:00'),
(489, 395, 68, '2020-11-26 13:00:00', '2020-11-26 13:00:00'),
(490, 395, 69, '2020-11-26 13:10:00', '2020-11-26 21:00:00'),
(491, 396, 68, '2020-11-27 05:00:00', '2020-11-27 05:00:00'),
(492, 396, 69, '2020-11-27 05:10:00', '2020-11-27 13:00:00'),
(493, 397, 68, '2020-11-27 13:00:00', '0200-11-27 13:00:00'),
(494, 397, 69, '2020-11-27 13:10:00', '2020-11-27 21:00:00'),
(495, 398, 68, '2020-11-28 09:00:00', '2020-11-28 09:00:00'),
(496, 398, 69, '2020-11-28 09:10:00', '2020-11-28 16:00:00'),
(497, 399, 68, '2020-11-29 09:00:00', '2020-11-29 09:00:00'),
(498, 399, 69, '2020-11-29 09:10:00', '2020-11-29 16:00:00'),
(499, 400, 68, '2020-11-30 05:00:00', '2020-11-30 05:00:00'),
(500, 400, 69, '2020-11-30 05:10:00', '2020-11-30 13:00:00'),
(501, 401, 68, '2020-11-30 13:00:00', '2020-11-30 13:00:00'),
(502, 401, 69, '2020-11-30 13:10:00', '2020-11-30 21:00:00'),
(503, 402, 68, '2020-11-13 08:00:00', '2020-11-13 08:00:00'),
(504, 402, 69, '2020-11-13 08:10:00', '2020-11-13 18:00:00'),
(505, 403, 68, '2020-11-14 08:00:00', '2020-11-14 08:00:00'),
(506, 403, 69, '2020-11-14 08:10:00', '2020-11-14 18:00:00'),
(507, 404, 68, '2020-11-16 08:00:00', '2020-11-16 08:00:00'),
(508, 404, 69, '2020-11-16 08:10:00', '2020-11-16 18:00:00'),
(509, 405, 68, '2020-11-17 08:00:00', '2020-11-17 08:00:00'),
(510, 405, 69, '2020-11-17 08:10:00', '2020-11-17 18:00:00'),
(511, 406, 68, '2020-11-18 08:00:00', '2020-11-18 08:00:00'),
(512, 406, 69, '2020-11-18 08:10:00', '2020-11-18 18:00:00'),
(513, 407, 68, '2020-11-19 08:00:00', '2020-11-19 08:00:00'),
(514, 407, 69, '2020-11-19 08:10:00', '2020-11-19 18:00:00'),
(515, 408, 68, '2020-11-20 08:00:00', '2020-11-20 08:00:00'),
(516, 408, 69, '2020-11-20 08:10:00', '2020-11-20 18:00:00'),
(517, 409, 68, '2020-11-21 08:00:00', '2020-11-21 08:00:00'),
(518, 409, 69, '2020-11-21 08:10:00', '2020-11-21 18:00:00'),
(519, 410, 68, '2020-11-23 08:00:00', '2020-11-23 08:00:00'),
(520, 410, 69, '2020-11-23 08:10:00', '2020-11-23 18:00:00'),
(521, 411, 68, '2020-11-24 08:00:00', '2020-11-24 08:00:00'),
(522, 411, 69, '2020-11-24 08:10:00', '2020-11-24 18:00:00'),
(523, 412, 68, '2020-11-25 08:00:00', '2020-11-25 08:00:00'),
(524, 412, 69, '2020-11-25 08:10:00', '2020-11-25 18:00:00'),
(525, 413, 68, '2020-11-26 08:00:00', '2020-11-26 08:00:00'),
(526, 413, 69, '2020-11-26 08:10:00', '2020-11-26 18:00:00'),
(527, 414, 68, '2020-11-27 08:00:00', '2020-11-27 08:00:00'),
(528, 414, 69, '2020-11-27 08:10:00', '2020-11-27 18:00:00'),
(529, 415, 68, '2020-11-28 08:00:00', '2020-11-28 08:00:00'),
(530, 415, 69, '2020-11-28 08:10:00', '2020-11-28 18:00:00'),
(531, 416, 68, '2020-11-30 08:00:00', '2020-11-30 08:00:00'),
(532, 416, 69, '2020-11-30 08:10:00', '2020-11-30 18:00:00'),
(533, 421, 74, '2020-11-19 04:00:00', '2020-11-21 06:00:00'),
(534, 421, 75, '2020-11-22 03:00:00', '2020-11-25 06:00:00'),
(535, 421, 82, '2020-11-22 04:39:00', '2020-11-26 18:00:00'),
(536, 417, 74, '2020-11-19 04:00:00', '2020-11-21 06:00:00'),
(537, 417, 75, '2020-11-22 03:00:00', '2020-11-25 06:00:00'),
(538, 417, 82, '2020-11-22 04:39:00', '2020-11-26 18:00:00'),
(539, 418, 74, '2020-11-19 04:00:00', '2020-11-20 06:00:00'),
(540, 418, 75, '2020-11-22 03:00:00', '2020-11-25 06:00:00'),
(541, 418, 82, '2020-11-22 04:39:00', '2020-11-27 18:00:00'),
(542, 420, 74, '2020-11-19 04:00:00', '2020-11-21 06:00:00'),
(543, 420, 75, '2020-11-22 03:00:00', '2020-11-25 06:00:00'),
(544, 420, 82, '2020-11-22 04:39:00', '2020-11-27 18:00:00'),
(545, 422, 70, '2020-11-24 08:00:00', '2020-11-24 08:00:00'),
(546, 422, 71, '2020-11-24 12:00:00', '2020-11-24 18:00:00'),
(547, 423, 70, '2020-11-25 08:00:00', '2020-11-25 08:00:00'),
(548, 423, 71, '2020-11-25 12:00:00', '2020-11-25 18:00:00'),
(549, 424, 70, '2020-11-26 08:00:00', '2020-11-26 08:00:00'),
(550, 424, 71, '2020-11-26 12:00:00', '2020-11-26 18:00:00'),
(551, 425, 70, '2020-11-27 08:00:00', '2020-11-27 08:00:00'),
(552, 425, 71, '2020-11-27 12:00:00', '2020-11-27 18:00:00'),
(553, 426, 70, '2020-11-30 08:00:00', '2020-11-30 08:00:00'),
(554, 426, 71, '2020-11-30 12:00:00', '2020-11-30 18:00:00'),
(555, 427, 68, '2020-12-01 05:00:00', '2020-12-01 05:00:00'),
(556, 427, 69, '2020-12-01 05:10:00', '2020-12-01 13:00:00'),
(557, 428, 68, '2020-12-01 13:00:00', '2020-12-01 13:00:00'),
(558, 428, 69, '2020-12-01 13:10:00', '2020-12-01 21:00:00'),
(559, 429, 68, '2020-12-02 05:00:00', '2020-12-02 05:00:00'),
(560, 429, 69, '2020-12-02 05:10:00', '2020-12-02 13:00:00'),
(561, 430, 68, '2020-12-02 13:00:00', '2020-12-02 13:00:00'),
(562, 430, 69, '2020-12-02 13:10:00', '2020-12-02 21:00:00'),
(563, 431, 68, '2020-12-03 05:00:00', '2020-12-03 05:00:00'),
(564, 431, 69, '2020-12-03 05:10:00', '2020-12-03 13:00:00'),
(565, 432, 68, '2020-12-03 13:00:00', '2020-12-03 13:00:00'),
(566, 432, 69, '2020-12-03 13:10:00', '2020-12-03 21:00:00'),
(567, 433, 68, '2020-12-04 05:00:00', '2020-12-04 05:00:00'),
(568, 433, 69, '2020-12-04 05:10:00', '2020-12-04 13:00:00'),
(569, 434, 68, '2020-12-04 13:00:00', '2020-12-04 13:00:00'),
(570, 434, 69, '2020-12-04 13:10:00', '2020-12-04 21:00:00'),
(571, 435, 68, '2020-12-05 09:00:00', '2020-12-05 09:00:00'),
(572, 435, 69, '2020-12-05 09:10:00', '2020-12-05 16:00:00'),
(573, 436, 68, '2020-12-06 09:00:00', '2020-12-06 09:00:00'),
(574, 436, 69, '2020-12-06 09:10:00', '2020-12-06 16:00:00'),
(575, 437, 68, '2020-12-07 05:00:00', '2020-12-07 05:00:00'),
(576, 437, 69, '2020-12-07 05:10:00', '2020-12-07 13:00:00'),
(577, 438, 68, '2020-12-07 13:00:00', '2020-12-07 13:00:00'),
(578, 438, 69, '2020-12-07 13:10:00', '2020-12-07 21:00:00'),
(579, 439, 68, '2020-12-08 05:00:00', '2020-12-08 05:00:00'),
(580, 439, 69, '2020-12-08 05:10:00', '2020-12-08 13:00:00'),
(581, 440, 68, '2020-12-08 13:00:00', '2020-12-08 13:00:00'),
(582, 440, 69, '2020-12-08 13:10:00', '2020-12-08 21:00:00'),
(583, 441, 68, '2020-12-09 05:00:00', '2020-12-09 05:00:00'),
(584, 441, 69, '2020-12-09 05:10:00', '2020-12-09 13:00:00'),
(585, 442, 68, '2020-12-09 13:00:00', '2020-12-09 13:00:00'),
(586, 442, 69, '2020-12-09 13:10:00', '2020-12-09 21:00:00'),
(587, 443, 68, '2020-12-10 05:00:00', '2020-12-10 05:00:00'),
(588, 443, 69, '2020-12-10 05:10:00', '2020-12-10 13:00:00'),
(589, 444, 68, '2020-12-10 13:00:00', '2020-12-10 13:00:00'),
(590, 444, 69, '2020-12-10 13:10:00', '2020-12-10 21:00:00'),
(591, 445, 68, '2020-12-11 05:00:00', '2020-12-11 05:00:00'),
(592, 445, 69, '2020-12-11 05:10:00', '2020-12-11 13:00:00'),
(593, 446, 68, '2020-12-11 13:00:00', '2020-12-11 13:00:00'),
(594, 446, 69, '2020-12-11 13:10:00', '2020-12-11 21:00:00'),
(595, 447, 74, '2020-11-20 04:00:00', '2020-11-19 06:00:00'),
(596, 447, 75, '2020-11-23 03:00:00', '2020-12-01 06:00:00'),
(597, 447, 82, '2020-11-23 04:39:00', '2020-12-02 18:00:00'),
(598, 448, 74, '2020-12-10 04:00:00', '2020-12-09 06:00:00'),
(599, 448, 75, '2020-12-13 03:00:00', '2020-12-14 06:00:00'),
(600, 448, 82, '2020-12-13 04:39:00', '2020-12-15 18:00:00'),
(601, 449, 74, '2020-12-11 04:00:00', '2020-12-10 06:00:00'),
(602, 449, 75, '2020-12-14 03:00:00', '2020-12-14 06:00:00'),
(603, 449, 82, '2020-12-14 04:39:00', '2020-12-15 18:00:00'),
(604, 450, 70, '2020-12-01 08:00:00', '2020-12-01 08:00:00'),
(605, 450, 71, '2020-12-01 12:00:00', '2020-12-01 18:00:00'),
(606, 451, 70, '2020-12-02 08:00:00', '2020-12-02 08:00:00'),
(607, 451, 71, '2020-12-02 12:00:00', '2020-12-02 18:00:00'),
(608, 452, 70, '2020-12-03 08:00:00', '2020-12-03 08:00:00'),
(609, 452, 71, '2020-12-03 12:00:00', '2020-12-03 18:00:00'),
(610, 453, 70, '2020-12-04 08:00:00', '2020-12-04 08:00:00'),
(611, 453, 71, '2020-12-04 12:00:00', '2020-12-04 18:00:00'),
(612, 454, 70, '2020-12-07 08:00:00', '2020-12-07 08:00:00'),
(613, 454, 71, '2020-12-07 12:00:00', '2020-12-07 18:00:00'),
(614, 455, 70, '2020-12-09 08:00:00', '2020-12-09 08:00:00'),
(615, 455, 71, '2020-12-09 12:00:00', '2020-12-09 18:00:00'),
(616, 456, 70, '2020-12-10 08:00:00', '2020-12-10 08:00:00'),
(617, 456, 71, '2020-12-10 12:00:00', '2020-12-10 18:00:00'),
(618, 457, 70, '2020-12-11 08:00:00', '2020-12-11 08:00:00'),
(619, 457, 71, '2020-12-11 12:00:00', '2020-12-11 18:00:00'),
(620, 458, 70, '2020-12-14 08:00:00', '2020-12-14 08:00:00'),
(621, 458, 71, '2020-12-14 12:00:00', '2020-12-14 18:00:00'),
(622, 459, 70, '2020-12-15 08:00:00', '2020-12-15 08:00:00'),
(623, 459, 71, '2020-12-15 12:00:00', '2020-12-15 18:00:00'),
(624, 460, 70, '2020-12-16 08:00:00', '2020-12-16 08:00:00'),
(625, 460, 71, '2020-12-16 12:00:00', '2020-12-16 18:00:00'),
(626, 461, 70, '2020-12-17 08:00:00', '2020-12-17 08:00:00'),
(627, 461, 71, '2020-12-17 12:00:00', '2020-12-17 18:00:00'),
(628, 462, 70, '2020-12-18 08:00:00', '2020-01-18 08:00:00'),
(629, 462, 71, '2020-12-18 12:00:00', '2020-01-18 18:00:00'),
(630, 464, 70, '2020-12-21 08:00:00', '2020-01-21 08:00:00'),
(631, 464, 71, '2020-12-21 12:00:00', '2020-01-21 18:00:00'),
(632, 465, 70, '2020-12-22 08:00:00', '2020-12-22 08:00:00'),
(633, 465, 71, '2020-12-22 12:00:00', '2020-12-22 18:00:00'),
(634, 466, 70, '2020-12-23 08:00:00', '2020-12-23 08:00:00'),
(635, 466, 71, '2020-12-23 12:00:00', '2020-12-23 18:00:00'),
(636, 468, 70, '2020-12-24 08:00:00', '2020-12-24 08:00:00'),
(637, 468, 71, '2020-12-24 12:00:00', '2020-12-24 18:00:00'),
(638, 469, 70, '2020-12-30 08:00:00', '2020-12-30 08:00:00'),
(639, 469, 71, '2020-12-30 12:00:00', '2020-12-30 18:00:00'),
(640, 470, 70, '2020-12-31 08:00:00', '2020-12-31 08:00:00'),
(641, 470, 71, '2020-12-31 12:00:00', '2020-12-31 18:00:00'),
(642, 471, 68, '2020-12-12 09:00:00', '2020-12-12 09:00:00'),
(643, 471, 69, '2020-12-12 09:10:00', '2020-12-21 16:00:00'),
(644, 472, 68, '2020-12-13 09:00:00', '2020-12-13 09:00:00'),
(645, 472, 69, '2020-12-13 09:10:00', '2020-12-13 16:00:00'),
(646, 473, 68, '2020-12-14 05:00:00', '2020-12-14 05:00:00'),
(647, 473, 69, '2020-12-14 05:10:00', '2020-12-14 13:00:00'),
(648, 474, 68, '2020-12-14 13:00:00', '2020-12-14 13:00:00'),
(649, 474, 69, '2020-12-14 13:10:00', '2020-12-14 21:00:00'),
(650, 475, 68, '2020-12-15 05:00:00', '2020-12-15 05:00:00'),
(651, 475, 69, '2020-12-15 05:10:00', '2020-12-15 13:00:00'),
(652, 476, 68, '2020-12-15 13:00:00', '2020-12-15 13:00:00'),
(653, 476, 69, '2020-12-15 13:10:00', '2020-12-15 21:00:00'),
(654, 477, 68, '2020-12-16 05:00:00', '2020-12-16 05:00:00'),
(655, 477, 69, '2020-12-16 05:10:00', '2020-12-16 13:00:00'),
(656, 478, 68, '2020-12-16 13:00:00', '2020-12-16 13:00:00'),
(657, 478, 69, '2020-12-16 13:10:00', '2020-12-16 21:00:00'),
(658, 479, 68, '2020-12-17 05:00:00', '2020-12-17 05:00:00'),
(659, 479, 69, '2020-12-17 05:10:00', '2020-12-17 13:00:00'),
(660, 480, 68, '2020-12-17 13:00:00', '2020-12-17 13:00:00'),
(661, 480, 69, '2020-12-17 13:10:00', '2020-12-17 21:00:00'),
(662, 481, 68, '2020-12-18 05:00:00', '2020-12-18 05:00:00'),
(663, 481, 69, '2020-12-18 05:10:00', '2020-12-18 13:00:00'),
(664, 482, 68, '2020-12-18 13:00:00', '2020-12-18 13:00:00'),
(665, 482, 69, '2020-12-18 13:10:00', '2020-12-18 21:00:00'),
(666, 483, 68, '2020-12-19 09:00:00', '2020-12-19 09:00:00'),
(667, 483, 69, '2020-12-19 09:10:00', '2020-12-19 16:00:00'),
(668, 484, 68, '2020-12-20 09:00:00', '2020-12-20 09:00:00'),
(669, 484, 69, '2020-12-20 09:10:00', '2020-12-20 16:00:00'),
(670, 485, 68, '2020-12-01 08:00:00', '2020-12-01 08:00:00'),
(671, 485, 69, '2020-12-01 08:10:00', '2020-12-01 18:00:00'),
(672, 486, 68, '2020-12-02 08:00:00', '2020-12-02 08:00:00'),
(673, 486, 69, '2020-12-02 08:10:00', '2020-12-02 18:00:00'),
(674, 487, 68, '2020-12-03 08:00:00', '2020-12-03 08:00:00'),
(675, 487, 69, '2020-12-03 08:10:00', '2020-12-03 18:00:00'),
(676, 488, 68, '2020-12-04 08:00:00', '2020-12-04 08:00:00'),
(677, 488, 69, '2020-12-04 08:10:00', '2020-12-04 18:00:00'),
(678, 490, 68, '2020-12-05 08:00:00', '2020-12-05 08:00:00'),
(679, 490, 69, '2020-12-05 08:10:00', '2020-12-05 18:00:00'),
(680, 491, 68, '2020-12-07 08:00:00', '2020-12-07 08:00:00'),
(681, 491, 69, '2020-12-07 08:10:00', '2020-12-07 18:00:00'),
(682, 492, 68, '2020-12-09 08:00:00', '2020-12-09 08:00:00'),
(683, 492, 69, '2020-12-09 08:10:00', '2020-12-09 18:00:00'),
(684, 493, 68, '2020-12-10 08:00:00', '2020-12-10 08:00:00'),
(685, 493, 69, '2020-12-10 08:10:00', '2020-12-10 18:00:00'),
(686, 494, 68, '2020-12-11 08:00:00', '2020-12-11 08:00:00'),
(687, 494, 69, '2020-12-11 08:10:00', '2020-12-11 18:00:00'),
(688, 495, 68, '2020-12-12 08:00:00', '2020-12-12 08:00:00'),
(689, 495, 69, '2020-12-12 08:10:00', '2020-12-12 18:00:00'),
(690, 496, 68, '2020-12-14 08:00:00', '2020-12-14 08:00:00'),
(691, 496, 69, '2020-12-14 08:10:00', '2020-12-14 18:00:00'),
(692, 497, 68, '2020-12-15 08:00:00', '2020-12-15 08:00:00'),
(693, 497, 69, '2020-12-15 08:10:00', '2020-12-15 18:00:00'),
(694, 498, 68, '2020-12-16 08:00:00', '2020-12-16 08:00:00'),
(695, 498, 69, '2020-12-16 08:10:00', '2020-12-16 18:00:00'),
(696, 499, 68, '2020-12-17 08:00:00', '2020-12-17 08:00:00'),
(697, 499, 69, '2020-12-17 08:10:00', '2020-12-17 18:00:00'),
(698, 500, 68, '2020-12-18 08:00:00', '2020-12-18 08:00:00'),
(699, 500, 69, '2020-12-18 08:10:00', '2020-12-18 18:00:00'),
(700, 501, 68, '2020-12-19 08:00:00', '2020-12-19 08:00:00'),
(701, 501, 69, '2020-12-19 08:10:00', '2020-12-19 18:00:00'),
(702, 502, 68, '2020-12-21 08:00:00', '2020-12-21 08:00:00'),
(703, 502, 69, '2020-12-21 08:10:00', '2020-12-21 18:00:00'),
(704, 504, 68, '2020-12-22 08:00:00', '2020-12-22 08:00:00'),
(705, 504, 69, '2020-12-22 08:10:00', '2020-12-22 18:00:00'),
(706, 505, 68, '2020-12-23 08:00:00', '2020-12-23 08:00:00'),
(707, 505, 69, '2020-12-23 08:10:00', '2020-12-23 18:00:00'),
(708, 506, 68, '2020-12-24 08:00:00', '2020-12-24 08:00:00'),
(709, 506, 69, '2020-12-24 08:10:00', '2020-12-24 18:00:00'),
(710, 507, 68, '2020-12-26 08:00:00', '2020-12-26 08:00:00'),
(711, 507, 69, '2020-12-26 08:10:00', '2020-12-26 18:00:00'),
(712, 508, 68, '2020-12-28 08:00:00', '2020-12-28 08:00:00'),
(713, 508, 69, '2020-12-28 08:10:00', '2020-12-28 18:00:00'),
(714, 509, 68, '2020-12-29 08:00:00', '2020-12-29 08:00:00'),
(715, 509, 69, '2020-12-29 08:10:00', '2020-12-29 18:00:00'),
(716, 510, 68, '2020-12-30 08:00:00', '2020-12-30 08:00:00'),
(717, 510, 69, '2020-12-30 08:10:00', '2020-12-30 18:00:00'),
(718, 511, 68, '2020-12-31 08:00:00', '2020-12-31 08:00:00'),
(719, 511, 69, '2020-12-31 08:10:00', '2020-12-31 18:00:00'),
(722, 513, 68, '2021-01-04 08:00:00', '2021-01-04 08:00:00'),
(723, 513, 69, '2021-01-04 08:10:00', '2021-01-04 18:00:00'),
(724, 514, 68, '2021-01-05 08:00:00', '2021-01-05 08:00:00'),
(725, 514, 69, '2021-01-05 08:10:00', '2021-01-05 18:00:00'),
(726, 515, 68, '2021-01-06 08:00:00', '2021-01-06 08:00:00'),
(727, 515, 69, '2021-01-06 08:10:00', '2021-01-06 18:00:00'),
(728, 516, 68, '2021-01-08 08:00:00', '2021-01-08 08:00:00'),
(729, 516, 69, '2021-01-08 08:10:00', '2021-01-08 18:00:00'),
(730, 517, 68, '2021-01-09 08:00:00', '2021-01-09 08:00:00'),
(731, 517, 69, '2021-01-09 08:10:00', '2021-01-09 18:00:00'),
(732, 518, 68, '2021-01-11 08:00:00', '2021-01-11 08:00:00'),
(733, 518, 69, '2021-01-11 08:10:00', '2021-01-11 18:00:00'),
(734, 519, 68, '2021-01-12 08:00:00', '2021-01-12 08:00:00'),
(735, 519, 69, '2021-01-12 08:10:00', '2021-01-12 18:00:00'),
(736, 520, 68, '2021-01-13 08:00:00', '2021-01-13 08:00:00'),
(737, 520, 69, '2021-01-13 08:10:00', '2021-01-13 18:00:00'),
(738, 521, 68, '2021-01-14 08:00:00', '2021-01-14 08:00:00'),
(739, 521, 69, '2021-01-14 08:10:00', '2021-01-14 18:00:00'),
(740, 522, 68, '2021-01-15 08:00:00', '2021-01-15 08:00:00'),
(741, 522, 69, '2021-01-15 08:10:00', '2021-01-15 18:00:00'),
(742, 523, 68, '2021-01-16 08:00:00', '2021-01-16 08:00:00'),
(743, 523, 69, '2021-01-16 08:10:00', '2021-01-16 18:00:00'),
(744, 524, 68, '2021-01-18 08:00:00', '2021-01-18 08:00:00'),
(745, 524, 69, '2021-01-18 08:10:00', '2021-01-18 18:00:00'),
(746, 525, 68, '2021-01-19 08:00:00', '2021-01-19 08:00:00'),
(747, 525, 69, '2021-01-19 08:10:00', '2021-01-19 18:00:00'),
(748, 526, 68, '2021-01-20 08:00:00', '2021-01-20 08:00:00'),
(749, 526, 69, '2021-01-20 08:10:00', '2021-01-20 18:00:00'),
(750, 527, 68, '2021-01-21 08:00:00', '2021-01-21 08:00:00'),
(751, 527, 69, '2021-01-21 08:10:00', '2021-01-21 18:00:00'),
(752, 528, 68, '2021-01-22 08:00:00', '2021-01-22 08:00:00'),
(753, 528, 69, '2021-01-22 08:10:00', '2021-01-22 18:00:00'),
(754, 529, 68, '2021-01-23 08:00:00', '2021-01-23 08:00:00'),
(755, 529, 69, '2021-01-23 08:10:00', '2021-01-23 18:00:00'),
(756, 512, 68, '2021-01-02 08:00:00', '2021-01-02 08:00:00'),
(757, 512, 69, '2021-01-02 08:10:00', '2021-01-02 18:00:00'),
(758, 530, 68, '2021-01-25 08:00:00', '2021-01-25 08:00:00'),
(759, 530, 69, '2021-01-25 08:10:00', '2021-01-25 18:00:00'),
(760, 531, 68, '2021-01-26 08:00:00', '2021-01-26 08:00:00'),
(761, 531, 69, '2021-01-26 08:10:00', '2021-01-26 18:00:00'),
(762, 532, 68, '2021-01-27 08:00:00', '2021-01-27 08:00:00'),
(763, 532, 69, '2021-01-27 08:10:00', '2021-01-27 18:00:00'),
(764, 533, 70, '2021-01-04 08:00:00', '2021-01-04 08:00:00'),
(765, 533, 71, '2021-01-04 12:00:00', '2021-01-04 18:00:00'),
(766, 534, 70, '2021-01-05 08:00:00', '2021-01-05 08:00:00'),
(767, 534, 71, '2021-01-05 12:00:00', '2021-01-05 18:00:00'),
(768, 535, 70, '2021-01-06 08:00:00', '2021-01-06 08:00:00'),
(769, 535, 71, '2021-01-06 12:00:00', '2021-01-06 18:00:00'),
(770, 536, 70, '2021-01-07 08:00:00', '2021-01-07 08:00:00'),
(771, 536, 71, '2021-01-07 12:00:00', '2021-01-07 18:00:00'),
(772, 537, 70, '2021-01-08 08:00:00', '2021-01-08 08:00:00'),
(773, 537, 71, '2021-01-08 12:00:00', '2021-01-08 18:00:00'),
(774, 538, 70, '2021-01-11 08:00:00', '2021-01-11 08:00:00'),
(775, 538, 71, '2021-01-11 12:00:00', '2021-01-11 18:00:00'),
(776, 539, 70, '2021-01-11 08:00:00', '2021-01-11 08:00:00'),
(777, 539, 71, '2021-01-11 12:00:00', '2021-01-11 18:00:00'),
(778, 540, 70, '2021-01-12 08:00:00', '2021-01-12 08:00:00'),
(779, 540, 71, '2021-01-12 12:00:00', '2021-01-12 18:00:00'),
(780, 541, 70, '2021-01-12 08:00:00', '2021-01-12 08:00:00'),
(781, 541, 71, '2021-01-12 12:00:00', '2021-01-12 18:00:00'),
(782, 542, 70, '2021-01-13 08:00:00', '2021-01-13 08:00:00'),
(783, 542, 71, '2021-01-13 12:00:00', '2021-01-13 18:00:00'),
(784, 543, 70, '2021-01-13 08:00:00', '2021-01-13 08:00:00'),
(785, 543, 71, '2021-01-13 12:00:00', '2021-01-13 18:00:00'),
(786, 544, 70, '2021-01-14 08:00:00', '2021-01-14 08:00:00'),
(787, 544, 71, '2021-01-14 12:00:00', '2021-01-14 18:00:00'),
(788, 545, 70, '2021-01-14 08:00:00', '2021-01-14 08:00:00'),
(789, 545, 71, '2021-01-14 12:00:00', '2021-01-14 18:00:00'),
(790, 546, 70, '2021-01-15 08:00:00', '2021-01-15 08:00:00'),
(791, 546, 71, '2021-01-15 12:00:00', '2021-01-15 18:00:00'),
(792, 547, 70, '2021-01-15 08:00:00', '2021-01-15 08:00:00'),
(793, 547, 71, '2021-01-15 12:00:00', '2021-01-15 18:00:00'),
(794, 548, 70, '2021-01-18 08:00:00', '2021-01-18 08:00:00'),
(795, 548, 71, '2021-01-18 12:00:00', '2021-01-18 18:00:00'),
(796, 549, 70, '2021-01-18 08:00:00', '2021-01-18 08:00:00'),
(797, 549, 71, '2021-01-18 12:00:00', '2021-01-18 18:00:00'),
(798, 550, 70, '2021-01-19 08:00:00', '2021-01-19 08:00:00'),
(799, 550, 71, '2021-01-19 12:00:00', '2021-01-19 18:00:00'),
(800, 551, 70, '2021-01-19 08:00:00', '2021-01-19 08:00:00'),
(801, 551, 71, '2021-01-19 12:00:00', '2021-01-19 18:00:00'),
(802, 552, 70, '2021-01-20 08:00:00', '2021-01-20 08:00:00'),
(803, 552, 71, '2021-01-20 12:00:00', '2021-01-20 18:00:00'),
(804, 554, 70, '2021-01-20 08:00:00', '2021-01-20 08:00:00'),
(805, 554, 71, '2021-01-20 12:00:00', '2021-01-20 18:00:00'),
(806, 555, 70, '2021-01-21 08:00:00', '2021-01-21 08:00:00'),
(807, 556, 70, '2021-01-21 08:00:00', '2021-01-21 08:00:00'),
(808, 556, 71, '2021-01-21 12:00:00', '2021-01-21 18:00:00'),
(809, 555, 71, '2021-01-21 12:00:00', '2021-01-21 18:00:00'),
(810, 557, 70, '2021-01-22 08:00:00', '2021-01-22 08:00:00'),
(811, 557, 71, '2021-01-22 12:00:00', '2021-01-22 18:00:00'),
(812, 558, 70, '2021-01-22 08:00:00', '2021-01-22 08:00:00'),
(813, 558, 71, '2021-01-22 12:00:00', '2021-01-22 18:00:00'),
(814, 559, 70, '2021-01-25 08:00:00', '2021-01-25 08:00:00'),
(815, 559, 71, '2021-01-25 12:00:00', '2021-01-25 18:00:00'),
(816, 560, 70, '2021-01-25 08:00:00', '2021-01-25 08:00:00'),
(817, 560, 71, '2021-01-25 12:00:00', '2021-01-25 18:00:00'),
(818, 561, 70, '2021-01-26 08:00:00', '2021-01-26 08:00:00'),
(819, 561, 71, '2021-01-26 12:00:00', '2021-01-26 18:00:00'),
(820, 562, 70, '2021-01-26 08:00:00', '2021-01-26 08:00:00'),
(821, 562, 71, '2021-01-26 12:00:00', '2021-01-26 18:00:00'),
(822, 563, 70, '2021-01-27 08:00:00', '2021-01-27 08:00:00'),
(823, 563, 71, '2021-01-27 12:00:00', '2021-01-27 18:00:00'),
(824, 564, 70, '2021-01-27 08:00:00', '2021-01-27 08:00:00'),
(825, 564, 71, '2021-01-27 12:00:00', '2021-01-27 18:00:00'),
(826, 565, 70, '2021-01-28 08:00:00', '2021-01-28 08:00:00'),
(827, 565, 71, '2021-01-28 12:00:00', '2021-01-28 18:00:00'),
(828, 566, 70, '2021-01-28 08:00:00', '2021-01-28 08:00:00'),
(829, 566, 71, '2021-01-28 12:00:00', '2021-01-28 18:00:00'),
(830, 567, 70, '2021-01-29 08:00:00', '2021-01-29 08:00:00'),
(831, 567, 71, '2021-01-29 12:00:00', '2021-01-29 18:00:00'),
(832, 568, 70, '2021-01-29 08:00:00', '2021-01-29 08:00:00'),
(833, 568, 71, '2021-01-29 12:00:00', '2021-01-29 18:00:00'),
(834, 569, 68, '2021-01-28 08:00:00', '2021-01-28 08:00:00'),
(835, 569, 69, '2021-01-28 08:10:00', '2021-01-28 18:00:00'),
(836, 571, 68, '2021-01-29 08:00:00', '2021-01-29 08:00:00'),
(837, 571, 69, '2021-01-29 08:10:00', '2021-01-29 18:00:00'),
(838, 572, 68, '2021-01-30 08:00:00', '2021-01-30 08:00:00');
INSERT INTO `tg_hitocontrolado` (`HICO_NCORR`, `SERV_NCORR`, `HITO_NCORR`, `HICO_HORAPLAN`, `HICO_HORAREAL`) VALUES
(839, 572, 69, '2021-01-30 08:10:00', '2021-01-30 18:00:00'),
(840, 573, 68, '2021-01-02 09:00:00', '2021-01-02 09:00:00'),
(841, 573, 69, '2021-01-02 09:10:00', '2021-01-02 16:00:00'),
(842, 574, 68, '2021-01-03 09:00:00', '2021-01-03 09:00:00'),
(843, 574, 69, '2021-01-03 09:10:00', '2021-01-03 16:00:00'),
(844, 575, 68, '2021-01-04 08:00:00', '2021-01-04 08:00:00'),
(845, 575, 69, '2021-01-04 08:10:00', '2021-01-04 18:00:00'),
(846, 576, 68, '2021-01-04 08:00:00', '2021-01-04 08:00:00'),
(847, 576, 69, '2021-01-04 08:10:00', '2021-01-04 18:00:00'),
(848, 577, 68, '2021-01-05 08:00:00', '2021-01-05 08:00:00'),
(849, 577, 69, '2021-01-05 08:10:00', '2021-01-05 18:00:00'),
(850, 578, 68, '2021-01-05 08:00:00', '2021-01-05 08:00:00'),
(851, 578, 69, '2021-01-05 08:10:00', '2021-01-05 18:00:00'),
(852, 580, 68, '2021-01-06 08:00:00', '2021-01-06 08:00:00'),
(853, 580, 69, '2021-01-06 08:10:00', '2021-01-06 18:00:00'),
(854, 579, 68, '2021-01-06 08:00:00', '2021-01-06 08:00:00'),
(855, 579, 69, '2021-01-06 08:10:00', '2021-01-06 18:00:00'),
(856, 581, 68, '2021-01-07 08:00:00', '2021-01-07 08:00:00'),
(857, 581, 69, '2021-01-07 08:10:00', '2021-01-07 18:00:00'),
(858, 582, 68, '2021-01-07 08:00:00', '2021-01-07 08:00:00'),
(859, 582, 69, '2021-01-07 08:10:00', '2021-01-07 18:00:00'),
(860, 583, 68, '2021-01-08 08:00:00', '2021-01-08 08:00:00'),
(861, 583, 69, '2021-01-08 08:10:00', '2021-01-08 18:00:00'),
(862, 584, 68, '2021-01-08 08:00:00', '2021-01-08 08:00:00'),
(863, 584, 69, '2021-01-08 08:10:00', '2021-01-08 18:00:00'),
(864, 585, 68, '2021-01-09 09:00:00', '2021-01-09 09:00:00'),
(865, 585, 69, '2021-01-09 09:10:00', '2021-01-09 16:00:00'),
(866, 586, 68, '2021-01-10 09:00:00', '2021-01-10 09:00:00'),
(867, 586, 69, '2021-01-10 09:10:00', '2021-01-10 16:00:00'),
(868, 588, 68, '2021-01-11 08:00:00', '2021-01-11 08:00:00'),
(869, 588, 69, '2021-01-11 08:10:00', '2021-01-11 18:00:00'),
(870, 587, 68, '2021-01-11 08:00:00', '2021-01-11 08:00:00'),
(871, 587, 69, '2021-01-11 08:10:00', '2021-01-11 18:00:00'),
(872, 590, 68, '2021-01-12 08:00:00', '2021-01-12 08:00:00'),
(873, 590, 69, '2021-01-12 08:10:00', '2021-01-12 18:00:00'),
(874, 589, 68, '2021-01-12 08:00:00', '2021-01-12 08:00:00'),
(875, 589, 69, '2021-01-12 08:10:00', '2021-01-12 18:00:00'),
(876, 592, 68, '2021-01-13 08:00:00', '2021-01-13 08:00:00'),
(877, 592, 69, '2021-01-13 08:10:00', '2021-01-13 18:00:00'),
(878, 591, 68, '2021-01-13 08:00:00', '2021-01-13 08:00:00'),
(879, 591, 69, '2021-01-13 08:10:00', '2021-01-13 18:00:00'),
(880, 594, 68, '2021-01-14 08:00:00', '2021-01-14 08:00:00'),
(881, 594, 69, '2021-01-14 08:10:00', '2021-01-14 18:00:00'),
(882, 593, 68, '2021-01-14 08:00:00', '2021-01-14 08:00:00'),
(883, 593, 69, '2021-01-14 08:10:00', '2021-01-14 18:00:00'),
(884, 596, 68, '2021-01-15 08:00:00', '2021-01-15 08:00:00'),
(885, 596, 69, '2021-01-15 08:10:00', '2021-01-15 18:00:00'),
(886, 595, 68, '2021-01-15 08:00:00', '2021-01-15 08:00:00'),
(887, 595, 69, '2021-01-15 08:10:00', '2021-01-15 18:00:00'),
(888, 597, 68, '2021-01-16 09:00:00', '2021-01-16 08:00:00'),
(889, 597, 69, '2021-01-16 09:10:00', '2021-01-16 18:00:00'),
(890, 598, 68, '2021-01-17 09:00:00', '2021-01-17 08:00:00'),
(891, 598, 69, '2021-01-17 09:10:00', '2021-01-17 18:00:00'),
(892, 600, 68, '2021-01-18 08:00:00', '2021-01-18 08:00:00'),
(893, 600, 69, '2021-01-18 08:10:00', '2021-01-18 18:00:00'),
(894, 599, 68, '2021-01-18 08:00:00', '2021-01-18 08:00:00'),
(895, 599, 69, '2021-01-18 08:10:00', '2021-01-18 18:00:00'),
(896, 601, 68, '2021-01-19 08:00:00', '2021-01-19 08:00:00'),
(897, 601, 69, '2021-01-19 08:10:00', '2021-01-19 18:00:00'),
(898, 602, 68, '2021-01-19 08:00:00', '2021-01-19 08:00:00'),
(899, 602, 69, '2021-01-19 08:10:00', '2021-01-19 18:00:00'),
(900, 603, 68, '2021-01-20 08:00:00', '2021-01-20 08:00:00'),
(901, 603, 69, '2021-01-20 08:10:00', '2021-01-20 18:00:00'),
(902, 604, 68, '2021-01-20 08:00:00', '2021-01-20 08:00:00'),
(903, 604, 69, '2021-01-20 08:10:00', '2021-01-20 18:00:00'),
(904, 605, 68, '2021-01-21 08:00:00', '2021-01-21 08:00:00'),
(905, 605, 69, '2021-01-21 08:10:00', '2021-01-21 18:00:00'),
(906, 606, 68, '2021-01-21 08:00:00', '2021-01-21 08:00:00'),
(907, 606, 69, '2021-01-21 08:10:00', '2021-01-21 18:00:00'),
(908, 607, 68, '2021-01-22 08:00:00', '2021-01-22 08:00:00'),
(909, 607, 69, '2021-01-22 08:10:00', '2021-01-22 18:00:00'),
(910, 608, 68, '2021-01-22 08:00:00', '2021-01-22 08:00:00'),
(911, 608, 69, '2021-01-22 08:10:00', '2021-01-22 18:00:00'),
(912, 609, 68, '2021-01-23 09:00:00', '2021-01-23 09:00:00'),
(913, 609, 69, '2021-01-23 09:10:00', '2021-01-23 16:00:00'),
(914, 610, 68, '2021-01-24 09:00:00', '2021-01-24 09:00:00'),
(915, 610, 69, '2021-01-24 09:10:00', '2021-01-24 16:00:00'),
(916, 611, 68, '2021-01-25 08:00:00', '2021-01-25 08:00:00'),
(917, 611, 69, '2021-01-25 08:10:00', '2021-01-25 18:00:00'),
(918, 612, 68, '2021-01-25 08:00:00', '2021-01-25 08:00:00'),
(919, 612, 69, '2021-01-25 08:10:00', '2021-01-25 18:00:00'),
(920, 613, 68, '2021-01-26 08:00:00', '2021-01-26 08:00:00'),
(921, 613, 69, '2021-01-26 08:10:00', '2021-01-26 18:00:00'),
(922, 614, 68, '2021-01-26 08:00:00', '2021-01-26 08:00:00'),
(923, 614, 69, '2021-01-26 08:10:00', '2021-01-26 18:00:00'),
(924, 615, 68, '2021-01-27 08:00:00', '2021-01-27 08:00:00'),
(925, 615, 69, '2021-01-27 08:10:00', '2021-01-27 18:00:00'),
(926, 616, 68, '2021-01-27 08:00:00', '2021-01-27 08:00:00'),
(927, 616, 69, '2021-01-27 08:10:00', '2021-01-27 18:00:00'),
(928, 617, 68, '2021-01-28 08:00:00', '2021-01-28 08:00:00'),
(929, 617, 69, '2021-01-28 08:10:00', '2021-01-28 18:00:00'),
(930, 618, 68, '2021-01-28 08:00:00', '2021-01-28 08:00:00'),
(931, 618, 69, '2021-01-28 08:10:00', '2021-01-28 18:00:00'),
(932, 619, 68, '2021-01-29 08:00:00', '2021-01-29 08:00:00'),
(933, 619, 69, '2021-01-29 08:10:00', '2021-01-29 18:00:00'),
(934, 620, 68, '2021-01-29 08:00:00', '2021-01-29 08:00:00'),
(935, 620, 69, '2021-01-29 08:10:00', '2021-01-29 18:00:00'),
(936, 621, 68, '2021-01-30 09:00:00', '2021-01-30 09:00:00'),
(937, 621, 69, '2021-01-30 09:10:00', '2021-01-30 16:00:00'),
(938, 622, 68, '2021-01-31 09:00:00', '2021-01-31 09:00:00'),
(939, 622, 69, '2021-01-31 09:10:00', '2021-01-31 16:00:00'),
(940, 623, 72, '2020-11-16 08:00:00', '2020-11-16 08:00:00'),
(941, 623, 73, '2020-11-16 12:00:00', '2020-11-16 18:00:00'),
(942, 624, 72, '2020-11-16 08:00:00', '2020-11-16 08:00:00'),
(943, 624, 73, '2020-11-16 12:00:00', '2020-11-16 18:00:00'),
(944, 625, 72, '2020-11-17 08:00:00', '2020-11-17 08:00:00'),
(945, 625, 73, '2020-11-17 12:00:00', '2020-11-17 18:00:00'),
(946, 626, 72, '2020-11-17 08:00:00', '2020-11-17 08:00:00'),
(947, 626, 73, '2020-11-17 12:00:00', '2020-11-17 18:00:00'),
(948, 627, 72, '2020-11-18 08:00:00', '2020-11-18 08:00:00'),
(949, 627, 73, '2020-11-18 12:00:00', '2020-11-18 18:00:00'),
(950, 628, 72, '2020-11-18 08:00:00', '2020-11-18 08:00:00'),
(951, 628, 73, '2020-11-18 12:00:00', '2020-11-18 18:00:00'),
(952, 629, 72, '2020-12-07 08:00:00', '2020-12-07 08:00:00'),
(953, 629, 73, '2020-12-07 12:00:00', '2020-12-07 18:00:00'),
(954, 630, 72, '2020-12-16 08:00:00', '2020-12-16 08:00:00'),
(955, 630, 73, '2020-12-16 12:00:00', '2020-12-16 18:00:00'),
(956, 631, 72, '2020-12-16 08:00:00', '2020-12-16 08:00:00'),
(957, 631, 73, '2020-12-16 12:00:00', '2020-12-16 18:00:00'),
(958, 632, 72, '2020-12-17 08:00:00', '2020-12-17 08:00:00'),
(959, 632, 73, '2020-12-17 12:00:00', '2020-12-17 18:00:00'),
(960, 633, 72, '2020-12-17 08:00:00', '2020-12-17 08:00:00'),
(961, 633, 73, '2020-12-17 12:00:00', '2020-12-17 18:00:00'),
(962, 634, 72, '2020-12-18 08:00:00', '2020-12-18 08:00:00'),
(963, 634, 73, '2020-12-18 12:00:00', '2020-12-18 18:00:00'),
(964, 635, 72, '2020-12-18 08:00:00', '2020-12-18 08:00:00'),
(965, 635, 73, '2020-12-18 12:00:00', '2020-12-18 18:00:00'),
(966, 636, 72, '2020-12-21 08:00:00', '2020-12-21 08:00:00'),
(967, 636, 73, '2020-12-21 12:00:00', '2020-12-21 18:00:00'),
(968, 637, 72, '2020-12-21 08:00:00', '2020-12-21 08:00:00'),
(969, 637, 73, '2020-12-21 12:00:00', '2020-12-21 18:00:00'),
(970, 638, 72, '2020-12-21 08:00:00', '2020-12-21 08:00:00'),
(971, 638, 73, '2020-12-21 12:00:00', '2020-12-21 18:00:00'),
(972, 639, 72, '2020-12-22 08:00:00', '2020-12-22 08:00:00'),
(973, 639, 73, '2020-12-22 12:00:00', '2020-12-22 18:00:00'),
(974, 640, 72, '2020-12-22 08:00:00', '2020-12-22 08:00:00'),
(975, 640, 73, '2020-12-22 12:00:00', '2020-12-22 18:00:00'),
(976, 641, 72, '2020-12-22 08:00:00', '2020-12-22 08:00:00'),
(977, 641, 73, '2020-12-22 12:00:00', '2020-12-22 18:00:00'),
(978, 642, 72, '2020-12-22 08:00:00', '2020-12-22 08:00:00'),
(979, 642, 73, '2020-12-22 12:00:00', '2020-12-22 18:00:00'),
(980, 645, 74, '2021-01-06 04:00:00', '2021-01-08 06:00:00'),
(981, 645, 75, '2021-01-09 03:00:00', '2021-01-18 06:00:00'),
(982, 645, 82, '2021-01-09 04:39:00', '2021-01-27 18:00:00'),
(983, 643, 74, '2021-01-09 04:00:00', '2021-01-08 06:00:00'),
(984, 643, 75, '2021-01-12 03:00:00', '2021-01-22 06:00:00'),
(985, 643, 82, '2021-01-12 04:39:00', '2021-01-27 18:00:00'),
(986, 644, 74, '2021-01-09 04:00:00', '2021-01-05 06:00:00'),
(987, 644, 75, '2021-01-12 03:00:00', '2021-01-12 06:00:00'),
(988, 644, 82, '2021-01-12 04:39:00', '2021-01-19 18:00:00'),
(989, 646, 84, '2021-01-09 04:00:00', '2021-01-08 06:00:00'),
(990, 646, 87, '2021-01-12 03:00:00', '2021-01-18 06:00:00'),
(991, 646, 88, '2021-01-12 04:39:00', '2021-01-27 18:00:00'),
(992, 647, 84, '2021-02-16 04:00:00', '2021-02-15 06:00:00'),
(993, 647, 87, '2021-02-19 03:00:00', '2021-01-23 06:00:00'),
(994, 647, 88, '2021-02-19 04:39:00', '2021-03-03 18:00:00'),
(995, 648, 84, '2021-02-16 04:00:00', '2021-02-17 06:00:00'),
(996, 648, 87, '2021-02-19 03:00:00', '2021-02-23 06:00:00'),
(997, 648, 88, '2021-02-19 04:39:00', '2021-03-03 18:00:00'),
(998, 649, 70, '2021-02-01 08:00:00', '2021-02-01 08:00:00'),
(999, 649, 71, '2021-02-01 12:00:00', '2021-02-01 18:00:00'),
(1000, 650, 70, '2021-02-01 08:00:00', '2021-02-01 08:00:00'),
(1001, 650, 71, '2021-02-01 12:00:00', '2021-02-01 18:00:00'),
(1002, 651, 70, '2021-02-02 08:00:00', '2021-02-02 08:00:00'),
(1003, 651, 71, '2021-02-02 12:00:00', '2021-02-02 18:00:00'),
(1004, 652, 70, '2021-02-02 08:00:00', '2021-02-02 08:00:00'),
(1005, 652, 71, '2021-02-02 12:00:00', '2021-02-02 18:00:00'),
(1006, 653, 70, '2021-02-03 08:00:00', '2021-02-03 08:00:00'),
(1007, 653, 71, '2021-02-03 12:00:00', '2021-02-03 18:00:00'),
(1008, 654, 70, '2021-02-03 08:00:00', '2021-02-03 08:00:00'),
(1009, 654, 71, '2021-02-03 12:00:00', '2021-02-03 18:00:00'),
(1010, 655, 70, '2021-02-04 08:00:00', '2021-02-04 08:00:00'),
(1011, 655, 71, '2021-02-04 12:00:00', '2021-02-04 18:00:00'),
(1012, 656, 70, '2021-02-04 08:00:00', '2021-02-04 08:00:00'),
(1013, 656, 71, '2021-02-04 12:00:00', '2021-02-04 18:00:00'),
(1014, 657, 70, '2021-02-05 08:00:00', '2021-02-05 08:00:00'),
(1015, 657, 71, '2021-02-05 12:00:00', '2021-02-05 18:00:00'),
(1016, 658, 70, '2021-02-05 08:00:00', '2021-02-05 08:00:00'),
(1017, 658, 71, '2021-02-05 12:00:00', '2021-02-05 18:00:00'),
(1018, 659, 70, '2021-02-08 08:00:00', '2021-02-08 08:00:00'),
(1019, 659, 71, '2021-02-08 12:00:00', '2021-02-08 18:00:00'),
(1020, 660, 70, '2021-02-08 08:00:00', '2021-02-08 08:00:00'),
(1021, 660, 71, '2021-02-08 12:00:00', '2021-02-08 18:00:00'),
(1022, 661, 70, '2021-02-09 08:00:00', '2021-02-09 08:00:00'),
(1023, 661, 71, '2021-02-09 12:00:00', '2021-02-09 18:00:00'),
(1024, 662, 70, '2021-02-09 08:00:00', '2021-02-09 08:00:00'),
(1025, 662, 71, '2021-02-09 12:00:00', '2021-02-09 18:00:00'),
(1026, 663, 70, '2021-02-10 08:00:00', '2021-02-10 08:00:00'),
(1027, 663, 71, '2021-02-10 12:00:00', '2021-02-10 18:00:00'),
(1028, 664, 70, '2021-02-10 08:00:00', '2021-02-10 08:00:00'),
(1029, 664, 71, '2021-02-10 12:00:00', '2021-02-10 18:00:00'),
(1030, 665, 70, '2021-02-11 08:00:00', '2021-02-11 08:00:00'),
(1031, 665, 71, '2021-02-11 12:00:00', '2021-02-11 18:00:00'),
(1032, 666, 70, '2021-02-11 08:00:00', '2021-02-11 08:00:00'),
(1033, 666, 71, '2021-02-11 12:00:00', '2021-02-11 18:00:00'),
(1034, 667, 70, '2021-02-12 08:00:00', '2021-02-12 08:00:00'),
(1035, 667, 71, '2021-02-12 12:00:00', '2021-02-12 18:00:00'),
(1036, 668, 70, '2021-02-12 08:00:00', '2021-02-12 08:00:00'),
(1037, 668, 71, '2021-02-12 12:00:00', '2021-02-12 18:00:00'),
(1038, 669, 70, '2021-02-15 08:00:00', '2021-02-15 08:00:00'),
(1039, 669, 71, '2021-02-15 12:00:00', '2021-02-15 18:00:00'),
(1040, 670, 70, '2021-02-15 08:00:00', '2021-02-15 08:00:00'),
(1041, 670, 71, '2021-02-15 12:00:00', '2021-02-15 18:00:00'),
(1042, 671, 70, '2021-02-16 08:00:00', '2021-02-16 08:00:00'),
(1043, 671, 71, '2021-02-16 12:00:00', '2021-02-16 18:00:00'),
(1044, 672, 70, '2021-02-16 08:00:00', '2021-02-16 08:00:00'),
(1045, 672, 71, '2021-02-16 12:00:00', '2021-02-16 18:00:00'),
(1046, 673, 70, '2021-02-17 08:00:00', '2021-02-17 08:00:00'),
(1047, 673, 71, '2021-02-17 12:00:00', '2021-02-17 18:00:00'),
(1048, 674, 70, '2021-02-17 08:00:00', '2021-02-17 08:00:00'),
(1049, 674, 71, '2021-02-17 12:00:00', '2021-02-17 18:00:00'),
(1050, 675, 70, '2021-02-18 08:00:00', '2021-02-18 08:00:00'),
(1051, 675, 71, '2021-02-18 12:00:00', '2021-02-18 18:00:00'),
(1052, 676, 70, '2021-02-18 08:00:00', '2021-02-18 08:00:00'),
(1053, 676, 71, '2021-02-18 12:00:00', '2021-02-18 18:00:00'),
(1054, 677, 70, '2021-02-19 08:00:00', '2021-02-19 08:00:00'),
(1055, 677, 71, '2021-02-19 12:00:00', '2021-02-19 18:00:00'),
(1056, 678, 70, '2021-02-19 08:00:00', '2021-02-19 08:00:00'),
(1057, 678, 71, '2021-02-19 12:00:00', '2021-02-19 18:00:00'),
(1058, 679, 70, '2021-02-22 08:00:00', '2021-02-22 08:00:00'),
(1059, 679, 71, '2021-02-22 12:00:00', '2021-02-22 18:00:00'),
(1060, 680, 70, '2021-02-22 08:00:00', '2021-02-22 08:00:00'),
(1061, 680, 71, '2021-02-22 12:00:00', '2021-02-22 18:00:00'),
(1062, 681, 70, '2021-02-23 08:00:00', '2021-02-23 08:00:00'),
(1063, 681, 71, '2021-02-23 12:00:00', '2021-02-23 18:00:00'),
(1064, 682, 70, '2021-02-23 08:00:00', '2021-02-23 08:00:00'),
(1065, 682, 71, '2021-02-23 12:00:00', '2021-02-23 18:00:00'),
(1066, 683, 70, '2021-02-24 08:00:00', '2021-02-24 08:00:00'),
(1067, 683, 71, '2021-02-24 12:00:00', '2021-02-24 18:00:00'),
(1068, 684, 70, '2021-02-24 08:00:00', '2021-02-24 08:00:00'),
(1069, 684, 71, '2021-02-24 12:00:00', '2021-02-24 18:00:00'),
(1070, 685, 70, '2021-02-25 08:00:00', '2021-02-25 08:00:00'),
(1071, 685, 71, '2021-02-25 12:00:00', '2021-02-25 18:00:00'),
(1072, 686, 70, '2021-02-25 08:00:00', '2021-02-25 08:00:00'),
(1073, 686, 71, '2021-02-25 12:00:00', '2021-02-25 18:00:00'),
(1074, 687, 70, '2021-02-26 08:00:00', '2021-02-26 08:00:00'),
(1075, 687, 71, '2021-02-26 12:00:00', '2021-02-26 18:00:00'),
(1076, 688, 70, '2021-02-26 08:00:00', '2021-02-26 08:00:00'),
(1077, 688, 71, '2021-02-26 12:00:00', '2021-02-26 18:00:00'),
(1078, 689, 70, '2021-03-01 08:00:00', '2021-03-01 08:00:00'),
(1079, 689, 71, '2021-03-01 12:00:00', '2021-03-01 18:00:00'),
(1080, 690, 70, '2021-03-01 08:00:00', '2021-03-01 08:00:00'),
(1081, 690, 71, '2021-03-01 12:00:00', '2021-03-01 18:00:00'),
(1082, 691, 70, '2021-03-02 08:00:00', '2021-03-02 08:00:00'),
(1083, 691, 71, '2021-03-02 12:00:00', '2021-03-02 18:00:00'),
(1084, 693, 70, '2021-03-02 08:00:00', '2021-03-02 08:00:00'),
(1085, 693, 71, '2021-03-02 12:00:00', '2021-03-02 18:00:00'),
(1086, 694, 70, '2021-03-03 08:00:00', '2021-03-03 08:00:00'),
(1087, 694, 71, '2021-03-03 12:00:00', '2021-03-03 18:00:00'),
(1088, 695, 70, '2021-03-03 08:00:00', '2021-03-03 08:00:00'),
(1089, 695, 71, '2021-03-03 12:00:00', '2021-03-03 18:00:00'),
(1090, 697, 70, '2021-03-04 08:00:00', '2021-03-04 08:00:00'),
(1091, 697, 71, '2021-03-04 12:00:00', '2021-03-04 18:00:00'),
(1092, 698, 70, '2021-03-04 08:00:00', '2021-03-04 08:00:00'),
(1093, 698, 71, '2021-03-04 12:00:00', '2021-03-04 18:00:00'),
(1094, 699, 70, '2021-03-05 08:00:00', '2021-03-05 08:00:00'),
(1095, 699, 71, '2021-03-05 12:00:00', '2021-03-05 18:00:00'),
(1096, 700, 70, '2021-03-05 08:00:00', '2021-03-05 08:00:00'),
(1097, 700, 71, '2021-03-05 12:00:00', '2021-03-05 18:00:00'),
(1098, 701, 70, '2021-03-08 08:00:00', '2021-03-08 08:00:00'),
(1099, 701, 71, '2021-03-08 12:00:00', '2021-03-08 18:00:00'),
(1100, 702, 70, '2021-03-08 08:00:00', '2021-03-08 08:00:00'),
(1101, 702, 71, '2021-03-08 12:00:00', '2021-03-08 18:00:00'),
(1102, 703, 70, '2021-03-09 08:00:00', '2021-03-09 08:00:00'),
(1103, 703, 71, '2021-03-09 12:00:00', '2021-03-09 18:00:00'),
(1104, 704, 70, '2021-03-09 08:00:00', '2021-03-09 08:00:00'),
(1105, 704, 71, '2021-03-09 12:00:00', '2021-03-09 18:00:00'),
(1106, 705, 70, '2021-03-10 08:00:00', '2021-03-10 08:00:00'),
(1107, 705, 71, '2021-03-10 12:00:00', '2021-03-10 18:00:00'),
(1108, 706, 70, '2021-03-10 08:00:00', '2021-03-10 08:00:00'),
(1109, 706, 71, '2021-03-10 12:00:00', '2021-03-10 18:00:00'),
(1110, 707, 70, '2021-03-11 08:00:00', '2021-03-11 08:00:00'),
(1111, 707, 71, '2021-03-11 12:00:00', '2021-03-11 18:00:00'),
(1112, 708, 70, '2021-03-11 08:00:00', '2021-03-11 08:00:00'),
(1113, 708, 71, '2021-03-11 12:00:00', '2021-03-11 18:00:00'),
(1114, 709, 70, '2021-03-12 08:00:00', '2021-03-12 08:00:00'),
(1115, 709, 71, '2021-03-12 12:00:00', '2021-03-12 18:00:00'),
(1116, 710, 70, '2021-03-12 08:00:00', '2021-03-12 08:00:00'),
(1117, 710, 71, '2021-03-12 12:00:00', '2021-03-12 18:00:00'),
(1118, 711, 70, '2021-03-15 08:00:00', '2021-03-15 08:00:00'),
(1119, 711, 71, '2021-03-15 12:00:00', '2021-03-15 18:00:00'),
(1120, 712, 70, '2021-03-15 08:00:00', '2021-03-15 08:00:00'),
(1121, 712, 71, '2021-03-15 12:00:00', '2021-03-15 18:00:00'),
(1122, 713, 70, '2021-03-16 08:00:00', '2021-03-16 08:00:00'),
(1123, 713, 71, '2021-03-16 12:00:00', '2021-03-16 18:00:00'),
(1124, 714, 70, '2021-03-16 08:00:00', '2021-03-16 08:00:00'),
(1125, 714, 71, '2021-03-16 12:00:00', '2021-03-16 18:00:00'),
(1126, 715, 70, '2021-03-17 08:00:00', '2021-03-17 08:00:00'),
(1127, 715, 71, '2021-03-17 12:00:00', '2021-03-17 18:00:00'),
(1128, 716, 70, '2021-03-17 08:00:00', '2021-03-17 08:00:00'),
(1129, 716, 71, '2021-03-17 12:00:00', '2021-03-17 18:00:00'),
(1130, 717, 70, '2021-03-18 08:00:00', '2021-03-18 08:00:00'),
(1131, 717, 71, '2021-03-18 12:00:00', '2021-03-18 18:00:00'),
(1132, 718, 70, '2021-03-18 08:00:00', '2021-03-18 08:00:00'),
(1133, 718, 71, '2021-03-18 12:00:00', '2021-03-18 18:00:00'),
(1134, 719, 70, '2021-03-19 08:00:00', '2021-03-19 08:00:00'),
(1135, 719, 71, '2021-03-19 12:00:00', '2021-03-19 18:00:00'),
(1136, 720, 70, '2021-03-19 08:00:00', '2021-03-19 08:00:00'),
(1137, 720, 71, '2021-03-19 12:00:00', '2021-03-19 18:00:00'),
(1138, 721, 70, '2021-03-22 08:00:00', '2021-03-22 08:00:00'),
(1139, 721, 71, '2021-03-22 12:00:00', '2021-03-22 18:00:00'),
(1140, 722, 70, '2021-03-22 08:00:00', '2021-03-22 08:00:00'),
(1141, 722, 71, '2021-03-22 12:00:00', '2021-03-22 18:00:00'),
(1142, 723, 70, '2021-03-23 08:00:00', '2021-03-23 08:00:00'),
(1143, 723, 71, '2021-03-23 12:00:00', '2021-03-23 18:00:00'),
(1144, 724, 70, '2021-03-23 08:00:00', '2021-03-23 08:00:00'),
(1145, 724, 71, '2021-03-23 12:00:00', '2021-03-23 18:00:00'),
(1146, 725, 70, '2021-03-24 08:00:00', '2021-03-24 08:00:00'),
(1147, 725, 71, '2021-03-24 12:00:00', '2021-03-24 18:00:00'),
(1148, 726, 70, '2021-03-24 08:00:00', '2021-03-24 08:00:00'),
(1149, 726, 71, '2021-03-24 12:00:00', '2021-03-24 18:00:00'),
(1150, 727, 70, '2021-03-25 08:00:00', '2021-03-25 08:00:00'),
(1151, 727, 71, '2021-03-25 12:00:00', '2021-03-25 18:00:00'),
(1152, 728, 70, '2021-03-25 08:00:00', '2021-03-25 08:00:00'),
(1153, 728, 71, '2021-03-25 12:00:00', '2021-03-25 18:00:00'),
(1154, 729, 70, '2021-03-26 08:00:00', '2021-03-26 08:00:00'),
(1155, 729, 71, '2021-03-26 12:00:00', '2021-03-26 18:00:00'),
(1156, 730, 70, '2021-03-26 08:00:00', '2021-03-26 08:00:00'),
(1157, 730, 71, '2021-03-26 12:00:00', '2021-03-26 18:00:00'),
(1158, 731, 70, '2021-03-29 08:00:00', '2021-03-29 08:00:00'),
(1159, 731, 71, '2021-03-29 12:00:00', '2021-03-29 18:00:00'),
(1160, 732, 70, '2021-03-29 08:00:00', '2021-03-29 08:00:00'),
(1161, 732, 71, '2021-03-29 12:00:00', '2021-03-29 18:00:00'),
(1162, 733, 70, '2021-03-30 08:00:00', '2021-03-30 08:00:00'),
(1163, 733, 71, '2021-03-30 12:00:00', '2021-03-30 18:00:00'),
(1164, 734, 70, '2021-03-30 08:00:00', '2021-03-30 08:00:00'),
(1165, 734, 71, '2021-03-30 12:00:00', '2021-03-30 18:00:00'),
(1166, 735, 70, '2021-03-31 08:00:00', '2021-03-31 08:00:00'),
(1167, 735, 71, '2021-03-31 12:00:00', '2021-03-31 18:00:00'),
(1168, 736, 70, '2021-03-31 08:00:00', '2021-03-31 08:00:00'),
(1169, 736, 71, '2021-03-31 12:00:00', '2021-03-31 18:00:00'),
(1170, 737, 68, '2021-02-01 05:00:00', '2021-02-01 05:00:00'),
(1171, 737, 69, '2021-02-01 05:10:00', '2021-02-01 13:00:00'),
(1172, 738, 68, '2021-02-01 08:00:00', '2021-02-01 08:00:00'),
(1173, 738, 69, '2021-02-01 08:10:00', '2021-02-01 21:00:00'),
(1174, 740, 68, '2021-02-01 08:00:00', '2021-02-01 08:00:00'),
(1175, 740, 69, '2021-02-01 08:10:00', '2021-02-01 18:00:00'),
(1176, 741, 68, '2021-02-02 05:00:00', '2021-02-02 05:00:00'),
(1177, 741, 69, '2021-02-02 05:10:00', '2021-02-02 13:00:00'),
(1178, 742, 68, '2021-02-02 08:00:00', '2021-02-02 08:00:00'),
(1179, 742, 69, '2021-02-02 08:10:00', '2021-02-02 21:00:00'),
(1180, 743, 68, '2021-02-02 08:00:00', '2021-02-02 08:00:00'),
(1181, 743, 69, '2021-02-02 08:10:00', '2021-02-02 18:00:00'),
(1182, 744, 68, '2021-02-03 05:00:00', '2021-02-03 05:00:00'),
(1183, 744, 69, '2021-02-03 05:10:00', '2021-03-03 13:00:00'),
(1184, 745, 68, '2021-02-03 08:00:00', '2021-02-03 08:00:00'),
(1185, 745, 69, '2021-02-03 08:10:00', '2021-02-03 21:00:00'),
(1186, 746, 68, '2021-02-03 08:00:00', '2021-02-03 08:00:00'),
(1187, 746, 69, '2021-02-03 08:10:00', '2021-02-03 18:00:00'),
(1188, 747, 68, '2021-02-04 05:00:00', '2021-02-04 05:00:00'),
(1189, 747, 69, '2021-02-04 05:10:00', '2021-02-04 13:00:00'),
(1190, 748, 68, '2021-02-04 08:00:00', '2021-02-04 08:00:00'),
(1191, 748, 69, '2021-02-04 08:10:00', '2021-02-04 21:00:00'),
(1192, 749, 68, '2021-02-04 08:00:00', '2021-02-04 08:00:00'),
(1193, 749, 69, '2021-02-04 08:10:00', '2021-02-04 18:00:00'),
(1194, 750, 68, '2021-02-05 05:00:00', '2021-02-05 05:00:00'),
(1195, 750, 69, '2021-02-05 05:10:00', '2021-02-05 13:00:00'),
(1196, 751, 68, '2021-02-05 08:00:00', '2021-02-05 08:00:00'),
(1197, 751, 69, '2021-02-05 08:10:00', '2021-02-05 21:00:00'),
(1198, 752, 68, '2021-02-05 08:00:00', '2021-02-05 08:00:00'),
(1199, 752, 69, '2021-02-05 08:10:00', '2021-02-05 18:00:00'),
(1200, 753, 68, '2021-02-06 08:00:00', '2021-02-06 05:00:00'),
(1201, 753, 69, '2021-02-06 08:10:00', '2021-02-06 13:00:00'),
(1202, 754, 68, '2021-02-06 08:00:00', '2021-02-06 09:00:00'),
(1203, 754, 69, '2021-02-06 08:10:00', '2021-02-06 16:00:00'),
(1204, 755, 68, '2021-02-07 09:00:00', '2021-02-07 09:00:00'),
(1205, 755, 69, '2021-02-07 09:10:00', '2021-02-07 16:00:00'),
(1206, 756, 68, '2021-02-08 05:00:00', '2021-02-08 05:00:00'),
(1207, 756, 69, '2021-02-08 05:10:00', '2021-02-08 13:00:00'),
(1208, 757, 68, '2021-02-08 08:00:00', '2021-02-08 08:00:00'),
(1209, 757, 69, '2021-02-08 08:10:00', '2021-02-08 21:00:00'),
(1210, 758, 68, '2021-02-08 08:00:00', '2021-02-08 08:00:00'),
(1211, 758, 69, '2021-02-08 08:10:00', '2021-02-08 18:00:00'),
(1212, 759, 68, '2021-02-09 05:00:00', '2021-02-09 05:00:00'),
(1213, 759, 69, '2021-02-09 05:10:00', '2021-02-09 13:00:00'),
(1214, 760, 68, '2021-02-09 08:00:00', '2021-02-09 08:00:00'),
(1215, 760, 69, '2021-02-09 08:10:00', '2021-02-09 21:00:00'),
(1216, 761, 68, '2021-02-09 08:00:00', '2021-02-09 08:00:00'),
(1217, 761, 69, '2021-02-09 08:10:00', '2021-02-09 18:00:00'),
(1218, 762, 68, '2021-02-10 05:00:00', '2021-02-10 05:00:00'),
(1219, 762, 69, '2021-02-10 05:10:00', '2021-02-10 13:00:00'),
(1220, 763, 68, '2021-02-10 08:00:00', '2021-02-10 08:00:00'),
(1221, 763, 69, '2021-02-10 08:10:00', '2021-02-10 21:00:00'),
(1222, 764, 68, '2021-02-10 08:00:00', '2021-02-10 08:00:00'),
(1223, 764, 69, '2021-02-10 08:10:00', '2021-02-10 18:00:00'),
(1224, 765, 74, '2021-04-02 09:00:00', '2021-04-02 09:00:00'),
(1225, 765, 75, '2021-04-05 08:00:00', '2021-04-07 08:00:00'),
(1226, 765, 82, '2021-04-05 09:39:00', '2021-04-08 08:00:00'),
(1227, 766, 68, '2022-04-06 05:00:00', '2022-04-06 05:00:00'),
(1228, 766, 69, '2022-04-06 05:10:00', '2022-04-06 05:20:00'),
(1229, 767, 92, '2022-04-06 18:38:00', '2022-04-06 18:40:00');

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
(505, 3, 1),
(504, 1, 1),
(502, 1, 1),
(506, 1, 1),
(507, 1, 1),
(508, 1, 1),
(509, 1, 1),
(510, 1, 1),
(511, 1, 1),
(512, 1, 1),
(513, 1, 1),
(514, 1, 1),
(517, 1, 1),
(518, 1, 1),
(519, 1, 1),
(520, 1, 1),
(521, 1, 1),
(522, 1, 1),
(523, 1, 1),
(524, 1, 1),
(525, 1, 1),
(527, 1, 1),
(528, 1, 1),
(529, 1, 1),
(530, 1, 1),
(531, 1, 1),
(532, 1, 1),
(533, 1, 1),
(534, 1, 1),
(535, 1, 1),
(536, 1, 1),
(537, 1, 1),
(538, 1, 1),
(539, 1, 1),
(551, 1, 1),
(541, 1, 1),
(542, 1, 1),
(543, 1, 1),
(544, 1, 1),
(545, 1, 1),
(546, 1, 1),
(547, 1, 1),
(548, 1, 1),
(549, 1, 1),
(550, 1, 1),
(552, 1, 1),
(553, 1, 1),
(554, 1, 1),
(555, 1, 1),
(556, 1, 1),
(578, 1, 1),
(579, 1, 1),
(577, 1, 1),
(580, 1, 1),
(581, 1, 1),
(562, 1, 1),
(563, 1, 1),
(564, 1, 1),
(565, 1, 1),
(566, 1, 1),
(567, 1, 1),
(568, 1, 1),
(569, 1, 1),
(570, 1, 1),
(571, 1, 1),
(572, 1, 1),
(573, 1, 1),
(582, 1, 1),
(583, 1, 1),
(601, 1, 1),
(600, 1, 1),
(599, 1, 1),
(598, 1, 1),
(597, 1, 1),
(596, 1, 1),
(595, 1, 1),
(594, 1, 1),
(592, 1, 1),
(602, 1, 1),
(603, 1, 1),
(604, 1, 1),
(605, 1, 1),
(606, 1, 1),
(607, 1, 1),
(608, 1, 1),
(609, 1, 1),
(610, 1, 1),
(611, 1, 1),
(612, 1, 1),
(613, 1, 1),
(614, 1, 1),
(615, 1, 1),
(616, 1, 1),
(617, 1, 1),
(618, 1, 1),
(619, 1, 1),
(620, 1, 1),
(621, 1, 1),
(622, 1, 1),
(623, 1, 1),
(624, 1, 1),
(625, 1, 1),
(626, 1, 1),
(627, 1, 1),
(628, 1, 1),
(629, 1, 1),
(630, 1, 1),
(631, 1, 1),
(632, 1, 1),
(633, 1, 1),
(634, 1, 1),
(635, 1, 1),
(636, 1, 1),
(637, 1, 1),
(638, 1, 1),
(639, 1, 1),
(640, 1, 1),
(641, 1, 1),
(642, 1, 1),
(643, 1, 1),
(644, 1, 1),
(645, 1, 1),
(646, 1, 1),
(647, 1, 1),
(648, 1, 1),
(649, 1, 1),
(650, 1, 1),
(651, 1, 1),
(652, 1, 1),
(653, 1, 1),
(654, 1, 1),
(655, 1, 1),
(656, 1, 1),
(657, 1, 1),
(658, 1, 1),
(659, 1, 1),
(660, 1, 1),
(661, 1, 1),
(662, 1, 1),
(663, 1, 1),
(664, 1, 1),
(665, 1, 1),
(666, 1, 1),
(667, 1, 1),
(668, 1, 1),
(669, 1, 1),
(670, 1, 1),
(671, 1, 1),
(672, 1, 1),
(673, 1, 1),
(674, 1, 1),
(675, 1, 1),
(676, 1, 1),
(677, 1, 1),
(678, 1, 1),
(679, 1, 1),
(680, 1, 1),
(681, 1, 1),
(682, 1, 1),
(683, 1, 1),
(684, 1, 1),
(685, 1, 1),
(689, 1, 1),
(687, 1, 1),
(688, 1, 1),
(690, 1, 1),
(691, 1, 1),
(692, 1, 1),
(693, 1, 1),
(694, 1, 1),
(695, 1, 1),
(696, 1, 1),
(697, 1, 1),
(698, 1, 1),
(699, 1, 1),
(700, 1, 1),
(701, 1, 1),
(702, 1, 1),
(703, 1, 1),
(704, 1, 1),
(705, 1, 1),
(706, 1, 1),
(707, 1, 1),
(708, 1, 1),
(709, 1, 1),
(710, 1, 1),
(711, 1, 1),
(712, 1, 1),
(713, 1, 1),
(714, 1, 1),
(715, 1, 1),
(716, 1, 1),
(717, 1, 1),
(718, 1, 1),
(719, 1, 1),
(720, 1, 1),
(721, 1, 1),
(722, 1, 1),
(723, 1, 1),
(724, 1, 1),
(725, 1, 1),
(726, 1, 1),
(727, 1, 1),
(728, 1, 1),
(729, 1, 1),
(730, 1, 1),
(731, 1, 1),
(732, 1, 1),
(733, 1, 1),
(734, 1, 1),
(735, 1, 1),
(736, 1, 1),
(737, 1, 1),
(738, 1, 1),
(739, 1, 1),
(740, 1, 1),
(741, 1, 1),
(742, 1, 1),
(743, 1, 1),
(744, 1, 1),
(745, 1, 1),
(746, 1, 1),
(747, 1, 1),
(748, 1, 1),
(749, 1, 1),
(750, 1, 1),
(751, 1, 1),
(752, 1, 1),
(753, 1, 1),
(754, 1, 1),
(755, 1, 1),
(756, 1, 1),
(757, 1, 1),
(758, 1, 1),
(759, 1, 1),
(760, 1, 1),
(761, 1, 1),
(762, 1, 1),
(763, 1, 1),
(764, 1, 1),
(765, 1, 1),
(766, 1, 1),
(767, 1, 1),
(768, 1, 1),
(769, 1, 1),
(770, 1, 1),
(771, 1, 1),
(772, 1, 1),
(773, 1, 1),
(774, 1, 1),
(775, 1, 1),
(776, 1, 1),
(777, 1, 1),
(778, 1, 1),
(779, 1, 1),
(780, 1, 1),
(781, 1, 1),
(782, 1, 1),
(783, 1, 1),
(784, 1, 1),
(785, 1, 1),
(786, 1, 1),
(787, 1, 1),
(788, 1, 1),
(789, 1, 1),
(790, 1, 1),
(791, 1, 1),
(792, 1, 1),
(793, 1, 1),
(794, 1, 1),
(795, 1, 1),
(796, 1, 1),
(797, 1, 1),
(798, 1, 1),
(799, 1, 1),
(800, 1, 1),
(801, 1, 1),
(802, 1, 1),
(803, 1, 1),
(804, 1, 1),
(805, 1, 1),
(806, 1, 1),
(807, 1, 1),
(808, 1, 1),
(809, 1, 1),
(810, 1, 1),
(811, 1, 1),
(812, 1, 1),
(813, 1, 1),
(814, 1, 1),
(815, 1, 1),
(816, 1, 1),
(817, 1, 1),
(818, 1, 1),
(819, 1, 1),
(820, 1, 1),
(821, 1, 1),
(822, 1, 1),
(823, 1, 1),
(824, 1, 1),
(825, 1, 1),
(826, 1, 1),
(827, 1, 1),
(828, 1, 1),
(829, 1, 1),
(830, 1, 1),
(831, 1, 1),
(832, 1, 1),
(833, 1, 1),
(834, 1, 1),
(835, 1, 1),
(836, 1, 1),
(837, 1, 1),
(838, 1, 1),
(839, 1, 1),
(840, 1, 1),
(841, 1, 1),
(842, 1, 1),
(843, 1, 1),
(844, 1, 1),
(845, 1, 1),
(846, 1, 1),
(847, 1, 1),
(848, 1, 1),
(849, 1, 1),
(850, 1, 1),
(851, 1, 1),
(852, 1, 1),
(853, 1, 1),
(854, 1, 1),
(855, 1, 1),
(856, 1, 1),
(857, 1, 1),
(858, 1, 1),
(859, 1, 1),
(860, 1, 1),
(861, 1, 1),
(862, 1, 1),
(863, 1, 1),
(864, 1, 1),
(865, 1, 1),
(866, 1, 1),
(867, 1, 1),
(868, 1, 1),
(869, 1, 1),
(870, 1, 1),
(871, 1, 1),
(872, 1, 1),
(873, 1, 1),
(874, 1, 1),
(875, 1, 1),
(876, 1, 1),
(877, 1, 1),
(878, 1, 1),
(879, 1, 1),
(880, 1, 1),
(881, 1, 1),
(882, 1, 1),
(883, 1, 1),
(884, 1, 1),
(885, 1, 1),
(886, 1, 1),
(887, 1, 1),
(888, 1, 1),
(889, 1, 1),
(890, 1, 1),
(891, 1, 1),
(892, 1, 1),
(893, 1, 1),
(894, 1, 1),
(895, 1, 1),
(896, 1, 1),
(897, 1, 1),
(898, 1, 1),
(899, 1, 1),
(900, 1, 1),
(901, 1, 1),
(902, 1, 1),
(903, 1, 1),
(904, 1, 1),
(905, 1, 1),
(906, 1, 1),
(907, 1, 1),
(908, 1, 1),
(909, 1, 1),
(910, 1, 1),
(911, 1, 1),
(912, 1, 1),
(913, 1, 1),
(914, 1, 1),
(915, 1, 1),
(916, 1, 1),
(917, 1, 1),
(918, 1, 1),
(919, 1, 1),
(920, 1, 1),
(921, 1, 1),
(922, 1, 1),
(923, 1, 1),
(924, 1, 1),
(925, 1, 1),
(926, 1, 1),
(927, 1, 1),
(928, 1, 1),
(929, 1, 1),
(930, 1, 1),
(931, 1, 1),
(932, 1, 1),
(933, 1, 1),
(934, 1, 1),
(935, 1, 1),
(936, 1, 1),
(937, 1, 1),
(938, 1, 1),
(939, 1, 1),
(940, 1, 1),
(941, 1, 1),
(942, 1, 1),
(943, 1, 1),
(944, 1, 1),
(945, 1, 1),
(946, 1, 1),
(947, 1, 1),
(948, 1, 1),
(949, 1, 1),
(950, 1, 1),
(951, 1, 1),
(952, 1, 1),
(953, 1, 1),
(954, 1, 1),
(955, 1, 1),
(956, 1, 1),
(957, 1, 1),
(958, 1, 1),
(959, 1, 1),
(960, 1, 1),
(961, 1, 1),
(962, 1, 1),
(963, 1, 1),
(964, 1, 1),
(965, 1, 1),
(966, 1, 1),
(967, 1, 1),
(968, 1, 1),
(969, 1, 1),
(970, 1, 1),
(971, 1, 1),
(972, 1, 1),
(973, 1, 1),
(974, 1, 1),
(975, 1, 1),
(976, 1, 1),
(977, 1, 1),
(978, 1, 1),
(979, 1, 1),
(980, 1, 1),
(981, 1, 1),
(982, 1, 1),
(983, 1, 1),
(984, 1, 1),
(985, 1, 1),
(986, 1, 1),
(987, 1, 1),
(988, 1, 1),
(989, 1, 1),
(990, 1, 1),
(991, 1, 1),
(992, 1, 1),
(993, 1, 1),
(994, 1, 1),
(995, 1, 1),
(996, 1, 1),
(997, 1, 1),
(998, 1, 1),
(999, 1, 1),
(1000, 1, 1),
(1001, 1, 1),
(1002, 1, 1),
(1003, 1, 1),
(1004, 1, 1),
(1005, 1, 1),
(1006, 1, 1),
(1007, 1, 1),
(1008, 1, 1),
(1009, 1, 1),
(1010, 1, 1),
(1011, 1, 1),
(1012, 1, 1),
(1013, 1, 1),
(1014, 1, 1),
(1015, 1, 1),
(1016, 1, 1),
(1017, 1, 1),
(1018, 1, 1),
(1019, 1, 1),
(1020, 1, 1),
(1021, 1, 1),
(1022, 1, 1),
(1023, 1, 1),
(1024, 1, 1),
(1025, 1, 1),
(1026, 1, 1),
(1027, 1, 1),
(1028, 1, 1),
(1029, 1, 1),
(1030, 1, 1),
(1031, 1, 1),
(1032, 1, 1),
(1033, 1, 1),
(1034, 1, 1),
(1035, 1, 1),
(1036, 1, 1),
(1037, 1, 1),
(1038, 1, 1),
(1039, 1, 1),
(1040, 1, 1),
(1041, 1, 1),
(1042, 1, 1),
(1043, 1, 1),
(1044, 1, 1),
(1045, 1, 1),
(1046, 1, 1),
(1047, 1, 1),
(1048, 1, 1),
(1049, 1, 1),
(1050, 1, 1),
(1051, 1, 1),
(1052, 1, 1),
(1053, 1, 1),
(1054, 1, 1),
(1055, 1, 1),
(1056, 1, 1),
(1057, 1, 1),
(1058, 1, 1),
(1059, 1, 1),
(1060, 1, 1),
(1061, 1, 1),
(1062, 1, 1),
(1063, 1, 1),
(1064, 1, 1),
(1065, 1, 1),
(1066, 1, 1),
(1067, 1, 1),
(1068, 1, 1),
(1069, 1, 1),
(1070, 1, 1),
(1071, 1, 1),
(1072, 1, 1),
(1073, 1, 1),
(1074, 1, 1),
(1075, 1, 1),
(1076, 1, 1),
(1077, 1, 1),
(1078, 1, 1),
(1079, 1, 1),
(1080, 1, 1),
(1081, 1, 1),
(1082, 1, 1),
(1083, 1, 1),
(1084, 1, 1),
(1085, 1, 1),
(1086, 1, 1),
(1087, 1, 1),
(1088, 1, 1),
(1089, 1, 1),
(1090, 1, 1),
(1091, 1, 1),
(1092, 1, 1),
(1093, 1, 1),
(1094, 1, 1),
(1095, 1, 1),
(1096, 1, 1),
(1097, 1, 1),
(1098, 1, 1),
(1099, 1, 1),
(1100, 1, 1),
(1101, 1, 1),
(1102, 1, 1),
(1103, 1, 1),
(1104, 1, 1),
(1105, 1, 1),
(1106, 1, 1),
(1107, 1, 1),
(1108, 1, 1),
(1109, 1, 1),
(1110, 1, 1),
(1111, 1, 1),
(1112, 1, 1),
(1113, 1, 1),
(1114, 1, 1),
(1115, 1, 1),
(1116, 1, 1),
(1117, 1, 1),
(1118, 1, 1),
(1119, 1, 1),
(1120, 1, 1),
(1121, 1, 1),
(1122, 1, 1),
(1123, 1, 1),
(1124, 1, 1),
(1125, 1, 1),
(1126, 1, 1),
(1127, 1, 1),
(1128, 1, 1),
(1129, 1, 1),
(1130, 1, 1),
(1131, 1, 1),
(1132, 1, 1),
(1133, 1, 1),
(1134, 1, 1),
(1135, 1, 1),
(1136, 1, 1),
(1137, 1, 1),
(1138, 4, 12),
(1139, 4, 10);

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
(502, NULL, NULL, '0000-00-00', '0000-00-00', 'richart simpson'),
(504, NULL, NULL, '0000-00-00', '0000-00-00', 'RICHARD SIMPSOM'),
(505, NULL, NULL, '0000-00-00', '0000-00-00', '24'),
(506, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(507, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(508, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(509, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(510, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(511, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(512, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(513, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(514, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(517, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(518, NULL, NULL, '0000-00-00', '0000-00-00', 'Rodrigo Lozano'),
(519, NULL, NULL, '0000-00-00', '0000-00-00', 'Rodrigo Lozano'),
(520, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(521, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(522, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(523, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(524, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(525, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(527, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(528, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(529, NULL, NULL, '0000-00-00', '0000-00-00', 'Rodrigo Lozano'),
(530, NULL, NULL, '0000-00-00', '0000-00-00', 'Rodrigo Lozano'),
(531, NULL, NULL, '0000-00-00', '0000-00-00', 'Rodrigo Lozano'),
(532, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(533, NULL, NULL, '0000-00-00', '0000-00-00', 'Rodrigo Lozano'),
(534, NULL, NULL, '0000-00-00', '0000-00-00', 'Rodrigo Lozano'),
(535, NULL, NULL, '0000-00-00', '0000-00-00', 'Rodrigo Lozano'),
(536, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(537, NULL, NULL, '0000-00-00', '0000-00-00', 'Raul Muñoz'),
(538, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(539, NULL, NULL, '0000-00-00', '0000-00-00', 'Raul Muñoz'),
(541, NULL, NULL, '0000-00-00', '0000-00-00', 'Rofran'),
(542, NULL, NULL, '0000-00-00', '0000-00-00', 'Rofran'),
(543, NULL, NULL, '0000-00-00', '0000-00-00', 'Rofran'),
(544, NULL, NULL, '0000-00-00', '0000-00-00', 'Rofran'),
(545, NULL, NULL, '0000-00-00', '0000-00-00', 'Rofran'),
(546, NULL, NULL, '0000-00-00', '0000-00-00', 'Rofran'),
(547, NULL, NULL, '0000-00-00', '0000-00-00', 'Rofran'),
(548, NULL, NULL, '0000-00-00', '0000-00-00', 'Rofran'),
(549, NULL, NULL, '0000-00-00', '0000-00-00', 'Rofran'),
(550, NULL, NULL, '0000-00-00', '0000-00-00', 'Rofran'),
(551, NULL, NULL, '0000-00-00', '0000-00-00', 'Rodrigo Lozano'),
(552, NULL, NULL, '0000-00-00', '0000-00-00', 'Rodrigo Lozano'),
(553, NULL, NULL, '0000-00-00', '0000-00-00', 'Rodrigo Lozano'),
(554, NULL, NULL, '0000-00-00', '0000-00-00', 'Rodrigo Lozano'),
(555, NULL, NULL, '0000-00-00', '0000-00-00', 'Rodrigo Lozano'),
(556, NULL, NULL, '0000-00-00', '0000-00-00', 'Rodrigo Lozano'),
(562, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(563, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(564, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(565, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(566, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(567, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(568, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(569, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(570, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(571, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(572, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(573, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(577, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(578, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(579, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(580, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(581, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(582, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(583, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(592, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(594, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(595, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(596, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(597, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(598, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(599, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(600, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(601, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(602, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(603, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(604, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(605, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(606, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(607, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(608, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(609, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(610, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(611, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(612, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(613, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(614, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(615, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(616, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(617, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(618, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(619, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(620, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(621, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(622, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(623, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(624, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(625, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(626, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(627, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(628, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(629, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(630, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(631, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(632, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(633, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(634, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(635, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(636, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(637, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(638, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(639, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(640, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(641, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(642, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(643, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(644, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(645, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(646, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(647, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(648, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(649, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(650, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(651, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(652, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(653, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(654, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(655, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(656, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(657, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(658, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(659, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(660, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(661, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(662, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(663, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(664, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(665, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(666, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(667, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(668, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(669, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(670, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(671, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(672, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(673, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(674, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(675, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(676, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(677, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(678, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(679, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(680, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(681, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(682, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(683, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(684, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(685, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(687, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(688, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(689, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(690, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(691, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(692, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(693, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(694, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(695, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(696, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(697, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(698, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(699, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(700, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(701, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(702, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(703, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(704, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(705, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(706, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(707, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(708, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(709, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(710, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(711, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(712, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(713, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(714, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(715, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(716, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(717, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(718, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(719, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(720, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(721, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(722, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(723, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(724, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(725, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(726, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(727, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(728, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(729, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(730, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(731, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(732, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(733, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(734, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(735, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(736, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(737, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(738, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(739, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(740, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(741, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(742, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(743, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(744, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(745, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(746, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(747, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(748, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(749, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(750, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(751, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(752, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(753, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(754, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(755, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(756, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(757, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(758, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(759, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(760, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(761, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(762, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(763, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(764, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(765, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(766, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(767, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(768, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(769, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(770, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(771, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(772, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(773, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(774, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(775, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(776, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(777, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(778, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(779, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(780, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(781, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(782, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(783, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(784, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(785, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(786, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(787, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(788, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(789, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(790, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(791, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(792, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(793, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(794, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(795, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(796, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(797, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(798, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(799, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(800, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(801, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(802, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(803, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(804, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(805, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(806, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(807, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(808, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(809, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(810, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(811, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(812, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(813, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(814, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(815, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(816, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(817, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(818, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(819, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(820, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(821, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(822, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(823, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(824, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(825, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(826, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(827, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(828, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(829, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(830, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(831, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(832, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(833, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(834, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(835, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(836, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(837, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(838, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(839, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(840, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(841, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(842, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(843, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(844, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(845, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(846, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(847, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(848, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(849, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(850, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(851, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(852, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(853, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(854, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(855, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(856, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(857, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(858, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(859, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(860, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(861, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(862, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(863, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(864, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(865, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(866, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(867, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(868, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(869, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(870, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(871, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(872, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(873, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(874, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(875, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(876, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(877, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(878, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(879, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(880, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(881, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(882, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(883, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(884, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(885, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(886, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(887, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(888, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(889, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(890, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(891, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(892, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(893, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(894, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(895, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(896, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(897, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(898, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(899, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(900, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(901, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(902, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(903, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(904, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(905, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(906, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(907, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(908, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(909, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(910, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(911, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(912, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(913, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(914, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(915, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(916, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(917, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(918, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(919, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(920, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(921, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(922, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(923, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(924, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(925, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(926, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(927, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(928, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(929, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(930, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(931, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(932, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(933, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(934, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(935, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(936, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(937, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(938, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(939, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(940, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(941, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(942, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(943, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(944, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(945, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(946, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(947, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(948, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(949, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(950, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(951, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(952, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(953, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(954, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(955, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(956, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(957, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(958, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(959, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(960, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(961, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(962, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(963, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(964, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(965, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(966, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(967, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(968, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(969, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(970, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(971, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(972, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(973, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(974, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(975, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(976, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(977, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(978, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(979, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(980, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(981, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(982, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(983, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(984, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(985, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(986, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(987, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(988, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(989, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(990, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(991, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(992, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(993, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(994, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(995, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(996, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(997, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(998, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(999, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1000, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1001, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1002, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1003, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1004, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1005, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1006, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1007, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1008, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1009, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1010, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1011, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1012, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1013, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1014, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1015, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1016, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1017, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1018, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1019, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1020, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1021, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1022, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1023, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1024, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1025, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1026, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1027, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1028, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1029, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1030, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1031, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1032, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1033, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1034, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1035, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1036, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1037, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1038, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1039, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1040, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1041, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1042, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1043, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1044, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1045, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1046, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1047, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1048, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1049, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1050, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1051, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1052, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1053, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1054, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1055, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1056, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1057, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1058, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1059, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1060, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1061, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1062, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1063, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1064, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1065, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1066, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1067, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1068, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1069, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1070, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1071, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1072, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1073, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1074, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1075, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1076, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1077, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1078, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1079, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1080, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1081, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1082, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1083, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1084, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1085, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1086, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1087, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1088, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1089, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1090, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1091, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1092, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1093, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1094, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1095, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1096, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1097, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1098, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1099, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1100, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1101, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1102, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1103, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1104, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1105, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1106, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1107, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1108, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1109, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1110, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1111, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1112, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1113, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1114, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1115, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1116, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1117, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1118, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1119, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1120, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1121, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1122, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1123, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1124, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1125, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1126, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1127, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1128, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1129, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1130, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1131, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1132, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1133, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1134, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1135, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1136, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1137, NULL, NULL, '0000-00-00', '0000-00-00', ''),
(1138, NULL, NULL, '0000-00-00', '0000-00-00', 'syswa'),
(1139, NULL, NULL, '0000-00-00', '0000-00-00', 'syswa');

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
(285, 'paso 4', NULL, NULL),
(286, 'paso 1', NULL, NULL),
(287, 'paso 4', NULL, NULL),
(288, 'paso 1', NULL, NULL),
(289, 'paso 4', NULL, NULL),
(290, 'paso 1', NULL, NULL),
(291, 'paso 4', NULL, NULL),
(292, 'paso 1', NULL, NULL),
(293, 'paso 4', NULL, NULL),
(294, 'paso 1', NULL, NULL),
(295, 'paso 4', NULL, NULL),
(296, 'paso 1', NULL, NULL),
(297, 'paso 4', NULL, NULL),
(298, 'paso 1', NULL, NULL),
(299, 'paso 4', NULL, NULL),
(300, 'paso 1', NULL, NULL),
(301, 'paso 4', NULL, NULL),
(302, 'paso 1', NULL, NULL),
(303, 'paso 3', NULL, NULL),
(304, 'paso 4', NULL, NULL),
(305, 'paso 1', NULL, NULL),
(306, 'paso 4', NULL, NULL),
(307, 'paso 1', NULL, NULL),
(308, 'paso 4', NULL, NULL),
(309, 'paso 1', NULL, NULL),
(310, 'paso 4', NULL, NULL),
(311, 'paso 1', NULL, NULL),
(312, 'paso 4', NULL, NULL),
(313, 'paso 1', NULL, NULL),
(314, 'paso 4', NULL, NULL),
(315, 'paso 1', NULL, NULL),
(316, 'paso 4', NULL, NULL),
(317, 'paso 1', NULL, NULL),
(318, 'paso 4', NULL, NULL),
(319, 'paso 1', NULL, NULL),
(320, 'paso 4', NULL, NULL),
(321, 'paso 1', NULL, NULL),
(322, 'paso 4', NULL, NULL),
(323, 'paso 1', NULL, NULL),
(324, 'paso 4', NULL, NULL),
(325, 'paso 1', NULL, NULL),
(326, 'paso 4', NULL, NULL),
(327, 'paso 1', NULL, NULL),
(328, 'paso 4', NULL, NULL),
(329, 'paso 1', NULL, NULL),
(330, 'paso 4', NULL, NULL),
(331, 'paso 1', NULL, NULL),
(332, 'paso 4', NULL, NULL),
(333, 'paso 1', NULL, NULL),
(334, 'paso 4', NULL, NULL),
(335, 'paso 1', NULL, NULL),
(336, 'paso 4', NULL, NULL),
(337, 'paso 1', NULL, NULL),
(338, 'paso 4', NULL, NULL),
(339, 'paso 1', NULL, NULL),
(340, 'paso 4', NULL, NULL),
(341, 'paso 1', NULL, NULL),
(342, 'paso 4', NULL, NULL),
(343, 'paso 1', NULL, NULL),
(344, 'paso 4', NULL, NULL),
(345, 'paso 1', NULL, NULL),
(346, 'paso 4', NULL, NULL),
(347, 'paso 1', NULL, NULL),
(348, 'paso 4', NULL, NULL),
(349, 'paso 1', NULL, NULL),
(350, 'paso 4', NULL, NULL),
(351, 'paso 1', NULL, NULL),
(352, 'paso 4', NULL, NULL),
(353, 'paso 1', NULL, NULL),
(354, 'paso 4', NULL, NULL),
(355, 'paso 1', NULL, NULL),
(356, 'paso 4', NULL, NULL),
(357, 'paso 1', NULL, NULL),
(358, 'paso 4', NULL, NULL),
(359, 'paso 1', NULL, NULL),
(360, 'paso 4', NULL, NULL),
(361, 'paso 1', NULL, NULL),
(362, 'paso 4', NULL, NULL),
(363, 'paso 1', NULL, NULL),
(364, 'paso 4', NULL, NULL),
(365, 'paso 1', NULL, NULL),
(366, 'paso 4', NULL, NULL),
(367, 'paso 1', NULL, NULL),
(368, 'paso 4', NULL, NULL),
(369, 'paso 1', NULL, NULL),
(370, 'paso 4', NULL, NULL),
(371, 'paso 1', NULL, NULL),
(372, 'paso 4', NULL, NULL),
(373, 'paso 1', NULL, NULL),
(374, 'paso 4', NULL, NULL),
(375, 'paso 1', NULL, NULL),
(376, 'paso 4', NULL, NULL),
(377, 'paso 1', NULL, NULL),
(378, 'paso 4', NULL, NULL),
(379, 'paso 1', NULL, NULL),
(380, 'paso 4', NULL, NULL),
(381, 'paso 1', NULL, NULL),
(382, 'paso 4', NULL, NULL),
(383, 'paso 1', NULL, NULL),
(384, 'paso 4', NULL, NULL),
(385, 'paso 1', NULL, NULL),
(386, 'paso 4', NULL, NULL),
(387, 'paso 1', NULL, NULL),
(388, 'paso 4', NULL, NULL),
(389, 'paso 1', NULL, NULL),
(390, 'paso 4', NULL, NULL),
(391, 'paso 1', NULL, NULL),
(392, 'paso 4', NULL, NULL),
(393, 'paso 1', NULL, NULL),
(394, 'paso 4', NULL, NULL),
(395, 'paso 1', NULL, NULL),
(396, 'paso 4', NULL, NULL),
(397, 'paso 1', NULL, NULL),
(398, 'paso 4', NULL, NULL),
(399, 'paso 1', NULL, NULL),
(400, 'paso 4', NULL, NULL),
(401, 'paso 1', NULL, NULL),
(402, 'paso 4', NULL, NULL),
(403, 'paso 1', NULL, NULL),
(404, 'paso 4', NULL, NULL),
(405, 'paso 1', NULL, NULL),
(406, 'paso 4', NULL, NULL),
(407, 'paso 1', NULL, NULL),
(408, 'paso 4', NULL, NULL),
(409, 'paso 1', NULL, NULL),
(410, 'paso 4', NULL, NULL),
(411, 'paso 1', NULL, NULL),
(412, 'paso 4', NULL, NULL),
(413, 'paso 1', NULL, NULL),
(414, 'paso 4', NULL, NULL),
(415, 'paso 1', NULL, NULL),
(416, 'paso 4', NULL, NULL),
(417, 'paso 1', NULL, NULL),
(418, 'paso 4', NULL, NULL),
(419, 'paso 1', NULL, NULL),
(420, 'paso 4', NULL, NULL),
(421, 'paso 1', NULL, NULL),
(422, 'paso 4', NULL, NULL),
(423, 'paso 1', NULL, NULL),
(424, 'paso 4', NULL, NULL),
(425, 'paso 1', NULL, NULL),
(426, 'paso 4', NULL, NULL),
(427, 'paso 1', NULL, NULL),
(428, 'paso 4', NULL, NULL),
(429, 'paso 1', NULL, NULL),
(430, 'paso 4', NULL, NULL),
(431, 'paso 1', NULL, NULL),
(432, 'paso 4', NULL, NULL),
(433, 'paso 1', NULL, NULL),
(434, 'paso 4', NULL, NULL),
(435, 'paso 1', NULL, NULL),
(436, 'paso 4', NULL, NULL),
(437, 'paso 1', NULL, NULL),
(438, 'paso 4', NULL, NULL),
(439, 'paso 1', NULL, NULL),
(440, 'paso 4', NULL, NULL),
(441, 'paso 1', NULL, NULL),
(442, 'paso 4', NULL, NULL),
(443, 'paso 1', NULL, NULL),
(444, 'paso 4', NULL, NULL),
(445, 'paso 1', NULL, NULL),
(446, 'paso 4', NULL, NULL),
(447, 'paso 1', NULL, NULL),
(448, 'paso 4', NULL, NULL),
(449, 'paso 1', NULL, NULL),
(450, 'paso 4', NULL, NULL),
(451, 'paso 1', NULL, NULL),
(452, 'paso 4', NULL, NULL),
(453, 'paso 1', NULL, NULL),
(454, 'paso 4', NULL, NULL),
(455, 'paso 1', NULL, NULL),
(456, 'paso 4', NULL, NULL),
(457, 'paso 1', NULL, NULL),
(458, 'paso 4', NULL, NULL),
(459, 'paso 1', NULL, NULL),
(460, 'paso 4', NULL, NULL),
(461, 'paso 1', NULL, NULL),
(462, 'paso 4', NULL, NULL),
(463, 'paso 1', NULL, NULL),
(464, 'paso 4', NULL, NULL),
(465, 'paso 1', NULL, NULL),
(466, 'paso 4', NULL, NULL),
(467, 'paso 1', NULL, NULL),
(468, 'paso 4', NULL, NULL),
(469, 'paso 1', NULL, NULL),
(470, 'paso 4', NULL, NULL),
(471, 'paso 1', NULL, NULL),
(472, 'paso 4', NULL, NULL),
(473, 'paso 1', NULL, NULL),
(474, 'paso 4', NULL, NULL),
(475, 'paso 1', NULL, NULL),
(476, 'paso 4', NULL, NULL),
(477, 'paso 1', NULL, NULL),
(478, 'paso 4', NULL, NULL),
(479, 'paso 1', NULL, NULL),
(480, 'paso 4', NULL, NULL),
(481, 'paso 1', NULL, NULL),
(482, 'paso 4', NULL, NULL),
(483, 'paso 1', NULL, NULL),
(484, 'paso 4', NULL, NULL),
(485, 'paso 1', NULL, NULL),
(486, 'paso 4', NULL, NULL),
(487, 'paso 1', NULL, NULL),
(488, 'paso 4', NULL, NULL),
(489, 'paso 1', NULL, NULL),
(490, 'paso 4', NULL, NULL),
(491, 'paso 1', NULL, NULL),
(492, 'paso 4', NULL, NULL),
(493, 'paso 1', NULL, NULL),
(494, 'paso 4', NULL, NULL),
(495, 'paso 1', NULL, NULL),
(496, 'paso 4', NULL, NULL),
(497, 'paso 1', NULL, NULL),
(498, 'paso 4', NULL, NULL),
(499, 'paso 1', NULL, NULL),
(500, 'paso 4', NULL, NULL),
(501, 'paso 1', NULL, NULL),
(502, 'paso 4', NULL, NULL),
(503, 'paso 1', NULL, NULL),
(504, 'paso 4', NULL, NULL),
(505, 'paso 1', NULL, NULL),
(506, 'paso 4', NULL, NULL),
(507, 'paso 1', NULL, NULL),
(508, 'paso 4', NULL, NULL),
(509, 'paso 1', NULL, NULL),
(510, 'paso 4', NULL, NULL),
(511, 'paso 1', NULL, NULL),
(512, 'paso 4', NULL, NULL),
(513, 'paso 1', NULL, NULL),
(514, 'paso 4', NULL, NULL),
(515, 'paso 1', NULL, NULL),
(516, 'paso 4', NULL, NULL),
(517, 'paso 1', NULL, NULL),
(518, 'paso 4', NULL, NULL),
(519, 'paso 1', NULL, NULL),
(520, 'paso 4', NULL, NULL),
(521, 'paso 1', NULL, NULL),
(522, 'paso 4', NULL, NULL),
(523, 'paso 1', NULL, NULL),
(524, 'paso 4', NULL, NULL),
(525, 'paso 1', NULL, NULL),
(526, 'paso 4', NULL, NULL),
(527, 'paso 1', NULL, NULL),
(528, 'paso 4', NULL, NULL),
(529, 'paso 1', NULL, NULL),
(530, 'paso 4', NULL, NULL),
(531, 'paso 1', NULL, NULL),
(532, 'paso 4', NULL, NULL),
(533, 'paso 1', NULL, NULL),
(534, 'paso 4', NULL, NULL),
(535, 'paso 1', NULL, NULL),
(536, 'paso 4', NULL, NULL),
(537, 'paso 1', NULL, NULL),
(538, 'paso 4', NULL, NULL),
(539, 'paso 1', NULL, NULL),
(540, 'paso 4', NULL, NULL),
(541, 'paso 1', NULL, NULL),
(542, 'paso 4', NULL, NULL),
(543, 'paso 1', NULL, NULL),
(544, 'paso 4', NULL, NULL),
(545, 'paso 1', NULL, NULL),
(546, 'paso 4', NULL, NULL),
(547, 'paso 1', NULL, NULL),
(548, 'paso 4', NULL, NULL),
(549, 'paso 1', NULL, NULL),
(550, 'paso 4', NULL, NULL),
(551, 'paso 1', NULL, NULL),
(552, 'paso 4', NULL, NULL),
(553, 'paso 1', NULL, NULL),
(554, 'paso 4', NULL, NULL),
(555, 'paso 1', NULL, NULL),
(556, 'paso 4', NULL, NULL),
(557, 'paso 1', NULL, NULL),
(558, 'paso 4', NULL, NULL),
(559, 'paso 1', NULL, NULL),
(560, 'paso 4', NULL, NULL),
(561, 'paso 1', NULL, NULL),
(562, 'paso 4', NULL, NULL),
(563, 'paso 1', NULL, NULL),
(564, 'paso 4', NULL, NULL),
(565, 'paso 1', NULL, NULL),
(566, 'paso 4', NULL, NULL),
(567, 'paso 1', NULL, NULL),
(568, 'paso 4', NULL, NULL),
(569, 'paso 1', NULL, NULL),
(570, 'paso 4', NULL, NULL),
(571, 'paso 1', NULL, NULL),
(572, 'paso 4', NULL, NULL),
(573, 'paso 1', NULL, NULL),
(574, 'paso 4', NULL, NULL),
(575, 'paso 1', NULL, NULL),
(576, 'paso 4', NULL, NULL),
(577, 'paso 1', NULL, NULL),
(578, 'paso 4', NULL, NULL),
(579, 'paso 1', NULL, NULL),
(580, 'paso 4', NULL, NULL),
(581, 'paso 1', NULL, NULL),
(582, 'paso 4', NULL, NULL),
(583, 'paso 1', NULL, NULL),
(584, 'paso 4', NULL, NULL),
(585, 'paso 1', NULL, NULL),
(586, 'paso 4', NULL, NULL),
(587, 'paso 1', NULL, NULL),
(588, 'paso 4', NULL, NULL),
(589, 'paso 1', NULL, NULL),
(590, 'paso 4', NULL, NULL),
(591, 'paso 1', NULL, NULL),
(592, 'paso 4', NULL, NULL),
(593, 'paso 1', NULL, NULL),
(594, 'paso 4', NULL, NULL),
(595, 'paso 1', NULL, NULL),
(596, 'paso 4', NULL, NULL),
(597, 'paso 1', NULL, NULL),
(598, 'paso 4', NULL, NULL),
(599, 'paso 1', NULL, NULL),
(600, 'paso 4', NULL, NULL),
(601, 'paso 1', NULL, NULL),
(602, 'paso 4', NULL, NULL),
(603, 'paso 1', NULL, NULL),
(604, 'paso 4', NULL, NULL),
(605, 'paso 1', NULL, NULL),
(606, 'paso 4', NULL, NULL),
(607, 'paso 1', NULL, NULL),
(608, 'paso 4', NULL, NULL),
(609, 'paso 1', NULL, NULL),
(610, 'paso 4', NULL, NULL),
(611, 'paso 1', NULL, NULL),
(612, 'paso 4', NULL, NULL),
(613, 'paso 1', NULL, NULL),
(614, 'paso 4', NULL, NULL),
(615, 'paso 1', NULL, NULL),
(616, 'paso 4', NULL, NULL),
(617, 'paso 1', NULL, NULL),
(618, 'paso 4', NULL, NULL),
(619, 'paso 1', NULL, NULL),
(620, 'paso 4', NULL, NULL),
(621, 'paso 1', NULL, NULL),
(622, 'paso 4', NULL, NULL),
(623, 'paso 1', NULL, NULL),
(624, 'paso 4', NULL, NULL),
(625, 'paso 1', NULL, NULL),
(626, 'paso 4', NULL, NULL),
(627, 'paso 1', NULL, NULL),
(628, 'paso 4', NULL, NULL),
(629, 'paso 1', NULL, NULL),
(630, 'paso 4', NULL, NULL),
(631, 'paso 1', NULL, NULL),
(632, 'paso 4', NULL, NULL),
(633, 'paso 1', NULL, NULL),
(634, 'paso 4', NULL, NULL),
(635, 'paso 1', NULL, NULL),
(636, 'paso 4', NULL, NULL),
(637, 'paso 1', NULL, NULL),
(638, 'paso 4', NULL, NULL),
(639, 'paso 1', NULL, NULL),
(640, 'paso 4', NULL, NULL),
(641, 'paso 1', NULL, NULL),
(642, 'paso 4', NULL, NULL),
(643, 'paso 1', NULL, NULL),
(644, 'paso 4', NULL, NULL),
(645, 'paso 1', NULL, NULL),
(646, 'paso 4', NULL, NULL),
(647, 'paso 1', NULL, NULL),
(648, 'paso 4', NULL, NULL),
(649, 'paso 1', NULL, NULL),
(650, 'paso 4', NULL, NULL),
(651, 'paso 1', NULL, NULL),
(652, 'paso 4', NULL, NULL),
(653, 'paso 1', NULL, NULL),
(654, 'paso 4', NULL, NULL),
(655, 'paso 1', NULL, NULL),
(656, 'paso 4', NULL, NULL),
(657, 'paso 1', NULL, NULL),
(658, 'paso 4', NULL, NULL),
(659, 'paso 1', NULL, NULL),
(660, 'paso 4', NULL, NULL),
(661, 'paso 1', NULL, NULL),
(662, 'paso 4', NULL, NULL),
(663, 'paso 1', NULL, NULL),
(664, 'paso 4', NULL, NULL),
(665, 'paso 1', NULL, NULL),
(666, 'paso 4', NULL, NULL),
(667, 'paso 1', NULL, NULL),
(668, 'paso 4', NULL, NULL),
(669, 'paso 1', NULL, NULL),
(670, 'paso 4', NULL, NULL),
(671, 'paso 1', NULL, NULL),
(672, 'paso 4', NULL, NULL),
(673, 'paso 1', NULL, NULL),
(674, 'paso 4', NULL, NULL),
(675, 'paso 1', NULL, NULL),
(676, 'paso 4', NULL, NULL),
(677, 'paso 1', NULL, NULL),
(678, 'paso 4', NULL, NULL),
(679, 'paso 1', NULL, NULL),
(680, 'paso 4', NULL, NULL),
(681, 'paso 1', NULL, NULL),
(682, 'paso 4', NULL, NULL),
(683, 'paso 1', NULL, NULL),
(684, 'paso 4', NULL, NULL),
(685, 'paso 1', NULL, NULL),
(686, 'paso 4', NULL, NULL),
(687, 'paso 1', NULL, NULL),
(688, 'paso 4', NULL, NULL),
(689, 'paso 1', NULL, NULL),
(690, 'paso 4', NULL, NULL),
(691, 'paso 1', NULL, NULL),
(692, 'paso 4', NULL, NULL),
(693, 'paso 1', NULL, NULL),
(694, 'paso 4', NULL, NULL),
(695, 'paso 1', NULL, NULL),
(696, 'paso 4', NULL, NULL),
(697, 'paso 1', NULL, NULL),
(698, 'paso 4', NULL, NULL),
(699, 'paso 1', NULL, NULL),
(700, 'paso 4', NULL, NULL),
(701, 'paso 1', NULL, NULL),
(702, 'paso 4', NULL, NULL),
(703, 'paso 1', NULL, NULL),
(704, 'paso 4', NULL, NULL),
(705, 'paso 1', NULL, NULL),
(706, 'paso 4', NULL, NULL),
(707, 'paso 1', NULL, NULL),
(708, 'paso 4', NULL, NULL),
(709, 'paso 1', NULL, NULL),
(710, 'paso 4', NULL, NULL),
(711, 'paso 1', NULL, NULL),
(712, 'paso 4', NULL, NULL),
(713, 'paso 1', NULL, NULL),
(714, 'paso 4', NULL, NULL),
(715, 'paso 1', NULL, NULL),
(716, 'paso 4', NULL, NULL),
(717, 'paso 1', NULL, NULL),
(718, 'paso 4', NULL, NULL),
(719, 'paso 1', NULL, NULL),
(720, 'paso 4', NULL, NULL),
(721, 'paso 1', NULL, NULL),
(722, 'paso 4', NULL, NULL),
(723, 'paso 1', NULL, NULL),
(724, 'paso 4', NULL, NULL),
(725, 'paso 1', NULL, NULL),
(726, 'paso 4', NULL, NULL),
(727, 'paso 1', NULL, NULL),
(728, 'paso 4', NULL, NULL),
(729, 'paso 1', NULL, NULL),
(730, 'paso 4', NULL, NULL),
(731, 'paso 1', NULL, NULL),
(732, 'paso 4', NULL, NULL),
(733, 'paso 1', NULL, NULL),
(734, 'paso 4', NULL, NULL),
(735, 'paso 1', NULL, NULL),
(736, 'paso 4', NULL, NULL),
(737, 'paso 1', NULL, NULL),
(738, 'paso 4', NULL, NULL),
(739, 'paso 1', NULL, NULL),
(740, 'paso 4', NULL, NULL),
(741, 'paso 1', NULL, NULL),
(742, 'paso 4', NULL, NULL),
(743, 'paso 1', NULL, NULL),
(744, 'paso 4', NULL, NULL),
(745, 'paso 1', NULL, NULL),
(746, 'paso 4', NULL, NULL),
(747, 'paso 1', NULL, NULL),
(748, 'paso 4', NULL, NULL),
(749, 'paso 1', NULL, NULL),
(750, 'paso 4', NULL, NULL),
(751, 'paso 1', NULL, NULL),
(752, 'paso 4', NULL, NULL),
(753, 'paso 1', NULL, NULL),
(754, 'paso 4', NULL, NULL),
(755, 'paso 1', NULL, NULL),
(756, 'paso 4', NULL, NULL),
(757, 'paso 1', NULL, NULL),
(758, 'paso 4', NULL, NULL),
(759, 'paso 1', NULL, NULL),
(760, 'paso 4', NULL, NULL),
(761, 'paso 1', NULL, NULL),
(762, 'paso 4', NULL, NULL),
(763, 'paso 1', NULL, NULL),
(764, 'paso 4', NULL, NULL),
(765, 'paso 1', NULL, NULL),
(766, 'paso 4', NULL, NULL),
(767, 'paso 1', NULL, NULL),
(768, 'paso 4', NULL, NULL),
(769, 'paso 1', NULL, NULL),
(770, 'paso 4', NULL, NULL),
(771, 'paso 1', NULL, NULL),
(772, 'paso 4', NULL, NULL),
(773, 'paso 1', NULL, NULL),
(774, 'paso 4', NULL, NULL),
(775, 'paso 1', NULL, NULL),
(776, 'paso 4', NULL, NULL),
(777, 'paso 1', NULL, NULL),
(778, 'paso 4', NULL, NULL),
(779, 'paso 1', NULL, NULL),
(780, 'paso 4', NULL, NULL),
(781, 'paso 1', NULL, NULL),
(782, 'paso 4', NULL, NULL),
(783, 'paso 1', NULL, NULL),
(784, 'paso 4', NULL, NULL),
(785, 'paso 1', NULL, NULL),
(786, 'paso 4', NULL, NULL),
(787, 'paso 1', NULL, NULL),
(788, 'paso 4', NULL, NULL),
(789, 'paso 1', NULL, NULL),
(790, 'paso 4', NULL, NULL),
(791, 'paso 1', NULL, NULL),
(792, 'paso 4', NULL, NULL),
(793, 'paso 1', NULL, NULL),
(794, 'paso 4', NULL, NULL),
(795, 'paso 1', NULL, NULL),
(796, 'paso 4', NULL, NULL),
(797, 'paso 1', NULL, NULL),
(798, 'paso 4', NULL, NULL),
(799, 'paso 1', NULL, NULL),
(800, 'paso 4', NULL, NULL),
(801, 'paso 1', NULL, NULL),
(802, 'paso 4', NULL, NULL),
(803, 'paso 1', NULL, NULL),
(804, 'paso 4', NULL, NULL),
(805, 'paso 1', NULL, NULL),
(806, 'paso 4', NULL, NULL),
(807, 'paso 1', NULL, NULL),
(808, 'paso 4', NULL, NULL),
(809, 'paso 1', NULL, NULL),
(810, 'paso 4', NULL, NULL),
(811, 'paso 1', NULL, NULL),
(812, 'paso 4', NULL, NULL),
(813, 'paso 1', NULL, NULL),
(814, 'paso 4', NULL, NULL),
(815, 'paso 1', NULL, NULL),
(816, 'paso 4', NULL, NULL),
(817, 'paso 1', NULL, NULL),
(818, 'paso 4', NULL, NULL),
(819, 'paso 1', NULL, NULL),
(820, 'paso 4', NULL, NULL),
(821, 'paso 1', NULL, NULL),
(822, 'paso 4', NULL, NULL),
(823, 'paso 1', NULL, NULL),
(824, 'paso 4', NULL, NULL),
(825, 'paso 1', NULL, NULL),
(826, 'paso 4', NULL, NULL),
(827, 'paso 1', NULL, NULL),
(828, 'paso 4', NULL, NULL),
(829, 'paso 1', NULL, NULL),
(830, 'paso 4', NULL, NULL),
(831, 'paso 1', NULL, NULL),
(832, 'paso 4', NULL, NULL),
(833, 'paso 1', NULL, NULL),
(834, 'paso 4', NULL, NULL),
(835, 'paso 1', NULL, NULL),
(836, 'paso 4', NULL, NULL),
(837, 'paso 1', NULL, NULL),
(838, 'paso 4', NULL, NULL),
(839, 'paso 1', NULL, NULL),
(840, 'paso 4', NULL, NULL),
(841, 'paso 1', NULL, NULL),
(842, 'paso 4', NULL, NULL),
(843, 'paso 1', NULL, NULL),
(844, 'paso 4', NULL, NULL),
(845, 'paso 1', NULL, NULL),
(846, 'paso 4', NULL, NULL),
(847, 'paso 1', NULL, NULL),
(848, 'paso 4', NULL, NULL),
(849, 'paso 1', NULL, NULL),
(850, 'paso 4', NULL, NULL),
(851, 'paso 1', NULL, NULL),
(852, 'paso 4', NULL, NULL),
(853, 'paso 1', NULL, NULL),
(854, 'paso 4', NULL, NULL),
(855, 'paso 1', NULL, NULL),
(856, 'paso 4', NULL, NULL),
(857, 'paso 1', NULL, NULL),
(858, 'paso 4', NULL, NULL),
(859, 'paso 1', NULL, NULL),
(860, 'paso 4', NULL, NULL),
(861, 'paso 1', NULL, NULL),
(862, 'paso 4', NULL, NULL),
(863, 'paso 1', NULL, NULL),
(864, 'paso 4', NULL, NULL),
(865, 'paso 1', NULL, NULL),
(866, 'paso 4', NULL, NULL),
(867, 'paso 1', NULL, NULL),
(868, 'paso 4', NULL, NULL),
(869, 'paso 1', NULL, NULL),
(870, 'paso 4', NULL, NULL),
(871, 'paso 1', NULL, NULL),
(872, 'paso 4', NULL, NULL),
(873, 'paso 1', NULL, NULL),
(874, 'paso 4', NULL, NULL),
(875, 'paso 1', NULL, NULL),
(876, 'paso 4', NULL, NULL),
(877, 'paso 1', NULL, NULL),
(878, 'paso 4', NULL, NULL),
(879, 'paso 1', NULL, NULL),
(880, 'paso 4', NULL, NULL),
(881, 'paso 1', NULL, NULL),
(882, 'paso 4', NULL, NULL),
(883, 'paso 1', NULL, NULL),
(884, 'paso 4', NULL, NULL),
(885, 'paso 1', NULL, NULL),
(886, 'paso 4', NULL, NULL),
(887, 'paso 1', NULL, NULL),
(888, 'paso 4', NULL, NULL),
(889, 'paso 1', NULL, NULL),
(890, 'paso 4', NULL, NULL),
(891, 'paso 1', NULL, NULL),
(892, 'paso 4', NULL, NULL),
(893, 'paso 1', NULL, NULL),
(894, 'paso 4', NULL, NULL),
(895, 'paso 1', NULL, NULL),
(896, 'paso 4', NULL, NULL),
(897, 'paso 1', NULL, NULL),
(898, 'paso 4', NULL, NULL),
(899, 'paso 1', NULL, NULL),
(900, 'paso 4', NULL, NULL),
(901, 'paso 1', NULL, NULL),
(902, 'paso 4', NULL, NULL),
(903, 'paso 1', NULL, NULL),
(904, 'paso 4', NULL, NULL),
(905, 'paso 1', NULL, NULL),
(906, 'paso 4', NULL, NULL),
(907, 'paso 1', NULL, NULL),
(908, 'paso 4', NULL, NULL),
(909, 'paso 1', NULL, NULL),
(910, 'paso 4', NULL, NULL),
(911, 'paso 1', NULL, NULL),
(912, 'paso 4', NULL, NULL),
(913, 'paso 1', NULL, NULL),
(914, 'paso 4', NULL, NULL),
(915, 'paso 1', NULL, NULL),
(916, 'paso 4', NULL, NULL),
(917, 'paso 1', NULL, NULL),
(918, 'paso 4', NULL, NULL),
(919, 'paso 1', NULL, NULL),
(920, 'paso 4', NULL, NULL),
(921, 'paso 1', NULL, NULL),
(922, 'paso 4', NULL, NULL),
(923, 'paso 1', NULL, NULL),
(924, 'paso 4', NULL, NULL),
(925, 'paso 1', NULL, NULL),
(926, 'paso 4', NULL, NULL),
(927, 'paso 1', NULL, NULL),
(928, 'paso 4', NULL, NULL),
(929, 'paso 1', NULL, NULL),
(930, 'paso 4', NULL, NULL),
(931, 'paso 1', NULL, NULL),
(932, 'paso 4', NULL, NULL),
(933, 'paso 1', NULL, NULL),
(934, 'paso 4', NULL, NULL),
(935, 'paso 1', NULL, NULL),
(936, 'paso 4', NULL, NULL),
(937, 'paso 1', NULL, NULL),
(938, 'paso 4', NULL, NULL),
(939, 'paso 1', NULL, NULL),
(940, 'paso 4', NULL, NULL),
(941, 'paso 1', NULL, NULL),
(942, 'paso 4', NULL, NULL),
(943, 'paso 1', NULL, NULL),
(944, 'paso 4', NULL, NULL),
(945, 'paso 1', NULL, NULL),
(946, 'paso 4', NULL, NULL),
(947, 'paso 1', NULL, NULL),
(948, 'paso 4', NULL, NULL),
(949, 'paso 1', NULL, NULL),
(950, 'paso 4', NULL, NULL),
(951, 'paso 1', NULL, NULL),
(952, 'paso 4', NULL, NULL),
(953, 'paso 1', NULL, NULL),
(954, 'paso 4', NULL, NULL),
(955, 'paso 1', NULL, NULL),
(956, 'paso 4', NULL, NULL),
(957, 'paso 1', NULL, NULL),
(958, 'paso 4', NULL, NULL),
(959, 'paso 1', NULL, NULL),
(960, 'paso 4', NULL, NULL),
(961, 'paso 1', NULL, NULL),
(962, 'paso 4', NULL, NULL),
(963, 'paso 1', NULL, NULL),
(964, 'paso 4', NULL, NULL),
(965, 'paso 1', NULL, NULL),
(966, 'paso 4', NULL, NULL),
(967, 'paso 1', NULL, NULL),
(968, 'paso 4', NULL, NULL),
(969, 'paso 1', NULL, NULL),
(970, 'paso 4', NULL, NULL),
(971, 'paso 1', NULL, NULL),
(972, 'paso 4', NULL, NULL),
(973, 'paso 1', NULL, NULL),
(974, 'paso 4', NULL, NULL),
(975, 'paso 1', NULL, NULL),
(976, 'paso 4', NULL, NULL),
(977, 'paso 1', NULL, NULL),
(978, 'paso 4', NULL, NULL),
(979, 'paso 1', NULL, NULL),
(980, 'paso 4', NULL, NULL),
(981, 'paso 1', NULL, NULL),
(982, 'paso 4', NULL, NULL),
(983, 'paso 1', NULL, NULL),
(984, 'paso 4', NULL, NULL),
(985, 'paso 1', NULL, NULL),
(986, 'paso 4', NULL, NULL),
(987, 'paso 1', NULL, NULL),
(988, 'paso 4', NULL, NULL),
(989, 'paso 1', NULL, NULL),
(990, 'paso 4', NULL, NULL),
(991, 'paso 1', NULL, NULL),
(992, 'paso 4', NULL, NULL),
(993, 'paso 1', NULL, NULL),
(994, 'paso 4', NULL, NULL),
(995, 'paso 1', NULL, NULL),
(996, 'paso 4', NULL, NULL),
(997, 'paso 1', NULL, NULL),
(998, 'paso 4', NULL, NULL),
(999, 'paso 1', NULL, NULL),
(1000, 'paso 4', NULL, NULL),
(1001, 'paso 1', NULL, NULL),
(1002, 'paso 4', NULL, NULL),
(1003, 'paso 1', NULL, NULL),
(1004, 'paso 4', NULL, NULL),
(1005, 'paso 1', NULL, NULL),
(1006, 'paso 4', NULL, NULL),
(1007, 'paso 1', NULL, NULL),
(1008, 'paso 4', NULL, NULL),
(1009, 'paso 1', NULL, NULL),
(1010, 'paso 4', NULL, NULL),
(1011, 'paso 1', NULL, NULL),
(1012, 'paso 4', NULL, NULL),
(1013, 'paso 1', NULL, NULL),
(1014, 'paso 4', NULL, NULL),
(1015, 'paso 1', NULL, NULL),
(1016, 'paso 4', NULL, NULL),
(1017, 'paso 1', NULL, NULL),
(1018, 'paso 4', NULL, NULL),
(1019, 'paso 1', NULL, NULL),
(1020, 'paso 4', NULL, NULL),
(1021, 'paso 1', NULL, NULL),
(1022, 'paso 4', NULL, NULL),
(1023, 'paso 1', NULL, NULL),
(1024, 'paso 4', NULL, NULL),
(1025, 'paso 1', NULL, NULL),
(1026, 'paso 4', NULL, NULL),
(1027, 'paso 1', NULL, NULL),
(1028, 'paso 4', NULL, NULL),
(1029, 'paso 1', NULL, NULL),
(1030, 'paso 4', NULL, NULL),
(1031, 'paso 1', NULL, NULL),
(1032, 'paso 4', NULL, NULL),
(1033, 'paso 1', NULL, NULL),
(1034, 'paso 4', NULL, NULL),
(1035, 'paso 1', NULL, NULL),
(1036, 'paso 4', NULL, NULL),
(1037, 'paso 1', NULL, NULL),
(1038, 'paso 4', NULL, NULL),
(1039, 'paso 1', NULL, NULL),
(1040, 'paso 4', NULL, NULL),
(1041, 'paso 1', NULL, NULL),
(1042, 'paso 4', NULL, NULL),
(1043, 'paso 1', NULL, NULL),
(1044, 'paso 4', NULL, NULL),
(1045, 'paso 1', NULL, NULL),
(1046, 'paso 4', NULL, NULL),
(1047, 'paso 1', NULL, NULL),
(1048, 'paso 4', NULL, NULL),
(1049, 'paso 1', NULL, NULL),
(1050, 'paso 4', NULL, NULL),
(1051, 'paso 1', NULL, NULL),
(1052, 'paso 4', NULL, NULL),
(1053, 'paso 1', NULL, NULL),
(1054, 'paso 4', NULL, NULL),
(1055, 'paso 1', NULL, NULL),
(1056, 'paso 4', NULL, NULL),
(1057, 'paso 1', NULL, NULL),
(1058, 'paso 4', NULL, NULL),
(1059, 'paso 1', NULL, NULL),
(1060, 'paso 4', NULL, NULL),
(1061, 'paso 1', NULL, NULL),
(1062, 'paso 4', NULL, NULL),
(1063, 'paso 1', NULL, NULL),
(1064, 'paso 4', NULL, NULL),
(1065, 'paso 1', NULL, NULL),
(1066, 'paso 4', NULL, NULL),
(1067, 'paso 1', NULL, NULL),
(1068, 'paso 4', NULL, NULL),
(1069, 'paso 1', NULL, NULL),
(1070, 'paso 4', NULL, NULL),
(1071, 'paso 1', NULL, NULL),
(1072, 'paso 4', NULL, NULL),
(1073, 'paso 1', NULL, NULL),
(1074, 'paso 4', NULL, NULL),
(1075, 'paso 1', NULL, NULL),
(1076, 'paso 4', NULL, NULL),
(1077, 'paso 1', NULL, NULL),
(1078, 'paso 4', NULL, NULL),
(1079, 'paso 1', NULL, NULL),
(1080, 'paso 4', NULL, NULL),
(1081, 'paso 1', NULL, NULL),
(1082, 'paso 4', NULL, NULL),
(1083, 'paso 1', NULL, NULL),
(1084, 'paso 4', NULL, NULL),
(1085, 'paso 1', NULL, NULL),
(1086, 'paso 4', NULL, NULL),
(1087, 'paso 1', NULL, NULL),
(1088, 'paso 4', NULL, NULL),
(1089, 'paso 1', NULL, NULL),
(1090, 'paso 4', NULL, NULL),
(1091, 'paso 1', NULL, NULL),
(1092, 'paso 4', NULL, NULL),
(1093, 'paso 1', NULL, NULL),
(1094, 'paso 4', NULL, NULL),
(1095, 'paso 1', NULL, NULL),
(1096, 'paso 4', NULL, NULL),
(1097, 'paso 1', NULL, NULL),
(1098, 'paso 4', NULL, NULL),
(1099, 'paso 1', NULL, NULL),
(1100, 'paso 4', NULL, NULL),
(1101, 'paso 1', NULL, NULL),
(1102, 'paso 4', NULL, NULL),
(1103, 'paso 1', NULL, NULL),
(1104, 'paso 4', NULL, NULL),
(1105, 'paso 1', NULL, NULL),
(1106, 'paso 4', NULL, NULL),
(1107, 'paso 1', NULL, NULL),
(1108, 'paso 4', NULL, NULL),
(1109, 'paso 1', NULL, NULL),
(1110, 'paso 4', NULL, NULL),
(1111, 'paso 1', NULL, NULL),
(1112, 'paso 4', NULL, NULL),
(1113, 'paso 1', NULL, NULL),
(1114, 'paso 4', NULL, NULL),
(1115, 'paso 1', NULL, NULL),
(1116, 'paso 4', NULL, NULL),
(1117, 'paso 1', NULL, NULL),
(1118, 'paso 4', NULL, NULL),
(1119, 'paso 1', NULL, NULL),
(1120, 'paso 4', NULL, NULL),
(1121, 'paso 1', NULL, NULL),
(1122, 'paso 4', NULL, NULL),
(1123, 'paso 1', NULL, NULL),
(1124, 'paso 4', NULL, NULL),
(1125, 'paso 1', NULL, NULL),
(1126, 'paso 4', NULL, NULL),
(1127, 'paso 1', NULL, NULL),
(1128, 'paso 4', NULL, NULL),
(1129, 'paso 1', NULL, NULL),
(1130, 'paso 4', NULL, NULL),
(1131, 'paso 1', NULL, NULL),
(1132, 'paso 4', NULL, NULL),
(1133, 'paso 1', NULL, NULL),
(1134, 'paso 4', NULL, NULL),
(1135, 'paso 1', NULL, NULL),
(1136, 'paso 4', NULL, NULL),
(1137, 'paso 1', NULL, NULL),
(1138, 'paso 4', NULL, NULL),
(1139, 'paso 1', NULL, NULL),
(1140, 'paso 4', NULL, NULL),
(1141, 'paso 1', NULL, NULL),
(1142, 'paso 4', NULL, NULL),
(1143, 'paso 1', NULL, NULL),
(1144, 'paso 4', NULL, NULL),
(1145, 'paso 1', NULL, NULL),
(1146, 'paso 4', NULL, NULL),
(1147, 'paso 1', NULL, NULL),
(1148, 'paso 4', NULL, NULL),
(1149, 'paso 1', NULL, NULL),
(1150, 'paso 4', NULL, NULL),
(1151, 'paso 1', NULL, NULL),
(1152, 'paso 4', NULL, NULL),
(1153, 'paso 1', NULL, NULL),
(1154, 'paso 4', NULL, NULL),
(1155, 'paso 1', NULL, NULL),
(1156, 'paso 4', NULL, NULL),
(1157, 'paso 1', NULL, NULL),
(1158, 'paso 4', NULL, NULL),
(1159, 'paso 1', NULL, NULL),
(1160, 'paso 4', NULL, NULL),
(1161, 'paso 1', NULL, NULL),
(1162, 'paso 4', NULL, NULL),
(1163, 'paso 1', NULL, NULL),
(1164, 'paso 4', NULL, NULL),
(1165, 'paso 1', NULL, NULL),
(1166, 'paso 4', NULL, NULL),
(1167, 'paso 1', NULL, NULL),
(1168, 'paso 4', NULL, NULL),
(1169, 'paso 1', NULL, NULL),
(1170, 'paso 4', NULL, NULL),
(1171, 'paso 1', NULL, NULL),
(1172, 'paso 4', NULL, NULL),
(1173, 'paso 1', NULL, NULL),
(1174, 'paso 4', NULL, NULL),
(1175, 'paso 1', NULL, NULL),
(1176, 'paso 4', NULL, NULL),
(1177, 'paso 1', NULL, NULL),
(1178, 'paso 4', NULL, NULL),
(1179, 'paso 1', NULL, NULL),
(1180, 'paso 4', NULL, NULL),
(1181, 'paso 1', NULL, NULL),
(1182, 'paso 4', NULL, NULL),
(1183, 'paso 1', NULL, NULL),
(1184, 'paso 4', NULL, NULL),
(1185, 'paso 1', NULL, NULL),
(1186, 'paso 4', NULL, NULL),
(1187, 'paso 1', NULL, NULL),
(1188, 'paso 4', NULL, NULL),
(1189, 'paso 1', NULL, NULL),
(1190, 'paso 4', NULL, NULL),
(1191, 'paso 1', NULL, NULL),
(1192, 'paso 4', NULL, NULL),
(1193, 'paso 1', NULL, NULL),
(1194, 'paso 4', NULL, NULL),
(1195, 'paso 1', NULL, NULL),
(1196, 'paso 4', NULL, NULL),
(1197, 'paso 1', NULL, NULL),
(1198, 'paso 4', NULL, NULL),
(1199, 'paso 1', NULL, NULL),
(1200, 'paso 4', NULL, NULL),
(1201, 'paso 1', NULL, NULL),
(1202, 'paso 4', NULL, NULL),
(1203, 'paso 1', NULL, NULL),
(1204, 'paso 4', NULL, NULL),
(1205, 'paso 1', NULL, NULL),
(1206, 'paso 4', NULL, NULL),
(1207, 'paso 1', NULL, NULL),
(1208, 'paso 4', NULL, NULL),
(1209, 'paso 1', NULL, NULL),
(1210, 'paso 4', NULL, NULL),
(1211, 'paso 1', NULL, NULL),
(1212, 'paso 4', NULL, NULL),
(1213, 'paso 1', NULL, NULL),
(1214, 'paso 4', NULL, NULL),
(1215, 'paso 1', NULL, NULL),
(1216, 'paso 4', NULL, NULL),
(1217, 'paso 1', NULL, NULL),
(1218, 'paso 4', NULL, NULL),
(1219, 'paso 1', NULL, NULL),
(1220, 'paso 4', NULL, NULL),
(1221, 'paso 1', NULL, NULL),
(1222, 'paso 4', NULL, NULL),
(1223, 'paso 1', NULL, NULL),
(1224, 'paso 4', NULL, NULL),
(1225, 'paso 1', NULL, NULL),
(1226, 'paso 4', NULL, NULL),
(1227, 'paso 1', NULL, NULL),
(1228, 'paso 4', NULL, NULL),
(1229, 'paso 1', NULL, NULL),
(1230, 'paso 4', NULL, NULL),
(1231, 'paso 1', NULL, NULL),
(1232, 'paso 4', NULL, NULL),
(1233, 'paso 1', NULL, NULL),
(1234, 'paso 4', NULL, NULL),
(1235, 'paso 1', NULL, NULL),
(1236, 'paso 4', NULL, NULL),
(1237, 'paso 1', NULL, NULL),
(1238, 'paso 4', NULL, NULL),
(1239, 'paso 1', NULL, NULL),
(1240, 'paso 4', NULL, NULL),
(1241, 'paso 1', NULL, NULL),
(1242, 'paso 4', NULL, NULL),
(1243, 'paso 1', NULL, NULL),
(1244, 'paso 4', NULL, NULL),
(1245, 'paso 1', NULL, NULL),
(1246, 'paso 4', NULL, NULL),
(1247, 'paso 1', NULL, NULL),
(1248, 'paso 4', NULL, NULL),
(1249, 'paso 1', NULL, NULL),
(1250, 'paso 4', NULL, NULL),
(1251, 'paso 1', NULL, NULL),
(1252, 'paso 4', NULL, NULL),
(1253, 'paso 1', NULL, NULL),
(1254, 'paso 4', NULL, NULL),
(1255, 'paso 1', NULL, NULL),
(1256, 'paso 4', NULL, NULL),
(1257, 'paso 1', NULL, NULL),
(1258, 'paso 4', NULL, NULL),
(1259, 'paso 1', NULL, NULL),
(1260, 'paso 4', NULL, NULL),
(1261, 'paso 1', NULL, NULL),
(1262, 'paso 4', NULL, NULL),
(1263, 'paso 1', NULL, NULL),
(1264, 'paso 4', NULL, NULL),
(1265, 'paso 1', NULL, NULL),
(1266, 'paso 4', NULL, NULL),
(1267, 'paso 1', NULL, NULL),
(1268, 'paso 4', NULL, NULL),
(1269, 'paso 1', NULL, NULL),
(1270, 'paso 4', NULL, NULL),
(1271, 'paso 1', NULL, NULL),
(1272, 'paso 4', NULL, NULL),
(1273, 'paso 1', NULL, NULL),
(1274, 'paso 4', NULL, NULL),
(1275, 'paso 1', NULL, NULL),
(1276, 'paso 4', NULL, NULL),
(1277, 'paso 1', NULL, NULL),
(1278, 'paso 4', NULL, NULL),
(1279, 'paso 1', NULL, NULL),
(1280, 'paso 4', NULL, NULL),
(1281, 'paso 1', NULL, NULL),
(1282, 'paso 4', NULL, NULL),
(1283, 'paso 1', NULL, NULL),
(1284, 'paso 4', NULL, NULL),
(1285, 'paso 1', NULL, NULL),
(1286, 'paso 4', NULL, NULL),
(1287, 'paso 1', NULL, NULL),
(1288, 'paso 4', NULL, NULL),
(1289, 'paso 1', NULL, NULL),
(1290, 'paso 4', NULL, NULL),
(1291, 'paso 1', NULL, NULL),
(1292, 'paso 4', NULL, NULL),
(1293, 'paso 1', NULL, NULL),
(1294, 'paso 4', NULL, NULL),
(1295, 'paso 1', NULL, NULL),
(1296, 'paso 4', NULL, NULL),
(1297, 'paso 1', NULL, NULL),
(1298, 'paso 4', NULL, NULL),
(1299, 'paso 1', NULL, NULL),
(1300, 'paso 4', NULL, NULL),
(1301, 'paso 1', NULL, NULL),
(1302, 'paso 4', NULL, NULL),
(1303, 'paso 1', NULL, NULL),
(1304, 'paso 4', NULL, NULL),
(1305, 'paso 1', NULL, NULL),
(1306, 'paso 4', NULL, NULL),
(1307, 'paso 1', NULL, NULL),
(1308, 'paso 4', NULL, NULL),
(1309, 'paso 1', NULL, NULL),
(1310, 'paso 4', NULL, NULL),
(1311, 'paso 1', NULL, NULL),
(1312, 'paso 4', NULL, NULL),
(1313, 'paso 1', NULL, NULL),
(1314, 'paso 4', NULL, NULL),
(1315, 'paso 1', NULL, NULL),
(1316, 'paso 4', NULL, NULL),
(1317, 'paso 1', NULL, NULL),
(1318, 'paso 4', NULL, NULL),
(1319, 'paso 1', NULL, NULL),
(1320, 'paso 4', NULL, NULL),
(1321, 'paso 1', NULL, NULL),
(1322, 'paso 4', NULL, NULL),
(1323, 'paso 1', NULL, NULL),
(1324, 'paso 4', NULL, NULL),
(1325, 'paso 1', NULL, NULL),
(1326, 'paso 4', NULL, NULL),
(1327, 'paso 1', NULL, NULL),
(1328, 'paso 4', NULL, NULL),
(1329, 'paso 1', NULL, NULL),
(1330, 'paso 4', NULL, NULL),
(1331, 'paso 1', NULL, NULL),
(1332, 'paso 4', NULL, NULL),
(1333, 'paso 1', NULL, NULL),
(1334, 'paso 4', NULL, NULL),
(1335, 'paso 1', NULL, NULL),
(1336, 'paso 4', NULL, NULL),
(1337, 'paso 1', NULL, NULL),
(1338, 'paso 4', NULL, NULL),
(1339, 'paso 1', NULL, NULL),
(1340, 'paso 4', NULL, NULL),
(1341, 'paso 1', NULL, NULL),
(1342, 'paso 4', NULL, NULL),
(1343, 'paso 1', NULL, NULL),
(1344, 'paso 4', NULL, NULL),
(1345, 'paso 1', NULL, NULL),
(1346, 'paso 4', NULL, NULL),
(1347, 'paso 1', NULL, NULL),
(1348, 'paso 4', NULL, NULL),
(1349, 'paso 1', NULL, NULL),
(1350, 'paso 4', NULL, NULL),
(1351, 'paso 1', NULL, NULL),
(1352, 'paso 4', NULL, NULL),
(1353, 'paso 1', NULL, NULL),
(1354, 'paso 4', NULL, NULL),
(1355, 'paso 1', NULL, NULL),
(1356, 'paso 4', NULL, NULL),
(1357, 'paso 1', NULL, NULL),
(1358, 'paso 4', NULL, NULL),
(1359, 'paso 1', NULL, NULL),
(1360, 'paso 4', NULL, NULL),
(1361, 'paso 1', NULL, NULL),
(1362, 'paso 4', NULL, NULL),
(1363, 'paso 1', NULL, NULL),
(1364, 'paso 4', NULL, NULL),
(1365, 'paso 1', NULL, NULL),
(1366, 'paso 4', NULL, NULL),
(1367, 'paso 1', NULL, NULL),
(1368, 'paso 4', NULL, NULL),
(1369, 'paso 1', NULL, NULL),
(1370, 'paso 4', NULL, NULL),
(1371, 'paso 1', NULL, NULL),
(1372, 'paso 4', NULL, NULL),
(1373, 'paso 1', NULL, NULL),
(1374, 'paso 4', NULL, NULL),
(1375, 'paso 1', NULL, NULL),
(1376, 'paso 4', NULL, NULL),
(1377, 'paso 1', NULL, NULL),
(1378, 'paso 4', NULL, NULL),
(1379, 'paso 1', NULL, NULL),
(1380, 'paso 4', NULL, NULL),
(1381, 'paso 1', NULL, NULL),
(1382, 'paso 4', NULL, NULL),
(1383, 'paso 1', NULL, NULL),
(1384, 'paso 4', NULL, NULL),
(1385, 'paso 1', NULL, NULL),
(1386, 'paso 4', NULL, NULL),
(1387, 'paso 1', NULL, NULL),
(1388, 'paso 4', NULL, NULL),
(1389, 'paso 1', NULL, NULL),
(1390, 'paso 4', NULL, NULL),
(1391, 'paso 1', NULL, NULL),
(1392, 'paso 4', NULL, NULL),
(1393, 'paso 1', NULL, NULL),
(1394, 'paso 4', NULL, NULL),
(1395, 'paso 1', NULL, NULL),
(1396, 'paso 4', NULL, NULL),
(1397, 'paso 1', NULL, NULL),
(1398, 'paso 4', NULL, NULL),
(1399, 'paso 1', NULL, NULL),
(1400, 'paso 4', NULL, NULL),
(1401, 'paso 1', NULL, NULL),
(1402, 'paso 4', NULL, NULL),
(1403, 'paso 1', NULL, NULL),
(1404, 'paso 4', NULL, NULL),
(1405, 'paso 1', NULL, NULL),
(1406, 'paso 4', NULL, NULL),
(1407, 'paso 1', NULL, NULL),
(1408, 'paso 4', NULL, NULL),
(1409, 'paso 1', NULL, NULL),
(1410, 'paso 4', NULL, NULL),
(1411, 'paso 1', NULL, NULL),
(1412, 'paso 4', NULL, NULL),
(1413, 'paso 1', NULL, NULL),
(1414, 'paso 4', NULL, NULL),
(1415, 'paso 1', NULL, NULL),
(1416, 'paso 4', NULL, NULL),
(1417, 'paso 1', NULL, NULL),
(1418, 'paso 4', NULL, NULL),
(1419, 'paso 1', NULL, NULL),
(1420, 'paso 4', NULL, NULL),
(1421, 'paso 1', NULL, NULL),
(1422, 'paso 4', NULL, NULL),
(1423, 'paso 1', NULL, NULL),
(1424, 'paso 4', NULL, NULL),
(1425, 'paso 1', NULL, NULL),
(1426, 'paso 4', NULL, NULL),
(1427, 'paso 1', NULL, NULL),
(1428, 'paso 4', NULL, NULL),
(1429, 'paso 1', NULL, NULL),
(1430, 'paso 4', NULL, NULL),
(1431, 'paso 1', NULL, NULL),
(1432, 'paso 4', NULL, NULL),
(1433, 'paso 1', NULL, NULL),
(1434, 'paso 4', NULL, NULL),
(1435, 'paso 1', NULL, NULL),
(1436, 'paso 4', NULL, NULL),
(1437, 'paso 1', NULL, NULL),
(1438, 'paso 4', NULL, NULL),
(1439, 'paso 1', NULL, NULL),
(1440, 'paso 4', NULL, NULL),
(1441, 'paso 1', NULL, NULL),
(1442, 'paso 4', NULL, NULL),
(1443, 'paso 1', NULL, NULL),
(1444, 'paso 4', NULL, NULL),
(1445, 'paso 1', NULL, NULL),
(1446, 'paso 4', NULL, NULL),
(1447, 'paso 1', NULL, NULL),
(1448, 'paso 4', NULL, NULL),
(1449, 'paso 1', NULL, NULL),
(1450, 'paso 4', NULL, NULL),
(1451, 'paso 1', NULL, NULL),
(1452, 'paso 4', NULL, NULL),
(1453, 'paso 1', NULL, NULL),
(1454, 'paso 4', NULL, NULL),
(1455, 'paso 1', NULL, NULL),
(1456, 'paso 4', NULL, NULL),
(1457, 'paso 1', NULL, NULL),
(1458, 'paso 4', NULL, NULL),
(1459, 'paso 1', NULL, NULL),
(1460, 'paso 4', NULL, NULL),
(1461, 'paso 1', NULL, NULL),
(1462, 'paso 4', NULL, NULL),
(1463, 'paso 1', NULL, NULL),
(1464, 'paso 4', NULL, NULL),
(1465, 'paso 1', NULL, NULL),
(1466, 'paso 4', NULL, NULL),
(1467, 'paso 1', NULL, NULL),
(1468, 'paso 4', NULL, NULL),
(1469, 'paso 1', NULL, NULL),
(1470, 'paso 4', NULL, NULL),
(1471, 'paso 1', NULL, NULL),
(1472, 'paso 4', NULL, NULL),
(1473, 'paso 1', NULL, NULL),
(1474, 'paso 4', NULL, NULL),
(1475, 'paso 1', NULL, NULL),
(1476, 'paso 4', NULL, NULL),
(1477, 'paso 1', NULL, NULL),
(1478, 'paso 4', NULL, NULL),
(1479, 'paso 1', NULL, NULL),
(1480, 'paso 4', NULL, NULL),
(1481, 'paso 1', NULL, NULL),
(1482, 'paso 4', NULL, NULL),
(1483, 'paso 1', NULL, NULL),
(1484, 'paso 4', NULL, NULL),
(1485, 'paso 1', NULL, NULL),
(1486, 'paso 4', NULL, NULL);

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
(63, '2018-10-01 00:00:00', '', '', '96792430', NULL, 11, 3, 56, NULL, '96792430', 19, 57, 56),
(64, '2018-10-30 00:00:00', '', '', '96792430', NULL, 11, 3, 56, NULL, '96792430', 20, 58, 56),
(65, '2020-09-01 00:00:00', 'N/A', 'Retiro Aeropuerto  Septiembre 2020', '96756430', NULL, 12, 7, 70, NULL, '96756430', 27, 71, 70),
(66, '2020-09-01 00:00:00', 'N/A', 'Retiro Aeropuerto Spot Octubre 2020', '96756430', NULL, 12, 7, 70, NULL, '96756430', 33, 71, 70),
(67, '2020-09-01 00:00:00', 'N/A', 'Abastecimiento Local - Septiembre 2020', '96756430', NULL, 12, 7, 72, NULL, '96756430', 28, 73, 72),
(68, '2020-09-01 00:00:00', 'N/A', 'Abastecimiento Spot - Septiembre 2020', '96756430', NULL, 12, 7, 72, NULL, '96756430', 29, 74, 73),
(69, '2020-09-12 00:00:00', 'N/A', 'Retiro Planta GM -  Septiembre 2020', '93515000', NULL, 12, 4, 65, NULL, '93515000', 30, 41, 65),
(70, '2020-09-12 00:00:00', 'N/A', 'Retiro  Planta GM IMO - Septiembre 2020', '93515000', NULL, 12, 4, 75, NULL, '93515000', 31, 41, 75),
(71, '2020-09-01 00:00:00', '', 'Retiro Aeropuerto Spot- Septiembre 2020', '96756430', NULL, 12, 7, 70, NULL, '96756430', 33, 71, 70),
(72, '2020-10-01 00:00:00', '', 'Retiro Aeropuerto - Octubre 2020', '96756430', NULL, 12, 7, 70, NULL, '96756430', 27, 71, 70),
(73, '2020-10-01 00:00:00', '', 'Abastecimiento Local- Octubre 2020', '96756430', NULL, 12, 7, 72, NULL, '96756430', 28, 73, 72),
(74, '2020-10-26 00:00:00', '', 'Abastecimiento Spot- Octubre 2020', '96756430', NULL, 12, 7, 72, NULL, '96756430', 29, 74, 73),
(75, '2020-10-28 00:00:00', 'N/A', 'Retiro Planta GM- Octubre 2020', '93515000', NULL, 12, 4, 65, NULL, '93515000', 30, 41, 65),
(76, '2020-11-01 00:00:00', '', 'Retiro Aeropuerto- Noviembre 2020', '96756430', NULL, 12, 7, 70, NULL, '96756430', 27, 71, 70),
(77, '2020-11-01 00:00:00', 'N/A', 'Retiro Aeropuerto Spot- Noviembre 2020', '96756430', NULL, 12, 7, 70, NULL, '96756430', 33, 71, 70),
(78, '2020-11-01 00:00:00', 'N/A', 'Abastecimiento Local- Noviembre 2020', '96756430', NULL, 12, 7, 72, NULL, '96756430', 28, 73, 73),
(79, '2020-11-01 00:00:00', 'N/A', 'Retiro Planta GM- Noviembre 2020', '93515000', NULL, 12, 4, 65, NULL, '93515000', 30, 41, 65),
(80, '2020-12-01 00:00:00', 'N/A', 'Retiro Aeropuerto- Diciembre 2020', '96756430', NULL, 12, 7, 70, NULL, '96756430', 27, 71, 70),
(81, '2020-12-01 00:00:00', 'N/A', 'Retiro Planta GM - Diciembre 2020', '93515000', NULL, 12, 4, 65, NULL, '93515000', 30, 41, 65),
(82, '2020-12-01 00:00:00', 'N/A', 'Abastecimiento Local - Diciembre 2020', '96756430', NULL, 12, 7, 72, NULL, '96756430', 28, 73, 72),
(83, '2021-01-01 00:00:00', 'N/A', 'Abastecimiento Local- Enero 2021', '96756430', NULL, 12, 7, 72, NULL, '96756430', 28, 73, 72),
(84, '2020-12-01 00:00:00', 'N/A', 'Retiro Aeropuerto Spot- Diciembre 2020', '96756430', NULL, 12, 7, 70, NULL, '96756430', 33, 71, 70),
(85, '2021-01-01 00:00:00', 'N/A', 'Retiro Aeropuerto Spot- Enero 2021', '96756430', NULL, 12, 7, 70, NULL, '96756430', 33, 71, 70),
(86, '2021-01-01 00:00:00', 'N/A', 'Retiro Planta GM- Enero 2021', '93515000', NULL, 12, 4, 65, NULL, '93515000', 30, 41, 65),
(87, '2021-01-01 00:00:00', 'N/A', 'Retiro Aeropuerto- Enero 2021', '96756430', NULL, 12, 7, 70, NULL, '96756430', 27, 71, 70),
(88, '2020-11-01 00:00:00', 'N/A', 'Abastecimiento Local Spot- Noviembre 2020', '96756430', NULL, 12, 7, 72, NULL, '96756430', 29, 74, 77),
(89, '2020-12-01 00:00:00', 'N/A', 'Abastecimiento local spot- Diciembre 2020', '96756430', NULL, 12, 7, 72, NULL, '96756430', 29, 74, 77),
(90, '2021-01-01 00:00:00', 'N/A', 'Retiro Planta GM IMO- Enero 2021', '93515000', NULL, 12, 4, 75, NULL, '93515000', 31, 41, 75),
(91, '2021-02-01 00:00:00', 'N/A', 'Retiro Planta GM- Febrero 2021', '93515000', NULL, 12, 4, 65, NULL, '93515000', 30, 41, 65),
(92, '2021-02-01 00:00:00', 'N/A', 'Retiro en Planta GM IMO- Febrero 2021', '93515000', NULL, 12, 4, 75, NULL, '93515000', 31, 41, 75),
(93, '2021-02-01 00:00:00', 'N/A', 'Abastecimiento Local- Febrero 2021 ', '96756430', NULL, 12, 7, 72, NULL, '96756430', 28, 73, 72),
(94, '2021-02-01 00:00:00', 'N/A', 'Retiro Aeropuerto - Febrero 2021', '96756430', NULL, 12, 7, 70, NULL, '96756430', 27, 71, 70),
(95, '2021-03-01 00:00:00', 'N/A', 'Abastecimiento local- Marzo 2021', '96756430', NULL, 12, 7, 72, NULL, '96756430', 28, 73, 71),
(96, '2021-03-01 00:00:00', 'N/A', 'Retiro Aeropuerto- marzo 2021', '96756430', NULL, 12, 7, 70, NULL, '96756430', 27, 71, 70),
(97, '2021-03-01 00:00:00', 'N/A', 'Retiro en Planta GM- Marzo 2021', '93515000', NULL, 12, 4, 65, NULL, '93515000', 30, 41, 65),
(98, '2022-04-06 00:00:00', '', '', '77233449', NULL, 11, 7, 79, NULL, '77233449', 35, 79, 79),
(99, '2022-04-06 00:00:00', 'N/A', 'asdasdasd', '77233449', NULL, 11, 7, 70, NULL, '77233449', 36, 20, 70),
(100, '2022-04-07 00:00:00', '', '', '77006430', NULL, 11, 6, 70, NULL, '77006430', 38, 71, 70);

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
(156, '\"\"', 502, 56, 57, 70, 31, 29, 40, '2019-09-10 11:00:00', '2019-09-10 14:00:00', 0, 56),
(157, '\"\"', 505, 56, 57, 70, 32, 28, 41, '2020-02-27 18:00:00', '2020-09-30 08:00:00', 0, 55),
(158, '\"\"', 504, 56, 58, 70, 32, 29, 41, '2020-02-27 19:00:00', '2020-02-28 19:00:00', 0, 54),
(159, '\"56 9 6919 2558\"', 506, 70, 71, 72, 33, 30, 42, '2020-09-01 08:00:00', '2020-09-01 18:00:00', 0, 0),
(160, '\"56 9 6919 2558\"', 507, 70, 71, 72, 33, 30, 42, '2020-09-02 08:00:00', '2020-09-02 18:00:00', 0, 0),
(161, '\"56 9 6919 2558\"', 508, 70, 71, 72, 33, 30, 42, '2020-09-03 08:00:00', '2020-09-03 18:00:00', 0, 0),
(162, NULL, 509, 72, 73, 73, NULL, NULL, NULL, '2020-09-01 09:00:00', '2020-09-01 09:00:00', 1, 0),
(163, '\"56 9 88315323\"', 509, 72, 73, 73, 34, 32, 43, '2020-09-01 09:00:00', '2020-09-01 18:00:00', 0, 0),
(164, '\"56 9 39534651\"', 511, 72, 74, 73, 34, 31, 44, '2020-09-02 09:00:00', '2020-09-02 18:00:00', 1, 0),
(165, '\"56 9 88315323\"', 510, 72, 74, 73, 34, 32, 43, '2020-09-01 09:00:00', '2020-09-01 18:00:00', 0, 0),
(166, '\"56 9 88315323\"', 511, 72, 73, 73, 34, 32, 43, '2020-09-02 09:00:00', '2020-09-02 18:00:00', 0, 0),
(167, '\"56 9 88315323\"', 512, 72, 73, 73, 34, 32, 43, '2020-09-03 09:00:00', '2020-09-03 18:00:00', 0, 0),
(168, '\"56 9 39534651\"', 513, 72, 74, 73, 34, 31, 44, '2020-09-02 09:00:00', '2020-09-02 18:00:00', 0, 0),
(169, '\"56 9 39534651\"', 514, 72, 74, 73, 34, 31, 44, '2020-09-03 09:00:00', '2020-09-03 18:00:00', 0, 0),
(170, '\"56 9 6919 2558\"', 517, 70, 71, 72, 33, 30, 42, '2020-09-04 08:00:00', '2020-09-04 18:00:00', 0, 0),
(171, '\"56 9 6919 2558\"', 518, 70, 71, 72, 33, 30, 42, '2020-09-05 08:00:00', '2020-09-05 18:00:00', 0, 0),
(172, '\"56 9 6919 2558\"', 519, 70, 71, 72, 33, 30, 42, '2020-09-07 08:00:00', '2020-09-07 18:00:00', 0, 0),
(173, '\"56 9 88315323\"', 520, 72, 73, 73, 34, 32, 43, '2020-09-04 09:00:00', '2020-09-04 18:00:00', 0, 0),
(174, '\"56 9 88315323\"', 521, 72, 73, 73, 34, 32, 43, '2020-09-07 09:00:00', '2020-09-07 18:00:00', 0, 0),
(175, '\"56 9 6919 2558\"', 527, 70, 71, 72, 33, 30, 42, '2020-09-08 08:00:00', '2020-09-08 18:00:00', 0, 0),
(176, '\"56 9 88315323\"', 522, 72, 73, 73, 34, 32, 43, '2020-09-08 09:00:00', '2020-09-08 18:00:00', 0, 0),
(177, '\"56 9 88315323\"', 523, 72, 73, 73, 34, 32, 43, '2020-09-09 09:00:00', '2020-09-09 18:00:00', 0, 0),
(178, '\"56 9 6919 2558\"', 528, 70, 71, 72, 33, 30, 42, '2020-09-09 08:00:00', '2020-09-09 18:00:00', 0, 0),
(179, '\"56 9 88315323\"', 524, 72, 73, 73, 34, 32, 43, '2020-09-10 09:00:00', '2020-09-10 18:00:00', 0, 0),
(180, '\"56 9 88315323\"', 525, 72, 73, 73, 34, 32, 43, '2020-09-11 09:00:00', '2020-09-11 18:00:00', 0, 0),
(181, '\"56 9 6919 2558\"', 529, 70, 71, 72, 33, 30, 42, '2020-09-10 08:00:00', '2020-09-10 18:00:00', 0, 0),
(182, '\"56 9 6919 2558\"', 530, 70, 71, 72, 33, 30, 42, '2020-09-11 08:00:00', '2020-09-11 18:00:00', 0, 0),
(183, '\"56 9 6919 2558\"', 531, 70, 71, 72, 33, 30, 42, '2020-09-12 08:00:00', '2020-09-12 18:00:00', 0, 0),
(184, '\"56 9 6919 2558\"', 532, 70, 71, 72, 33, 30, 42, '2020-09-14 08:00:00', '2020-09-14 18:00:00', 0, 0),
(185, NULL, 536, 72, 71, 0, NULL, NULL, NULL, '2020-09-14 09:00:00', '2020-09-14 09:00:00', 0, 57),
(186, '\"56 9 88315323\"', 537, 72, 73, 73, 34, 32, 43, '2020-09-15 09:00:00', '2020-09-15 18:00:00', 0, 0),
(187, '\"56 9 6919 2558\"', 533, 70, 71, 72, 33, 30, 42, '2020-09-15 08:00:00', '2020-09-15 18:00:00', 0, 0),
(188, '\"56 9 6919 2558\"', 534, 70, 73, 73, 33, 30, 42, '2020-09-16 08:00:00', '2020-09-16 18:00:00', 0, 0),
(189, '\"56 9 88315323\"', 538, 72, 73, 73, 34, 32, 43, '2020-09-16 09:00:00', '2020-09-16 18:00:00', 0, 0),
(190, '\"56 9 6919 2558\"', 535, 70, 71, 72, 33, 30, 42, '2020-09-17 08:00:00', '2020-09-17 18:00:00', 0, 0),
(191, '\"56 9 88315323\"', 539, 72, 73, 73, 34, 32, 43, '2020-09-17 09:00:00', '2020-09-17 18:00:00', 0, 0),
(192, '\"56 (2) 25206210\"', 541, 65, 41, 71, 36, 34, 46, '2020-08-04 00:00:00', '2020-08-04 23:00:00', 0, 0),
(193, '\"56 (2) 25206210\"', 543, 65, 41, 71, 36, 34, 46, '2020-08-07 00:00:00', '2020-08-07 23:00:00', 0, 0),
(194, '\"56 (2) 25206210\"', 544, 65, 41, 71, 36, 34, 46, '2020-08-12 00:00:00', '2020-08-12 23:00:00', 0, 0),
(195, '\"56 (2) 25206210\"', 545, 65, 41, 71, 36, 34, 46, '2020-08-21 00:00:00', '2020-08-21 23:00:00', 0, 0),
(196, '\"56 (2) 25206210\"', 546, 65, 41, 71, 36, 34, 46, '2020-08-24 00:00:00', '2020-08-24 23:00:00', 0, 0),
(197, '\"56 (2) 25206210\"', 547, 65, 41, 71, 36, 34, 46, '2020-09-04 00:00:00', '2020-09-04 23:00:00', 0, 0),
(198, '\"56 (2) 25206210\"', 548, 65, 41, 71, 36, 34, 46, '2020-09-11 00:00:00', '2020-09-11 23:00:00', 0, 0),
(199, '\"56 (2) 25206210\"', 542, 75, 41, 71, 36, 34, 46, '2020-08-06 05:00:00', '2020-08-18 18:00:00', 0, 0),
(200, '\"56 9 6919 2558\"', 551, 70, 71, 72, 33, 30, 42, '2020-09-21 08:00:00', '2020-09-21 18:00:00', 0, 0),
(201, '\"56 9 6919 2558\"', 552, 70, 71, 72, 33, 30, 42, '2020-09-22 08:00:00', '2020-09-22 18:00:00', 0, 0),
(202, '\"56 9 6919 2558\"', 553, 70, 71, 72, 33, 30, 42, '2020-09-23 08:00:00', '2020-09-23 18:00:00', 0, 0),
(203, '\"56 9 6919 2558\"', 554, 70, 71, 72, 33, 30, 42, '2020-09-24 08:00:00', '2020-09-24 18:00:00', 0, 0),
(204, '\"56 9 6919 2558\"', 555, 70, 71, 72, 33, 30, 42, '2020-09-25 08:00:00', '2020-09-25 18:00:00', 0, 0),
(205, '\"56 (2) 26565160\"', 562, 70, 71, 78, 37, 35, 47, '2020-09-17 10:00:00', '2020-09-17 18:00:00', 0, 0),
(206, NULL, 563, 70, 71, 0, NULL, NULL, NULL, '2020-09-17 10:00:00', '2020-09-17 10:00:00', 0, 0),
(207, '\"56 (2) 26565160\"', 556, 70, 71, 78, 37, 35, 47, '2020-09-21 09:00:00', '2020-09-21 18:00:00', 0, 0),
(208, '\"56 9 64395435\"', 564, 70, 71, 79, 38, 39, 48, '2020-09-08 09:00:00', '2020-09-08 18:00:00', 0, 0),
(209, '\"56 9 64395435\"', 565, 70, 71, 79, 38, 39, 48, '2020-09-10 09:00:00', '2020-09-10 18:00:00', 0, 0),
(210, '\"56 9 64395435\"', 566, 70, 71, 79, 38, 39, 48, '2020-09-12 09:00:00', '2020-09-12 18:00:00', 0, 0),
(211, '\"56 9 64395435\"', 567, 70, 71, 79, 38, 39, 48, '2020-09-14 09:00:00', '2020-09-14 18:00:00', 0, 0),
(212, '\"56 9 64395435\"', 568, 70, 71, 79, 38, 39, 48, '2020-09-25 09:00:00', '2020-09-25 18:00:00', 0, 0),
(213, '\"56 9 64395435\"', 569, 70, 71, 79, 38, 39, 48, '2020-09-15 09:00:00', '2020-09-15 18:00:00', 0, 0),
(214, '\"56 9 64395435\"', 570, 70, 71, 79, 38, 39, 48, '2020-09-16 09:00:00', '2020-09-16 18:00:00', 0, 0),
(215, '\"56 9 64395435\"', 571, 70, 71, 79, 38, 39, 48, '2020-09-28 09:00:00', '2020-09-28 18:00:00', 0, 0),
(216, '\"56 9 64395435\"', 572, 70, 71, 79, 38, 39, 48, '2020-09-29 09:00:00', '2020-09-29 18:00:00', 0, 0),
(217, '\"56 9 64395435\"', 573, 70, 71, 79, 38, 39, 48, '2020-09-30 09:00:00', '2020-09-30 18:00:00', 0, 0),
(218, '56 9 8831 5323', 577, 72, 73, 80, 39, 42, 51, '2020-09-21 08:00:00', '2020-09-21 18:00:00', 0, 59),
(219, '56 9 8831 5323', 578, 72, 73, 80, 39, 42, 51, '2020-09-22 08:00:00', '2020-09-22 18:00:00', 0, 60),
(220, '56 9 8831 5323', 579, 72, 73, 80, 39, 42, 51, '2020-09-23 08:00:00', '2020-09-23 18:00:00', 0, 61),
(221, '56 9 8831 5323', 580, 72, 73, 80, 39, 42, 51, '2020-09-24 08:00:00', '2020-09-24 18:00:00', 0, 62),
(222, '56 9 8831 5323', 581, 72, 73, 80, 39, 42, 51, '2020-09-28 08:00:00', '2020-09-28 18:00:00', 0, 63),
(223, '56 9 8831 5323', 582, 72, 73, 80, 39, 42, 51, '2020-09-29 08:00:00', '2020-09-29 18:00:00', 0, 64),
(224, '569 8831 5323', 583, 72, 73, 80, 39, 42, 51, '2020-09-30 08:00:00', '2020-09-30 18:00:00', 0, 65),
(225, '\"56 9 6919 2558\"', 592, 70, 71, 72, 33, 30, 42, '2020-09-26 09:00:00', '2020-09-26 18:00:00', 0, 0),
(226, '\"56 9 6919 2558\"', 594, 70, 71, 72, 33, 30, 42, '2020-09-26 09:00:00', '2020-09-26 18:00:00', 0, 0),
(227, '\"56 9 6919 2558\"', 595, 70, 71, 72, 33, 30, 42, '2020-09-28 09:00:00', '2020-09-28 18:00:00', 0, 0),
(228, '\"56 9 6919 2558\"', 596, 70, 71, 72, 33, 30, 42, '2020-09-29 09:00:00', '2020-09-29 18:00:00', 0, 0),
(229, '\"56 9 6919 2558\"', 597, 70, 71, 72, 33, 30, 42, '2020-09-30 09:00:00', '2020-09-30 18:00:00', 0, 0),
(230, '\"56 9 6919 2558\"', 598, 70, 71, 72, 33, 30, 42, '2020-09-21 09:00:00', '2020-09-21 18:00:00', 0, 0),
(231, '\"56 9 6919 2558\"', 599, 70, 71, 72, 33, 30, 42, '2020-09-26 09:00:00', '2020-09-26 18:00:00', 0, 0),
(232, '\"56 9 6919 2558\"', 600, 70, 71, 72, 33, 30, 42, '2020-09-28 09:00:00', '2020-09-28 18:00:00', 0, 0),
(233, '\"56 9 6919 2558\"', 601, 70, 71, 72, 33, 30, 42, '2020-09-29 09:00:00', '2020-09-29 18:00:00', 0, 0),
(234, '\"56 9 6919 2558\"', 602, 70, 71, 72, 33, 30, 42, '2020-09-30 09:00:00', '2020-09-30 18:00:00', 0, 0),
(235, NULL, 603, 70, 71, 79, NULL, NULL, NULL, '2020-10-01 09:00:00', '2020-10-01 09:00:00', 1, 0),
(236, '\"56 9 64395435\"', 603, 70, 71, 79, 38, 39, 48, '2020-10-01 09:00:00', '2020-10-01 18:00:00', 0, 0),
(237, '\"56 9 64395435\"', 604, 70, 71, 79, 38, 39, 48, '2020-10-02 09:00:00', '2020-10-02 18:00:00', 0, 0),
(238, '\"56 9 6919 2558\"', 605, 70, 71, 72, 33, 30, 42, '2020-10-01 08:00:00', '2020-10-01 18:00:00', 0, 0),
(239, '\"56 9 6919 2558\"', 606, 70, 71, 72, 33, 30, 42, '2020-10-02 05:00:00', '2020-10-02 13:00:00', 0, 0),
(240, '\"56 9 8913 8998\"', 607, 70, 71, 72, 33, 46, 42, '2020-10-02 13:00:00', '2020-10-02 21:00:00', 0, 0),
(241, NULL, 608, 70, 71, 72, NULL, NULL, NULL, '2020-10-04 05:00:00', '2020-10-04 05:00:00', 1, 0),
(242, '\"56 9 6919 2558\"', 608, 70, 71, 72, 33, 30, 42, '2020-10-03 09:00:00', '2020-10-03 16:00:00', 0, 0),
(243, '\"56 9 6919 2558\"', 609, 70, 71, 72, 33, 30, 42, '2020-10-04 09:00:00', '2020-10-04 16:00:00', 0, 0),
(244, '\"56 9 6919 2558\"', 610, 70, 71, 72, 33, 30, 42, '2020-10-05 05:00:00', '2020-10-05 13:00:00', 0, 0),
(245, '\"56 9 8913 8998\"', 611, 70, 71, 72, 33, 46, 42, '2020-10-05 13:00:00', '2020-10-05 21:00:00', 0, 0),
(246, '\"56 9 6919 2558\"', 612, 70, 71, 72, 33, 30, 42, '2020-10-06 05:00:00', '2020-10-06 13:00:00', 0, 0),
(247, '\"56 9 8913 8998\"', 613, 70, 71, 72, 33, 46, 42, '2020-10-06 13:00:00', '2020-10-06 21:00:00', 0, 0),
(248, '\"56 9 6919 2558\"', 614, 70, 71, 72, 33, 30, 42, '2020-10-07 05:00:00', '2020-10-07 13:00:00', 0, 0),
(249, '\"56 9 8913 8998\"', 615, 70, 71, 72, 33, 46, 42, '2020-10-07 05:00:00', '2020-10-07 13:00:00', 0, 0),
(250, '\"56 9 6919 2558\"', 616, 70, 71, 72, 33, 30, 42, '2020-10-08 05:00:00', '2020-10-08 13:00:00', 0, 0),
(251, '\"56 9 8913 8998\"', 617, 70, 71, 72, 33, 46, 42, '2020-10-08 13:00:00', '2020-10-08 21:00:00', 0, 0),
(252, '\"56 9 6919 2558\"', 618, 70, 71, 72, 33, 30, 42, '2020-10-09 05:00:00', '2020-10-09 13:00:00', 0, 0),
(253, '\"56 9 8913 8998\"', 619, 70, 71, 72, 33, 46, 42, '2020-10-09 13:00:00', '2020-10-09 21:00:00', 0, 0),
(254, '\"56 9 8913 8998\"', 620, 70, 71, 72, 33, 46, 42, '2020-10-10 09:00:00', '2020-10-10 16:00:00', 0, 0),
(255, '\"56 9 8913 8998\"', 621, 70, 71, 72, 33, 46, 42, '2020-10-11 09:00:00', '2020-10-11 16:00:00', 0, 0),
(256, '\"56 9 8913 8998\"', 622, 70, 71, 72, 33, 46, 42, '2020-10-12 09:00:00', '2020-10-12 16:00:00', 0, 0),
(257, '\"56 9 8913 8998\"', 623, 70, 71, 72, 33, 46, 42, '2020-10-13 05:00:00', '2020-10-13 13:00:00', 0, 0),
(258, '\"56 9 6919 2558\"', 624, 70, 71, 72, 33, 30, 42, '2020-10-13 13:00:00', '2020-10-13 21:00:00', 0, 0),
(259, '569 8831 5323', 625, 72, 73, 80, 39, 42, 51, '2020-10-01 08:00:00', '2020-10-01 18:00:00', 0, 66),
(260, '569 8831 5323', 626, 72, 73, 80, 39, 42, 51, '2020-10-02 08:00:00', '2020-10-02 18:00:00', 0, 67),
(261, '569 8831 5323', 627, 72, 73, 80, 39, 42, 51, '2020-10-05 08:00:00', '2020-10-05 18:00:00', 0, 68),
(262, '569 8831 5323', 628, 72, 73, 80, 39, 42, 51, '2020-10-06 08:00:00', '2020-10-06 18:00:00', 0, 69),
(263, '569 8831 5323', 629, 72, 73, 80, 39, 42, 51, '2020-10-07 08:00:00', '2020-10-07 18:00:00', 0, 70),
(264, '569 8831 5323', 630, 72, 73, 80, 39, 42, 51, '2020-10-08 08:00:00', '2020-10-08 18:00:00', 0, 71),
(265, '569 8831 5323', 631, 72, 73, 80, 39, 42, 51, '2020-10-09 08:00:00', '2020-10-09 18:00:00', 0, 72),
(266, '569 8831 5323', 632, 72, 73, 80, 39, 42, 51, '2020-10-19 08:00:00', '2020-10-19 18:00:00', 0, 76),
(267, '569 8831 5323', 633, 72, 73, 80, 39, 42, 51, '2020-10-13 08:00:00', '2020-10-13 18:00:00', 0, 77),
(268, '569 8831 5323', 634, 72, 73, 80, 39, 42, 51, '2020-10-14 08:00:00', '2020-10-14 18:00:00', 0, 73),
(269, '569 8831 5323', 635, 72, 73, 80, 39, 42, 51, '2020-10-15 08:00:00', '2020-10-15 18:00:00', 0, 74),
(270, '569 8831 5323', 636, 72, 73, 80, 39, 42, 51, '2020-10-16 08:00:00', '2020-10-16 18:00:00', 0, 75),
(271, '\"56 9 8913 8998\"', 637, 70, 71, 72, 33, 46, 42, '2020-10-14 05:00:00', '2020-10-14 13:00:00', 0, 0),
(272, '\"56 9 6919 2558\"', 638, 70, 71, 72, 33, 30, 42, '2020-10-14 13:00:00', '2020-10-14 21:00:00', 0, 0),
(273, '\"56 9 8913 8998\"', 639, 70, 71, 72, 33, 46, 42, '2020-10-15 05:00:00', '2020-10-15 13:00:00', 0, 0),
(274, '\"56 9 6919 2558\"', 640, 70, 71, 72, 33, 30, 42, '2020-10-15 13:00:00', '2020-10-15 21:00:00', 0, 0),
(275, '\"56 9 8913 8998\"', 641, 70, 71, 72, 33, 46, 42, '2020-10-16 05:00:00', '2020-10-16 13:00:00', 0, 0),
(276, '\"56 9 6919 2558\"', 642, 70, 71, 72, 33, 30, 42, '2020-10-16 13:00:00', '2020-10-16 21:00:00', 0, 0),
(277, '\"56 9 6919 2558\"', 643, 70, 71, 72, 33, 30, 42, '2020-10-17 09:00:00', '2020-10-17 16:00:00', 0, 0),
(278, '\"56 9 6919 2558\"', 644, 70, 71, 72, 33, 30, 42, '2020-10-18 09:00:00', '2020-10-18 16:00:00', 0, 0),
(279, '\"56 9 6919 2558\"', 645, 70, 71, 72, 33, 30, 42, '2020-10-19 05:00:00', '2020-10-19 13:00:00', 0, 0),
(280, '\"56 9 8913 8998\"', 646, 70, 71, 72, 33, 46, 42, '2020-10-19 13:00:00', '2020-10-19 21:00:00', 0, 0),
(281, '\"56 9 6919 2558\"', 647, 70, 71, 72, 33, 30, 42, '2020-10-20 05:00:00', '2020-10-20 13:00:00', 0, 0),
(282, '\"56 9 8913 8998\"', 648, 70, 71, 72, 33, 46, 42, '2020-10-20 13:00:00', '2020-10-20 21:00:00', 0, 0),
(283, '569 8831 5323', 649, 72, 73, 80, 39, 42, 51, '2020-10-20 08:00:00', '2020-10-20 18:00:00', 0, 78),
(284, '569 8831 5323', 650, 72, 73, 80, 39, 42, 51, '2020-10-21 08:00:00', '2020-10-21 18:00:00', 0, 79),
(285, '569 8831 5323', 651, 72, 73, 80, 39, 42, 51, '2020-10-22 08:00:00', '2020-10-22 18:00:00', 0, 80),
(286, '569 8831 5323', 652, 72, 73, 80, 39, 42, 51, '2020-10-23 08:00:00', '2020-10-23 18:00:00', 0, 81),
(287, '\"56 9 6919 2558\"', 653, 70, 71, 72, 33, 30, 42, '2020-10-21 05:00:00', '2020-10-21 13:00:00', 0, 0),
(288, '\"56 9 8913 8998\"', 654, 70, 71, 72, 33, 46, 42, '2020-10-21 13:00:00', '2020-10-21 21:00:00', 0, 0),
(289, '\"56 9 6919 2558\"', 655, 70, 71, 72, 33, 30, 42, '2020-10-22 05:00:00', '2020-10-22 13:00:00', 0, 0),
(290, '\"56 9 8913 8998\"', 656, 70, 71, 72, 33, 46, 42, '2020-10-22 13:00:00', '2020-10-22 21:00:00', 0, 0),
(291, '\"56 9 6919 2558\"', 657, 70, 71, 72, 33, 30, 42, '2020-10-23 05:00:00', '2020-10-23 13:00:00', 0, 0),
(292, '\"56 9 8913 8998\"', 658, 70, 71, 72, 33, 46, 42, '2020-10-23 13:00:00', '2020-10-23 21:00:00', 0, 0),
(293, '569 8831 5323', 659, 72, 74, 77, 42, 47, 54, '2020-10-23 10:00:00', '2020-10-23 18:00:00', 0, 82),
(294, '\"56 9 8913 8998\"', 660, 70, 71, 72, 33, 46, 42, '2020-10-24 09:00:00', '2020-10-24 16:00:00', 0, 0),
(295, '\"56 9 8913 8998\"', 661, 70, 71, 72, 33, 46, 42, '2020-10-25 09:00:00', '2020-10-25 16:00:00', 0, 0),
(296, '\"56 9 8913 8998\"', 662, 70, 71, 72, 33, 46, 42, '2020-10-26 05:00:00', '2020-10-26 13:00:00', 0, 0),
(297, '\"56 9 6919 2558\"', 663, 70, 71, 72, 33, 30, 42, '2020-10-26 13:00:00', '2020-10-26 21:00:00', 0, 0),
(298, '569 8831 5323', 664, 72, 73, 80, 39, 42, 51, '2020-10-26 08:00:00', '2020-10-26 18:00:00', 0, 83),
(299, '\"56 (2) 25206210\"', 549, 75, 41, 71, 36, 34, 46, '2020-08-11 05:00:00', '2020-08-11 18:00:00', 0, 0),
(300, '\"56 (2) 25206210\"', 550, 75, 41, 71, 36, 34, 46, '2020-09-11 05:00:00', '2020-09-11 18:00:00', 0, 0),
(301, '\"56 (2) 25206210\"', 665, 75, 41, 71, 36, 34, 46, '2020-09-17 05:00:00', '2020-09-17 18:00:00', 0, 0),
(302, '\"56 (2) 25206210\"', 666, 65, 41, 71, 36, 34, 46, '2020-09-11 05:00:00', '2020-09-11 18:00:00', 0, 0),
(303, '\"56 (2) 25206210\"', 667, 65, 41, 71, 36, 34, 46, '2020-09-17 05:00:00', '2020-09-17 18:00:00', 0, 0),
(304, '\"56 (2) 25206210\"', 668, 65, 41, 71, 36, 34, 46, '2020-10-08 05:00:00', '2020-10-08 18:00:00', 0, 0),
(305, '\"56 (2) 25206210\"', 669, 65, 41, 71, 36, 34, 46, '2020-10-13 05:00:00', '2020-10-13 18:00:00', 0, 0),
(306, '\"56 (2) 25206210\"', 670, 65, 41, 71, 36, 34, 46, '2020-10-15 05:00:00', '2020-10-15 18:00:00', 0, 0),
(307, '\"56 (2) 25206210\"', 671, 65, 41, 71, 36, 34, 46, '2020-10-19 05:00:00', '2020-10-19 18:00:00', 0, 0),
(308, '569 8831 5323', 672, 72, 73, 80, 39, 42, 51, '2020-10-27 08:00:00', '2020-10-27 18:00:00', 0, 84),
(309, '\"56 (2) 25206210\"', 673, 65, 41, 71, 36, 34, 46, '2020-10-30 08:00:00', '2020-11-11 14:00:00', 0, 0),
(310, '\"56 (2) 25206210\"', 674, 65, 41, 71, 36, 34, 46, '2020-10-30 08:00:00', '2020-11-11 14:00:00', 0, 0),
(311, '\"56 (2) 25206210\"', 675, 65, 41, 71, 36, 34, 46, '2020-10-30 08:00:00', '2020-11-11 14:00:00', 0, 0),
(312, '569 8831 5323', 676, 72, 73, 80, 39, 42, 51, '2020-10-28 08:00:00', '2020-10-28 18:00:00', 0, 85),
(313, '\"56 9 8913 8998\"', 677, 70, 71, 72, 33, 46, 42, '2020-10-28 05:00:00', '2020-10-28 13:00:00', 0, 0),
(314, '\"56 9 6919 2558\"', 678, 70, 71, 72, 33, 30, 42, '2020-10-28 13:00:00', '2020-10-28 21:00:00', 0, 0),
(315, '\"56 9 8913 8998\"', 679, 70, 71, 72, 33, 46, 42, '2020-10-29 05:00:00', '2020-10-29 13:00:00', 0, 0),
(316, '\"56 9 6919 2558\"', 680, 70, 71, 72, 33, 30, 42, '2020-10-29 13:00:00', '2020-10-29 21:00:00', 0, 0),
(317, '\"56 9 8913 8998\"', 681, 70, 71, 72, 33, 46, 42, '2020-10-30 05:00:00', '2020-10-30 13:00:00', 0, 0),
(318, '\"56 9 6919 2558\"', 682, 70, 71, 72, 33, 30, 42, '2020-10-30 13:00:00', '2020-10-30 21:00:00', 0, 0),
(319, '569 8831 5323', 683, 70, 71, 77, 42, 47, 54, '2020-10-28 08:00:00', '2020-10-28 18:00:00', 0, 0),
(320, '569 8831 5323', 684, 70, 71, 77, 42, 47, 54, '2020-10-29 08:00:00', '2020-10-29 18:00:00', 0, 0),
(321, '569 8831 5323', 685, 70, 71, 77, 42, 47, 54, '2020-10-30 08:00:00', '2020-10-30 18:00:00', 0, 0),
(322, '569 8831 5323', 687, 72, 73, 80, 39, 42, 51, '2020-10-29 08:00:00', '2020-10-29 18:00:00', 0, 87),
(323, '569 8831 5323', 688, 72, 73, 80, 39, 42, 51, '2020-10-30 08:00:00', '2020-10-30 18:00:00', 0, 88),
(324, '\"56 9 6919 2558\"', 690, 70, 71, 72, 33, 30, 42, '2020-10-31 09:00:00', '2020-10-31 16:00:00', 0, 0),
(325, '\"56 9 6919 2558\"', 691, 70, 71, 72, 33, 30, 42, '2020-11-01 09:00:00', '2020-11-01 16:00:00', 0, 0),
(326, '\"56 9 6919 2558\"', 692, 70, 71, 72, 33, 30, 42, '2020-11-02 05:00:00', '2020-11-02 13:00:00', 0, 0),
(327, '\"56 9 8913 8998\"', 693, 70, 71, 72, 33, 46, 42, '2020-11-02 13:00:00', '2020-11-02 21:00:00', 0, 0),
(328, '\"56 9 6919 2558\"', 694, 70, 71, 72, 33, 30, 42, '2020-11-03 05:00:00', '2020-11-03 13:00:00', 0, 0),
(329, '\"56 9 8913 8998\"', 695, 70, 71, 72, 33, 46, 42, '2020-11-03 13:00:00', '2020-11-03 21:00:00', 0, 0),
(330, '569 8831 5323', 696, 70, 71, 77, 42, 47, 54, '2020-11-02 08:00:00', '2020-11-02 18:00:00', 0, 0),
(331, '569 8831 5323', 697, 70, 71, 77, 42, 47, 54, '2020-11-03 08:00:00', '2020-11-03 18:00:00', 0, 0),
(332, '569 8831 5323', 698, 72, 73, 80, 39, 42, 51, '2020-11-02 08:00:00', '2020-11-02 18:00:00', 0, 89),
(333, '569 8831 5323', 699, 72, 73, 80, 39, 42, 51, '2020-11-03 08:00:00', '2020-11-03 18:00:00', 0, 90),
(334, '569 8831 5323', 700, 72, 73, 80, 39, 42, 51, '2020-11-04 08:00:00', '2020-11-04 18:00:00', 0, 91),
(335, '569 8831 5323', 701, 72, 73, 80, 39, 42, 51, '2020-11-05 08:00:00', '2020-11-05 18:00:00', 0, 92),
(336, '569 8831 5323', 702, 72, 73, 80, 39, 42, 51, '2020-11-06 08:00:00', '2020-11-06 18:00:00', 0, 93),
(337, '569 8831 5323', 703, 72, 73, 80, 39, 42, 51, '2020-11-09 08:00:00', '2020-11-09 18:00:00', 0, 94),
(338, '569 8831 5323', 704, 72, 73, 80, 39, 42, 51, '2020-11-10 08:00:00', '2020-11-10 18:00:00', 0, 95),
(339, '569 8831 5323', 705, 72, 73, 80, 39, 42, 51, '2020-11-11 08:00:00', '2020-11-11 18:00:00', 0, 96),
(340, '\"56 9 6919 2558\"', 706, 70, 71, 72, 33, 30, 42, '2020-11-04 05:00:00', '2020-11-04 13:00:00', 0, 0),
(341, '\"56 9 8913 8998\"', 707, 70, 71, 72, 33, 46, 42, '2020-11-04 13:00:00', '2020-11-04 21:00:00', 0, 0),
(342, '\"56 9 6919 2558\"', 708, 70, 71, 72, 33, 30, 42, '2020-11-05 08:00:00', '2020-11-05 13:00:00', 0, 0),
(343, '\"56 9 8913 8998\"', 709, 70, 71, 72, 33, 46, 42, '2020-11-05 13:00:00', '2020-11-05 21:00:00', 0, 0),
(344, '\"56 9 6919 2558\"', 710, 70, 71, 72, 33, 30, 42, '2020-11-06 05:00:00', '2020-11-06 13:00:00', 0, 0),
(345, '\"56 9 8913 8998\"', 711, 70, 71, 72, 33, 46, 42, '2020-11-06 13:00:00', '2020-11-06 21:00:00', 0, 0),
(346, '\"56 9 8913 8998\"', 712, 70, 71, 72, 33, 46, 42, '2020-11-07 09:00:00', '2020-11-07 16:00:00', 0, 0),
(347, '\"56 9 8913 8998\"', 713, 70, 71, 72, 33, 46, 42, '2020-11-08 09:00:00', '2020-11-08 16:00:00', 0, 0),
(348, '\"56 9 8913 8998\"', 714, 70, 71, 72, 33, 46, 42, '2020-11-09 05:00:00', '2020-11-09 13:00:00', 0, 0),
(349, '\"56 9 6919 2558\"', 715, 70, 71, 72, 33, 30, 42, '2020-11-09 13:00:00', '2020-11-09 21:00:00', 0, 0),
(350, '\"56 9 8913 8998\"', 716, 70, 71, 72, 33, 46, 42, '2020-11-10 05:00:00', '2020-11-10 13:00:00', 0, 0),
(351, '\"56 9 6919 2558\"', 717, 70, 71, 72, 33, 30, 42, '2020-11-10 13:00:00', '2020-11-10 21:00:00', 0, 0),
(352, '\"56 9 8913 8998\"', 718, 70, 71, 72, 33, 46, 42, '2020-11-11 05:00:00', '2020-11-11 13:00:00', 0, 0),
(353, '\"56 9 6919 2558\"', 719, 70, 71, 72, 33, 30, 42, '2020-11-11 13:00:00', '2020-11-11 21:00:00', 0, 0),
(354, '\"56 9 8913 8998\"', 720, 70, 71, 72, 33, 46, 42, '2020-11-12 05:00:00', '2020-11-12 13:00:00', 0, 0),
(355, '\"56 9 6919 2558\"', 721, 70, 71, 72, 33, 30, 42, '2020-11-12 13:00:00', '2020-11-12 21:00:00', 0, 0),
(356, '569 8831 5323', 725, 70, 71, 77, 42, 47, 54, '2020-11-04 08:00:00', '2020-11-04 18:00:00', 0, 0),
(357, '569 8831 5323', 726, 70, 71, 77, 42, 47, 54, '2020-11-05 08:00:00', '2020-11-05 18:00:00', 0, 0),
(358, '569 8831 5323', 727, 70, 71, 77, 42, 47, 54, '2020-11-06 08:00:00', '2020-11-06 18:00:00', 0, 0),
(359, '569 8831 5323', 728, 70, 71, 77, 42, 47, 54, '2020-11-07 08:00:00', '2020-11-07 18:00:00', 0, 0),
(360, '569 8831 5323', 729, 70, 71, 77, 42, 47, 54, '2020-11-09 08:00:00', '2020-11-09 18:00:00', 0, 0),
(361, '569 8831 5323', 730, 70, 71, 77, 42, 47, 54, '2020-11-10 08:00:00', '2020-11-10 18:00:00', 0, 0),
(362, '569 8831 5323', 731, 70, 71, 77, 42, 47, 54, '2020-11-11 08:00:00', '2020-11-11 18:00:00', 0, 0),
(363, '569 8831 5323', 732, 70, 71, 77, 42, 47, 54, '2020-11-12 08:00:00', '2020-11-12 18:00:00', 0, 0),
(364, '56 9 8831 5323', 733, 72, 73, 80, 39, 42, 51, '2020-11-12 08:00:00', '2020-11-12 18:00:00', 0, 97),
(365, '56 9 8831 5323', 734, 72, 73, 80, 39, 42, 51, '2020-11-13 08:00:00', '2020-11-13 18:00:00', 0, 98),
(366, '56 9 8831 5323', 735, 72, 73, 80, 39, 42, 51, '2020-11-16 08:00:00', '2020-11-16 18:00:00', 0, 99),
(367, '56 9 8831 5323', 736, 72, 73, 80, 39, 42, 51, '2020-11-17 08:00:00', '2020-11-17 18:00:00', 0, 100),
(368, '56 9 8831 5323', 737, 72, 73, 80, 39, 42, 51, '2020-11-18 08:00:00', '2020-11-18 18:00:00', 0, 101),
(369, '56 9 8831 5323', 738, 72, 73, 80, 39, 42, 51, '2020-11-19 08:00:00', '2020-11-19 18:00:00', 0, 102),
(370, '56 9 8831 5323', 739, 72, 73, 80, 39, 42, 51, '2020-11-20 08:00:00', '2020-11-20 18:00:00', 0, 103),
(371, '56 9 8831 5323', 740, 72, 73, 80, 39, 42, 51, '2020-11-23 08:00:00', '2020-11-23 18:00:00', 0, 104),
(372, '\"56 9 8913 8998\"', 722, 70, 71, 72, 33, 46, 42, '2020-11-13 05:00:00', '2020-11-13 13:00:00', 0, 0),
(373, '\"56 9 6919 2558\"', 723, 70, 71, 72, 33, 30, 42, '2020-11-13 13:00:00', '2020-11-13 21:00:00', 0, 0),
(374, '\"56 9 6919 2558\"', 724, 70, 71, 72, 33, 30, 42, '2020-11-14 09:00:00', '2020-11-14 16:00:00', 0, 0),
(375, '\"56 9 6919 2558\"', 741, 70, 71, 72, 33, 30, 42, '2020-11-15 09:00:00', '2020-11-15 16:00:00', 0, 0),
(376, '\"56 9 6919 2558\"', 742, 70, 71, 72, 33, 30, 42, '2020-11-16 05:00:00', '2020-11-16 13:00:00', 0, 0),
(377, '\"56 9 8913 8998\"', 743, 70, 71, 72, 33, 46, 42, '2020-11-16 13:00:00', '2020-11-16 21:00:00', 0, 0),
(378, '\"56 9 6919 2558\"', 744, 70, 71, 72, 33, 30, 42, '2020-11-17 05:00:00', '2020-11-17 13:00:00', 0, 0),
(379, '\"56 9 8913 8998\"', 745, 70, 71, 72, 33, 46, 42, '2020-11-17 13:00:00', '2020-11-17 21:00:00', 0, 0),
(380, '\"56 9 6919 2558\"', 746, 70, 71, 72, 33, 30, 42, '2020-11-18 05:00:00', '2020-11-18 13:00:00', 0, 0),
(381, '\"56 9 8913 8998\"', 747, 70, 71, 72, 33, 46, 42, '2020-11-18 13:00:00', '2020-11-18 21:00:00', 0, 0),
(382, '\"56 9 6919 2558\"', 748, 70, 71, 72, 33, 30, 42, '2020-11-19 05:00:00', '2020-11-19 13:00:00', 0, 0),
(383, '\"56 9 8913 8998\"', 749, 70, 71, 72, 33, 46, 42, '2020-11-19 13:00:00', '2020-11-19 21:00:00', 0, 0),
(384, '\"56 9 6919 2558\"', 750, 70, 71, 72, 33, 30, 42, '2020-11-20 05:00:00', '2020-11-20 13:00:00', 0, 0),
(385, '\"56 9 8913 8998\"', 751, 70, 71, 72, 33, 46, 42, '2020-11-20 13:00:00', '2020-11-20 21:00:00', 0, 0),
(386, '\"56 9 8913 8998\"', 752, 70, 71, 72, 33, 46, 42, '2020-11-21 09:00:00', '2020-11-21 16:00:00', 0, 0),
(387, '\"56 9 8913 8998\"', 753, 70, 71, 72, 33, 46, 42, '2020-11-22 09:00:00', '2020-11-22 16:00:00', 0, 0),
(388, '\"56 9 8913 8998\"', 754, 70, 71, 72, 33, 46, 42, '2020-11-23 05:00:00', '2020-11-23 13:00:00', 0, 0),
(389, '\"56 9 6919 2558\"', 755, 70, 71, 72, 33, 30, 42, '2020-11-23 13:00:00', '2020-11-23 21:00:00', 0, 0),
(390, '\"56 9 8913 8998\"', 756, 70, 71, 72, 33, 46, 42, '2020-11-24 05:00:00', '2020-11-24 13:00:00', 0, 0),
(391, '\"56 9 6919 2558\"', 757, 70, 71, 72, 33, 30, 42, '2020-11-24 13:00:00', '2020-11-24 21:00:00', 0, 0),
(392, '\"56 9 8913 8998\"', 758, 70, 71, 72, 33, 46, 42, '2020-11-25 05:00:00', '2020-11-25 13:00:00', 0, 0),
(393, '\"56 9 6919 2558\"', 759, 70, 71, 72, 33, 30, 42, '2020-11-25 13:00:00', '2020-11-25 21:00:00', 0, 0),
(394, '\"56 9 8913 8998\"', 760, 70, 71, 72, 33, 46, 42, '2020-11-26 05:00:00', '2020-11-26 13:00:00', 0, 0),
(395, '\"56 9 6919 2558\"', 761, 70, 71, 72, 33, 30, 42, '2020-11-26 13:00:00', '2020-11-26 21:00:00', 0, 0),
(396, '\"56 9 8913 8998\"', 762, 70, 71, 72, 33, 46, 42, '2020-11-27 05:00:00', '2020-11-27 13:00:00', 0, 0),
(397, '\"56 9 6919 2558\"', 763, 70, 71, 72, 33, 30, 42, '2020-11-27 13:00:00', '2020-11-27 21:00:00', 0, 0),
(398, '\"56 9 6919 2558\"', 764, 70, 71, 72, 33, 30, 42, '2020-11-28 09:00:00', '2020-11-28 16:00:00', 0, 0),
(399, '\"56 9 6919 2558\"', 765, 70, 71, 72, 33, 30, 42, '2020-11-29 09:00:00', '2020-11-29 16:00:00', 0, 0),
(400, '\"56 9 6919 2558\"', 766, 70, 71, 72, 33, 30, 42, '2020-11-30 05:00:00', '2020-11-30 13:00:00', 0, 0),
(401, '\"56 9 8913 8998\"', 767, 70, 71, 72, 33, 46, 42, '2020-11-30 13:00:00', '2020-11-30 21:00:00', 0, 0),
(402, '569 8831 5323', 768, 70, 71, 77, 42, 47, 54, '2020-11-13 08:00:00', '2020-11-13 18:00:00', 0, 0),
(403, '569 8831 5323', 769, 70, 71, 77, 42, 47, 54, '2020-11-14 08:00:00', '2020-11-14 18:00:00', 0, 0),
(404, '569 8831 5323', 770, 70, 71, 77, 42, 47, 54, '2020-11-16 08:00:00', '2020-11-16 18:00:00', 0, 0),
(405, '569 8831 5323', 771, 70, 71, 77, 42, 47, 54, '2020-11-17 08:00:00', '2020-11-17 18:00:00', 0, 0),
(406, '569 8831 5323', 772, 70, 71, 77, 42, 47, 54, '2020-11-18 08:00:00', '2020-11-18 18:00:00', 0, 0),
(407, '569 8831 5323', 773, 70, 71, 77, 42, 47, 54, '2020-11-19 08:00:00', '2020-11-19 18:00:00', 0, 0),
(408, '569 8831 5323', 774, 70, 71, 77, 42, 47, 54, '2020-11-20 08:00:00', '2020-11-20 18:00:00', 0, 0),
(409, '569 8831 5323', 775, 70, 71, 77, 42, 47, 54, '2020-11-21 08:00:00', '2020-11-21 18:00:00', 0, 0),
(410, '569 8831 5323', 776, 70, 71, 77, 42, 47, 54, '2020-11-23 08:00:00', '2020-11-23 18:00:00', 0, 0),
(411, '569 8831 5323', 777, 70, 71, 77, 42, 47, 54, '2020-11-24 08:00:00', '2020-11-24 18:00:00', 0, 0),
(412, '569 8831 5323', 778, 70, 71, 77, 42, 47, 54, '2020-11-25 08:00:00', '2020-11-25 18:00:00', 0, 0),
(413, '569 8831 5323', 779, 70, 71, 77, 42, 47, 54, '2020-11-26 08:00:00', '2020-11-26 18:00:00', 0, 0),
(414, '569 8831 5323', 780, 70, 71, 77, 42, 47, 54, '2020-11-27 08:00:00', '2020-11-27 18:00:00', 0, 0),
(415, '569 8831 5323', 781, 70, 71, 77, 42, 47, 54, '2020-11-28 08:00:00', '2020-11-28 18:00:00', 0, 0),
(416, '569 8831 5323', 782, 70, 71, 77, 42, 47, 54, '2020-11-30 08:00:00', '2020-11-30 18:00:00', 0, 0),
(417, '\"56 (2) 25206210\"', 783, 65, 41, 71, 36, 34, 46, '2020-11-18 06:00:00', '2020-11-26 18:00:00', 0, 0),
(418, '\"56 (2) 25206210\"', 784, 65, 41, 71, 36, 34, 46, '2020-11-18 06:00:00', '2020-11-27 18:00:00', 0, 0),
(419, NULL, 785, 65, 41, 71, NULL, NULL, NULL, '2020-11-18 06:00:00', '2020-11-18 06:00:00', 1, 0),
(420, '\"56 (2) 25206210\"', 785, 65, 41, 71, 36, 34, 46, '2020-11-18 06:00:00', '2020-11-26 18:00:00', 0, 0),
(421, '\"56 (2) 25206210\"', 786, 65, 41, 71, 36, 34, 46, '2020-11-18 06:00:00', '2020-11-27 18:00:00', 0, 0),
(422, '569 8831 5323', 787, 72, 73, 80, 39, 42, 51, '2020-11-24 08:00:00', '2020-11-24 18:00:00', 0, 105),
(423, '569 8831 5323', 788, 72, 73, 80, 39, 42, 51, '2020-11-25 08:00:00', '2020-11-25 18:00:00', 0, 106),
(424, '569 8831 5323', 789, 72, 73, 80, 39, 42, 51, '2020-11-26 08:00:00', '2020-11-26 18:00:00', 0, 107),
(425, '569 8831 5323', 790, 72, 73, 80, 39, 42, 51, '2020-11-27 08:00:00', '2020-11-27 18:00:00', 0, 109),
(426, '569 8831 5323', 791, 72, 73, 80, 39, 42, 51, '2020-11-30 08:00:00', '2020-11-30 18:00:00', 0, 114),
(427, '\"56 9 6919 2558\"', 792, 70, 71, 72, 33, 30, 42, '2020-12-01 05:00:00', '2020-12-01 13:00:00', 0, 0),
(428, '\"56 9 8913 8998\"', 793, 70, 71, 72, 33, 46, 42, '2020-12-01 13:00:00', '2020-12-01 21:00:00', 0, 0),
(429, '\"56 9 6919 2558\"', 794, 70, 71, 72, 33, 30, 42, '2020-12-02 05:00:00', '2020-12-02 13:00:00', 0, 0),
(430, '\"56 9 8913 8998\"', 795, 70, 71, 72, 33, 46, 42, '2020-12-02 13:00:00', '2020-12-02 21:00:00', 0, 0),
(431, '\"56 9 6919 2558\"', 796, 70, 71, 72, 33, 30, 42, '2020-12-03 05:00:00', '2020-12-03 13:00:00', 0, 0),
(432, '\"56 9 8913 8998\"', 797, 70, 71, 72, 33, 46, 42, '2020-12-03 13:00:00', '2020-12-03 21:00:00', 0, 0),
(433, '\"56 9 6919 2558\"', 798, 70, 71, 72, 33, 30, 42, '2020-12-04 05:00:00', '2020-12-04 13:00:00', 0, 0),
(434, '\"56 9 8913 8998\"', 799, 70, 71, 72, 33, 46, 42, '2020-12-04 13:00:00', '2020-12-04 21:00:00', 0, 0),
(435, '\"56 9 8913 8998\"', 800, 70, 71, 72, 33, 46, 42, '2020-12-05 09:00:00', '2020-12-05 16:00:00', 0, 0),
(436, '\"56 9 8913 8998\"', 801, 70, 71, 72, 33, 46, 42, '2020-12-06 09:00:00', '2020-12-06 16:00:00', 0, 0),
(437, '\"56 9 8913 8998\"', 802, 70, 71, 72, 33, 46, 42, '2020-12-07 05:00:00', '2020-12-07 13:00:00', 0, 0),
(438, '\"56 9 6919 2558\"', 803, 70, 71, 72, 33, 30, 42, '2020-12-07 13:00:00', '2020-12-07 21:00:00', 0, 0),
(439, '\"56 9 8913 8998\"', 804, 70, 71, 72, 33, 46, 42, '2020-12-08 05:00:00', '2020-12-08 13:00:00', 0, 0),
(440, '\"56 9 6919 2558\"', 805, 70, 71, 72, 33, 30, 42, '2020-12-08 13:00:00', '2020-12-08 21:00:00', 0, 0),
(441, '\"56 9 8913 8998\"', 806, 70, 71, 72, 33, 46, 42, '2020-12-09 05:00:00', '2020-12-09 13:00:00', 0, 0),
(442, '\"56 9 6919 2558\"', 807, 70, 71, 72, 33, 30, 42, '2020-12-09 13:00:00', '2020-12-09 21:00:00', 0, 0),
(443, '\"56 9 8913 8998\"', 808, 70, 71, 72, 33, 46, 42, '2020-12-10 05:00:00', '2020-12-10 13:00:00', 0, 0),
(444, '\"56 9 6919 2558\"', 809, 70, 71, 72, 33, 30, 42, '2020-12-10 13:00:00', '2020-12-10 21:00:00', 0, 0),
(445, '\"56 9 8913 8998\"', 810, 70, 71, 72, 33, 46, 42, '2020-12-11 05:00:00', '2020-12-11 13:00:00', 0, 0),
(446, '\"56 9 6919 2558\"', 811, 70, 71, 72, 33, 30, 42, '2020-12-11 13:00:00', '2020-12-11 21:00:00', 0, 0),
(447, '\"56 (2) 25206210\"', 813, 65, 41, 71, 36, 34, 46, '2020-11-19 06:00:00', '2020-12-02 18:00:00', 0, 0),
(448, '\"56 (2) 25206210\"', 814, 65, 41, 71, 36, 34, 46, '2020-12-09 06:00:00', '2020-12-15 06:00:00', 0, 0),
(449, '\"56 (2) 25206210\"', 815, 65, 41, 71, 36, 34, 46, '2020-12-10 06:00:00', '2020-12-15 06:00:00', 0, 0),
(450, '569 8831 5323', 816, 72, 73, 80, 39, 42, 51, '2020-12-01 08:00:00', '2020-12-01 18:00:00', 0, 115),
(451, '569 8831 5323', 817, 72, 73, 80, 39, 42, 51, '2020-12-02 08:00:00', '2020-12-02 18:00:00', 0, 116),
(452, '569 8831 5323', 818, 72, 73, 80, 39, 42, 51, '2020-12-03 08:00:00', '2020-12-03 18:00:00', 0, 117),
(453, '569 8831 5323', 819, 72, 73, 80, 39, 42, 51, '2020-12-04 08:00:00', '2020-12-04 18:00:00', 0, 118),
(454, '569 8831 5323', 820, 72, 73, 80, 39, 42, 51, '2020-12-07 08:00:00', '2020-12-07 18:00:00', 0, 119),
(455, '569 8831 5323', 821, 72, 73, 80, 39, 42, 51, '2020-12-09 08:00:00', '2020-12-09 18:00:00', 0, 120),
(456, '569 8831 5323', 822, 72, 73, 80, 39, 42, 51, '2020-12-10 08:00:00', '2020-12-10 18:00:00', 0, 121),
(457, '569 8831 5323', 823, 72, 73, 80, 39, 42, 51, '2020-12-11 08:00:00', '2020-12-11 18:00:00', 0, 122),
(458, '569 8831 5323', 824, 72, 73, 80, 39, 42, 51, '2020-12-14 08:00:00', '2020-12-14 18:00:00', 0, 123),
(459, '569 8831 5323', 825, 72, 73, 80, 39, 42, 51, '2020-12-15 08:00:00', '2020-12-15 18:00:00', 0, 124),
(460, '569 8831 5323', 826, 72, 73, 80, 39, 42, 51, '2020-12-16 08:00:00', '2020-12-16 18:00:00', 0, 125),
(461, '569 8831 5323', 827, 72, 73, 80, 39, 42, 51, '2020-12-17 08:00:00', '2020-12-17 18:00:00', 0, 126),
(462, '569 8831 5323', 828, 72, 73, 80, 39, 42, 51, '2020-12-18 08:00:00', '2020-12-18 18:00:00', 0, 129),
(463, NULL, 829, 72, 73, 80, NULL, NULL, NULL, '2020-12-21 08:00:00', '2020-12-21 08:00:00', 1, 0),
(464, '569 8831 5323', 829, 72, 73, 80, 39, 42, 51, '2020-12-21 08:00:00', '2020-12-21 18:00:00', 0, 130),
(465, '569 8831 5323', 830, 72, 73, 80, 39, 42, 51, '2020-12-22 08:00:00', '2020-12-22 18:00:00', 0, 131),
(466, '569 8831 5323', 831, 72, 73, 80, 39, 42, 51, '2020-12-23 08:00:00', '2020-12-23 18:00:00', 0, 132),
(467, NULL, 832, 72, 73, 80, NULL, NULL, NULL, '2020-12-24 08:00:00', '2020-12-24 08:00:00', 1, 0),
(468, '569 8831 5323', 832, 72, 73, 80, 39, 42, 51, '2020-12-24 08:00:00', '2020-12-24 18:00:00', 0, 133),
(469, '569 8831 5323', 833, 72, 73, 80, 39, 42, 51, '2020-12-30 08:00:00', '2020-12-30 18:00:00', 0, 134),
(470, '569 8831 5323', 834, 72, 73, 80, 39, 42, 51, '2020-12-31 08:00:00', '2020-12-31 18:00:00', 0, 135),
(471, '\"56 9 6919 2558\"', 812, 70, 71, 72, 33, 30, 42, '2020-12-12 09:00:00', '2020-12-12 16:00:00', 0, 0),
(472, '\"56 9 6919 2558\"', 835, 70, 71, 72, 33, 30, 42, '2020-12-13 09:00:00', '2020-12-13 16:00:00', 0, 0),
(473, '\"56 9 6919 2558\"', 836, 70, 71, 72, 33, 30, 42, '2020-12-14 05:00:00', '2020-12-14 13:00:00', 0, 0),
(474, '\"56 9 8913 8998\"', 837, 70, 71, 72, 33, 46, 42, '2020-12-14 13:00:00', '2020-12-14 21:00:00', 0, 0),
(475, '\"56 9 6919 2558\"', 838, 70, 71, 72, 33, 30, 42, '2020-12-15 05:00:00', '2020-12-15 13:00:00', 0, 0),
(476, '\"56 9 8913 8998\"', 839, 70, 71, 72, 33, 46, 42, '2020-12-15 13:00:00', '2020-12-15 21:00:00', 0, 0),
(477, '\"56 9 6919 2558\"', 840, 70, 71, 72, 33, 30, 42, '2020-12-16 05:00:00', '2020-12-16 13:00:00', 0, 0),
(478, '\"56 9 8913 8998\"', 841, 70, 71, 72, 33, 46, 42, '2020-12-16 13:00:00', '2020-12-16 21:00:00', 0, 0),
(479, '\"56 9 6919 2558\"', 842, 70, 71, 72, 33, 30, 42, '2020-12-17 05:00:00', '2020-12-17 13:00:00', 0, 0),
(480, '\"56 9 8913 8998\"', 843, 70, 71, 72, 33, 46, 42, '2020-12-17 13:00:00', '2020-12-17 21:00:00', 0, 0),
(481, '\"56 9 6919 2558\"', 844, 70, 71, 72, 33, 30, 42, '2020-12-18 05:00:00', '2020-12-18 13:00:00', 0, 0),
(482, '\"56 9 8913 8998\"', 845, 70, 71, 72, 33, 46, 42, '2020-12-18 13:00:00', '2020-12-18 21:00:00', 0, 0),
(483, '\"56 9 6919 2558\"', 846, 70, 71, 72, 33, 30, 42, '2020-12-19 09:00:00', '2020-12-19 16:00:00', 0, 0),
(484, '\"56 9 6919 2558\"', 847, 70, 71, 72, 33, 30, 42, '2020-12-20 09:00:00', '2020-12-20 16:00:00', 0, 0),
(485, '569 8831 5323', 848, 70, 71, 77, 42, 47, 54, '2020-12-01 08:00:00', '2020-12-01 18:00:00', 0, 0),
(486, '569 8831 5323', 849, 70, 71, 77, 42, 47, 54, '2020-12-02 08:00:00', '2020-12-02 18:00:00', 0, 0),
(487, '569 8831 5323', 850, 70, 71, 77, 42, 47, 54, '2020-12-03 08:00:00', '2020-12-03 18:00:00', 0, 0),
(488, '569 8831 5323', 851, 70, 71, 77, 42, 47, 54, '2020-12-04 08:00:00', '2020-12-04 18:00:00', 0, 0),
(489, NULL, 852, 70, 71, 77, NULL, NULL, NULL, '2020-12-05 08:00:00', '2020-12-05 08:00:00', 1, 0),
(490, '569 8831 5323', 852, 70, 71, 77, 42, 47, 54, '2020-12-05 08:00:00', '2020-12-05 18:00:00', 0, 0),
(491, '569 8831 5323', 853, 70, 71, 77, 42, 47, 54, '2020-12-07 08:00:00', '2020-12-07 18:00:00', 0, 0),
(492, '569 8831 5323', 854, 70, 71, 77, 42, 47, 54, '2020-12-09 08:00:00', '2020-12-09 18:00:00', 0, 0),
(493, '569 8831 5323', 855, 70, 71, 77, 42, 47, 54, '2020-12-10 08:00:00', '2020-12-10 18:00:00', 0, 0),
(494, '569 8831 5323', 856, 70, 71, 77, 42, 47, 54, '2020-12-11 08:00:00', '2020-12-11 18:00:00', 0, 0),
(495, '569 8831 5323', 857, 70, 71, 77, 42, 47, 54, '2020-12-12 08:00:00', '2020-12-12 18:00:00', 0, 0),
(496, '569 8831 5323', 858, 70, 71, 77, 42, 47, 54, '2020-12-14 08:00:00', '2020-12-14 18:00:00', 0, 0),
(497, '569 8831 5323', 859, 70, 71, 77, 42, 47, 54, '2020-12-15 08:00:00', '2020-12-15 18:00:00', 0, 0),
(498, '569 8831 5323', 860, 70, 71, 77, 42, 47, 54, '2020-12-16 08:00:00', '2020-12-16 18:00:00', 0, 0),
(499, '569 8831 5323', 861, 70, 71, 77, 42, 47, 54, '2020-12-17 08:00:00', '2020-12-17 17:00:00', 0, 0),
(500, '569 8831 5323', 862, 70, 71, 77, 42, 47, 54, '2020-12-18 08:00:00', '2020-12-18 18:00:00', 0, 0),
(501, '569 8831 5323', 863, 70, 71, 77, 42, 47, 54, '2020-12-19 08:00:00', '2020-12-19 18:00:00', 0, 0),
(502, '569 8831 5323', 864, 70, 71, 77, 42, 47, 54, '2020-12-21 08:00:00', '2020-12-21 18:00:00', 0, 0),
(503, NULL, 865, 70, 71, 77, NULL, NULL, NULL, '2020-12-22 08:00:00', '2020-12-22 08:00:00', 1, 0),
(504, '569 8831 5323', 865, 70, 71, 77, 42, 47, 54, '2020-12-22 08:00:00', '2020-12-22 18:00:00', 0, 0),
(505, '569 8831 5323', 866, 70, 71, 77, 42, 47, 54, '2020-12-23 08:00:00', '2020-12-23 18:00:00', 0, 0),
(506, '569 8831 5323', 867, 70, 71, 77, 42, 47, 54, '2020-12-24 08:00:00', '2020-12-24 18:00:00', 0, 0),
(507, '569 8831 5323', 868, 70, 71, 77, 42, 47, 54, '2020-12-26 08:00:00', '2020-12-26 18:00:00', 0, 0),
(508, '569 8831 5323', 869, 70, 71, 77, 42, 47, 54, '2020-12-28 08:00:00', '2020-12-28 18:00:00', 0, 0),
(509, '569 8831 5323', 870, 70, 71, 77, 42, 47, 54, '2020-12-29 08:00:00', '2020-12-29 18:00:00', 0, 0),
(510, '569 8831 5323', 871, 70, 71, 77, 42, 47, 54, '2020-12-30 08:00:00', '2020-12-30 18:00:00', 0, 0),
(511, '569 8831 5323', 872, 70, 71, 77, 42, 47, 54, '2020-12-31 08:00:00', '2020-12-31 18:00:00', 0, 0),
(512, '569 8831 5323', 873, 70, 71, 77, 42, 47, 54, '2021-01-02 08:00:00', '2021-01-02 18:00:00', 0, 0),
(513, '569 8831 5323', 874, 70, 71, 77, 42, 47, 54, '2021-01-04 08:00:00', '2021-01-04 18:00:00', 0, 0),
(514, '569 8831 5323', 875, 70, 71, 77, 42, 47, 54, '2021-01-05 08:00:00', '2021-01-05 18:00:00', 0, 0),
(515, '569 8831 5323', 876, 70, 71, 77, 42, 47, 54, '2021-01-06 08:00:00', '2021-01-06 18:00:00', 0, 0),
(516, '569 8831 5323', 877, 70, 71, 77, 42, 47, 54, '2021-01-08 08:00:00', '2021-01-08 18:00:00', 0, 0),
(517, '569 8831 5323', 878, 70, 71, 77, 42, 47, 54, '2021-01-09 08:00:00', '2021-01-09 18:00:00', 0, 0),
(518, '\"56 9 8913 8998\"', 879, 70, 71, 72, 33, 46, 42, '2021-01-11 08:00:00', '2021-01-11 18:00:00', 0, 0),
(519, '\"56 9 8913 8998\"', 880, 70, 71, 72, 33, 46, 42, '2021-01-12 08:00:00', '2021-01-12 18:00:00', 0, 0),
(520, '\"56 9 8913 8998\"', 881, 70, 71, 72, 33, 46, 42, '2021-01-13 08:00:00', '2021-01-13 18:00:00', 0, 0),
(521, '\"56 9 8913 8998\"', 882, 70, 71, 72, 33, 46, 42, '2021-01-14 08:00:00', '2021-01-14 18:00:00', 0, 0),
(522, '\"56 9 8913 8998\"', 883, 70, 71, 72, 33, 46, 42, '2021-01-15 08:00:00', '2021-01-15 18:00:00', 0, 0),
(523, '\"56 9 8913 8998\"', 884, 70, 71, 72, 33, 46, 42, '2021-01-16 08:00:00', '2021-01-16 18:00:00', 0, 0),
(524, '\"56 9 8913 8998\"', 885, 70, 71, 72, 33, 46, 42, '2021-01-18 08:00:00', '2021-01-18 18:00:00', 0, 0),
(525, '\"56 9 8913 8998\"', 886, 70, 71, 72, 33, 46, 42, '2021-01-19 08:00:00', '2021-01-19 18:00:00', 0, 0),
(526, '\"56 9 8913 8998\"', 887, 70, 71, 72, 33, 46, 42, '2021-01-20 08:00:00', '2021-01-20 18:00:00', 0, 0),
(527, '\"56 9 8913 8998\"', 888, 70, 71, 72, 33, 46, 42, '2021-01-21 08:00:00', '2021-01-21 18:00:00', 0, 0),
(528, '\"56 9 8913 8998\"', 889, 70, 71, 72, 33, 46, 42, '2021-01-22 08:00:00', '2021-01-22 18:00:00', 0, 0),
(529, '\"56 9 8913 8998\"', 890, 70, 71, 72, 33, 46, 42, '2021-01-23 08:00:00', '2021-01-23 18:00:00', 0, 0),
(530, '\"56 9 8913 8998\"', 891, 70, 71, 72, 33, 46, 42, '2021-01-25 08:00:00', '2021-01-25 18:00:00', 0, 0),
(531, '\"56 9 8913 8998\"', 892, 70, 71, 72, 33, 46, 42, '2021-01-26 08:00:00', '2021-01-26 18:00:00', 0, 0),
(532, '\"56 9 8913 8998\"', 893, 70, 71, 72, 33, 46, 42, '2021-01-27 08:00:00', '2021-01-27 18:00:00', 0, 0),
(533, '569 8831 5323', 894, 72, 73, 80, 39, 42, 51, '2021-01-04 08:00:00', '2021-01-04 18:00:00', 0, 136),
(534, '569 8831 5323', 895, 72, 73, 80, 39, 42, 51, '2021-01-05 08:00:00', '2021-01-05 18:00:00', 0, 137),
(535, '569 8831 5323', 896, 72, 73, 80, 39, 42, 51, '2021-01-06 08:00:00', '2021-01-06 18:00:00', 0, 138),
(536, '569 8831 5323', 897, 72, 73, 80, 39, 42, 51, '2021-01-07 08:00:00', '2021-01-07 18:00:00', 0, 139),
(537, '569 8831 5323', 898, 72, 73, 80, 39, 42, 51, '2021-01-08 08:00:00', '2021-01-08 18:00:00', 0, 140),
(538, '569 8831 5323', 899, 72, 73, 80, 39, 42, 51, '2021-01-11 08:00:00', '2021-01-11 18:00:00', 0, 141),
(539, '569 8831 5323', 900, 72, 73, 77, 42, 47, 54, '2021-01-11 08:00:00', '2021-01-11 18:00:00', 0, 142),
(540, '569 8831 5323', 901, 72, 73, 80, 39, 42, 51, '2021-01-12 08:00:00', '2021-01-12 18:00:00', 0, 143),
(541, '569 8831 5323', 902, 72, 73, 77, 42, 47, 54, '2021-01-12 08:00:00', '2021-01-12 18:00:00', 0, 144),
(542, '569 8831 5323', 903, 72, 73, 80, 39, 42, 51, '2021-01-13 08:00:00', '2021-01-13 18:00:00', 0, 145),
(543, '569 8831 5323', 904, 72, 73, 77, 42, 47, 54, '2021-01-13 08:00:00', '2021-01-13 18:00:00', 0, 146),
(544, '569 8831 5323', 905, 72, 73, 80, 39, 42, 51, '2021-01-14 08:00:00', '2021-01-14 18:00:00', 0, 148),
(545, '569 8831 5323', 906, 72, 73, 77, 42, 47, 54, '2021-01-14 08:00:00', '2021-01-14 18:00:00', 0, 149),
(546, '569 8831 5323', 907, 72, 73, 80, 39, 42, 51, '2021-01-15 08:00:00', '2021-01-15 18:00:00', 0, 150),
(547, '569 8831 5323', 908, 72, 73, 77, 42, 47, 54, '2021-01-15 08:00:00', '2021-01-15 18:00:00', 0, 151),
(548, '569 8831 5323', 909, 72, 73, 80, 39, 42, 51, '2021-01-18 08:00:00', '2021-01-18 18:00:00', 0, 152),
(549, '569 8831 5323', 910, 72, 73, 77, 42, 47, 54, '2021-01-18 08:00:00', '2021-01-18 18:00:00', 0, 153),
(550, '569 8831 5323', 911, 72, 73, 80, 39, 42, 51, '2021-01-19 08:00:00', '2021-01-19 18:00:00', 0, 154),
(551, '569 8831 5323', 912, 72, 73, 77, 42, 47, 54, '2021-01-19 08:00:00', '2021-01-19 18:00:00', 0, 155),
(552, '569 8831 5323', 913, 72, 73, 80, 39, 42, 51, '2021-01-20 08:00:00', '2021-01-20 18:00:00', 0, 156),
(553, NULL, 914, 72, 73, 77, NULL, NULL, NULL, '2021-01-20 08:00:00', '2021-01-20 08:00:00', 1, 0),
(554, '569 8831 5323', 914, 72, 73, 77, 42, 47, 54, '2021-01-20 08:00:00', '2021-01-20 18:00:00', 0, 157),
(555, '569 8831 5323', 915, 72, 73, 80, 39, 42, 51, '2021-01-21 08:00:00', '2021-01-21 18:00:00', 0, 158),
(556, '569 8831 5323', 916, 72, 73, 77, 42, 47, 54, '2021-01-21 08:00:00', '2021-01-21 18:00:00', 0, 159),
(557, '569 8831 5323', 917, 72, 73, 80, 39, 42, 51, '2021-01-22 08:00:00', '2021-01-22 18:00:00', 0, 161),
(558, '569 8831 5323', 918, 72, 73, 77, 42, 47, 54, '2021-01-22 08:00:00', '2021-01-22 18:00:00', 0, 162),
(559, '569 8831 5323', 919, 72, 73, 80, 39, 42, 51, '2021-01-25 08:00:00', '2021-01-25 18:00:00', 0, 163),
(560, '569 8831 5323', 920, 72, 73, 77, 42, 47, 54, '2021-01-25 08:00:00', '2021-01-25 18:00:00', 0, 164),
(561, '569 8831 5323', 921, 72, 73, 80, 39, 42, 51, '2021-01-26 08:00:00', '2021-01-26 18:00:00', 0, 165),
(562, '569 8831 5323', 922, 72, 73, 77, 42, 47, 54, '2021-01-26 08:00:00', '2021-01-26 18:00:00', 0, 166),
(563, '569 8831 5323', 923, 72, 73, 80, 39, 42, 51, '2021-01-27 08:00:00', '2021-01-27 18:00:00', 0, 167),
(564, '569 8831 5323', 924, 72, 73, 77, 42, 47, 54, '2021-01-27 08:00:00', '2021-01-27 18:00:00', 0, 168),
(565, '569 8831 5323', 925, 72, 73, 80, 39, 42, 51, '2021-01-28 08:00:00', '2021-01-28 18:00:00', 0, 169),
(566, '569 8831 5323', 926, 72, 73, 77, 42, 47, 54, '2021-01-28 08:00:00', '2021-01-28 18:00:00', 0, 170),
(567, '569 8831 5323', 927, 72, 73, 80, 39, 42, 51, '2021-01-29 08:00:00', '2021-01-29 18:00:00', 0, 171),
(568, '569 8831 5323', 928, 72, 73, 77, 42, 47, 54, '2021-01-29 08:00:00', '2021-01-29 18:00:00', 0, 172),
(569, '\"56 9 8913 8998\"', 929, 70, 71, 72, 33, 46, 42, '2021-01-28 08:00:00', '2021-01-28 18:00:00', 0, 0),
(570, NULL, 930, 70, 71, 77, NULL, NULL, NULL, '2021-01-29 08:00:00', '2021-01-29 08:00:00', 1, 0),
(571, '\"56 9 6919 2558\"', 930, 70, 71, 72, 33, 30, 42, '2021-01-29 08:00:00', '2021-01-29 18:00:00', 0, 0),
(572, '\"56 9 8913 8998\"', 931, 70, 71, 72, 33, 46, 42, '2021-01-30 08:00:00', '2021-01-30 18:00:00', 0, 0),
(573, '\"56 9 8913 8998\"', 932, 70, 71, 72, 33, 46, 42, '2021-01-02 09:00:00', '2021-01-02 16:00:00', 0, 0),
(574, '\"56 9 8913 8998\"', 933, 70, 71, 72, 33, 46, 42, '2021-01-03 09:00:00', '2021-01-03 16:00:00', 0, 0),
(575, '\"56 9 6919 2558\"', 934, 70, 71, 72, 33, 30, 42, '2021-01-04 08:00:00', '2021-01-04 18:00:00', 0, 0),
(576, '\"56 9 8913 8998\"', 935, 70, 71, 72, 33, 46, 42, '2021-01-04 08:00:00', '2021-01-04 18:00:00', 0, 0),
(577, '\"56 9 6919 2558\"', 936, 70, 71, 72, 33, 30, 42, '2021-01-05 08:00:00', '2021-01-05 18:00:00', 0, 0),
(578, '\"56 9 8913 8998\"', 937, 70, 71, 72, 33, 46, 42, '2021-01-05 08:00:00', '2021-01-05 18:00:00', 0, 0),
(579, '\"56 9 8913 8998\"', 939, 70, 71, 72, 33, 46, 42, '2021-01-06 08:00:00', '2021-01-06 18:00:00', 0, 0),
(580, '\"56 9 6919 2558\"', 938, 70, 71, 72, 33, 30, 42, '2021-01-06 08:00:00', '2021-01-06 18:00:00', 0, 0),
(581, '\"56 9 6919 2558\"', 940, 70, 71, 72, 33, 30, 42, '2021-01-07 08:00:00', '2021-01-07 18:00:00', 0, 0),
(582, '\"56 9 8913 8998\"', 941, 70, 71, 72, 33, 46, 42, '2021-01-07 08:00:00', '2021-01-07 18:00:00', 0, 0),
(583, '\"56 9 6919 2558\"', 942, 70, 71, 72, 33, 30, 42, '2021-01-08 08:00:00', '2021-01-08 18:00:00', 0, 0),
(584, '\"56 9 8913 8998\"', 943, 70, 71, 72, 33, 46, 42, '2021-01-08 08:00:00', '2021-01-08 18:00:00', 0, 0),
(585, '\"56 9 6919 2558\"', 944, 70, 71, 72, 33, 30, 42, '2021-01-09 09:00:00', '2021-01-09 16:00:00', 0, 0),
(586, '\"56 9 6919 2558\"', 945, 70, 71, 72, 33, 30, 42, '2021-01-10 09:00:00', '2021-01-10 16:00:00', 0, 0),
(587, '\"56 9 8913 8998\"', 947, 70, 71, 72, 33, 46, 42, '2021-01-11 08:00:00', '2021-01-11 18:00:00', 0, 0),
(588, '\"56 9 6919 2558\"', 946, 70, 71, 72, 33, 30, 42, '2021-01-11 08:00:00', '2021-01-11 18:00:00', 0, 0),
(589, '\"56 9 8913 8998\"', 949, 70, 71, 72, 33, 46, 42, '2021-01-12 08:00:00', '2021-01-12 18:00:00', 0, 0),
(590, '\"56 9 6919 2558\"', 948, 70, 71, 72, 33, 30, 42, '2021-01-12 08:00:00', '2021-01-12 18:00:00', 0, 0),
(591, '\"56 9 8913 8998\"', 951, 70, 71, 72, 33, 46, 42, '2021-01-13 08:00:00', '2021-01-13 18:00:00', 0, 0),
(592, '\"56 9 6919 2558\"', 950, 70, 71, 72, 33, 30, 42, '2021-01-13 08:00:00', '2021-01-13 18:00:00', 0, 0),
(593, '\"56 9 8913 8998\"', 953, 70, 71, 72, 33, 46, 42, '2021-01-14 08:00:00', '2021-01-14 18:00:00', 0, 0),
(594, '\"56 9 6919 2558\"', 952, 70, 71, 72, 33, 30, 42, '2021-01-14 08:00:00', '2021-01-14 18:00:00', 0, 0),
(595, '\"56 9 8913 8998\"', 955, 70, 71, 72, 33, 46, 42, '2021-01-15 08:00:00', '2021-01-15 18:00:00', 0, 0),
(596, '\"56 9 6919 2558\"', 954, 70, 71, 72, 33, 30, 42, '2021-01-15 08:00:00', '2021-01-15 18:00:00', 0, 0),
(597, '\"56 9 6919 2558\"', 956, 70, 71, 72, 33, 30, 42, '2021-01-16 09:00:00', '2021-01-16 16:00:00', 0, 0),
(598, '\"56 9 8913 8998\"', 957, 70, 71, 72, 33, 46, 42, '2021-01-17 09:00:00', '2021-01-17 16:00:00', 0, 0),
(599, '\"56 9 8913 8998\"', 959, 70, 71, 72, 33, 46, 42, '2021-01-18 08:00:00', '2021-01-18 18:00:00', 0, 0),
(600, '\"56 9 6919 2558\"', 958, 70, 71, 72, 33, 30, 42, '2021-01-18 08:00:00', '2021-01-18 18:00:00', 0, 0),
(601, '\"56 9 6919 2558\"', 960, 70, 71, 72, 33, 30, 42, '2021-01-19 08:00:00', '2021-01-19 18:00:00', 0, 0),
(602, '\"56 9 8913 8998\"', 961, 70, 71, 72, 33, 46, 42, '2021-01-19 08:00:00', '2021-01-19 18:00:00', 0, 0),
(603, '\"56 9 6919 2558\"', 962, 70, 71, 72, 33, 30, 42, '2021-01-20 08:00:00', '2021-01-20 18:00:00', 0, 0),
(604, '\"56 9 8913 8998\"', 963, 70, 71, 72, 33, 46, 42, '2021-01-20 08:00:00', '2021-01-20 18:00:00', 0, 0),
(605, '\"56 9 6919 2558\"', 964, 70, 71, 72, 33, 30, 42, '2021-01-21 08:00:00', '2021-01-21 18:00:00', 0, 0),
(606, '\"56 9 8913 8998\"', 965, 70, 71, 72, 33, 46, 42, '2021-01-21 08:00:00', '2021-01-21 18:00:00', 0, 0),
(607, '\"56 9 6919 2558\"', 966, 70, 71, 72, 33, 30, 42, '2021-01-22 08:00:00', '2021-01-22 18:00:00', 0, 0),
(608, '\"56 9 8913 8998\"', 967, 70, 71, 72, 33, 46, 42, '2021-01-22 08:00:00', '2021-01-22 18:00:00', 0, 0),
(609, '\"56 9 6919 2558\"', 968, 70, 71, 72, 33, 30, 42, '2021-01-23 09:00:00', '2021-01-23 16:00:00', 0, 0),
(610, '\"56 9 6919 2558\"', 969, 70, 71, 72, 33, 30, 42, '2021-01-24 09:00:00', '2021-01-24 16:00:00', 0, 0),
(611, '\"56 9 6919 2558\"', 970, 70, 71, 72, 33, 30, 42, '2021-01-25 08:00:00', '2021-01-25 18:00:00', 0, 0),
(612, '\"56 9 8913 8998\"', 971, 70, 71, 72, 33, 46, 42, '2021-01-25 08:00:00', '2021-01-25 18:00:00', 0, 0),
(613, '\"56 9 6919 2558\"', 972, 70, 71, 72, 33, 30, 42, '2021-01-26 08:00:00', '2021-01-26 18:00:00', 0, 0),
(614, '\"56 9 8913 8998\"', 973, 70, 71, 72, 33, 46, 42, '2021-01-26 08:00:00', '2021-01-26 18:00:00', 0, 0),
(615, '\"56 9 6919 2558\"', 974, 70, 71, 72, 33, 30, 42, '2021-01-27 08:00:00', '2021-01-27 18:00:00', 0, 0),
(616, '\"56 9 8913 8998\"', 975, 70, 71, 72, 33, 46, 42, '2021-01-27 08:00:00', '2021-01-27 18:00:00', 0, 0),
(617, '\"56 9 6919 2558\"', 976, 70, 71, 72, 33, 30, 42, '2021-01-28 08:00:00', '2021-01-28 18:00:00', 0, 0),
(618, '\"56 9 8913 8998\"', 977, 70, 71, 72, 33, 46, 42, '2021-01-28 08:00:00', '2021-01-28 18:00:00', 0, 0),
(619, '\"56 9 6919 2558\"', 978, 70, 71, 72, 33, 30, 42, '2021-01-29 08:00:00', '2021-01-29 18:00:00', 0, 0),
(620, '\"56 9 8913 8998\"', 979, 70, 71, 72, 33, 46, 42, '2021-01-29 08:00:00', '2021-01-29 18:00:00', 0, 0),
(621, '\"56 9 8913 8998\"', 980, 70, 71, 72, 33, 46, 42, '2021-01-30 09:00:00', '2021-01-30 16:00:00', 0, 0),
(622, '\"56 9 8913 8998\"', 981, 70, 71, 72, 33, 46, 42, '2021-01-31 09:00:00', '2021-01-31 16:00:00', 0, 0),
(623, '\"56 966542008\"', 982, 72, 74, 75, 43, 48, 55, '2020-11-16 08:00:00', '2020-11-16 18:00:00', 0, 0);
INSERT INTO `tg_servicio` (`serv_ncorr`, `SERV_VCELULAR`, `CAR_NCORR`, `LUG_NCORR_ORIGEN`, `LUG_NCORR_DESTINO`, `EMP_NCORR`, `CHA_NCORR`, `CHOF_NCORR`, `CAM_NCORR`, `SERV_DINICIO`, `SERV_DTERMINO`, `SERV_NTERMINADO`, `GUIA_NCORR`) VALUES
(624, '\"56 966542008\"', 983, 72, 74, 75, 43, 48, 55, '2020-11-16 08:00:00', '2020-11-16 18:00:00', 0, 0),
(625, '\"56 966542008\"', 984, 72, 74, 75, 43, 48, 55, '2020-11-17 08:00:00', '2020-11-17 18:00:00', 0, 0),
(626, '\"56 966542008\"', 985, 72, 74, 75, 43, 48, 55, '2020-11-17 08:00:00', '2020-11-17 18:00:00', 0, 0),
(627, '\"56 966542008\"', 986, 72, 74, 75, 43, 48, 55, '2020-11-18 08:00:00', '2020-11-18 18:00:00', 0, 0),
(628, '\"56 966542008\"', 987, 72, 74, 75, 43, 48, 55, '2020-11-18 08:00:00', '2020-11-18 18:00:00', 0, 0),
(629, '569 8831 5323', 988, 72, 74, 77, 42, 47, 54, '2020-12-07 08:00:00', '2020-12-07 18:00:00', 0, 0),
(630, '\"56 9 95329081\"', 989, 72, 74, 82, 44, 50, 56, '2020-12-16 08:00:00', '2020-12-16 18:00:00', 0, 0),
(631, '\"56 966542008\"', 990, 72, 74, 75, 43, 48, 55, '2020-12-16 08:00:00', '2020-12-16 18:00:00', 0, 0),
(632, '\"56 9 95329081\"', 991, 72, 74, 82, 44, 50, 56, '2020-12-17 08:00:00', '2020-12-17 18:00:00', 0, 0),
(633, '\"56 966542008\"', 992, 72, 74, 75, 43, 48, 55, '2020-12-17 08:00:00', '2020-12-17 18:00:00', 0, 0),
(634, '\"56 9 95329081\"', 993, 72, 74, 82, 44, 50, 56, '2020-12-18 08:00:00', '2020-12-18 18:00:00', 0, 0),
(635, '\"56 966542008\"', 994, 72, 74, 75, 43, 48, 55, '2020-12-18 08:00:00', '2020-12-18 18:00:00', 0, 0),
(636, '\"56 9 95329081\"', 995, 72, 74, 82, 44, 50, 56, '2020-12-21 08:00:00', '2020-12-21 18:00:00', 0, 0),
(637, '\"56 966542008\"', 996, 72, 74, 75, 43, 48, 55, '2020-12-21 08:00:00', '2020-12-21 21:00:00', 0, 0),
(638, '\"56 9 65471699\"', 997, 72, 74, 83, 45, 49, 57, '2020-12-21 08:00:00', '2020-12-21 18:00:00', 0, 0),
(639, '\"56 9 95329081\"', 999, 72, 74, 82, 44, 50, 56, '2020-12-22 08:00:00', '2020-12-22 18:00:00', 0, 0),
(640, '\"56 966542008\"', 1000, 72, 74, 75, 43, 48, 55, '2020-12-22 08:00:00', '2020-12-22 18:00:00', 0, 0),
(641, '\"56 9 65471699\"', 1001, 72, 74, 83, 45, 49, 57, '2020-12-22 08:00:00', '2020-12-22 18:00:00', 0, 0),
(642, '569 8831 5323', 1002, 72, 74, 81, 41, 45, 53, '2020-12-22 08:00:00', '2020-12-22 18:00:00', 0, 0),
(643, '\"56 (2) 25206210\"', 1003, 65, 41, 71, 36, 34, 46, '2021-01-08 06:00:00', '2021-01-27 18:00:00', 0, 0),
(644, '\"56 (2) 25206210\"', 1004, 65, 41, 71, 36, 34, 46, '2021-01-08 06:00:00', '2021-01-27 18:00:00', 0, 0),
(645, '\"56 (2) 25206210\"', 1005, 65, 41, 71, 36, 34, 46, '2021-01-05 06:00:00', '2021-01-19 18:00:00', 0, 0),
(646, '\"56 (2) 25206210\"', 1006, 75, 41, 71, 36, 34, 46, '2021-01-08 06:00:00', '2021-01-27 18:00:00', 0, 0),
(647, '\"56 (2) 25206210\"', 1008, 75, 41, 71, 36, 34, 46, '2021-02-15 06:00:00', '2021-03-03 18:00:00', 0, 0),
(648, '\"56 (2) 25206210\"', 1009, 75, 41, 71, 36, 34, 46, '2021-02-15 06:00:00', '2021-03-15 18:00:00', 0, 0),
(649, '\"\"', 1010, 72, 73, 77, 42, 47, 54, '2021-02-01 08:00:00', '2021-02-01 18:00:00', 0, 173),
(650, '\"940271261\"', 1011, 72, 73, 84, 46, 51, 58, '2021-02-01 08:00:00', '2021-02-01 18:00:00', 0, 174),
(651, '\"\"', 1012, 72, 73, 77, 42, 47, 54, '2021-02-02 08:00:00', '2021-02-02 18:00:00', 0, 175),
(652, '\"940271261\"', 1013, 72, 73, 84, 46, 51, 58, '2021-02-02 08:00:00', '2021-02-02 18:00:00', 0, 176),
(653, '\"940271261\"', 1014, 72, 73, 84, 46, 51, 58, '2021-02-03 08:00:00', '2021-02-03 18:00:00', 0, 177),
(654, '\"\"', 1015, 72, 73, 77, 42, 47, 54, '2021-02-03 08:00:00', '2021-02-03 18:00:00', 0, 178),
(655, '\"940271261\"', 1016, 72, 73, 84, 46, 51, 58, '2021-02-04 08:00:00', '2021-02-04 18:00:00', 0, 179),
(656, '\"\"', 1017, 72, 73, 77, 42, 47, 54, '2021-02-04 08:00:00', '2021-02-04 18:00:00', 0, 180),
(657, '\"940271261\"', 1018, 72, 73, 84, 46, 51, 58, '2021-02-05 08:00:00', '2021-02-05 18:00:00', 0, 181),
(658, '\"\"', 1019, 72, 73, 77, 42, 47, 54, '2021-02-05 08:00:00', '2021-02-05 18:00:00', 0, 182),
(659, '\"940271261\"', 1020, 72, 73, 84, 46, 51, 58, '2021-02-08 08:00:00', '2021-02-08 18:00:00', 0, 183),
(660, '\"\"', 1021, 72, 73, 77, 42, 47, 54, '2021-02-08 08:00:00', '2021-02-08 18:00:00', 0, 185),
(661, '\"940271261\"', 1022, 72, 73, 84, 46, 51, 58, '2021-02-09 08:00:00', '2021-02-09 18:00:00', 0, 186),
(662, '\"\"', 1023, 72, 73, 77, 42, 47, 54, '2021-02-09 08:00:00', '2021-02-09 18:00:00', 0, 187),
(663, '\"940271261\"', 1024, 72, 73, 84, 46, 51, 58, '2021-02-10 08:00:00', '2021-02-10 18:00:00', 0, 188),
(664, '\"\"', 1025, 72, 73, 77, 42, 47, 54, '2021-02-10 08:00:00', '2021-02-10 18:00:00', 0, 189),
(665, '\"940271261\"', 1026, 72, 73, 84, 46, 51, 58, '2021-02-11 08:00:00', '2021-02-11 18:00:00', 0, 190),
(666, '\"\"', 1027, 72, 73, 77, 42, 47, 54, '2021-02-11 08:00:00', '2021-02-11 18:00:00', 0, 192),
(667, '\"940271261\"', 1028, 72, 73, 84, 46, 51, 58, '2021-02-12 08:00:00', '2021-02-12 18:00:00', 0, 193),
(668, '\"\"', 1029, 72, 73, 77, 42, 47, 54, '2021-02-12 08:00:00', '2021-02-12 18:00:00', 0, 194),
(669, '\"940271261\"', 1030, 72, 73, 84, 46, 51, 58, '2021-02-15 08:00:00', '2021-02-15 18:00:00', 0, 195),
(670, '\"\"', 1031, 72, 73, 77, 42, 47, 54, '2021-02-15 08:00:00', '2021-02-15 18:00:00', 0, 196),
(671, '\"940271261\"', 1032, 72, 73, 84, 46, 51, 58, '2021-02-16 08:00:00', '2021-02-16 18:00:00', 0, 197),
(672, '\"\"', 1033, 72, 73, 77, 42, 47, 54, '2021-02-16 08:00:00', '2021-02-16 18:00:00', 0, 198),
(673, '\"940271261\"', 1034, 72, 73, 84, 46, 51, 58, '2021-02-17 08:00:00', '2021-02-17 18:00:00', 0, 199),
(674, '\"\"', 1035, 72, 73, 77, 42, 47, 54, '2021-02-17 08:00:00', '2021-02-17 18:00:00', 0, 200),
(675, '\"940271261\"', 1036, 72, 73, 84, 46, 51, 58, '2021-02-18 08:00:00', '2021-02-18 18:00:00', 0, 201),
(676, '\"\"', 1037, 72, 73, 77, 42, 47, 54, '2021-02-18 08:00:00', '2021-02-18 18:00:00', 0, 202),
(677, '\"940271261\"', 1038, 72, 73, 84, 46, 51, 58, '2021-02-19 08:00:00', '2021-02-19 18:00:00', 0, 203),
(678, '\"\"', 1039, 72, 73, 77, 42, 47, 54, '2021-02-19 08:00:00', '2021-02-19 18:00:00', 0, 204),
(679, '\"940271261\"', 1040, 72, 73, 84, 46, 51, 58, '2021-02-22 08:00:00', '2021-02-22 18:00:00', 0, 205),
(680, '\"\"', 1041, 72, 73, 77, 42, 47, 54, '2021-02-22 08:00:00', '2021-02-22 18:00:00', 0, 206),
(681, '\"940271261\"', 1042, 72, 73, 84, 46, 51, 58, '2021-02-23 08:00:00', '2021-02-23 18:00:00', 0, 207),
(682, '\"\"', 1043, 72, 73, 77, 42, 47, 54, '2021-02-23 08:00:00', '2021-02-23 18:00:00', 0, 208),
(683, '\"940271261\"', 1044, 72, 73, 84, 46, 51, 58, '2021-02-24 08:00:00', '2021-02-24 18:00:00', 0, 209),
(684, '\"\"', 1045, 72, 73, 77, 42, 47, 54, '2021-02-24 08:00:00', '2021-02-24 18:00:00', 0, 210),
(685, '\"940271261\"', 1046, 72, 73, 84, 46, 51, 58, '2021-02-25 08:00:00', '2021-02-25 18:00:00', 0, 211),
(686, '\"\"', 1047, 72, 73, 77, 42, 47, 54, '2021-02-25 08:00:00', '2021-02-25 18:00:00', 0, 212),
(687, '\"940271261\"', 1048, 72, 73, 84, 46, 51, 58, '2021-02-26 08:00:00', '2021-02-26 18:00:00', 0, 213),
(688, '\"\"', 1049, 72, 73, 77, 42, 47, 54, '2021-02-26 08:00:00', '2021-02-26 18:00:00', 0, 214),
(689, '\"940271261\"', 1050, 72, 73, 77, 46, 51, 58, '2021-03-01 08:00:00', '2021-03-01 18:00:00', 0, 0),
(690, '\"\"', 1051, 72, 73, 77, 42, 47, 54, '2021-03-01 08:00:00', '2021-04-01 18:00:00', 0, 0),
(691, '\"940271261\"', 1052, 72, 73, 84, 46, 51, 58, '2021-03-02 08:00:00', '2021-03-02 18:00:00', 0, 0),
(692, NULL, 1053, 72, 73, 77, NULL, NULL, NULL, '2021-04-02 08:00:00', '2021-04-02 08:00:00', 1, 0),
(693, '\"\"', 1053, 72, 73, 77, 42, 47, 54, '2021-03-02 08:00:00', '2021-03-02 18:00:00', 0, 0),
(694, '\"940271261\"', 1054, 72, 73, 84, 46, 51, 58, '2021-03-03 08:00:00', '2021-03-03 18:00:00', 0, 0),
(695, '\"\"', 1055, 72, 73, 77, 42, 47, 54, '2021-03-03 08:00:00', '2021-03-03 18:00:00', 0, 0),
(696, NULL, 1056, 72, 73, 84, NULL, NULL, NULL, '2021-03-04 08:00:00', '2021-03-04 08:00:00', 1, 0),
(697, '\"940271261\"', 1056, 72, 73, 84, 46, 51, 58, '2021-03-04 08:00:00', '2021-03-04 18:00:00', 0, 0),
(698, '\"\"', 1057, 72, 73, 77, 42, 47, 54, '2021-03-04 08:00:00', '2021-03-04 18:00:00', 0, 0),
(699, '\"940271261\"', 1058, 72, 73, 84, 46, 51, 58, '2021-03-05 08:00:00', '2021-03-05 18:00:00', 0, 0),
(700, '\"\"', 1059, 72, 73, 77, 42, 47, 54, '2021-03-05 08:00:00', '2021-03-05 18:00:00', 0, 0),
(701, '\"940271261\"', 1060, 72, 73, 84, 46, 51, 58, '2021-03-08 08:00:00', '2021-03-08 18:00:00', 0, 0),
(702, '\"\"', 1061, 72, 73, 77, 42, 47, 54, '2021-03-08 08:00:00', '2021-03-08 18:00:00', 0, 0),
(703, '\"940271261\"', 1062, 72, 73, 84, 46, 51, 58, '2021-03-09 08:00:00', '2021-03-09 18:00:00', 0, 0),
(704, '\"\"', 1063, 72, 73, 77, 42, 47, 54, '2021-03-09 08:00:00', '2021-03-09 18:00:00', 0, 0),
(705, '\"940271261\"', 1064, 72, 73, 84, 46, 51, 58, '2021-03-10 08:00:00', '2021-03-10 18:00:00', 0, 0),
(706, '\"\"', 1065, 72, 73, 77, 42, 47, 54, '2021-03-10 08:00:00', '2021-03-10 18:00:00', 0, 0),
(707, '\"940271261\"', 1066, 72, 73, 84, 46, 51, 58, '2021-03-11 08:00:00', '2021-03-11 18:00:00', 0, 0),
(708, '\"\"', 1067, 72, 73, 77, 42, 47, 54, '2021-03-11 08:00:00', '2021-03-11 18:00:00', 0, 0),
(709, '\"940271261\"', 1068, 72, 73, 84, 46, 51, 58, '2021-03-12 08:00:00', '2021-03-12 18:00:00', 0, 0),
(710, '\"\"', 1069, 72, 73, 77, 42, 47, 54, '2021-03-12 08:00:00', '2021-03-12 18:00:00', 0, 0),
(711, '\"940271261\"', 1070, 72, 73, 84, 46, 51, 58, '2021-03-15 08:00:00', '2021-03-15 18:00:00', 0, 0),
(712, '\"\"', 1071, 72, 73, 77, 42, 47, 54, '2021-03-15 08:00:00', '2021-03-15 18:00:00', 0, 0),
(713, '\"940271261\"', 1072, 72, 73, 84, 46, 51, 58, '2021-03-16 08:00:00', '2021-03-16 18:00:00', 0, 0),
(714, '\"\"', 1073, 72, 73, 77, 42, 47, 54, '2021-03-16 08:00:00', '2021-03-16 18:00:00', 0, 0),
(715, '\"940271261\"', 1074, 72, 73, 84, 46, 51, 58, '2021-03-17 08:00:00', '2021-03-17 18:00:00', 0, 0),
(716, '\"\"', 1075, 72, 73, 77, 42, 47, 54, '2021-03-17 08:00:00', '2021-03-17 18:00:00', 0, 0),
(717, '\"940271261\"', 1076, 72, 73, 84, 46, 51, 58, '2021-03-18 08:00:00', '2021-03-18 18:00:00', 0, 0),
(718, '\"\"', 1077, 72, 73, 77, 42, 47, 54, '2021-03-18 08:00:00', '2021-03-18 18:00:00', 0, 0),
(719, '\"940271261\"', 1078, 72, 73, 84, 46, 51, 58, '2021-03-19 08:00:00', '2021-03-19 18:00:00', 0, 0),
(720, '\"\"', 1079, 72, 73, 77, 42, 47, 54, '2021-03-19 08:00:00', '2021-03-19 18:00:00', 0, 0),
(721, '\"940271261\"', 1080, 72, 73, 84, 46, 51, 58, '2021-03-22 08:00:00', '2021-03-22 18:00:00', 0, 0),
(722, '\"\"', 1081, 72, 73, 77, 42, 47, 54, '2021-03-22 08:00:00', '2021-03-22 18:00:00', 0, 0),
(723, '\"940271261\"', 1082, 72, 73, 84, 46, 51, 58, '2021-03-23 08:00:00', '2021-03-23 18:00:00', 0, 0),
(724, '\"\"', 1083, 72, 73, 77, 42, 47, 54, '2021-03-23 08:00:00', '2021-03-23 18:00:00', 0, 0),
(725, '\"940271261\"', 1084, 72, 73, 84, 46, 51, 58, '2021-03-24 08:00:00', '2021-03-24 18:00:00', 0, 0),
(726, '\"\"', 1085, 72, 73, 77, 42, 47, 54, '2021-03-24 08:00:00', '2021-03-24 18:00:00', 0, 0),
(727, '\"940271261\"', 1086, 72, 73, 84, 46, 51, 58, '2021-03-25 08:00:00', '2021-03-25 18:00:00', 0, 0),
(728, '\"\"', 1087, 72, 73, 77, 42, 47, 54, '2021-03-25 08:00:00', '2021-03-25 18:00:00', 0, 0),
(729, '\"940271261\"', 1088, 72, 73, 84, 46, 51, 58, '2021-03-26 08:00:00', '2021-03-26 18:00:00', 0, 0),
(730, '\"\"', 1089, 72, 73, 77, 42, 47, 54, '2021-03-26 08:00:00', '2021-03-26 18:00:00', 0, 0),
(731, '\"940271261\"', 1090, 72, 73, 84, 46, 51, 58, '2021-03-29 08:00:00', '2021-03-29 18:00:00', 0, 0),
(732, '\"\"', 1091, 72, 73, 77, 42, 47, 54, '2021-03-29 08:00:00', '2021-03-29 18:00:00', 0, 0),
(733, '\"940271261\"', 1092, 72, 73, 84, 46, 51, 58, '2021-03-30 08:00:00', '2021-03-30 18:00:00', 0, 0),
(734, '\"\"', 1093, 72, 73, 77, 42, 47, 54, '2021-03-30 08:00:00', '2021-03-30 18:00:00', 0, 0),
(735, '\"940271261\"', 1094, 72, 73, 84, 46, 51, 58, '2021-03-31 08:00:00', '2021-03-31 18:00:00', 0, 0),
(736, '\"\"', 1095, 72, 73, 77, 42, 47, 54, '2021-03-31 08:00:00', '2021-03-31 18:00:00', 0, 0),
(737, '\"56 9 6919 2558\"', 1096, 70, 71, 72, 33, 30, 42, '2021-02-01 05:00:00', '2021-02-01 13:00:00', 0, 0),
(738, '\"56 9 8913 8998\"', 1097, 70, 71, 72, 33, 46, 42, '2021-02-01 08:00:00', '2021-02-01 21:00:00', 0, 0),
(739, NULL, 1098, 70, 71, 72, NULL, NULL, NULL, '2021-02-01 08:00:00', '2021-02-01 08:00:00', 1, 0),
(740, '\"56 9 8913 8998\"', 1098, 70, 71, 72, 33, 54, 42, '2021-02-01 08:00:00', '2021-02-01 18:00:00', 0, 0),
(741, '\"56 9 6919 2558\"', 1099, 70, 71, 72, 33, 30, 42, '2021-02-02 05:00:00', '2021-02-02 13:00:00', 0, 0),
(742, '\"56 9 8913 8998\"', 1100, 70, 71, 72, 33, 46, 42, '2021-02-02 08:00:00', '2021-02-02 21:00:00', 0, 0),
(743, '\"56 9 8913 8998\"', 1101, 70, 71, 72, 33, 54, 42, '2021-02-02 08:00:00', '2021-02-02 18:00:00', 0, 0),
(744, '\"56 9 6919 2558\"', 1102, 70, 71, 72, 33, 30, 42, '2021-02-03 05:00:00', '2021-02-03 13:00:00', 0, 0),
(745, '\"56 9 8913 8998\"', 1103, 70, 71, 72, 33, 46, 42, '2021-02-03 08:00:00', '2021-02-03 21:00:00', 0, 0),
(746, '\"56 9 89138998\"', 1104, 70, 71, 72, 33, 52, 42, '2021-02-03 08:00:00', '2021-02-03 18:00:00', 0, 0),
(747, '\"56 9 6919 2558\"', 1105, 70, 71, 72, 33, 30, 42, '2021-02-04 05:00:00', '2021-02-04 13:00:00', 0, 0),
(748, '\"56 9 8913 8998\"', 1106, 70, 71, 72, 33, 46, 42, '2021-02-04 08:00:00', '2021-02-04 21:00:00', 0, 0),
(749, '\"56 9 89138998\"', 1107, 70, 71, 72, 33, 52, 42, '2021-02-04 08:00:00', '2021-02-04 18:00:00', 0, 0),
(750, '\"56 9 6919 2558\"', 1108, 70, 71, 72, 33, 30, 42, '2021-02-05 05:00:00', '2021-02-05 13:00:00', 0, 0),
(751, '\"56 9 8913 8998\"', 1109, 70, 71, 72, 33, 46, 42, '2021-02-05 08:00:00', '2021-02-05 21:00:00', 0, 0),
(752, '\"56 9 89138998\"', 1110, 70, 71, 72, 33, 52, 42, '2021-02-05 08:00:00', '2021-02-05 18:00:00', 0, 0),
(753, '\"56 9 6919 2558\"', 1111, 70, 71, 72, 33, 30, 42, '2021-02-06 08:00:00', '2021-02-06 18:00:00', 0, 0),
(754, '\"56 9 89138998\"', 1112, 70, 71, 72, 33, 52, 42, '2021-02-06 08:00:00', '2021-02-06 18:00:00', 0, 0),
(755, '\"56 9 6919 2558\"', 1113, 70, 71, 72, 33, 30, 42, '2021-02-07 09:00:00', '2021-02-07 16:00:00', 0, 0),
(756, '\"56 9 8913 8998\"', 1114, 70, 71, 72, 33, 46, 42, '2021-02-08 05:00:00', '2021-02-08 13:00:00', 0, 0),
(757, '\"56 9 6919 2558\"', 1115, 70, 71, 72, 33, 30, 42, '2021-02-08 08:00:00', '2021-02-08 21:00:00', 0, 0),
(758, '\"56 9 89138998\"', 1116, 70, 71, 72, 33, 52, 42, '2021-02-08 08:00:00', '2021-02-08 18:00:00', 0, 0),
(759, '\"56 9 8913 8998\"', 1117, 70, 71, 72, 33, 46, 42, '2021-02-09 05:00:00', '2021-02-09 13:00:00', 0, 0),
(760, '\"56 9 6919 2558\"', 1118, 70, 71, 72, 33, 30, 42, '2021-02-09 08:00:00', '2021-02-09 21:00:00', 0, 0),
(761, '\"56 9 89138998\"', 1119, 70, 71, 72, 33, 52, 42, '2021-02-09 08:00:00', '2021-02-09 18:00:00', 0, 0),
(762, '\"56 9 8913 8998\"', 1120, 70, 71, 72, 33, 46, 42, '2021-02-10 05:00:00', '2021-02-10 13:00:00', 0, 0),
(763, '\"56 9 6919 2558\"', 1121, 70, 71, 72, 33, 30, 42, '2021-02-10 08:00:00', '2021-02-10 21:00:00', 0, 0),
(764, '\"56 9 89138998\"', 1122, 70, 71, 72, 33, 52, 42, '2021-02-10 08:00:00', '2021-02-10 18:00:00', 0, 0),
(765, '\"56 (2) 25206210\"', 1007, 65, 41, 71, 36, 34, 46, '2021-04-01 11:00:00', '2021-04-29 12:00:00', 0, 0),
(766, '\"56 9 6919 2558\"', 1128, 70, 71, 72, 33, 30, 42, '2022-04-06 05:00:00', '2022-04-06 18:00:00', 0, 0),
(767, '\"964868893\"', 1138, 79, 79, 85, 47, 55, 59, '2022-04-06 17:58:00', '2022-04-06 18:06:00', 0, 0);

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
(25, 10, 62, NULL, NULL, NULL, NULL, 2100),
(26, 10, 64, NULL, NULL, NULL, NULL, 2100),
(27, 10, 63, NULL, NULL, NULL, NULL, 2100),
(28, 22, 0, NULL, NULL, NULL, NULL, 45000),
(29, 23, 0, NULL, NULL, NULL, NULL, 65000),
(30, 22, 66, NULL, NULL, NULL, NULL, 45000),
(31, 23, 66, NULL, NULL, NULL, NULL, 65000),
(32, 24, 68, NULL, NULL, NULL, NULL, 130000),
(33, 25, 68, NULL, NULL, NULL, NULL, 160000),
(34, 27, 68, NULL, NULL, NULL, NULL, 200000),
(35, 24, 67, NULL, NULL, NULL, NULL, 130000),
(36, 25, 67, NULL, NULL, NULL, NULL, 160000),
(39, 29, 69, NULL, NULL, NULL, NULL, 120000),
(40, 30, 69, NULL, NULL, NULL, NULL, 135000),
(41, 31, 70, NULL, NULL, NULL, NULL, 100000),
(42, 26, 70, NULL, NULL, NULL, NULL, 380000),
(43, 24, 70, NULL, NULL, NULL, NULL, 137000),
(44, 25, 70, NULL, NULL, NULL, NULL, 167000),
(45, 32, 72, NULL, NULL, NULL, NULL, 125000),
(46, 34, 73, NULL, NULL, NULL, NULL, 132000),
(47, 33, 73, NULL, NULL, NULL, NULL, 122000),
(48, 35, 71, NULL, NULL, NULL, NULL, 3800),
(49, 36, 71, NULL, NULL, NULL, NULL, 3940),
(50, 32, 78, NULL, NULL, NULL, NULL, 140000),
(51, 37, 72, NULL, NULL, NULL, NULL, 150000),
(53, 32, 79, NULL, NULL, NULL, NULL, 110000),
(54, 34, 80, NULL, NULL, NULL, NULL, 132000),
(55, 33, 80, NULL, NULL, NULL, NULL, 122000),
(56, 37, 0, NULL, NULL, NULL, NULL, 100000),
(57, 32, 72, NULL, NULL, NULL, NULL, 250000),
(58, 33, 77, NULL, NULL, NULL, NULL, 130000),
(59, 34, 77, NULL, NULL, NULL, NULL, 130000),
(61, 34, 75, NULL, NULL, NULL, NULL, 100000),
(62, 34, 82, NULL, NULL, NULL, NULL, 100000),
(63, 34, 83, NULL, NULL, NULL, NULL, 100000),
(64, 34, 81, NULL, NULL, NULL, NULL, 130000),
(65, 33, 84, NULL, NULL, NULL, NULL, 130000),
(66, 38, 85, NULL, NULL, NULL, NULL, 500000),
(67, 38, 57, NULL, NULL, NULL, NULL, 10000);

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
(7, NULL, 5, 40, 135, 130),
(8, NULL, 2, 40, 105, 100),
(9, NULL, 40, 41, 35, 50),
(10, NULL, 42, 43, 1550, 8640),
(15, NULL, 49, 40, 135, 130),
(16, NULL, 50, 40, 135, 130),
(17, NULL, 40, 51, 30, 30),
(18, NULL, 40, 52, 45, 45),
(19, NULL, 41, 46, 1400, 1900),
(20, NULL, 1, 5, 60, 20),
(21, NULL, 40, 53, 0, 0),
(22, NULL, 54, 54, 1, 30),
(23, NULL, 55, 55, 1, 30),
(24, NULL, 56, 57, 120, 70),
(25, NULL, 56, 58, 135, 90),
(26, NULL, 56, 60, 505, 320),
(27, NULL, 56, 59, 201, 150),
(28, NULL, 57, 56, 120, 70),
(29, NULL, 61, 2, 105, 95),
(30, NULL, 61, 1, 149, 120),
(31, NULL, 56, 62, 64, 50),
(32, NULL, 70, 71, 5, 10),
(33, NULL, 72, 73, 75, 240),
(34, NULL, 72, 74, 75, 240),
(35, NULL, 65, 41, 3280, 2820),
(36, NULL, 75, 41, 3280, 10080),
(37, NULL, 70, 77, 5, 10),
(38, NULL, 79, 79, 20, 40);

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
(15, 15, 10),
(16, 17, 22),
(41, 0, 38),
(32, 27, 32),
(25, 22, 29),
(26, 23, 30),
(29, 24, 31),
(30, 20, 25),
(28, 21, 27),
(27, 19, 24),
(31, 25, 26),
(33, 28, 33),
(34, 29, 34),
(44, 35, 38),
(36, 30, 35),
(37, 32, 37),
(38, 33, 32),
(40, 31, 36),
(43, 36, 37),
(46, 0, 32);

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
(1, 1, 'admin', 'Administrador', '-', '-', '.', '4321'),
(2, 2, 'pperez', 'Pedro', 'Perez', '-', '-', 'pperez'),
(3, 3, 'coordinador', 'Coordinador', 'Transporte', '-', '-', 'coordinador'),
(4, 1, 'cgonzalez', 'Camilo', 'Gonzalez', '', 'cigonzalez@simplexlogistica.cl', 'admin'),
(5, 1, 'haichele', 'Hardy', 'Aichele', 'Oyarzún', 'hardy.aichele@capturactiva.com', ',.haichele'),
(6, 2, 'vendedor', 'usuario', 'vendedor', '-', 'vendedor@simplexlogisitca.cl', 'vendedor'),
(7, 2, 'Igna', 'Ignacio', 'Unzueta', '', 'info@simplexlogistica.cl', 'ignacio'),
(9, 1, 'Ariel', 'Ariel', 'Musumeci', '', 'arielmusumeci@yahoo.com', '4321'),
(11, 1, 'Norman', 'Norman', 'Rigual', 'Cloralt', 'nrigual@simplexlogistica.cl', 'Simplex');

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
  MODIFY `CAR_NCORR` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador de la carga', AUTO_INCREMENT=1140;

--
-- AUTO_INCREMENT de la tabla `tg_detallefactura`
--
ALTER TABLE `tg_detallefactura`
  MODIFY `DEFA_NCORR` double NOT NULL AUTO_INCREMENT COMMENT 'Id. del detalle de la factura';

--
-- AUTO_INCREMENT de la tabla `tg_guiatransporte`
--
ALTER TABLE `tg_guiatransporte`
  MODIFY `guia_ncorr` double NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=215;

--
-- AUTO_INCREMENT de la tabla `tg_log`
--
ALTER TABLE `tg_log`
  MODIFY `log_ncorr` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1487;

--
-- AUTO_INCREMENT de la tabla `tg_ordenservicio`
--
ALTER TABLE `tg_ordenservicio`
  MODIFY `OSE_NCORR` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador del registro', AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT de la tabla `tg_servicio`
--
ALTER TABLE `tg_servicio`
  MODIFY `serv_ncorr` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id. de la programación', AUTO_INCREMENT=768;

--
-- AUTO_INCREMENT de la tabla `tg_tramo`
--
ALTER TABLE `tg_tramo`
  MODIFY `TRA_NCORR` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id. del tramo', AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT de la tabla `tg_tramo_subtiposervicio`
--
ALTER TABLE `tg_tramo_subtiposervicio`
  MODIFY `tss_ncorr` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT de la tabla `tg_versioncarga`
--
ALTER TABLE `tg_versioncarga`
  MODIFY `CAR_NVERSION` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
