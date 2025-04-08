

select ds_login from pje.tb_usuario_login tul where ds_nome = 'ABEL TEIXEIRA ARIMATEIA%';



delete
from jbpm_variableinstance
where processinstance_ in (
     select id_proc_inst
     from tb_processo_instance
     where id_processo in (SELECT id_processo FROM TB_PROCESSO where nr_processo in ('0000558-06.2016.5.07.0029'))
)
and ((bytearrayvalue_ is not null and name_ <> 'intimacaoAutomatica:destinatarios') or 
name_ ILIKE ANY (array['%minutaemElaboracao', '%minutaarquivamento', '%modelo', '%temp%', 'prevencao:%', '%pje:atoProferido%']));



select id_proc_inst from pje.tb_processo_instance where id_processo in 
(SELECT id_processo FROM TB_PROCESSO where nr_processo in ('0000558-06.2016.5.07.0029')); --37243852

select * from pje_jbpm.jbpm_variableinstance jv where jv.processinstance_ = 37243852;


