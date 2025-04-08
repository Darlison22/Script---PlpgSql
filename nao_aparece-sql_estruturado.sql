


create or replace function excluir_registro_tabela_temporaria(p_nr_processo varchar)
returns varchar as $$
declare 

	 v_id_processo integer;
	resultado varchar;

 begin
 	
		select id_processo_trf into v_id_processo from pje.tb_tmp_documento_assinando
		where id_processo_trf = (select id_processo from pje.tb_processo where nr_processo = p_nr_processo);

		if not found then
			raise exception 'Não há registro na tabela temporaria de assinatura para esse processo';
		end if;

		delete from pje.tb_tmp_documento_assinando where id_processo_trf = v_id_processo;

		raise notice 'delete from pje.tb_tmp_documento_assinando where id_processo_trf = %;', v_id_processo;
		resultado = '------------------------------------------------------------------------------------';
		return resultado;

 end;
$$
language plpgsql;
 

--chamada da função
do $$
declare

	resultado varchar;
	
begin
	resultado := excluir_registro_tabela_temporaria('0000101-28.2025.5.07.0006');
	raise notice'%', resultado;
end;
$$
language plpgsql;
