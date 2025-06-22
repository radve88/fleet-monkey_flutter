const express = require('express');
const router = express.Router();
const db = require('../db/db');

router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT ParcelDeliveryStatusID, ParcelDeliveryStatus, SortOrderID 
      FROM dbo_tblParcelDeliveryStatus ORDER BY SortOrderID
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

module.exports = router;
