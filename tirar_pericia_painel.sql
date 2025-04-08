
select ds_login from pje.tb_usuario_login tul where tul.ds_nome = 'NAZARENO RODRIGUES ROCHA';


select 
		tpp.id_pessoa_marcador_pericia ,
       tpp.id_processo_trf ,
       tpp.id_processo_pericia 
from tb_processo_pericia tpp
inner join tb_processo p on p.id_processo = tpp.id_processo_trf
where tpp.cd_status_pericia = 'L'
  and p.nr_processo = '0000681-03.2021.5.07.0005';
  
 

update tb_processo_pericia
set id_pessoa_cancela_pericia = 96336,
    cd_status_pericia = 'C',
    dt_cancelamento = now()
where id_processo_trf = 565188
  and id_processo_pericia = 34102;
  
 
 insert into tb_historico_processo_pericia (id_processo_pericia, cd_status_pericia_novo, dh_atualizacao, id_usuario)
values(34102, 'C', now(), 96336);


select * from pje.tb_processo_pericia tpp ;
select * from pje.tb_historico_processo_pericia thpp ;


