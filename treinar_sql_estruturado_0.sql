


DO $$


DECLARE
    ---------------------------
    -------- PARAMETROS -------
    ---------------------------
    p_id_sessao INTEGER := 8228;
    p_ds_orgao_julgador VARCHAR := 'PAULO R%';
    p_nome_magistrado VARCHAR := 'ROSA DE LOURDES AZ%';
    p_ds_cargo VARCHAR := 'Desembargador'; -- Se der erro, tentar Juiz%

    -- Liste os processos neste array
    p_nr_processo_array VARCHAR[] := ARRAY[
        '0000279-45.2024.5.07.0027',
        '0000335-48.2024.5.07.0037',
        '0000346-07.2024.5.07.0028',
        '0000349-62.2024.5.07.0027'
    ];

	---------- Arrays de ids -----------------
	p_id_processo_array INTEGER[4];
	p_id_pauta_sessao_array integer[4];
	p_id_composicao_sessao_array integer[4];
	posicao integer := 1;

/*p1_nr_processo_array varchar[] := array [

	'0000279-45.2024.5.07.0027',
        '0000335-48.2024.5.07.0037',
        '0000346-07.2024.5.07.0028',
        '0000349-62.2024.5.07.0027'
];

   

   p1_id_processo_array integer[4];
   posicao1 integer := 1;
   p3 integer := 1;
	*/
    ---------------------------
    ------ VARIAVEIS -------
    ---------------------------
    v_id_pauta_sessao INTEGER;
    v_padrao_nome_magistrado VARCHAR;
    v_id_processo INTEGER;
    v_nr_processo VARCHAR;
    v_id_usuario_magistrado INTEGER;
    v_nm_usuario_magistrado VARCHAR;
    v_id_orgao_julgador INTEGER;
    v_ds_orgao_julgador VARCHAR;
    v_padrao_ds_orgao_julgador VARCHAR;
    v_id_cargo INTEGER;
    v_id_orgao_julgador_cargo INTEGER;
    v_ds_orgao_julgador_cargo VARCHAR;
    v_id_orgao_julgador_colegiado INTEGER;
    v_ds_orgao_julgador_colegiado VARCHAR;
    v_tp_orgao_julgador_colegiado VARCHAR;
    v_id_composicao_sessao INTEGER;


BEGIN
    -- Gerar padrão de consulta por nome do magistrado informado
    SELECT '%' || LOWER(TO_ASCII(REPLACE(p_nome_magistrado, ' ', '%'))) || '%' INTO v_padrao_nome_magistrado;

    -- Gerar padrão de consulta por descrição do órgão julgador informado
    SELECT '%' || LOWER(TO_ASCII(REPLACE(p_ds_orgao_julgador, ' ', '%'))) || '%' INTO v_padrao_ds_orgao_julgador;

	
	raise notice '------------------------ INICIO -------------------------------';

 ------------ Preencher o array de id_processo ------------------------------------------
    FOREACH v_nr_processo IN ARRAY p_nr_processo_array LOOP

        -- Procurar o processo
        SELECT id_processo INTO v_id_processo FROM tb_processo WHERE nr_processo = v_nr_processo;

        IF COALESCE(v_id_processo, 0) <> 0 THEN
            -- Armazenar id_processo no array
            p_id_processo_array[posicao] := v_id_processo;
            RAISE NOTICE '-- Processo: (%) - id_processo:(%)', v_nr_processo, v_id_processo;
            posicao := posicao + 1;
        ELSE
            RAISE EXCEPTION 'Processo não localizado: %', v_nr_processo;
        END IF;

    END LOOP;
---------------------------------------------------------------------------------------------


posicao := 1;

-------- Procurar pauta em que o o processo está e armazenar cada pauta em um array de pautas -----
FOREACH v_nr_processo IN ARRAY p_nr_processo_array loop

		select id_pauta_sessao into v_id_pauta_sessao
		from tb_pauta_sessao where id_processo_trf = p_id_processo_array[posicao] AND id_sessao = p_id_sessao;


		if coalesce (v_id_pauta_sessao, 0) <> 0
			then
				p_id_pauta_sessao_array[posicao] := v_id_pauta_sessao;
				posicao := posicao + 1;
			--	raise notice '-- Pauta: (%)', v_id_pauta_sessao;
		else
				raise notice '-- Pauta nao localizada na tabela';
		end if;

end loop;
-------------------------------------------------------------------------------------------------------


------ Mostrar as pautas que foram armazenadas no array de pautas ----------
foreach v_id_pauta_sessao in array p_id_pauta_sessao_array loop

		
			if coalesce(v_id_pauta_sessao, 0) <> 0 then
				
				raise notice '-- Pauta sessão: %', v_id_pauta_sessao;
			else
				raise exception '-- Pauta não encontrada no array';
			end if;

