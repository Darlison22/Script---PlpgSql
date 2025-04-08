

select * from pje.tb_log tl order by tl.id_log desc limit 30;

select * from pje.tb_log_detalhe tld order by tld.id_log desc limit 10;

SELECT * 
FROM pje.tb_log_auditoria tla 
WHERE tla.dh_operacao BETWEEN '2024-08-30 00:00:00.000' AND '2024-08-28 23:59:59.999'
and nm_usuario ilike 'ADRIANO ALISSON RENAUX LOPES'
ORDER BY tla.id_log_auditoria DESC 
LIMIT 20000;


select * from pje.tb_log_auditoria tla 
where tla.nm_usuario ilike 'DEMETRIUS DE CASTRO MARTINS SILVEIRA'
and tla.dh_operacao between '2024-08-07' and '2024-08-08'
order by tla.id_log_auditoria desc;

select * from pje.tb_log_auditoria tla 
where tla.nm_usuario ilike 'LUIS EDUARDO FREITAS GOULART'
and tla.dh_operacao between '2024-09-01 00:00.000' and '2024-09-02 23:59:59.999'
order by tla.id_log_auditoria desc
limit 10000;


select * from pje.tb_log_auditoria tla 
where tla.nm_usuario ilike 'MARLEY CISNE DE MORAIS JUNIOR'
and tla.dh_operacao between '2024-09-15 00:00.000' and '2024-09-16 23:59:59.999'
order by tla.id_log_auditoria desc ;


