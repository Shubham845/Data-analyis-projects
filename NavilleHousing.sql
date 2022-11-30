select * from PortfolioProject.dbo.NashvilleHousing

--Date Change
select SaleDate from NashvilleHousing

Alter table  NashvilleHousing
add SaleDateup date

update NashvilleHousing
SET SaleDateup = convert(Date,SaleDate)

--NULL VALUES
 
select * from PortfolioProject.dbo.NashvilleHousing
  Where PropertyAddress is NULL
  order by ParcelID


  select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
  from 
  PortfolioProject.dbo.NashvilleHousing a
  JOIN PortfolioProject.dbo.NashvilleHousing b
   on a.ParcelID=b.ParcelID
   and a.[UniqueID ]<>b.[UniqueID ]
   WHERE a.PropertyAddress is NULL

  UPDATE a
  SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
  from 
  PortfolioProject.dbo.NashvilleHousing a
  JOIN PortfolioProject.dbo.NashvilleHousing b
   on a.ParcelID=b.ParcelID
   and a.[UniqueID ]<>b.[UniqueID ]
   WHERE a.PropertyAddress is NULL

--Splitting Address
              --Property ADDRESS
 select PropertyAddress from PortfolioProject.dbo.NashvilleHousing

 Select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
 SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))as Address from
 PortfolioProject.dbo.NashvilleHousing

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 ADD PropertysplitAddress NVARCHAR(255);

 Update PortfolioProject.dbo.NashvilleHousing
 SET PropertysplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 ADD PropertysplitCity NVARCHAR(255);

  Update PortfolioProject.dbo.NashvilleHousing
 SET PropertysplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

        --OWNER ADDRESS

select OwnerAddress from PortfolioProject.dbo.NashvilleHousing

select PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing	

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 ADD OwnersplitAddress NVARCHAR(255);

 Update PortfolioProject.dbo.NashvilleHousing
 SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 ADD OwnersplitCity NVARCHAR(255);

  Update PortfolioProject.dbo.NashvilleHousing
 SET OwnersplitCity =PARSENAME(REPLACE(OwnerAddress,',','.'),2)

 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
 ADD Ownersplitstate NVARCHAR(255);

  Update PortfolioProject.dbo.NashvilleHousing
 SET Ownersplitstate =PARSENAME(REPLACE(OwnerAddress,',','.'),1)

 ---CHANGE Y AND N AS YEAS AND NO

select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 1

select SoldAsVacant,
CASE WHEN SoldAsVacant='Y' THEN 'YES'
     WHEN SoldAsVacant='N' THEN 'NO'
	 ELSE SoldAsvacant END
	from PortfolioProject.dbo.NashvilleHousing

	UPDATE PortfolioProject.dbo.NashvilleHousing
	SET SoldAsVacant=
	CASE WHEN SoldAsVacant='Y' THEN 'YES'
     WHEN SoldAsVacant='N' THEN 'NO'
	 ELSE SoldAsvacant END

--Delete Duplicates
WITH row_NUMCTE AS (

select *,ROW_NUMBER() OVER(
         PARTITION BY ParcelID,
		              PropertyAddress,
                      SalePrice,
					  LegalReference
					  Order by
					   UniqueID
					   ) row_num
from PortfolioProject.dbo.NashvilleHousing
)

select * from row_numCTE
WHERE row_num>1
ORDER BY PropertyAddress

DELETE  from row_numCTE
WHERE row_num>1


--DELETE COLUMNS

ALTER Table PortfolioProject.dbo.NashvilleHousing
 Drop column PropertyAddress,SaleDate,OwnerAddress