WITH job_name AS (
SELECT
    UNNEST(ARRAY['ComunicacaoAssincronaJob-EnvioEmail']) AS jobname
)
SELECT
    jn.jobname,
    SUBSTRING(je.jobParameters,
    'grauInstancia = (\d)') AS instancia,
    se.*
FROM
    job_jberet.step_execution AS se
INNER JOIN job_jberet.job_execution AS je on se.jobexecutionid = je.jobexecutionid
INNER JOIN job_jberet.job_instance AS ji on je.jobinstanceid = ji.jobinstanceid
INNER JOIN job_name AS jn on ji.jobname = jn.jobname
	where SUBSTRING(je.jobParameters, 'grauInstancia = (\d)') = '1'
ORDER by se.starttime DESC
LIMIT 100000;


WITH TIMERS as (
  SELECT encode(substr(decode(info,'base64'),4),'escape') as jobinfo, * 
    FROM jboss_ejb_timer
   ORDER BY 1 )
SELECT * FROM TIMERS WHERE jobinfo ilike '%EnvioEmail%';



update job_jberet.step_execution
set batchstatus = 'ABANDONED', exitstatus = 'ABANDONED'
where stepexecutionid in (select se.stepexecutionid 
							from job_jberet.step_execution AS se
								INNER JOIN job_jberet.job_execution AS je on se.jobexecutionid = je.jobexecutionid
								INNER JOIN job_jberet.job_instance AS ji on je.jobinstanceid = ji.jobinstanceid
							where 1=1
								and ji.jobname = 'ComunicacaoAssincronaJob-EnvioEmail'
								and SUBSTRING(je.jobParameters, 'grauInstancia = (\d)') = '1'
								and se.batchstatus = 'STARTED'
								and se.exitstatus is null
							);

update job_jberet.job_execution
set batchstatus  = 'ABANDONED', exitstatus  = 'ABANDONED'
where jobexecutionid in (select je.jobexecutionid  
							from job_jberet.job_execution AS je
								INNER JOIN job_jberet.job_instance AS ji on je.jobinstanceid = ji.jobinstanceid
							where 1=1
								and ji.jobname = 'ComunicacaoAssincronaJob-EnvioEmail'
								and SUBSTRING(je.jobParameters, 'grauInstancia = (\d)') = '1'
								and je.batchstatus = 'STARTED'
								and je.exitstatus is null
							);