

select ds_login from pje.tb_usuario_login tul where ds_nome = 'FRANCISCO OTAVIO COSTA';


select * from pje.tb_processo tp where nr_processo = '0001499-09.2023.5.07.0029';



select right(pd.ds_identificador_unico, 7),
       pd.in_ativo,
       *
from pje.tb_processo_documento pd
where dt_juntada is null
  and pd.id_processo = (select id_processo from pje.tb_processo where nr_processo = '0001624-54.2016.5.07.0018')
order by pd.dt_inclusao;

select tpd.* from pje.tb_processo_documento tpd inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0001624-54.2016.5.07.0018';


UPDATE pje.tb_processo_documento
    SET in_ativo='N'
    WHERE id_processo_documento in (19801842, 19801851);
   
   select 
   	* 
from pje.tb_processo_documento tpd 
inner join pje.tb_processo tp on tpd.id_processo = tp.id_processo 
where tp.nr_processo = '0001624-54.2016.5.07.0018';
    
select * from pje.tb_processo_documento tpd where id_processo_documento = 37939519;

select * from pje.tb_processo_documento d where id_processo = 326872;

select * from pje.tb_processo_documento tpd where tpd.ds_processo_documento = '%Planilha';

select 
	toj.ds_orgao_julgador 
from pje.tb_processo_trf tpt 
inner join pje.tb_orgao_julgador toj on tpt.id_orgao_julgador = toj.id_orgao_julgador 
where tpt.id_processo_trf = (select id_processo from pje.tb_processo where nr_processo = '0001624-54.2016.5.07.0018');
