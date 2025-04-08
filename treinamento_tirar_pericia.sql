

select ds_login from pje.tb_usuario_login tul where tul.ds_nome like 'DENISE LEAL TEIXEIRA';

select * from pje.tb_processo_pericia tpp;

----------------------------------- Treinamento para cancelar pericia ----------------------------------------------------

select * from pje.tb_processo_pericia tpp where id_processo_pericia = 36416;

select 
	tpp.id_processo_pericia ,
	tu.id_usuario ,
	tpp.cd_status_pericia ,
	tpp.dt_cancelamento ,
	tpt.id_processo_trf 
from pje.tb_processo_pericia tpp left outer join pje.tb_usuario tu
on tpp.id_pessoa_marcador_pericia = tu.id_usuario left outer join pje.tb_processo_trf tpt 
on tpp.id_processo_trf = tpt.id_processo_trf  left outer join pje.tb_processo tp2 
on tpt.id_processo_trf = tp2.id_processo 
where tp2.nr_processo = '0000144-45.2019.5.07.0015'; 


update pje.tb_processo_pericia 
	 set id_pessoa_cancela_pericia = 45190,
	     cd_status_pericia = 'C',
	     dt_cancelamento = now()
	     where id_processo_pericia = 36416
	     and id_processo_trf = 519976;
	    
	update pje.tb_processo_pericia

set id_pessoa_cancela_pericia = 45190,

cd_status_pericia = 'F',

dt_cancelamento = now()

where id_processo_trf = 519976

and id_processo_pericia = 36416;
	    
	    
	    
	    insert into pje.tb_historico_processo_pericia 
	   (id_processo_pericia, cd_status_pericia_novo, dh_atualizacao, id_usuario) values(36416, 'C', now(), 45190);

select * from pje.tb_processo_pericia tpp where tpp.id_processo_pericia = 36416;


/*select 
	tu.id_usuario,
	tpp.id_pessoa_marcador_pericia 
from pje.tb_processo_pericia tpp left outer join pje.tb_usuario tu  
on tpp.id_pessoa_marcador_pericia = tu.id_usuario  right outer join pje.tb_processo tp2 
on tpp.id_processo_trf = tp2.id_processo where tp2.nr_processo = '0000144-45.2019.5.07.0015';*/







insert into pje.tb_historico_processo_pericia (id_processo_pericia, cd_status_pericia_novo, dh_atualizacao, id_usuario) values(36416, 'F', now(), 45190);