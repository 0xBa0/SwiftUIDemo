var express = require('express');
var router = express.Router();
const errors = require('../bll/werrors');
const di = require('../di');

di.configDI('data/datafile');

router.post('/emailSignup', function(req, res, next) {
  let email = req.body.email
  let password = req.body.password
  di.userManager.signupUserByEmail(email, password)
    .then(function (userId) {
      res.json({code:0, data: {userId: userId}});
    })
    .catch(function (err) {
      next(err)
    });
});
router.post('/emailSignin', function(req, res, next) {
  let email = req.body.email
  let password = req.body.password
  di.userManager.signinByEmail(email, password)
    .then(function (sigininfo) {
      res.json({code:0, data: sigininfo});
    })
    .catch(function (err) {
      next(err)
    });
});
router.post('/refreshToken', function(req, res, next) {
  let refreshToken = req.body.refreshToken
  di.userManager.refreshToken(refreshToken)
    .then(function (sigininfo) {
      res.json({code:0, data: sigininfo});
    })
    .catch(function (err) {
      next(err)
    });
});

router.use(function(err, req, res, next) {
  //console.log(err)
  if (err instanceof errors.WError) { 
      res.status(200).json({code: err.code, message: err.message});
  } else {
      let err2 = errors.internalError()
      res.status(200).json({code: err2.code, message: err2.message});
  }
  
});

module.exports = router;
