const should = require('chai').should() 
const request = require('supertest');
const jwt = require('jsonwebtoken');

const app = require('../app');
const defaultConfig = require('config-lite')(__dirname)
const ERR_Codes = require('../bll/werrorCodes');
const agent = request(app)

describe('Given a app', function() {
  describe('When refresh token with valid refreshToken', function() {
    it('Then got a new userid and tokens', function(done) {
      let refreshToken = jwt.sign({ userId: 'testUserId' }, defaultConfig.jwtSecret,  {expiresIn: '60s'});
      agent
      .post('/api/refreshToken')
      .send({refreshToken: refreshToken})
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
  describe('When refresh token with valid refreshToken', function() {
    it('Then got a invalid refreshToken error', function(done) {
      let refreshToken = jwt.sign({ userId: 'testUserId' }, defaultConfig.jwtSecret,  {expiresIn: -1});
      agent
      .post('/api/refreshToken')
      .send({refreshToken: refreshToken})
      .set('Accept', 'application/json')
      .expect('Content-Type', /json/)
      .expect(200)
      .expect(function(res) {
          res.body.code.should.to.be.equal(ERR_Codes.ERR_INVAILD_REFRESH_TOKEN);
      })
      .end(function(err, res) {
          if (err) return done(err);
          done();
      });
    });
  });
});
