

--------------------------------------------------
-- Lancar de movimento de transito em julgado
--------------------------------------------------

do $$

declare 

	-- Parametros
	p_nr_processo varchar := '0080291-69.2020.5.07.0000';
	p_dt_transito_julgado date := '2021-04-07';
	p_dt_movimento timestamp := null; -- NULL -> CURRENT_TIMESTAMP
	
	-- Variaveis
	v_id_processo bigint;
	v_dt_transito_julgado varchar;
	v_id_processo_evento bigint;

begin
		
		--busca o processo no banco e coloca um tratamento para excessão no caso de não encontrar o processo na base de dados
		select id_processo into v_id_processo from pje.tb_processo where nr_processo = p_nr_processo;
		if not found then
			raise exception 'Processo não localizado';
		end if;
		
		--Atribui a data do transito em julgado para a variavel
		v_dt_transito_julgado := to_char(p_dt_transito_julgado, 'DD/MM/YYYY');
		-- Pega a sequencia do proximo id na tabela de processo_evento e atribui a variavel
		v_id_processo_evento := nextval ('sq_tb_processo_evento');
		
		--Faz os inserts necessários para lançar o movimento
		insert into pje.tb_processo_evento (id_processo_evento , id_processo, id_evento, id_usuario, dt_atualizacao, id_processo_documento, 
		in_processado, in_verificado_processado, tp_processo_evento, ds_texto_final_externo, ds_texto_final_interno, in_visibilidade_externa, ds_texto_parametrizado)
		values (v_id_processo_evento, v_id_processo, 848, 0, coalesce(p_dt_movimento, current_timestamp), null,
		'N', 'N', 'M', 'Transito em julgado em ' || v_dt_transito_julgado, 'Transito em julgado em ' || v_dt_transito_julgado, true,  'Transito em julgado em #{data do trânsito}');
	
		insert into pje.tb_complemento_segmentado (vl_ordem, ds_texto, ds_valor_complemento, id_movimento_processo, id_tipo_complemento, in_visibilidade_externa, in_multivalorado)
		values (0, '5002', v_dt_transito_julgado, v_id_processo_evento, 6, true, false);
	
end $$ language plpgsql;
