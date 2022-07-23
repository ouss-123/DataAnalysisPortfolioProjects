/*

Cleaning Data in SQL Queries

*/

select *
from PortfolioProject.dbo.NashvilleHousing

--Change Date Format

select SaleDateConverted, convert(date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date, SaleDate)

alter table NashvilleHousing
add SaleDateConverted date

update NashvilleHousing
set SaleDateConverted = convert(date, SaleDate)


-- Populate Propererty Adress Data

Select *
from PortfolioProject.dbo.NashvilleHousing
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing as a
join PortfolioProject.dbo.NashvilleHousing as b
	on a.ParcelID = b.ParcelID 
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing as a
join PortfolioProject.dbo.NashvilleHousing as b
	on a.ParcelID = b.ParcelID 
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


-- Breaking out Adress into Individual Columns (Adress, City, State)

Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing


select 
SUBSTRING(PropertyAddress, 1, charindex(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress)) as Adress
from PortfolioProject.dbo.NashvilleHousing

-- Create 2 new Columns 

alter table PortfolioProject.dbo.NashvilleHousing
add PropertySplitAddress nvarchar(255)

update PortfolioProject.dbo.NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, charindex(',',PropertyAddress)-1)

alter table PortfolioProject.dbo.NashvilleHousing
add PropertySplitCity nvarchar(255)

update PortfolioProject.dbo.NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress))







select
PARSENAME(replace(OwnerAddress, ',', '.'),3),
PARSENAME(replace(OwnerAddress, ',', '.'),2),
PARSENAME(replace(OwnerAddress, ',', '.'),1)
from PortfolioProject.dbo.NashvilleHousing

-- Adding 3 new Columns

alter table PortfolioProject.dbo.NashvilleHousing
add OwnerSplitAddress nvarchar(255)

update PortfolioProject.dbo.NashvilleHousing
set  OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.'),3)


alter table PortfolioProject.dbo.NashvilleHousing
add OwnerSplitCity nvarchar(255)

update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'),2)


alter table PortfolioProject.dbo.NashvilleHousing
add OwnerSplitState nvarchar(255)

update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'),1)


-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End 
from PortfolioProject.dbo.NashvilleHousing



update PortfolioProject.dbo.NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End 







-- Remove Duplicates


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() over( partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
				order by UniqueID) row_num
from PortfolioProject.dbo.NashvilleHousing
)
delete
from RowNumCTE
where row_num > 1
