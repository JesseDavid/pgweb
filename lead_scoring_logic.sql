CREATE OR REPLACE FUNCTION set_lead_score(
    current_rating DOUBLE precision,
    has_budget BOOLEAN,
    rating character varying,
    city character varying) 
RETURNS NUMERIC AS $$
DECLARE newScore NUMERIC;
BEGIN
    newScore := current_rating;
    
    IF has_budget THEN
      newScore := newScore + 5;
    ELSE
      newScore := newScore - 10;
    END IF;
    
    IF rating = 'Hot' THEN
      newScore := newScore + 7;
    ELSIF rating = 'Warm' THEN
      newScore := newScore;
    ELSE 
      newScore := newScore - 8;
    END IF;
    
    IF city IS NULL THEN
      newScore := newScore - 2;
    END IF;  
    
    IF newScore > 100 THEN
      newScore := 100;
    ELSIF newScore < 0 THEN
      newScore := 0;
    END IF;
      
    
    RETURN newScore;
END; $$

LANGUAGE plpgsql;


create or replace procedure update_leads()
language plpgsql    
as $$
begin
   UPDATE salesforce.lead
    SET lead_score_value__c = set_lead_score( lead_score_value__c, has_budget__c, rating, city )
    WHERE  lastname LIKE 'C%';

    commit;
end;$$
