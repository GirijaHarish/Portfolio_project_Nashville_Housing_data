SELECT TOP (1000) [District]
      ,[State]
      ,[Growth]
      ,[Sex_Ratio]
      ,[Literacy]
  FROM [master].[dbo].[Dataset1_popdata];
  SELECT TOP (1000) [District]
      ,[State]
      ,[Area_km2]
      ,[Population]
  FROM [master].[dbo].[Dataset2];
  --checking the count of rows in two datasets
  select count(*) as count1 FROM [master].[dbo].[Dataset2];
  select count(*) s count2 FROM [master].[dbo].[Dataset1_popdata];

  -- data set for jharkhand and bihar
  select * from [master].[dbo].[Dataset1_popdata]
  where [State] in ('Jharkhand','Bihar')
  order by [State];

  -- calculating the population of India
  select sum([Population]) as Population_India FROM [master].[dbo].[Dataset2];

  -- calculate the average growth of india
  select [Growth] FROM [master].[dbo].[Dataset1_popdata];
  update [master].[dbo].[Dataset1_popdata]
  Set Growth = REPLACE(Growth,'%','');

  Alter table [master].[dbo].[Dataset1_popdata]
  Alter column [Growth] float;

  select round(avg([Growth]),2) as Growth_rate FROM [master].[dbo].[Dataset1_popdata];
 -- average growth percentage by state
 select [State],round(avg([Growth]),2) as Growth_rate 
 FROM [master].[dbo].[Dataset1_popdata]
 group by [State]
 order by State asc;

 -- states having average growth greater than country average

 select [State],round(avg([Growth]),2) as Growth_rate 
 FROM [master].[dbo].[Dataset1_popdata]
 group by [State]
 having round(avg([Growth]),2) > (select round(avg([Growth]),2) FROM [master].[dbo].[Dataset1_popdata])


-- average sex ratio by state
select [State],round(avg([Sex_Ratio]),2) as Avg_sexratio
FROM [master].[dbo].[Dataset1_popdata]
group by [State]
order by Avg_sexratio asc;

--average literacy rate
select [State],round(avg([Literacy]),2) as Avg_Literacy
FROM [master].[dbo].[Dataset1_popdata]
group by [State]
having round(avg([Literacy]),2) > 90
order by Avg_Literacy desc;

--Top 3 states showing highest growthrate 
select  top 3 [State],round(avg([Growth]),2) as Growth_rate 
 FROM [master].[dbo].[Dataset1_popdata]
 group by [State]
 order by Growth_rate desc  ;

 --Bottom 3 average sex ratio by state
select Top 3 [State],round(avg([Sex_Ratio]),2) as Avg_sexratio
FROM [master].[dbo].[Dataset1_popdata]
group by [State]
order by Avg_sexratio asc;


--Top and bottom 3 states having highest and lowest Literacy Rate
select * from (select Top 3 [State],round(avg([Literacy]),2) as Top_bottom3
FROM [master].[dbo].[Dataset1_popdata]
group by [State]
order by round(avg([Literacy]),2) desc) a
UNION All
select * from (select Top 3 [State],round(avg([Literacy]),2) as bottom_3
FROM [master].[dbo].[Dataset1_popdata]
group by [State]
order by round(avg([Literacy]),2) asc) b;



--States starting with 'a' or 'b' 
select distinct(State) from [master].[dbo].[Dataset1_popdata]
where lower(State) like 'a%' or lower(State) like'b%'

--joining both the tables to get male and female population by district
with pop as (select S.state,s.District,(s.Sex_Ratio/1000) as sexratio,p.population from [dbo].[Dataset1_popdata] s 
 inner join [dbo].[Dataset2] p on s.District = p.District ),
 pop_f_m as (select state,District,sexratio,population,round((population * sexratio)/(sexratio + 1),0) as Female_pop,
 round(population/(1+sexratio),0) as male_pop from pop)
 select state ,sum(Female_pop) as F_pipulation,sum(male_pop) as M_population from pop_f_m
 group by state;


--calculating the total literacy rate
select state ,sum(Literate_population) as Total_Literate,sum(Illiterate_population) as Total_Illiterate from (
    select State,District,Literate_population,(Population - Literate_population) as Illiterate_population from (
    select S.state,s.District,((s.Literacy/100)*p.population) as Literate_population,p.population from [dbo].[Dataset1_popdata] s 
 inner join [dbo].[Dataset2] p on s.District = p.District) b) c 
 group by State;

 --populatiobb in previous census
 with census_pop as (select G.District,G.state,round((P.Population/(1+(G.Growth/100))),0) as Previous_census,population as Current_census from [dbo].[Dataset1_popdata] as G 
  inner join [dbo].[Dataset2] p on G.District =P.District),
  State_wise as (select  State,sum(previous_census) as state_previous,sum(Current_census) as State_current from census_pop 
  group by State)
  select sum(state_previous) as Previos_census,sum(State_current) as Current_census from State_wise;

--Top 3 districts from each state having Highest Literacy rate 

select * from (Select District,State,literacy, row_number() over (partition by State order by Literacy desc) as row_num from [dbo].[Dataset1_popdata]) b
where row_num <=3;






