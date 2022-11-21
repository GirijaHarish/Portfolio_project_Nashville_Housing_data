
SELECT TOP (1000) [UniqueID]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [master].[dbo].[Nashville_housingdata];

  use master;

-- converting data type of SalePrice from Varchar to int


    select cast([SalePrice] as int) from [dbo].[Nashville_housingdata]; --"Msg 245, Level 16, State 1, Line 1
    --Conversion failed when converting the nvarchar value '$178,500 ' to data type int.

    --checking the data with SalePrice = '$178,500 ' and updating the value 
    select * from [Nashville_housingdata]
    where SalePrice = '178500 ';

    update [dbo].[Nashville_housingdata] set SalePrice = '178500'
    where uniqueID = 17651; 

    --Altering the table column Saleprice from varchar to int 
    Alter table [dbo].[Nashville_housingdata]
    Alter COLUMN SalePrice bigint;  --Msg 8114, Level 16, State 5, Line 1 Error converting data type nvarchar to bigint.

    select * from [Nashville_housingdata] --Checking the data again 
    where SalePrice like  '%%,%%';
    select * from [Nashville_housingdata] --Checking the data again 
    where SalePrice like  '$%' 


    --Updating and Altering the column 

    update [dbo].[Nashville_housingdata] set SalePrice = REPLACE(SalePrice ,',','')
    where uniqueID in  (26950,57,25017,50605,39467,39539,8996,17845,55748,23307,1390,50606); 
    update [dbo].[Nashville_housingdata] set SalePrice = REPLACE(SalePrice ,'$','')
    where uniqueID in  (26950,57,25017,50605,39467,39539,8996,17845,55748,23307,1390,50606);

    Alter table [dbo].[Nashville_housingdata]
    Alter COLUMN SalePrice bigint;

--Populate property address data 
select * from dbo.[Nashville_housingdata]
where PropertyAddress is null ;


Update a
SET PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from dbo.[Nashville_housingdata] a 
join dbo.[Nashville_housingdata] b 
on a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID
where a.propertyAddress is null;

select * from dbo.[Nashville_housingdata]
where PropertyAddress is null ; --- checking 

--splitting up the property Adress

select propertyAddress, Substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Adress,
Substring(propertyAddress,charindex(',',propertyAddress)+1,len(propertyAddress)) as city
from [master].[dbo].[Nashville_housingdata]

Alter TABLE [master].[dbo].[Nashville_housingdata]
Add Address varchar(255) ;


update [master].[dbo].[Nashville_housingdata]
set Address = substring(PropertyAddress,1,charindex(',',propertyAddress)-1);

Alter TABLE [master].[dbo].[Nashville_housingdata]
Add City_name varchar(255) ;

update [master].[dbo].[Nashville_housingdata]
set City_name = substring(PropertyAddress,charindex(',',propertyAddress)+1,len(PropertyAddress));

select OwnerAddress from dbo.[Nashville_housingdata];

Alter TABLE [master].[dbo].[Nashville_housingdata]
Add Owner_address varchar(255) ;

update [master].[dbo].[Nashville_housingdata]
set Owner_address = PARSENAME(replace(OwnerAddress,',','.'),3);

Alter TABLE [master].[dbo].[Nashville_housingdata]
Add Owner_city varchar(255) ;

update [master].[dbo].[Nashville_housingdata]
set Owner_city = PARSENAME(replace(OwnerAddress,',','.'),2);

Alter TABLE [master].[dbo].[Nashville_housingdata]
Add Owner_State varchar(255) ;

update [master].[dbo].[Nashville_housingdata]
set Owner_State = PARSENAME(replace(OwnerAddress,',','.'),1);

--replacing y to yes and N to no in SoldasVacant

Select soldasvacant,count(*)
from [master].[dbo].[Nashville_housingdata]
group by soldasvacant;

update [master].[dbo].[Nashville_housingdata]
Set soldasvacant = case when soldasvacant = 'Y' then 'yes'
                        when soldasvacant = 'N' then 'No'
                        else soldasvacant
                        END;

--removing duplicates 
with dup_reco as (select * ,row_number() over (partition by ParcelID,propertyAddress,saleDate,saleprice,legalReference order by UniqueID ) as row_num
from [master].[dbo].[Nashville_housingdata])
delete from dup_reco
where row_num > 1;

select * from [dbo].[Nashville_housingdata];

--deleting unwanted columns
Alter Table [dbo].[Nashville_housingdata]
Drop COLUMN propertyAddress,OwnerAddress,TaxDistrict;

select * from [dbo].[Nashville_housingdata];






