end loop;
-----------------------------------------------------------------------------


---------------------- Procurar usuairo do magistrado ----------------------
	select 
			u.id_usuario, u.ds_nome into
			v_id_usuario_magistrado, v_nm_usuario_magistrado
 	from tb_usuario_login u 
		inner join tb_pessoa_magistrado um on um.id = u.id_usuario
			where LOWER(TO_ASCII(u.ds_nome)) like v_padrao_nome_magistrado;

	if coalesce (v_id_usuario_magistrado, 0) <> 0 then

		raise notice 'id_magistrado: % - ds_magistrado: %', v_id_usuario_magistrado, v_nm_usuario_magistrado;
	else
		raise notice 'Usuario magistrado não encontrado';
	end if;
---------------------------------------------------------------------------


---------------- Procurar orgao julgador do magistrado --------------------
	select oj.id_orgao_julgador, oj.ds_orgao_julgador
	into v_id_orgao_julgador, v_ds_orgao_julgador
	from tb_orgao_julgador oj
	where lower (to_ascii(ds_orgao_julgador)) like v_padrao_ds_orgao_julgador
	and oj.ds_email is not null;


	if coalesce (v_id_orgao_julgador, 0) <> 0 then
		
		raise notice '-- id_orgao_julgador: % - ds_orgao_julgador: %', v_id_orgao_julgador, v_ds_orgao_julgador;
	else
		raise exception 'Orgao julgador do magistrado não encontrado';
	end if;
----------------------------------------------------------------------------


---------------------- Procurar o orgao julgador colegiado ---------------
foreach v_id_processo in array p_id_processo_array loop

	select x.id_orgao_julgador_colegiado, x.ds_orgao_julgador_colegiado, 
			c.id_orgao_julgador_cargo, c.ds_cargo 
	into v_id_orgao_julgador_colegiado, v_ds_orgao_julgador_colegiado, 
			v_id_orgao_julgador_cargo, v_ds_orgao_julgador_cargo
	from tb_processo_trf y
	join tb_orgao_julgador_colgiado x on y.id_orgao_julgador_colegiado = x.id_orgao_julgador_colegiado
	join tb_orgao_julgador_cargo c on c.id_orgao_julgador_cargo = y.id_orgao_julgador_cargo 
	where y.id_processo_trf = v_id_processo;
	
	
	if coalesce(v_id_orgao_julgador_colegiado, 0) <> 0
	then
		raise notice '-- id_orgao_julgador_colegiado: % - ds_orgao_julgador_colegiado: %', v_id_orgao_julgador_colegiado, v_ds_orgao_julgador_colegiado;
	else
		raise exception 'Colegiado nao localizado!';
	end if;
end loop;
------------------------------------------------------------------------------------



------------------ Procurar cargo de distribuicao do orgao julgador -----------------
	/*
	select c.id_orgao_julgador_cargo, c.ds_cargo
	into v_id_orgao_julgador_cargo, v_ds_orgao_julgador_cargo
	from tb_orgao_julgador_cargo c
	join tb_usu_local_mgtdo_servdor u on u.id_orgao_julgador_cargo = c.id_orgao_julgador_cargo and u.id_orgao_julgador = c.id_orgao_julgador
	join tb_cargo cargo on cargo.id_cargo = c.id_cargo
	where c.id_orgao_julgador = v_id_orgao_julgador
	and u.id_orgao_julgador_colegiado = v_id_orgao_julgador_colegiado
	and cargo.ds_cargo ilike p_ds_cargo
	and c.in_ativo = 'S' 
	and u.dt_final is null;
	
	if coalesce(v_id_orgao_julgador_cargo, 0) <> 0
	then
		raise notice '-- Cargo de distribuicao: % (%)', v_id_orgao_julgador_cargo, v_ds_orgao_julgador_cargo;
	else
		raise exception 'Cargo de distribuicao nao localizado!';
	end if;
	*/

	------------------ Procurar o registro nas tabelas de composição -----------------------

posicao := 1;
	
foreach v_id_pauta_sessao in array p_id_pauta_sessao_array loop

	select 
		cs.id_composicao_sessao into v_id_composicao_sessao 
	from pje_jt.tb_composicao_sessao cs
	join pje_jt.tb_composicao_proc_sessao cps on cps.id_composicao_sessao = cs.id_composicao_sessao
	where 1=1
	and cs.id_sessao = p_id_sessao
	and cs.id_orgao_julgador = v_id_orgao_julgador
	and cps.id_pauta_sessao = v_id_pauta_sessao;
	
	if coalesce(v_id_composicao_sessao, 0) <> 0 then
		
		p_id_composicao_sessao_array[posicao] := v_id_composicao_sessao; 
		raise notice '-- Id na composicao: %', v_id_composicao_sessao;
		posicao := posicao + 1;
	else
		
		raise exception 'Id na composição não localizado!';
	end if;


