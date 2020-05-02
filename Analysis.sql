create database `assignment`;
use assignment;
SET SQL_SAFE_UPDATES = 0;
-- Checking created tables after importing from csv
show tables;
-- Checking structure of created table
desc bajaj_auto;
desc eicher_motors;
desc hero_motocorp;
desc infosys;
desc tcs;
desc tvs_motors;
-- Checking Data stored in tables
select * from bajaj_auto;
select * from eicher_motors;
select * from hero_motocorp;
select * from infosys;
select * from tcs;
select * from tvs_motors;
-- Function to get Month name from Date
delimiter ||
create function getMonth(date varchar(20))
returns varchar(20) deterministic
begin
return (select substring_index(substring_index(Date,'-',2),'-',-1));
end ||
delimiter ;
-- Function to get  date as number
delimiter $$
create function getDate(fileDate varchar(20))
returns  varchar(2) deterministic
begin 
declare formatDate varchar(2);
if fileDate='January' then set formatDate= '1';
elseif  fileDate='February' then set formatDate= '2';
elseif fileDate='March' then set formatDate= '3';
elseif fileDate='April' then set formatDate= '4';
elseif  fileDate='May' then set formatDate= '5';
elseif fileDate='June' then set formatDate= '6';
elseif fileDate='July' then set formatDate= '7';
elseif  fileDate='August' then set formatDate= '8';
elseif fileDate='September' then set formatDate='9';
elseif fileDate='October' then set formatDate='10';
elseif  fileDate='November' then set formatDate= '11';
else set fileDate= '12';
end if;
return formatDate;
end $$
delimiter ;
-- Updating Values of Dates 
update bajaj_auto set Date=(select replace(Date,getMonth(Date),getDate(getMonth(Date))));
update eicher_motors set Date=(select replace(Date,getMonth(Date),getDate(getMonth(Date))));
update hero_motocorp set Date=(select replace(Date,getMonth(Date),getDate(getMonth(Date))));
update infosys set Date=(select replace(Date,getMonth(Date),getDate(getMonth(Date))));
update tcs set Date=(select replace(Date,getMonth(Date),getDate(getMonth(Date))));
update tvs_motors set Date=(select replace(Date,getMonth(Date),getDate(getMonth(Date))));
-- Update Values of Dates to be taken with str_to_date function and convert to date 
update bajaj_auto set `Date`=  str_to_date(`Date`,'%d-%m-%Y');
alter table bajaj_auto modify `Date` date ;
update eicher_motors set `Date`=  str_to_date(`Date`,'%d-%m-%Y');
alter table eicher_motors modify `Date` date ;
update hero_motocorp set `Date`=  str_to_date(`Date`,'%d-%m-%Y');
alter table hero_motocorp modify `Date` date ;
update infosys set `Date`=  str_to_date(`Date`,'%d-%m-%Y');
alter table infosys modify `Date` date ;
update tcs set `Date`=  str_to_date(`Date`,'%d-%m-%Y');
alter table tcs modify `Date` date ;
update tvs_motors set `Date`=  str_to_date(`Date`,'%d-%m-%Y');
alter table tvs_motors modify `Date` date ;

