const express = require('express');
const router = express.Router();
const db = require('../db/db');

// POST /loads → Get filtered load list
router.post('/', async (req, res) => {
  const { startDate, endDate, statusId } = req.body;
  try {
    const [rows] = await db.query(`
      SELECT dbo_tblLoad.LoadID, dbo_tblLoad.LoadCode, dbo_tblLoad.DriverID, dbo_tblLoad.VehicleID, dbo_tblLoad.CompanyID, dbo_tblLoad.OriginAddressID, dbo_tblLoad.DestinationAddressID, dbo_tblLoad.AvailableToLoadDateTime, dbo_tblLoad.LoadStartDate, dbo_tblLoad.LoadStatusID, dbo_tblLoad.SortOrderID, dbo_tblLoad.Weight, dbo_tblLoad.Volume, dbo_tblLoad.RepackagedPalletOrTobaccoID, dbo_tblLoad.CreatedByID, dbo_tblLoad.CreatedDateTime, dbo_tblLoad.IsDeleted, dbo_tblLoad.DeletedDateTime, dbo_tblLoad.DeletedByID, dbo_tblLoad.RowVersionColumn, dbo_tblLoad.WeightUOMID, dbo_tblLoad.VolumeUOMID, dbo_tblLoad.LoadTypeID, dbo_tblParcelDeliveryStatus.ParcelDeliveryStatusID, dbo_tblParcelDeliveryStatus.ParcelDeliveryStatus
FROM dbo_tblParcelDeliveryStatus INNER JOIN ((dbo_tblLoad INNER JOIN dbo_tblVehicle ON dbo_tblLoad.VehicleID = dbo_tblVehicle.VehicleID) INNER JOIN dbo_tblVehicleType ON dbo_tblVehicle.VehicleTypeID = dbo_tblVehicleType.VehicleTypeID) ON dbo_tblParcelDeliveryStatus.ParcelDeliveryStatusID = 1
      WHERE (dbo_tblLoad.AvailableToLoadDateTime) BETWEEN ? AND ? 
      AND LoadStatusID = ?
      ORDER BY dbo_tblLoad.LoadID DESC
    `, [startDate, endDate, statusId]);
    res.json(rows);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// GET /loads/:id → Get load detail and trailer rows
router.get('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    // Master query for load record
    const [masterRows] = await db.query(`
      SELECT L.LoadID, L.LoadCode,
             CONCAT(P.FirstName, ', ', P.LastName) AS Driver,
             V.TruckNumberPlate AS \`Truck Registration\`,
             C.CompanyName,
             A1.AddressName AS \`Origin AddressName\`,
             A2.AddressName AS \`Destination AddressName\`,
             L.AvailableToLoadDateTime,
             S.ParcelDeliveryStatus,
             L.Weight,
             L.Volume
      FROM dbo_tblLoad L
      LEFT JOIN dbo_tblVehicle V ON L.VehicleID = V.VehicleID
      LEFT JOIN dbo_tblVehicleType VT ON V.VehicleTypeID = VT.VehicleTypeID
      LEFT JOIN dbo_tblPerson P ON L.DriverID = P.PersonID
      LEFT JOIN dbo_tblCompany C ON L.CompanyID = C.CompanyID
      LEFT JOIN dbo_tblParcelDeliveryStatus S ON L.LoadStatusID = S.ParcelDeliveryStatusID
      LEFT JOIN dbo_tblAddresses A1 ON L.OriginAddressID = A1.AddressID
      LEFT JOIN dbo_tblAddresses A2 ON L.DestinationAddressID = A2.AddressID
      WHERE L.LoadID = ?
    `, [id]);

    // Detail query for trailers
    const [trailers] = await db.query(`
      SELECT LoadTrailerID, LoadID, TrailerID
      FROM dbo_tblLoadTrailer
      WHERE LoadID = ?
    `, [id]);

    res.json({ master: masterRows[0], trailers });
  } catch (err) {
    console.error(err);
    res.status(500).send(err.message);
  }
});


module.exports = router;
