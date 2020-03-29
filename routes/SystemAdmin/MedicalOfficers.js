var express = require("express");
var MedicalOfficers = express();
var mysql = require("mysql");
var config = require("./DB");
var con = mysql.createPool(config);

const Joi = require("@hapi/joi");
MedicalOfficers.get("/", function(
  req,
  res
) {
  const CompanyID = req.params.CompanyID;
  con.getConnection(function(err, connection) {
    if (err) {
      res.json({
        success: false,
        message: err.message
      });
    } // not connected!
    else {
      let sp = "call SPgetMedicalOfficers()";
      connection.query(sp,  function(error, results, fields) {
        if (error) {
          res.json({
            success: false,
          
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

MedicalOfficers.post("/", function(req, res) {  
  const schema = Joi.object({
  
    Name: Joi.string().required(),
    Email: Joi.string().required(),
    Country: Joi.number().integer(),
    Mobile: Joi.string().required(),
    Address: Joi.string().required(),
    Employed: Joi.string().required(),
    GraduationDate: Joi.date(),
    Qualification: Joi.string().required(),
    Registered: Joi.boolean(),
    Category: Joi.number().integer(),
  });
  //   const result = Joi.validate(, schema);
  //   if (!result.error) {
  try {
    const { error, value } = schema.validate(req.body);

    if (!error) {
      //console.log(res.locals);
      let data = [req.body.Name, req.body.Email, req.body.Category,req.body.Country,req.body.Mobile,req.body.Address,req.body.Employed,req.body.GraduationDate,req.body.Qualification,req.body.Registered];
      
      con.getConnection(function(err, connection) {
        if (err) {
          res.json({
            success: false,
            message: err.message
          });
        } // not connected!
        else {
          let sp = "call Savemedicalofficers(?,?,?,?,?,?,?,?,?,?)";
          connection.query(sp, data, function(error, results, fields) {
            if (error) {
              res.json({
                success: false,
                message: error.message
              });
            } else {
              res.json({
                success: true,
                message: "saved"
              });
            }
            connection.release();
            // Don't use the connection here, it has been returned to the pool.
          });
        }
      });
    } else {
      res.json({
        success: false,
        message: error.details[0].message
      });
    }
  } catch (err) {
    //console.log(err);
    res.json({
      success: false,
      message: err
    });
  }
});

module.exports = MedicalOfficers;