-- TASK 1 
-- Create table bajaj1
create table bajaj1 as select `Date`,`Close Price`, 
avg(`Close Price`) over(order by `Date` rows between 19 preceding and current row) as '20 Day MA',
avg(`Close Price`) over(order by `Date` rows between 49 preceding and current row) as '50 Day MA'
from bajaj_auto;
-- Create table eicher1
create table eicher1 as select `Date`,`Close Price`,
avg(`Close Price`) over(order by `Date` rows between 19 preceding and current row) as '20 Day MA',
avg(`Close Price`) over(order by `Date` rows between 49 preceding and current row) as '50 Day MA'
from eicher_motors;
-- Create table hero1
create table hero1 as select `Date`,`Close Price`,
avg(`Close Price`) over(order by `Date` rows between 19 preceding and current row) as '20 Day MA',
avg(`Close Price`) over(order by `Date` rows between 49 preceding and current row) as '50 Day MA'
from hero_motocorp; 
-- Create table infosys1
Create table infosys1 as select `Date`,`Close price`,
avg(`Close price`) over(order by `Date` rows  between 19 preceding and current row) as '20 Day MA',
avg(`Close price`) over(order by `Date` rows  between 49 preceding and current row) as '50 Day MA'
from infosys;
-- Create table tcs1
Create table tcs1 as select `Date`,`Close price`,
avg(`Close price`) over(order by `Date` rows  between 19 preceding and current row) as '20 Day MA',
avg(`Close price`) over(order by `Date` rows  between 49 preceding and current row) as '50 Day MA'
from tcs; 
-- Create table tvs1
Create table tvs1 as select `Date`,`Close price`,
avg(`Close price`) over(order by `Date` rows  between 19 preceding and current row) as '20 Day MA',
avg(`Close price`) over(order by `Date` rows  between 49 preceding and current row) as '50 Day MA'
from tvs_motors;
-- Making first 19 rows NULL 
update bajaj1 set `20 Day MA` = NULL limit 19;
update eicher1 set `20 Day MA` = NULL limit 19;
update hero1 set `20 Day MA` = NULL limit 19;
update infosys1 set `20 Day MA` = NULL limit 19;
update tcs1 set `20 Day MA` = NULL limit 19;
update tvs1 set `20 Day MA` = NULL limit 19;
-- Making first 49 rows NULL 
update bajaj1 set `50 Day MA` = NULL limit 49;
update eicher1 set `50 Day MA` = NULL limit 49;
update hero1 set `50 Day MA` = NULL limit 49;
update infosys1 set `50 Day MA` = NULL limit 49;
update tcs1 set `50 Day MA` = NULL limit 49;
update tvs1 set `50 Day MA` = NULL limit 49;
-- Checking Data
select * from bajaj1;
select * from eicher1;
select * from hero1;
select * from infosys1;
select * from tcs1;
select * from tvs1;

-- Task 2
-- Create master_stock_info table
create table master_stock_info as 
select tcs.`Date`,b.`Close price` as 'Bajaj',
tcs.`Close price` as 'TCS' ,tvs.`Close price` as 'TVS',
i.`Close price` as 'Infosys',e.`Close price` as 'Eicher',
h.`Close price` as 'Hero'
from tcs  inner join eicher_motors e on e.`Date`=tcs.`Date`
join  tvs_motors tvs on tvs.`Date`= tcs.`Date`
join  hero_motocorp h on h.`Date` = tcs.`Date`
join  bajaj_auto b on b.`Date`=tcs.`Date`
join  infosys i on i.`Date`=tcs.`Date` 
order by tcs.`Date`;
-- Display data from master_stock_info
select * from master_stock_info;
-- Task 2 :End 

-- Task 3 
-- create table bajaj2
create table bajaj2 as select `Date`,`Close price`,
case 
	when `50 Day MA` is NULL then 'NA'
	when `20 Day MA`>`50 Day MA` 
		and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) 
			then 'BUY'
	when `20 Day MA`<`50 Day MA` 
		and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) 
			then 'SELL'
	else 'HOLD' 
end as `Signal`
from bajaj1 ;
-- create table eicher2 
create table eicher2 as select `Date`,`Close price`,
case 
	when `50 Day MA` is NULL then 'NA'
	when `20 Day MA`>`50 Day MA` 
		and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) 
			then 'BUY'
	when `20 Day MA`<`50 Day MA` 
		and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) 
			then 'SELL'
	else 'HOLD' 
end as `Signal`
from eicher1;
 
-- create table tcs2
create table tcs2 as select `Date`,`Close price`,
case 
	when `50 Day MA` is NULL then 'NA'	
	when `20 Day MA`>`50 Day MA` 
		and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) 
			then 'BUY'
	when `20 Day MA`<`50 Day MA` 
		and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) 
			then 'SELL'
	else 'HOLD' 
end as `Signal`
from tcs1 ;
 
