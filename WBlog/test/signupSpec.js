const should = require('chai').should() 
const request = require('supertest');
const app = require('../app');
const ERR_Codes = require('../bll/werrorCodes');
const di = require('../di');
const agent = request(app)

describe('Given a user without a account', function() {
  beforeEach(function() {
    di.configDI();
  });
  describe('When signup a account with correct email and password', function() {
    it('Then got a userid', function(done) {
      agent
      .post('/api/emailSignup')
      .send({email: 'test@test.com', password: 'password'})
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200)
      .expect(function(res) {
          res.body.code.should.to.be.equal(0);
          res.body.data.should.have.property('userId').not.be.null.and.empty;
      })
      .end(function(err, res) {
          if (err) return done(err);
          done();
      });
    });
  });
  describe('When signup a account without email.', function() {
    it('Then got a empty email error', function(done) {
      agent
      .post('/api/emailSignup')
      .send({password: 'password'})
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200)
      .expect(function(res) {
          res.body.code.should.to.equal(ERR_Codes.ERR_EMPTY_EMAIL)
      })
      .end(function(err, res) {
          if (err) return done(err);
          done();
      });
    });
  });
  describe('When signup a account without password.', function() {
    it('Then got a empty password error', function(done) {
      agent
      .post('/api/emailSignup')
      .send({email: 'test@test.com'})
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200)
      .expect(function(res) {
        res.body.code.should.to.equal(ERR_Codes.ERR_EMPTY_PASSWORD)
      })
      .end(function(err, res) {
          if (err) return done(err);
          done();
      });
    });
  });
  describe('When signup a account with empty parameters.', function() {
    it('Then got a empty email error', function(done) {
      agent
      .post('/api/emailSignup')
      .send({})
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200)
      .expect(function(res) {
         res.body.code.should.to.equal(ERR_Codes.ERR_EMPTY_EMAIL)
      })
      .end(function(err, res) {
          if (err) return done(err);
          done();
      });
    });
  });
  describe('and with a exists user', function() {
    let userEmail = 'test@test.com';
    let userPassword = "password";
    beforeEach(async function() {
      await di.userManager.signupUserByEmail(userEmail, userPassword);
    });
    describe('When signup a account with a exists email', function() {
      it('Then got a exists email error', function(done) {
        agent
        .post('/api/emailSignup')
        .send({email: 'test@test.com', password: 'password2'})
        .set('Accept', 'application/json')
        .expect('Content-Type', /json/)
        .expect(200)
        .expect(function(res) {
           res.body.code.should.to.equal(ERR_Codes.ERR_EXISTS_EMAIL)
        })
        .end(function(err, res) {
            if (err) return done(err);
            done();
        });
      });
    });
  });
});
