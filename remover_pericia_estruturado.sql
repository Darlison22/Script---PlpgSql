
CREATE OR REPLACE FUNCTION public.remover_pericia (p_nr_processo CHARACTER VARYING)
RETURNS character varying 
LANGUAGE plpgsql
AS $$
DECLARE
	
	v_id_pessoa_marcador_pericia integer;
	v_id_processo integer;
	v_id_processo_pericia integer;
	resultado character varying;
BEGIN
    
	--Busca os dados necessários nas tabelas do banco.
	select 
			tpp.id_pessoa_marcador_pericia, tpp.id_processo_trf, tpp.id_processo_pericia 
		into v_id_pessoa_marcador_pericia, v_id_processo, v_id_processo_pericia
	from pje.tb_processo_pericia tpp
	inner join pje.tb_processo p on p.id_processo = tpp.id_processo_trf
	where tpp.cd_status_pericia = 'L'
  	and p.nr_processo = p_nr_processo;

	if not found then
		raise exception 'Processo ou pericia não localizados. Certifique-se de que inseriu o processo correto ou que a pericia realmente esteja ativa';
	end if;

	-- Executa de maneira automatica os movimentos para remover pericia
	update pje.tb_processo_pericia
	set id_pessoa_cancela_pericia = v_id_pessoa_marcador_pericia,
    	cd_status_pericia = 'C',
   	 dt_cancelamento = now()
	where id_processo_trf = v_id_processo
  	and id_processo_pericia = v_id_processo_pericia;
  
 	insert into pje.tb_historico_processo_pericia (id_processo_pericia, cd_status_pericia_novo, dh_atualizacao, id_usuario)
	values(v_id_processo_pericia, 'C', now(), v_id_pessoa_marcador_pericia);

	raise notice '-------------------- PROCESSO: % --------------------------', p_nr_processo;

  -- Gera os scripts para serem analisados pelo thiago ou demais servidores
	raise notice 'update pje.tb_processo_pericia set 
		id_pessoa_cancela_pericia = %,
   	 	cd_status_pericia = ''C'',
   		dt_cancelamento = now() 
		where id_processo_trf = % 
	    and id_processo_pericia = %;', v_id_pessoa_marcador_pericia, v_id_processo, v_id_processo_pericia;
  
	raise notice ' '; -- pular 1 linha 

 	raise notice 'insert into pje.tb_historico_processo_pericia (id_processo_pericia, cd_status_pericia_novo, dh_atualizacao, id_usuario)
	values(%, ''C'', now(), %);', v_id_processo_pericia, v_id_pessoa_marcador_pericia;

	raise notice '-----------------------------------------------------------------------------------';

	resultado := 'Movimentos de remoção da pericia executados com sucesso. Veja a mudança em bugfix e copie os scripts para serem analisados';

	RETURN resultado;

END;
$$;


SELECT public.remover_pericia('0000681-03.2021.5.07.0005');

















