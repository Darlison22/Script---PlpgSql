

select * from pje.tb_usuario_login tul where tul.ds_nome like 'FERNANDO FONTOURA GOMES';



DO $$
DECLARE

p_nr_processo varchar[]; 
v_id_processo integer = null;
v_in_selecionado_pauta char(1);
v_in_selecionado_julgamento char(1);
v_relator varchar(200);
v_revisor varchar(200);
v_id_sessao integer;
v_dt_sessao date;
v_in_situacao_sessao char(1);
v_tarefa varchar(200); 
v_tarefa_desejada varchar(200) = '%Aguardando inclusão em pauta ou sessão%';
v_ds_sala varchar(50);
i varchar;
   
begin
 p_nr_processo := array['0000686-67.2013.5.07.0017',
						'0000213-78.2014.5.07.0039',
						'0001434-74.2014.5.07.0014',
						'0000782-17.2015.5.07.0016',
						'0001236-59.2014.5.07.0039'];	
	
  foreach i in array p_nr_processo loop
  
	select id_processo into v_id_processo from tb_processo where nr_processo = i;

	select 	oj.ds_orgao_julgador,oj_revisor.ds_orgao_julgador, trf.in_selecionado_pauta, 
	trf.in_selecionado_julgamento, s.id_sessao, s.dt_sessao, s.in_situacao_sessao , sala.ds_sala
	into v_relator, v_revisor, v_in_selecionado_pauta, v_in_selecionado_julgamento, 
	v_id_sessao,v_dt_sessao, v_in_situacao_sessao, v_ds_sala
	from tb_processo_trf trf
		join tb_processo p on p.id_processo = trf.id_processo_trf
		LEFT join tb_orgao_julgador oj on trf.id_orgao_julgador = oj.id_orgao_julgador
		LEFT join tb_orgao_julgador oj_revisor on trf.id_orgao_julgador_revisor = oj_revisor.id_orgao_julgador
		left join tb_pauta_sessao ps on ps.id_processo_trf = trf.id_processo_trf
		left join tb_jt_sessao s on ps.id_sessao = s.id_sessao
		LEFT JOIN tb_sala_horario horario on s.id_sala_horario = horario.id_sala_horario
		LEFT join tb_sala sala on sala.id_sala = horario.id_sala
	where trf.id_processo_trf  = v_id_processo;

	select 	name_ into v_tarefa
	from jbpm_taskinstance task 
		inner join tb_processo_instance  procIns on task.procinst_ =  procIns.id_proc_inst
		inner join tb_processo processo on processo.id_processo =  procIns.id_processo
		inner join tb_processo_trf trf on processo.id_processo = trf.id_processo_trf		
	where trf.id_processo_trf = v_id_processo
	and end_ is null;

	if (v_tarefa not ilike v_tarefa_desejada) then
		raise notice 'Processo: % -- Processo não está na tarefa correta, tarefa atualmente: %' , i, v_tarefa;
		raise notice 'Processo: % -- Sessão de id: % do dia: %', i, v_id_sessao, v_dt_sessao;
		raise notice 'Processo: % -- Sala: %',  i, v_ds_sala;
		raise notice '';
	
	elseif(v_in_situacao_sessao is not null and v_in_situacao_sessao not like 'F' and v_dt_sessao > now()) then
			raise notice 'Processo: % -- Processo já em uma sessão posterior a data atual', i;
			raise notice 'Processo: % -- Sessão de id: % do dia: %', i, v_id_sessao, v_dt_sessao;
			raise notice 'Processo: % -- Sala: %',  i, v_ds_sala;
			raise notice '';

	elseif(v_in_situacao_sessao is not null and v_in_situacao_sessao not like 'F' and v_dt_sessao < now()) then
			raise notice 'Processo: % -- Sessão de Julgamento anterior não fechada', i;
			raise notice 'Processo: % -- Fechar a sessão de id: % do dia: %', i, v_id_sessao, v_dt_sessao;
			raise notice 'Processo: % -- Sala: %',  i, v_ds_sala;
			raise notice '';

	elseif (v_in_situacao_sessao is not null and v_in_situacao_sessao like 'F' and v_in_selecionado_julgamento like 'S') then
		raise notice 'Processo: % -- TUDO OK, verificar composição da sessão que se deseja adicionar', i;
		raise notice 'Processo: % -- Relator: % -- Revisor: % ',  i, v_relator, v_revisor;
		raise notice '';
		
	elseif (v_in_situacao_sessao is not null and v_in_situacao_sessao like 'F' and v_in_selecionado_julgamento like 'N') then
		raise notice 'Processo: % -- update tb_processo_trf set in_selecionado_julgamento = ''S'' where id_processo_trf = %;', i, v_id_processo;
		raise notice '';
		
	elseif (v_in_situacao_sessao is null and v_in_selecionado_pauta like 'S') then
		raise notice 'Processo: % -- TUDO OK, verificar composição da sessão que se deseja adicionar' , i;
		raise notice 'Processo: % -- Relator: % -- Revisor: % ', i, v_relator, v_revisor;
		raise notice '';
		
	elseif (v_in_situacao_sessao is null and v_in_selecionado_pauta like 'N') then
		raise notice 'Processo: % -- update tb_processo_trf set in_selecionado_pauta = ''S'' where id_processo_trf = %;', i, v_id_processo;	
		raise notice '';

	end if;
  end loop;
end;
$$ LANGUAGE plpgsql;