-- create table tvs2
create table tvs2 as select `Date`,`Close price`,
case 
	when `50 Day MA` is NULL then 'NA'
	when `20 Day MA`>`50 Day MA` 
		and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) 
			then 'BUY'
	when `20 Day MA`<`50 Day MA` 
		and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) 
			then 'SELL'
	else 'HOLD' 
end as `Signal`
from tvs1 ;
 
-- create table hero2
create table hero2 as select `Date`,`Close price`,
case 
	when `50 Day MA` is NULL then 'NA'
	when `20 Day MA`>`50 Day MA` 
		and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) 
			then 'BUY'
	when `20 Day MA`<`50 Day MA` 
		and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) 
			then 'SELL'
	else 'HOLD' 
end as `Signal`
from hero1 ;
 
-- create  table infosys2
create table infosys2 as select `Date`,`Close price`,
case 
	when `50 Day MA` is NULL then 'NA'
	when `20 Day MA`>`50 Day MA` 
		and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) 
			then 'BUY'
	when `20 Day MA`<`50 Day MA` 
		and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) 
        then 'SELL'
	else 'HOLD' 
end as `Signal`
from infosys1 ;
 

 -- Checking Data
 select * from bajaj2;
 select * from eicher2;
 select * from hero2;
 select * from infosys2;
 select * from tcs2;
 select * from tvs2;
-- Task 3 :End


-- Task 4 
DELIMITER $$
create function getSignal(signal_date date)
	returns varchar(20) deterministic
BEGIN
	return (select `Signal` from bajaj2 where bajaj2.`Date` = signal_date);
END $$
DELIMITER ;
-- testing of function
select getSignal(`Date`),`Date` as 'Signal' from bajaj_auto;
-- Expected output  BUY  
select getSignal('2018-06-21');
-- Actual output BUY ->Pass 

-- Expected output SELL 
select getSignal('2018-05-29');
-- Actual output SELL ->Pass

-- Expected output HOLD 
select getSignal('2018-05-30');
-- Actual output HOLD ->Pass

-- Expected output NA 
select getSignal('2015-01-01');
-- Actual output NA ->Pass
-- Task 4 End 
 
-- Task 5
-- Getting the number of times bought and sold
select * from bajaj2 where `Signal`='BUY' or `Signal`='SELL';
select count(*) from bajaj2 where `Signal`='SELL';
select count(*) from bajaj2 where `Signal`='BUY'; 
select * from tcs2 where `Signal`='BUY' or `Signal`='SELL';
select count(*) from tcs2 where `Signal`='SELL';
select * from eicher2 where `Signal`='BUY' or `Signal`='SELL';
select count(*) from eicher2 where `Signal`='SELL';
select count(*) from eicher2 where `Signal`='BUY';
select * from tvs2 where `Signal`='BUY' or `Signal`='SELL';
select count(*) from tvs2 where `Signal`='SELL';
select count(*) from tvs2 where `Signal`='BUY';
select * from hero2 where `Signal`='BUY' or `Signal`='SELL';
select count(*) from hero2 where `Signal`='SELL';
select count(*) from hero2 where `Signal`='BUY';
select * from infosys2 where `Signal`='BUY' or `Signal`='SELL';
select count(*) from infosys2 where `Signal`='SELL';
select count(*) from infosys2 where `Signal`='BUY';
-- Getting the trend
select round((select `Close price` from bajaj_auto  
order by `Date` desc limit 1) - (select `Close price` from bajaj_auto  
order by `Date`  limit 1),2) as 'Trend';
 
select round((select `Close price` from tcs 
order by `Date` desc limit 1) - (select `Close price` from tcs  
order by `Date`  limit 1),2) as 'Trend';
 
select round((select `Close price` from eicher_motors  
order by `Date` desc limit 1) - (select `Close price` from eicher_motors  
order by `Date`  limit 1),2) as 'Trend';
 
select round((select `Close price` from tvs_motors  
order by `Date` desc limit 1) - (select `Close price` from tvs_motors  
order by `Date`  limit 1),2) as 'Trend';
 
select round((select `Close price` from infosys  
order by `Date` desc limit 1) - (select `Close price` from infosys  
order by `Date`  limit 1),2) as 'Trend';
