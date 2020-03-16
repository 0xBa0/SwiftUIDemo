var chai = require("chai");
var chaiAsPromised = require("chai-as-promised");
chai.use(chaiAsPromised);

const should = require('chai').should();
const expect = require('chai').expect;
const jwt = require('jsonwebtoken');

const ERR_Codes = require('../bll/werrorCodes');
const defaultConfig = require('config-lite')(__dirname)
const di = require('../di');

describe('Given a userManager', function() {
  beforeEach(function() {
     di.configDI();
  });
  describe('When create a account with correct email and password', function() {
    it('Then got a userid', function() {
      return di.userManager.signupUserByEmail('test@test.com', 'password')
              .should.eventually.not.be.null.and.empty;
    });
  });
  describe('When create a account without email.', function() {
    it('Then got a empty email error', function() {
      return di.userManager.signupUserByEmail(null, 'password')
              .should.eventually.be.rejected
              .and.have.property('code').to.be.equal(ERR_Codes.ERR_EMPTY_EMAIL)
    });
  });
  describe('When create a account with a invalid email.', function() {
    it('Then got a invalid email error', function() {
      return di.userManager.signupUserByEmail('abc', 'password')
              .should.eventually.be.rejected
              .and.have.property('code').to.be.equal(ERR_Codes.ERR_INVAIL_EMAIL)
    });
  });
  describe('When create a account without password.', function() {
    it('Then got a empty password error', function() {
      return di.userManager.signupUserByEmail('test@test.com', null)
              .should.eventually.be.rejected
              .and.have.property('code').to.be.equal(ERR_Codes.ERR_EMPTY_PASSWORD)
    });
  });
  describe('When create a account with a 5 characters password.', function() {
    it('Then got a invalid password error', function() {
      return di.userManager.signupUserByEmail('test@test.com', '12345')
              .should.eventually.be.rejected
              .and.have.property('code').to.be.equal(ERR_Codes.ERR_INVAIL_PASSWORD)
    });
  });
  describe('When create a account with a 21 characters password.', function() {
    it('Then got a invalid password error', function() {
      return di.userManager.signupUserByEmail('test@test.com', '12345678901234567890a')
              .should.eventually.be.rejected
              .and.have.property('code').to.be.equal(ERR_Codes.ERR_INVAIL_PASSWORD)
    });
  });
  describe('and with a exists user', function() {
    let userEmail = 'test@test.com';
    let userPassword = "password";
    beforeEach(async function() {
      await di.userManager.signupUserByEmail(userEmail, userPassword);
    });
    describe('When signup a account with a exists email', function() {
      it('Then got a exists email error', function() {
        return di.userManager.signupUserByEmail(userEmail, userPassword)
                .should.eventually.be.rejected
                .and.have.property('code').to.be.equal(ERR_Codes.ERR_EXISTS_EMAIL);
      });
    });
    //test get user by email
    describe('When get user by email', function() {
      it('Then got the correct user', function() {
        return di.userManager.getUserByEmail(userEmail)
                .should.eventually.have.property('email').to.be.equal(userEmail);
      });
    });
    describe('When get user by a not exists email', function() {
      it('Then get a null', function() {
        return di.userManager.getUserByEmail('test123@abc.com')
                .should.eventually.to.be.null;
      });
    });
    describe('When get user by a null email', function() {
      it('Then got a empty email error', function() {
        return di.userManager.getUserByEmail(null)
                          .should.eventually.be.rejected
                          .and.have.property('code').to.be.equal(ERR_Codes.ERR_EMPTY_EMAIL)
      });
    });
    describe('When get user by a empty email', function() {
      it('Then got a empty email error', function() {
        return di.userManager.getUserByEmail('')
                          .should.eventually.be.rejected
                          .and.have.property('code').to.be.equal(ERR_Codes.ERR_EMPTY_EMAIL)
      });
    });
    describe('When get user by a invalid email', function() {
      it('Then got a invalid email error', function() {
        return di.userManager.getUserByEmail('abc')
                          .should.eventually.be.rejected
                          .and.have.property('code').to.be.equal(ERR_Codes.ERR_INVAIL_EMAIL)
      });
    });
    //test login
    describe('When login with a correct user', function() {
      it('Then got the user id and tokens', async function() {
        let loginedInfo = await di.userManager.signinByEmail(userEmail, userPassword);
        loginedInfo.should.have.property('userId').not.be.null.and.empty;
        loginedInfo.should.have.property('accessToken').not.be.null.and.empty;
        loginedInfo.should.have.property('refreshToken').not.be.null.and.empty;
      });
    });
    describe('When login with wrong password', function() {
      it('Then got a wrong password error', async function() {
        return di.userManager.signinByEmail(userEmail, 'password2')
                .should.eventually.be.rejected
                .and.have.property('code').to.be.equal(ERR_Codes.ERR_WRONG_PASSWORD);
      });
    });
    describe('When login with a not exists user', function() {
      it('Then got a not exists user error', async function() {
        return di.userManager.signinByEmail('test2@abc.com', userPassword)
                .should.eventually.be.rejected
                .and.have.property('code').to.be.equal(ERR_Codes.ERR_USER_NOT_EXISTS);
      });
    });
    describe('and did signin', function() {
      describe('When refresh token before expire', function() {
        it('Then got a new accessToken', async function() {
          let refreshToken = jwt.sign({ userId: 'testUserId' }, defaultConfig.jwtSecret,  {expiresIn: 60});
          let loginedInfo = await di.userManager.refreshToken(refreshToken);
          loginedInfo.should.have.property('userId').not.be.null.and.empty;
          loginedInfo.should.have.property('accessToken').not.be.null.and.empty;
          loginedInfo.should.have.property('refreshToken').not.be.null.and.empty;
        });
      });
      describe('When refresh token after expire', function() {
        it('Then got a invalid refreshToken', function() {
          let expiredRefreshToken = jwt.sign({ userId: 'testUserId' }, defaultConfig.jwtSecret,  {expiresIn: -1});
          return di.userManager.refreshToken(expiredRefreshToken)
                .should.eventually.be.rejected
                .and.have.property('code').to.be.equal(ERR_Codes.ERR_INVAILD_REFRESH_TOKEN);
        });
      });
  
    });
  });
});