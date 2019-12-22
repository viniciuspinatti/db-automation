/*
    Random number in a range. 
    Visit: http://www.postgresqltutorial.com/postgresql-random-range/
*/
drop function if exists automations.fn_random_between;
CREATE OR REPLACE FUNCTION automations.fn_random_between(low int, high int) 
   RETURNS INT AS
$$
begin
   return floor(random()* (high-low + 1) + low);
end;
$$ language 'plpgsql' STRICT;


drop procedure if exists automations.prc_generate_choice;
create or replace procedure automations.prc_generate_choice()
language 'plpgsql' 
as $$
declare
	v_id int;
begin
	select
		automations.fn_random_between(1, count(*)::int)
 	into
 		v_id
	from
		automations.person;
		
	insert into automations.choice(id_person) values(v_id);
end
$$;


/*
    This will call the procedure every minute.
    Easy way to create a cron schedule: https://crontab.guru/ 
*/
select 
    cron.schedule('* * * * *', $$call automations.prc_generate_choice()$$);


/*
    How many times each person appeared?
*/
select 
	per.name,
	count(cho.cd_id) as how_many_times
from
	automations.choice as cho
	join automations.person as per on per.cd_id = cho.id_person
group by
	per.name
order by
	how_many_times desc;