end loop;

raise notice '---------------------------------------------------------------------- UPDATES ---------------------------------------------------------------------------------------';


raise notice '-----------------------------------------------------------------------------------------------------------------------------------------------------------------------';

foreach v_id_pauta_sessao in array p_id_pauta_sessao_array loop

	raise notice 'update tb_pauta_sessao set id_orgao_julgador_redator = %, id_magistrado_redator = %, where id_pauta_sessao = %;', v_id_orgao_julgador, v_id_usuario_magistrado, v_id_pauta_sessao;

end loop;
	
raise notice '-----------------------------------------------------------------------------------------------------------------------------------------------------------------------';

foreach v_id_processo in array p_id_processo_array loop

	raise notice 'update tb_processo_trf set id_orgao_julgador = %, id_orgao_julgador_cargo = % where id_processo_trf = %;', v_id_orgao_julgador, v_id_orgao_julgador_cargo, v_id_processo;

end loop;

raise notice '------------------------------------------------------------------------------------------------------------------------------------------------------------------------';

foreach v_id_composicao_sessao in array p_id_composicao_sessao_array loop

	raise notice 'update pje_jt.tb_composicao_sessao set id_magistrado_presente = % where id_composicao_sessao = % and id_sessao = %;', v_id_usuario_magistrado, v_id_composicao_sessao, p_id_sessao;

end loop;




/*

    -- Procurar usuário do magistrado
    FOREACH v_nr_processo IN ARRAY p_nr_processo_array LOOP

        SELECT u.id_usuario, u.ds_nome
        INTO v_id_usuario_magistrado, v_nm_usuario_magistrado
        FROM tb_usuario_login u
        JOIN tb_pessoa_magistrado m ON m.id = u.id_usuario
        WHERE LOWER(TO_ASCII(u.ds_nome)) LIKE v_padrao_nome_magistrado;

        IF COALESCE(v_id_usuario_magistrado, 0) <> 0 THEN
            RAISE NOTICE '-- Usuário do magistrado: % (%), Posição: %', v_nm_usuario_magistrado, v_id_usuario_magistrado, posicao;
        ELSE
            RAISE EXCEPTION 'Usuário do magistrado não localizado!';
        END IF;
    END LOOP;



	--Treinamento para aprender a pegar o id do processo e jogar num array de ids
	foreach v_nr_processo in array p1_nr_processo_array loop
	
			select id_processo into v_id_processo from tb_processo where nr_processo = v_nr_processo;
	
			if coalesce(v_id_processo, 0) <> 0
				then
					p1_id_processo_array[posicao1] := v_id_processo;
					raise notice '-- processo: % - id_processo: %', v_nr_processo, v_id_processo;
					posicao1 := posicao1 + 1;
			else
					raise exception '--Proceso: (%) nao encontrado', v_nr_processo;
			end if;
	
	
	end loop;


	-- Treinamento para aprender a buscar o id da pauta_sessao
	foreach v_nr_processo in array p1_nr_processo_array loop
	
			select id_pauta_sessao into v_id_pauta_sessao from tb_pauta_sessao where p1_id_processo_array[p3] = id_processo_trf and id_sessao = p_id_sessao;

	
			if coalesce (v_id_pauta_sessao, 0) <> 0 then
				raise notice '-- Processo: % - Pauta: %', v_nr_processo, v_id_pauta_sessao;
				p3 := p3 + 1;
			else
				raise exception '-- Pauta não encontrada';
			end if;
	
	
	end loop;





--Treinamento para pegar o id e nome do magistrado || Aqui que faz uma relação entre o processo, o orgao julgador e o nome do magistrado que está sendo o relator

foreach v_nr_processo in array p1_nr_processo_array loop

	select 
		u1.id_usuario, u1.ds_nome into
		v_id_usuario_magistrado, v_nm_usuario_magistrado 
	from tb_usuario_login u1
	inner join tb_pessoa_magistrado u2 on u2.id = u1.id_usuario
	WHERE LOWER(TO_ASCII(u1.ds_nome)) LIKE v_padrao_nome_magistrado;

	if coalesce(v_id_usuario_magistrado, 0) <> 0 then
		raise notice 'Magistrado: % - id_magistrado: %', v_nm_usuario_magistrado, v_id_usuario_magistrado;
	else
		raise exception 'Magistrado não encontrado';
	end if;
	

end loop;
*/

	raise notice '-------------------------------------------------------------------- FIM -----------------------------------------------------------------------------';


END $$ LANGUAGE plpgsql;
