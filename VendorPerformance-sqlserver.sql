-- 1. Join table to calculate on-time delivery performance.
-- This query retrieves data from multiple tables to calculate the on-time delivery performance of purchase orders. 
-- It joins the purchaseorderheader table with the vendor, shipmethod, purchaseorderdetail, and productvendor tables to gather relevant information.
SELECT 
	purchaseorderheader.PurchaseOrderID,
	purchaseorderheader.Status,
	purchaseorderheader.OrderDate,
	purchaseorderheader.ShipDate,
	purchaseorderheader.Subtotal,
	purchaseorderheader.VendorID,
	purchaseorderheader.Freight,
	vendor.Name AS Vendor,
	vendor.CreditRating,
	purchaseorderdetail.DueDate,
	shipmethod.Name AS ShipMethod,
	shipmethod.ShipBase,
	shipmethod.ShipRate,
	productvendor.AverageLeadTime
FROM Adventureworks2005.dbo.purchaseorderheader AS purchaseorderheader
JOIN Adventureworks2005.dbo.vendor AS vendor
	ON purchaseorderheader.VendorID = vendor.VendorID
JOIN Adventureworks2005.dbo.shipmethod AS shipmethod
	ON purchaseorderheader.ShipMethodID = shipmethod.ShipMethodID
JOIN 
		(SELECT DISTINCT PurchaseOrderID, DueDate
		FROM Adventureworks2005.dbo.purchaseorderdetail) AS purchaseorderdetail
	ON purchaseorderdetail.PurchaseOrderID = purchaseorderheader.PurchaseOrderID
JOIN 
		(SELECT DISTINCT VendorID, AverageLeadTime
		FROM Adventureworks2005.dbo.productvendor) AS productvendor
	ON purchaseorderheader.VendorID = productvendor.VendorID


-- 2. Join table purchaseorderdetail
-- This query retrieves details about purchase orders from the purchaseorderheader table and joins it with a subquery that calculates 
-- the total order quantity, total received quantity, and total rejected quantity from the purchaseorderdetail table.
-- It also includes the vendor information from the vendor table.

SELECT 
	purchaseorderheader.PurchaseOrderID,
	purchaseorderheader.OrderDate,
	purchaseorderheader.Subtotal,
	vendor.Name AS Vendor,
	purchaseorderdetail.TotalOrderQty,
	purchaseorderdetail.TotalReceivedQty,
	purchaseorderdetail.TotalRejectedQty	
FROM Adventureworks2005.dbo.purchaseorderheader AS purchaseorderheader
JOIN (SELECT DISTINCT PurchaseOrderID,
					SUM(OrderQty) AS TotalOrderQty,
					SUM(ReceivedQty) AS TotalReceivedQty,
					SUM(RejectedQty) AS TotalRejectedQty
		FROM Adventureworks2005.dbo.purchaseorderdetail
		GROUP BY PurchaseOrderID) AS purchaseorderdetail
ON purchaseorderdetail.PurchaseOrderID = purchaseorderheader.PurchaseOrderID
JOIN Adventureworks2005.dbo.vendor AS vendor
	ON purchaseorderheader.VendorID = vendor.VendorID



-- 3. Retrieve info on Vendor credit rating and preferred vendor status
-- This query fetches data from the purchaseorderheader and vendor tables to retrieve information about the vendor's credit rating and preferred vendor status. 

-- It joins the purchaseorderheader table with the vendor table based on the VendorID column.
SELECT 
	purchaseorderheader.PurchaseOrderID,
	purchaseorderheader.OrderDate,
	vendor.Name AS Vendor,
	vendor.CreditRating,
	vendor.PreferredVendorStatus
FROM Adventureworks2005.dbo.purchaseorderheader AS purchaseorderheader
JOIN Adventureworks2005.dbo.vendor AS vendor
	ON purchaseorderheader.VendorID = vendor.VendorID