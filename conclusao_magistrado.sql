


select ds_login from pje.tb_usuario_login tul where ds_nome like 'GEORGE DAMASCENO SIQUEIRA';


select ulms.*, cargo.*, visib.*
from tb_usu_local_mgtdo_servdor ulms
join tb_usuario_localizacao ul on ul.id_usuario_localizacao = ulms.id_usu_local_mgstrado_servidor
join tb_orgao_julgador_cargo cargo on cargo.id_orgao_julgador_cargo = ulms.id_orgao_julgador_cargo
left join tb_usu_local_visibilidade visib on visib.id_usu_local_mgstrado_servidor = ulms.id_usu_local_mgstrado_servidor
where 1=1
and ulms.dt_inicio <= current_date
and (ulms.dt_final>= current_date or ulms.dt_final is null)
and ul.id_papel = (select id_papel from pje.tb_papel tp where ds_nome ilike 'magistrado')
and ul.id_usuario = (select id_usuario  from pje.tb_usuario_login tul where ds_nome = 'MARIA RAFAELA DE CASTRO')
and ulms.id_orgao_julgador = (select id_orgao_julgador from tb_orgao_julgador where ds_orgao_julgador = '1ª Vara do Trabalho de Caucaia');

select * from pje.tb_orgao_julgador toj ;


-- tb_usu_local_mgtrado_servidor ids antigos: 25857 e 25857

select * from pje.tb_usu_local_visibilidade tulv where tulv.id_usu_local_mgstrado_servidor = 109836;

--tb_usu_local_visibilidade ids antigos: 3889 e 3192

delete from pje.tb_usu_local_visibilidade where id_usu_localzacao_visibilidade = 3889;
delete from pje.tb_usu_local_visibilidade where id_usu_localzacao_visibilidade = 3192;
delete from pje.tb_usu_local_mgtdo_servdor whre where whre.id_usu_local_mgstrado_servidor = 25857;










