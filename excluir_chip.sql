
--------------------------------------------------  CHAMADO S107182 -------------------------------------------------

--verificar as etiquetas do processo e copie o nome da que deseja excluir, passando como parametro na função
  select 
	tee.nm_etiqueta,
	tac.ds_aplicacao_classe, 
	tepe.id_etq_processo_etiqueta ,
	tepe.dh_inclusao 
from pje_etq.tb_etq_processo_etiqueta tepe 
inner join pje_etq.tb_etq_etiqueta_instancia teei on tepe.id_etq_etiqueta_instancia = teei.id_etq_etiqueta_instancia 
inner join pje.tb_aplicacao_classe tac on teei.id_instancia = tac.id_aplicacao_classe 
inner join pje_etq.tb_etq_etiqueta tee on teei.id_etq_etiqueta = tee.id_etq_etiqueta 
inner join pje.tb_processo tp on tepe.id_processo_trf = tp.id_processo 
where tp.nr_processo = '0000403-08.2018.5.07.0037';


--execute a função com os parametros passados
create or replace function public.excluir_chip(p_nr_processo character varying, p_nm_etiqueta character varying)
returns character varying
language plpgsql
as $$
declare
    v_id_processo integer;
    v_id_etq_processo_etiqueta integer;
    resultado character varying;

begin
    select id_processo into v_id_processo from pje.tb_processo where nr_processo = p_nr_processo;
    if not found then
        raise exception 'Processo não encontrado. Verifique se o número do processo está correto';
    end if;

    select 
		tepe.id_etq_processo_etiqueta into v_id_etq_processo_etiqueta
    from pje_etq.tb_etq_processo_etiqueta tepe 
    inner join pje_etq.tb_etq_etiqueta_instancia teei on tepe.id_etq_etiqueta_instancia = teei.id_etq_etiqueta_instancia
    inner join pje_etq.tb_etq_etiqueta tee on teei.id_etq_etiqueta = tee.id_etq_etiqueta
    inner join pje.tb_processo tp on tepe.id_processo_trf = tp.id_processo
    where tp.nr_processo = p_nr_processo 
	and tee.nm_etiqueta = p_nm_etiqueta;

    if not found then
        raise exception 'Chip não encontrado, verifique se o nome passado como parametro está correto';
    end if;

    delete from pje_etq.tb_etq_processo_etiqueta where id_etq_processo_etiqueta = v_id_etq_processo_etiqueta;    
    resultado := 'Chip excluído com sucesso';
    return resultado;
end;
$$;


select public.excluir_chip('0000403-08.2018.5.07.0037', 'Recebido do TST');





