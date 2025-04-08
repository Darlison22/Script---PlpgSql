select tcoj.*, tcm.nm_central_mandados
from ctm.tb_oficial_justica toj
inner join ctm.tb_central_oficial_justica tcoj on tcoj.id_oficial_justica = toj.id_oficial_justica
inner join ctm.tb_central_mandados tcm on tcoj.id_central_mandados = tcm.id_central_mandados
where toj.nm_oficial_justica= 'FRANCISCO THIAGO FERREIRA DOS ANJOS'; -- 7 - id de iguatu

-----------------

select tcoj.*, tcm.nm_central_mandados
from ctm.tb_oficial_justica toj
inner join ctm.tb_central_oficial_justica tcoj on tcoj.id_oficial_justica = toj.id_oficial_justica
inner join ctm.tb_central_mandados tcm on tcoj.id_central_mandados = tcm.id_central_mandados
where toj.nm_oficial_justica= 'FRANCISCO THIAGO FERREIRA DOS ANJOS'; -- 7 - id de iguatu


select * from ctm.tb_central_mandados tcm ;


select *
from ctm.tb_oficial_justica toj
where toj.nm_oficial_justica= 'FRANCISCO THIAGO FERREIRA DOS ANJOS'; 




select * from ctm.tb_mandado_documento;

select 
	m.* 
from ctm.tb_mandado m
inner join ctm.tb_central_mandados cm on m.id_central_mandados = cm.id_central_mandados
inner join ctm.tb_mandado_documento md on md.id_mandado = m.id_mandado
where nr_processo_externo = '0000153-64.2016.5.07.0030'
and cm.nm_central_mandados = 'CTM DE CAUCAIA - PJe 2';


delete from ctm.tb_mandado where nr_processo_externo = '0000153-64.2016.5.07.0030' and id_central_mandados = 4;


-------------------------------------------------------------------------------------------------------------

---------------------------------- CHAMADO S113878 ---------------------------------------------

insert into ctm.tb_oficial_justica (id_oficial_justica, nm_oficial_justica, ds_login)
values (nextval('ctm.sq_tb_oficial_justica'), 'FRANCISCO THIAGO FERREIRA DOS ANJOS', '02000319378');

insert into ctm.tb_central_oficial_justica (id_central_mandados, id_oficial_justica, in_distribuidor)
values (7, (select id_oficial_justica from ctm.tb_oficial_justica toj where toj.ds_login = '02000319378'), 'S');


select * from ctm.tb_central_mandados tcm ; --CTM DE IGUATU - PJe 2 -> id_central_mandados = 7













