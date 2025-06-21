// serve   r.js
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

const statusRoutes = require('./routes/statusRoutes');
const loadRoutes = require('./routes/loadRoutes');

app.use(cors());
app.use(express.json());

app.use('/status', statusRoutes);
app.use('/loads', loadRoutes);

app.listen(port, () => {
  console.log(`Fleet Monkey backend running on port ${port}`);
});


      SELECT * FROM dbo_tblLoad WHERE LoadID = ?
    `, [id]);
    const [trailers] = await db.query(`
      SELECT * FROM dbo_tblLoadTrailer WHERE LoadID = ?
    `, [id]);
    res.json({ master: master[0], trailers });
  } catch (err) {
    res.status(500).send(err.message);
  }
});

module.exports = router;
