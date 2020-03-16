const should = require('chai').should() 
const request = require('supertest');
const app = require('../app');
const ERR_Codes = require('../bll/werrorCodes');
const di = require('../di');
const agent = request(app)

describe('Given a user who has a account', function() {
  let userEmail = 'test@test.com';
  let userPassword = "password";
  beforeEach(async function() {
    di.configDI();
    await di.userManager.signupUserByEmail(userEmail, userPassword);
  });
  describe('When signin with correct email and password', function() {
    it('Then got a userid and tokens', function(done) {
      agent
      .post('/api/emailSignin')
      .send({email: userEmail, password: userPassword})
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200)
      .expect(function(res) {
          res.body.code.should.to.be.equal(0);
          res.body.data.should.have.property('userId').not.be.null.and.empty;
          res.body.data.should.have.property('accessToken').not.be.null.and.empty;
          res.body.data.should.have.property('refreshToken').not.be.null.and.empty;
      })
      .end(function(err, res) {
          if (err) return done(err);
          done();
      });
    });
  });
  describe('When signin with a wrong password', function() {
    it('Then got a wrong password error', function(done) {
      agent
      .post('/api/emailSignin')
      .send({email: userEmail, password: "wrongpassword"})
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200)
      .expect(function(res) {
          res.body.code.should.to.be.equal(ERR_Codes.ERR_WRONG_PASSWORD);
      })
      .end(function(err, res) {
          if (err) return done(err);
          done();
      });
    });
  });
  describe('When signin with a non-existent email', function() {
    it('Then got a not exists user error', function(done) {
      agent
      .post('/api/emailSignin')
      .send({email: 'non.existent@test.com', password: "123445"})
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200)
      .expect(function(res) {
          res.body.code.should.to.be.equal(ERR_Codes.ERR_USER_NOT_EXISTS);
      })
      .end(function(err, res) {
          if (err) return done(err);
          done();
      });
    });
  });
});
