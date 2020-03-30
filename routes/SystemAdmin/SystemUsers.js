var express = require("express");
var SystemUsers = express();
var mysql = require("mysql");
var config = require("./DB");
var con = mysql.createPool(config);
const bcrypt = require("bcryptjs");
const Joi = require("@hapi/joi");

var auth = require("./auth");
SystemUsers.get("/",  function(
  req,
  res
) {
  con.getConnection(function(err, connection) {
    if (err) {
      res.json({
        success: false,
        message: err.message
      });
    } // not connected!
    else {
      let sp = "call GetUsers()";
      connection.query(sp,  function(
        error,
        results,
        fields
      ) {
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


SystemUsers.post("/", function(req, res) {
  const schema = Joi.object({
    Country: Joi.number().integer(),
    MobileNo: Joi.string()
      .min(10)
      .required(),
      Email: Joi.string()
      .min(3)
      .required(),
    Password: Joi.string().regex(/^[a-zA-Z0-9]{3,30}$/),
    Email: Joi.string().email({ minDomainSegments: 2 }),
    Name: Joi.string().required()
  });
  //   const result = Joi.validate(, schema);
  //   if (!result.error) {
  try {
    const { error, value } = schema.validate(req.body);

    if (!error) {
      bcrypt.hash(req.body.Password, 10, function(err, hash) {
       if (err) {
          return res.json({
            success: false,
            message: "failed to bcyrpt the password"
          });
        }

        let data = [
          req.body.Name,
          req.body.Email,
          hash,
          req.body.Country,
          req.body.Email,
          req.body.MobileNo,
         
          
        ];
        con.getConnection(function(err, connection) {
          if (err) {
            res.json({
              success: false,
              message: err.message
            });
          } // not connected!
          else {
            let sp = "call SaveUser(?,?,?,?,?)";
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
SystemUsers.put("/:ID", function(req, res) {
 
        con.getConnection(function(err, connection) {
          if (err) {
            res.json({
              success: false,
              message: err.message
            });
          } // not connected!
          else {
            let sp = "call ApproveUser(?)";
            connection.query(sp, [req.params.ID], function(error, results, fields) {
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
     
});
SystemUsers.delete("/:ID", function(req, res) {
 
  con.getConnection(function(err, connection) {
    if (err) {
      res.json({
        success: false,
        message: err.message
      });
    } // not connected!
    else {
      let sp = "call DeleteUser(?)";
      connection.query(sp, [req.params.ID], function(error, results, fields) {
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

});
module.exports = SystemUsers;
