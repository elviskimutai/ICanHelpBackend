var createError = require("http-errors");
var express = require("express");
var path = require("path");
var cookieParser = require("cookie-parser");
var logger = require("morgan");
//Routes
var auth = require("./routes/SystemAdmin/auth");
var MedicalOfficers = require("./routes/SystemAdmin/MedicalOfficers");
var Countries = require("./routes/SystemAdmin/Countries");
var Medicalcategories = require("./routes/SystemAdmin/Medicalcategories");
var SystemUsers = require("./routes/SystemAdmin/SystemUsers");

var app = express();

// view engine setup
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "jade");

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));


app.use("/api/login", auth.router);

app.use("/api/Medicalcategories", Medicalcategories);
app.use("/api/Countries", Countries);
app.use("/api/MedicalOfficers", MedicalOfficers);
app.use("/api/Register", SystemUsers);


app.use(auth.validateToken);


module.exports = app;
