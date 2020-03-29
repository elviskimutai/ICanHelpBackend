var express = require("express");
var Medicalcategories = express();
var mysql = require("mysql");
var config = require("./DB");
var con = mysql.createPool(config);
Medicalcategories.get("/", function(req, res) {
  
  con.getConnection(function(err, connection) {
    if (err) {
      res.json({
        success: false,
        message: err.message
      });
    } // not connected!
    else {
      let sp = "call Getmedicalcategories()";
      connection.query(sp, function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
            Another: "Bnooo",
            message: error.message
          });
        } else {
          res.json(results[0]);
        }
        connection.release();
        // Don't use the connection here, it has been returned to the pool.
      });
    }
  });
});

module.exports = Medicalcategories;
