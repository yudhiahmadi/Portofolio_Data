USE ProyekKimiaFarma

--Check and Cleaning
----------------------------------------------
SELECT * 
FROM ProyekKimiaFarma..Penjualan

Select REPLACE(lini, ',,,', ' ')
From ProyekKimiaFarma.dbo.Penjualan

Update Penjualan
SET lini = REPLACE(lini, ',,,', ' ')

----------------------------------------------

SELECT * 
FROM ProyekKimiaFarma..Pelanggan

EXEC sp_RENAME 'Pelanggan.group' , 'grup', 'COLUMN'

----------------------------------------------

SELECT * 
FROM ProyekKimiaFarma..Barang

----------------------------------------------

SELECT * 
FROM ProyekKimiaFarma..Penjualan_ds

----------------------------------------------

SELECT * 
FROM ProyekKimiaFarma..Pelanggan_ds

----------------------------------------------

SELECT * 
FROM ProyekKimiaFarma..Barang_ds

----------------------------------------------
--Processing Data
----------------------------------------------
--CTE

WITH TableBase (Tanggal, id_distributor, id_cabang, id_invoice, id_customer, id_barang, id_group, brand_id, Kode_brand, brand, Jumlah_barang, HargaPenjualan, Unit, Level, Nama, Grup, Sektor, Nama_barang, Tipe, Nama_tipe, Kemasan, HargaBarang, Cabang_sales)
AS
(
SELECT pjn.tanggal, pjn.id_distributor, pjn.id_cabang, pjn.id_invoice, pjn.id_customer, pjn.id_barang, pln.id_group, pjn.brand_id, brgs.kode_brand, pjn.lini AS brand, pjn.jumlah_barang, pjn.harga as HargaPenjualan, pjn.unit, pln.level, pln.nama, pln.grup, brg.sektor, brg.nama_barang, brg.tipe, brg.nama_tipe, brg.kemasan, brgs.harga AS HargaBarang, plgs.cabang_sales
FROM ProyekKimiaFarma..Penjualan pjn
JOIN ProyekKimiaFarma..Pelanggan pln
	ON pjn.id_customer = pln.id_customer
JOIN ProyekKimiaFarma..Barang brg
	ON pjn.id_barang = brg.kode_barang
JOIN ProyekKimiaFarma..Barang_ds brgs
	ON pjn.id_barang = brgs.kode_barang
JOIN ProyekKimiaFarma..Pelanggan_ds plgs 
	ON pjn.id_customer = plgs.id_customer
)

SELECT *
FROM TableBase
ORDER BY 1

----------------------------------------------
--Save in View
CREATE VIEW TableBase as
SELECT pjn.tanggal, pjn.id_distributor, pjn.id_cabang, pjn.id_invoice, pjn.id_customer, pjn.id_barang, pln.id_group, pjn.brand_id, brgs.kode_brand, pjn.lini AS brand, pjn.jumlah_barang, pjn.harga AS HargaPenjualan, pjn.unit, pln.level, pln.nama, pln.grup, brg.sektor, brg.nama_barang, brg.tipe, brg.nama_tipe, brg.kemasan, brgs.harga AS HargaBarang, plgs.cabang_sales
FROM ProyekKimiaFarma..Penjualan pjn
JOIN ProyekKimiaFarma..Pelanggan pln
	ON pjn.id_customer = pln.id_customer
JOIN ProyekKimiaFarma..Barang brg
	ON pjn.id_barang = brg.kode_barang
JOIN ProyekKimiaFarma..Barang_ds brgs
	ON pjn.id_barang = brgs.kode_barang
JOIN ProyekKimiaFarma..Pelanggan_ds plgs 
	ON pjn.id_customer = plgs.id_customer

---------------------------------------------- 
--AGREGATING
Select SUM(Jumlah_barang) as Total_Jumlah_barang, SUM(HargaPenjualan) as Total_HargaPenjualan
From TableBase
ORDER BY 1


Select cabang_sales, COUNT(cabang_sales) AS Jumlah_Cabang, SUM(Jumlah_barang) as Total_Jumlah_barang, SUM(hargapenjualan) as Total_Harga_Penjualan
From TableBase
GROUP BY cabang_sales
ORDER BY 1

Select brand, COUNT(brand) AS Jumlah_Brand, SUM(Jumlah_barang) as Total_Jumlah_barang, SUM(hargapenjualan) as Total_Harga_Penjualan
From TableBase
GROUP BY brand
ORDER BY 1

Select kemasan, COUNT(kemasan) AS Jumlah_Kemasan, SUM(Jumlah_barang) as Total_Jumlah_barang, SUM(hargapenjualan) as Total_Harga_Penjualan
From TableBase
GROUP BY kemasan
ORDER BY 1 

Select nama as Nama_Tempat_Jual, COUNT(nama) AS Jumlah_Tempat_Jual, SUM(Jumlah_barang) as Total_Jumlah_barang, SUM(hargapenjualan) as Total_Harga_Penjualan
From TableBase
GROUP BY nama
ORDER BY 1 

Select grup as Jenis_Tempat_Jual, COUNT(grup) AS Jumlah_Tempat_Jual, SUM(Jumlah_barang) as Total_Jumlah_barang, SUM(hargapenjualan) as Total_Harga_Penjualan
From TableBase
GROUP BY grup
ORDER BY 1 

Select nama_barang as Nama_Barang, COUNT(nama_barang) AS Jumlah_Nama_Barang, SUM(HargaBarang) as Total_Harga_Barang
From TableBase
GROUP BY nama_barang
ORDER BY 1 
