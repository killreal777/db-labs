create or replace function check_if_astronaut_is_free()
returns trigger as $$
begin
    if exists (
        select 1
        from crew c join expeditions e on (c.expedition_id = e.id and
                c.astronaut_id = new.astronaut_id and e.id != new.expedition_id)
        where (e.end_date is null) or e.end_date > (
            select start_date from expeditions where expeditions.id = new.expedition_id
        )
	) then
	    raise exception 'This astronaut is in expedition at this time.';
    end if;
    return new;
end;
$$ language plpgsql;


create trigger check_if_astronaut_is_free_trigger
before insert on crew
for each row
execute function check_if_astronaut_is_free();