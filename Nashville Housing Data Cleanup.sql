

---Cleaning Data in SQL queries

select*
from [portfolio project]..[Nashville Housing]


---Standardize Data format

ALTER TABLE [portfolio project]..[Nashville Housing]
ADD SaleDateonly DATE;

UPDATE [portfolio project]..[Nashville Housing]
SET SaleDateOnly = CAST(SaleDate AS DATE);

SELECT SaleDate, SaleDateOnly
FROM [portfolio project]..[Nashville Housing];

ALTER TABLE [portfolio project]..[Nashville Housing]
DROP COLUMN SaleDate;


---Populate property address

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress,b.PropertyAddress) 
from [portfolio project]..[Nashville Housing] a
join [portfolio project]..[Nashville Housing] b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null 

 update a
 set PropertyAddress= isnull(a.propertyaddress,b.PropertyAddress) 
 from [portfolio project]..[Nashville Housing] a
join [portfolio project]..[Nashville Housing] b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]


 ---Breaking out PropertyAddress into Individual column (Address, city, state)

 --Select PropertyAddress
 select PropertyAddress
 from [portfolio project]..[Nashville Housing]

--Split PropertyAddress into Address and City components
 SELECT 
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM [portfolio project]..[Nashville Housing];

--Add new columns for split address and city
ALTER TABLE [portfolio project]..[Nashville Housing]
ADD PropertySplitAddress NVARCHAR(255);

ALTER TABLE [portfolio project]..[Nashville Housing]
ADD PropertySplitCity NVARCHAR(255);

--Update new columns with split address and city
UPDATE [portfolio project]..[Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

UPDATE [portfolio project]..[Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

--updated
 select*
 from [portfolio project]..[Nashville Housing]


 ---Breaking out owneraddress into individual columns (Address,city,state)

--Select OwnerAddress
 select owneraddress
 from [portfolio project]..[Nashville Housing]

----Splitting OwnerAddress
  SELECT 
    PARSENAME(REPLACE(owneraddress, ',', '.'), 3),
    PARSENAME(REPLACE(owneraddress, ',', '.'), 2),
    PARSENAME(REPLACE(owneraddress, ',', '.'), 1),
FROM [portfolio project]..[Nashville Housing];

--Add new columns for split address and city
ALTER TABLE [portfolio project]..[Nashville Housing]
ADD OwnerSplitState1 NVARCHAR(255);

ALTER TABLE [portfolio project]..[Nashville Housing]
ADD OwnerSplitCity NVARCHAR(255);

ALTER TABLE [portfolio project]..[Nashville Housing]
ADD OwnerSplitAddress NVARCHAR(255);

--Update new columns with split address, city, state
UPDATE [portfolio project]..[Nashville Housing]
SET OwnerSplitState1 = PARSENAME(REPLACE(owneraddress, ',', '.'), 3);

UPDATE [portfolio project]..[Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(owneraddress, ',', '.'), 2);

UPDATE [portfolio project]..[Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(owneraddress, ',', '.'), 1);

--updated
 select*
 from [portfolio project]..[Nashville Housing]


 ---Change Y and N to Yes and No in "sold as vacant" field

 --Select SoldasVacant
 select distinct (soldasvacant), COUNT(soldasvacant)
  from [portfolio project]..[Nashville Housing]
  group by SoldAsVacant
  order by 2

--Changing Y to YES and N to NO
  select soldasvacant
  , case when soldasvacant='y' then 'YES'
         when soldasvacant='N' then 'NO'
		 ELSE SoldAsVacant
		 END
from [portfolio project]..[Nashville Housing]

--Update New Column
UPDATE [portfolio project]..[Nashville Housing]
Set SoldAsVacant=case when soldasvacant='y' then 'YES'
         when soldasvacant='N' then 'NO'
		 ELSE SoldAsVacant
		 END

--updated
 select*
 from [portfolio project]..[Nashville Housing]


 ---Removing Duplicates

--Determining Duplicates

  WITH rownumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ParcelID, saleprice, legalReference ORDER BY uniqueID) AS row_num
    FROM [portfolio project]..[Nashville Housing]
)

SELECT *
FROM rownumCTE
WHERE row_num > 1
ORDER BY propertyAddress;

--Deleting Duplicates

  WITH rownumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ParcelID, saleprice, legalReference ORDER BY uniqueID) AS row_num
    FROM [portfolio project]..[Nashville Housing]
)

Delete
FROM rownumCTE
WHERE row_num > 1


---Deleting Unused Column

 select*
 from [portfolio project]..[Nashville Housing]

 Alter Table [portfolio project]..[Nashville Housing]
 Drop column owneraddress, taxDistrict, ownersplitstate