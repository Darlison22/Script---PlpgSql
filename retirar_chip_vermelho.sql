


select * from tb_usuario_login where ds_nome ilike '%ABEL TEIXEIRA ARIMATEIA%';


(select 'DELETE FROM pje_jt.tb_djen_comunicacao_erro WHERE id_djen_comunicacao_erro=' || tdce.id_djen_comunicacao_erro || ';'
from pje_jt.tb_djen_comunicacao_erro tdce
where id_djen_comunicacao in (select tdc.id_djen_comunicacao
                              from pje_jt.tb_djen_comunicacao tdc 
                              where tdc.id_djen_situacao_comunicacao in (5, 6)
                                and id_processo_trf = (select id_processo from tb_processo where nr_processo = '0000308-55.2025.5.07.0029')
))
union all
(select 'DELETE FROM pje_jt.tb_djen_comunicacao WHERE id_djen_comunicacao=' || tdc.id_djen_comunicacao || ';'
from pje_jt.tb_djen_comunicacao tdc 
where tdc.id_djen_situacao_comunicacao in (5, 6)
  and id_processo_trf = (select id_processo from tb_processo where nr_processo = '0000308-55.2025.5.07.0029'))
union all
(select 'DELETE FROM pje_etq.tb_etq_processo_etiqueta WHERE id_etq_processo_etiqueta=' || tepe.id_etq_processo_etiqueta || ';'
from pje_etq.tb_etq_processo_etiqueta tepe 
where id_etq_etiqueta_instancia in (451, 442)
  and id_processo_trf = (select id_processo from tb_processo where nr_processo = '0000169-06.2025.5.07.0029'))
  
  
  
  DELETE FROM pje_etq.tb_etq_processo_etiqueta WHERE id_etq_processo_etiqueta=15776968;